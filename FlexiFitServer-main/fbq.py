# Fbq.py by Isaac Texeira
import firebase_admin
from firebase_admin import credentials, firestore
import datetime
import os

_PATH_TO_FIREBASE_CERT = os.path.abspath("cert.json")
_TEST_DOUBLES_MODE = True # Controls whether or not to use test doubles, such as a fixed today()

class EmailNotFound(Exception):
    def __init__(self, s):
        self.text = "The email " + s + " doesn't exist in Firebase"

# Establish the connection to the database
creds = credentials.Certificate(_PATH_TO_FIREBASE_CERT)
firebase_admin.initialize_app(creds)
db = firestore.client()

def today(dummy=False):
    if dummy:
        return '02_23_2024'
    return datetime.datetime.now().date().strftime("%d_%m_%Y")

def get_user_data(email: str):
    """Input: A live database and an email string
    Output: The data associated with the email in that database"""

    userdat = db.collection('User') # Navigate to the User collection

    # This part of the navigation uses the 'email' field of the documents in the User collection. If that field is removed,
    # simply adjust this to use the .document() method instead
    query = userdat.where('Email', '==', email).limit(1)

    #one = query.get()[0]
    one = userdat.document(email).get()
    if not one.exists:
        raise EmailNotFound(email)
    user_globals = one.to_dict()
    user_stats = one.reference.collection('Stats')
    user_daily = user_stats.document(today(_TEST_DOUBLES_MODE)).get().to_dict() # if this fails, check _TEST_DOUBLES_MODE

    return user_globals | user_daily

if __name__ == '__main__':
    print(get_user_data('TestEmail@example.com'))