# server.py by Isaac Texeira
# External libraries
from http.server import BaseHTTPRequestHandler, HTTPServer
import pickle
import datetime
import firebase_admin
from firebase_admin import credentials, firestore
import sklearn
print(sklearn.__version__)

# Our modules
import fbq
import outa_seantext

_PATH_TO_FIREBASE_CERT = "cert.json" # Make sure that the Firebase certificate file is pointed to by this address

# Load the recommendation classsifier
_CLASSIFIER = pickle.load(open('classifier', 'rb'))
_global_apicalls = 0 # _global_apicalls is ONLY to be modified by the _weather_data method of RecServer


class RecServer(BaseHTTPRequestHandler):
    # Load the classifier at server start time, and keep it loaded
    def __init__(self, *args, **kwargs):
        """Initializes 2 resources for the life of the server: The classifier model and the firebase database connection."""
        #self.db = _DB
        self.cls = _CLASSIFIER

        # Also keep the normal init process or a BaseHTTPRequestHandler
        super().__init__(*args, **kwargs)


    # Respond to requests
    def do_GET(self):
        """Called when the server receives a request.
        REQUEST STRUCTURE: The http request should go to http://localhost:8000/InsertUserEmailHere
        where InsertUserEmailHere is a email address that corresponds to the user in the database that
        the recommendation will be personalized for.
        OUTPUT: The body of the response will include a subset of the workout option strings, each seperated by a newline,
        ranked in order from top to bottom"""

        email = self.path.split('/')[1] # self.path from [1] onwards contains the parameters we'll need to make predictions

        # Use these fixed headers for a successful response
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()

        # Get the recommendations
        recommendations = self._recommend(email)
        response = recommendations[0] + '\n'

        self.wfile.write(bytes(response, "utf-8"))


    def _recommend(self, email: str):
        """Accesses the necessary data to make recommendations and returns what's recommended"""
        db_info = fbq.get_user_data(email)

        report = self._weather_data(db_info['City'])
        Precipitation = report[0]
        Temp = int(((report[2] - 273.15) * 1.8) + 32)
        AQI = report[3] * 25

        CalorieTarget = min(2000 - int(db_info['ActiveCalories']), 500)
        CardioWeeklyMinutes = int(db_info['CardioMinutes'])
        CardioToday = bool(CardioWeeklyMinutes)
        Gym = db_info['Gym']

        curday = (datetime.datetime.now().date() - datetime.date(2024, 1, 1)).days
        day_determiner = curday % 4
        PushDay = (day_determiner == 0)
        PullDay = (day_determiner == 1)
        ArmDay = (day_determiner == 2)
        LegDay = (day_determiner == 3)

        WeightLoss = (db_info['Preference'] == 0)
        HealthMaintenance = (db_info['Preference'] == 1)
        MuscleGain = (db_info['Preference'] == 2)

        dob = db_info['DOB']
        dob = dob.split('_')
        dob = datetime.date(int(dob[2]), int(dob[0]), int(dob[1]))
        Age = datetime.datetime.now().date().year - dob.year

        BodyMassIndex = float(db_info['Weight']) / float(db_info['Height'])

        return self.cls.predict([[CalorieTarget, CardioToday, CardioWeeklyMinutes, PushDay, PullDay, ArmDay, LegDay, WeightLoss, HealthMaintenance, MuscleGain, Temp, Precipitation, AQI, Age, BodyMassIndex, Gym]])

    def _weather_data(self, city: str):
        """Tracks API calls to the OpenWeatherAPI. If within the limit, returns the contextual data from Sean's API calls.
        Like Sean's API calls, it """
        global _global_apicalls

        if _global_apicalls > 100:
            raise Exception('100 API calls made this session! Make sure that you are not approaching 1,000 daily calls.')

        _global_apicalls += 1
        return outa_seantext.get_weather(city)

def run_server(port=8000):
    address = ('', port)
    server = HTTPServer(address, RecServer)

    print('Server running on port ' + str(port))
    server.serve_forever()

if __name__ == '__main__':
    run_server()