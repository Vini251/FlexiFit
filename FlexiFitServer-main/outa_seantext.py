# outa_seantext.py by Sean, slightly edited
# Contextual module for finding weather and air quality conditions
import requests, json

def get_weather(city):
    # outside variable tells whether or not the software will suggest outdoor workouts
    # curr_weather is the current weather and will adjust if outdoor boolean is true or false
    # if their city is not specified or if their city was not found, we will just return outside = True

    # the function returns a list called weather_report and these are the contents
    # 1:wether outside excersizes are recommendable, 2:what kind of weather, 3:temp, and 4:Air Quality
    # there is a list of bad weather that can be adjusted and temp is measured in kelvin

    # if the function fails to find the city it will return with a default of:
    # [True, 'Clear', 287, 3]
    outside = True
    curr_weather = "Clear"
    current_temperature = 287 #googled average earth temp in kelvin
    current_aqi = 0
    bad_weather = ["Thunderstorm", "Drizzle", "Rain", "Snow", "Smoke", "Haze", "Dust", "Sand", "Ash", "Squall", "Tornado"]
    weather_report = []
    api_key = "3df64a9fb1b9cda0c0242beb874a8ac3"
    base_url = "http://api.openweathermap.org/data/2.5/weather?"
    city_name = city

    #coordinates that will be extracted with first api call
    coords = []

    full_url = base_url + "appid=" + api_key + "&q=" + city_name
    response = requests.get(full_url)
    x = response.json()


    if x["cod"] != "404":
        y = x["main"]
        weath = x["weather"]
        current_temperature = y["temp"]
        coords = x["coord"]
        curr_weather = weath[0]["main"]

        if curr_weather in bad_weather:
            outside = False
        else:
            outside = True
    
    else:
        outside = True
        #print("failed")

    weather_report.append(outside)
    weather_report.append(curr_weather)
    weather_report.append(current_temperature)

    #### Air quality portion ####
    #  Air Quality Index. Possible values: 1, 2, 3, 4, 5. Where 1 = Good, 2 = Fair, 3 = Moderate, 4 = Poor, 5 = Very Poor
    try:
        aqi_url = "http://api.openweathermap.org/data/2.5/air_pollution?"
        full_aqi_url = aqi_url + "lat=" + str(coords["lat"]) + "&lon=" + str(coords["lon"]) + "&appid=" + api_key
        aqi_response = requests.get(full_aqi_url)
        aqi_x = aqi_response.json()
        
        current_aqi = aqi_x["list"][0]["main"]["aqi"]

        if current_aqi >= 4:
            weather_report[0] = False
    except:
        current_aqi = 3

    weather_report.append(current_aqi)

    return weather_report

if __name__ == "__main__":
    results = get_weather("los angeles")
    print(results)