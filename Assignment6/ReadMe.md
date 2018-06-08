
# Analysis

1. The peak of the temperature trend seems to be around 25 degrees latitude.
2. There seems to be a high degree of humidity at a majority of points near the equator.
3. Wind speeds seem to be the highest between -25 and 75 degrees latitude.


```python
#Import dependencies 
import pandas as pd
import numpy as np
import random
import requests
import json
import csv
import openweathermapy.core as owm
import matplotlib.pyplot as plt
from datetime import datetime

from citipy import citipy
#Importing personal API key from own config file
from config import api_key
```

# Generating a list of cities


```python
#Making an empty list to store randomly generated longitude and latitude data
longi = []
latit = []
for i in range(1500):
    longi.append(float(random.uniform(-180.00,180.00)))
    latit.append(float(random.uniform(-90.00,90.00)))
#Creating empty lists to store the cities and their names
cities = []
city_names = []
#Finding the nearest city given the random coordinates
for i in range(len(longi)):
    cities.append(citipy.nearest_city(latit[i],longi[i]))
#Finding the city info and appending to empty list
for city in cities:
    city_names.append(city.city_name)
#Inputting the city name, lat, and lon into a dataframe
city_df = pd.DataFrame({"City": city_names,
                        "Latitude": latit,
                        "Longitude": longi})
#Dropping any duplicate cities 
unique_city_df = city_df.drop_duplicates(subset = ["City"])
unique_city_df.head()
#print(len(unique_city_df))
print(len(unique_city_df))
```

    583
    

# Grabbing city weather data


```python
#Grabbing data using API
url = "http://api.openweathermap.org/data/2.5/weather?"
units = "imperial"
target_cities = city_df["City"]
country = []
date = []
max_temp = []
humidity = []
cloudiness = []
wind_speed = []
for target_city in target_cities:
    query_url = f"{url}appid={api_key}&units={units}&q="
    response_url = query_url + target_city
    print(f"Processing record for {target_city}: {response_url}")
    try:
        weather_data = requests.get(query_url + target_city).json()
        country_data = weather_data["sys"]["country"]
        date_data = weather_data["dt"]
        temperature = weather_data["main"]["temp_max"]
        humidity_data = weather_data["main"]["humidity"]
        cloudiness_data = weather_data["clouds"]["all"]
        wind_data = weather_data["wind"]["speed"]
    except KeyError: 
        print("Pull was unsuccessful")
    country.append(country_data)
    date.append(date_data)
    max_temp.append(temperature)
    humidity.append(humidity_data)
    cloudiness.append(cloudiness_data)
    wind_speed.append(wind_data)
weather_dict = {"City": target_cities,
                "Cloudiness": cloudiness,
                "Country": country,
                "Date": date,
                "Humidity": humidity,
                "Lat": latit,
                "Lon": longi,
                "Max Temp": max_temp,
                "Wind Speed": wind_speed}

```

    Processing record for katsuura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=katsuura
    Processing record for cabo san lucas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cabo san lucas
    Processing record for bull savanna: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bull savanna
    Processing record for rongcheng: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rongcheng
    Processing record for hermon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermon
    Processing record for las margaritas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=las margaritas
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for sao filipe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao filipe
    Processing record for pisco: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pisco
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for saskylakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saskylakh
    Processing record for barentsburg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barentsburg
    Pull was unsuccessful
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for chokurdakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chokurdakh
    Processing record for hamilton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hamilton
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for seydi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=seydi
    Processing record for bengkulu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bengkulu
    Pull was unsuccessful
    Processing record for yellowknife: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yellowknife
    Processing record for teya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=teya
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for narrabri: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=narrabri
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for eureka: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=eureka
    Processing record for flinders: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=flinders
    Processing record for iqaluit: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=iqaluit
    Processing record for te anau: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=te anau
    Processing record for tateyama: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tateyama
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for kruisfontein: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kruisfontein
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for havre-saint-pierre: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=havre-saint-pierre
    Processing record for liloy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=liloy
    Processing record for mahajanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahajanga
    Processing record for yugorsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yugorsk
    Processing record for dakar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dakar
    Processing record for tiksi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tiksi
    Processing record for asfi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=asfi
    Pull was unsuccessful
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for souillac: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=souillac
    Processing record for kahului: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kahului
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for severo-kurilsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=severo-kurilsk
    Processing record for namibe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=namibe
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for bridgetown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bridgetown
    Processing record for faanui: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=faanui
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for marawi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=marawi
    Processing record for ozinki: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ozinki
    Processing record for mount gambier: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mount gambier
    Processing record for prosyana: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=prosyana
    Pull was unsuccessful
    Processing record for beringovskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=beringovskiy
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for geraldton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=geraldton
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for tasiilaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tasiilaq
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for plettenberg bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=plettenberg bay
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for airai: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=airai
    Processing record for bozova: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bozova
    Processing record for gewane: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gewane
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for ilulissat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ilulissat
    Processing record for loa janan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=loa janan
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for barentsburg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barentsburg
    Pull was unsuccessful
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for ponta do sol: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ponta do sol
    Processing record for praia da vitoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=praia da vitoria
    Processing record for los llanos de aridane: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=los llanos de aridane
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for anloga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=anloga
    Processing record for mahon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahon
    Processing record for thano bula khan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=thano bula khan
    Pull was unsuccessful
    Processing record for souillac: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=souillac
    Processing record for taoudenni: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taoudenni
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for saskylakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saskylakh
    Processing record for merauke: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=merauke
    Processing record for provideniya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=provideniya
    Processing record for port elizabeth: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port elizabeth
    Processing record for codrington: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=codrington
    Processing record for vestmannaeyjar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vestmannaeyjar
    Processing record for cherskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cherskiy
    Processing record for longyearbyen: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=longyearbyen
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for yellowknife: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yellowknife
    Processing record for caravelas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=caravelas
    Processing record for gandajika: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gandajika
    Processing record for saldanha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saldanha
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for bethel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bethel
    Processing record for talnakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=talnakh
    Processing record for mar del plata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mar del plata
    Processing record for savonlinna: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=savonlinna
    Processing record for palaikastron: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=palaikastron
    Processing record for skelleftea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=skelleftea
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for tyrma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tyrma
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for nikolskoye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nikolskoye
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for tastur: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tastur
    Processing record for sitka: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sitka
    Processing record for non thai: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=non thai
    Processing record for cherskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cherskiy
    Processing record for trelew: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=trelew
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for fevralsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=fevralsk
    Pull was unsuccessful
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for mahajanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahajanga
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for parsabad: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=parsabad
    Processing record for kaeo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaeo
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for ilulissat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ilulissat
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for polohy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=polohy
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for balimo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=balimo
    Pull was unsuccessful
    Processing record for aswan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=aswan
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for los llanos de aridane: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=los llanos de aridane
    Processing record for kusti: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kusti
    Pull was unsuccessful
    Processing record for clyde river: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=clyde river
    Processing record for kempten: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kempten
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for corner brook: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=corner brook
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for swinford: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=swinford
    Processing record for tautira: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tautira
    Processing record for maragheh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=maragheh
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for eenhana: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=eenhana
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for souillac: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=souillac
    Processing record for krasnoselkup: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=krasnoselkup
    Pull was unsuccessful
    Processing record for ola: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ola
    Processing record for chapais: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chapais
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for mildura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mildura
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for padang: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=padang
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for banda aceh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=banda aceh
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for miranorte: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=miranorte
    Pull was unsuccessful
    Processing record for caravelas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=caravelas
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for dukat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dukat
    Processing record for ilulissat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ilulissat
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for rundu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rundu
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for sibot: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sibot
    Processing record for pisco: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pisco
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for riyadh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=riyadh
    Processing record for georgetown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=georgetown
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for yellowknife: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yellowknife
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for mitsamiouli: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mitsamiouli
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for mitsamiouli: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mitsamiouli
    Processing record for boddam: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=boddam
    Processing record for oktyabrskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=oktyabrskiy
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for pacific grove: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pacific grove
    Processing record for la rioja: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=la rioja
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for labutta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=labutta
    Pull was unsuccessful
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for huarmey: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=huarmey
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for ostrovnoy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ostrovnoy
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for hoffman estates: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hoffman estates
    Processing record for la ronge: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=la ronge
    Processing record for saint-denis: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-denis
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for belmonte: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belmonte
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for solnechnyy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=solnechnyy
    Processing record for yellowknife: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yellowknife
    Processing record for faanui: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=faanui
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for victoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=victoria
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for mitu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mitu
    Processing record for shitanjing: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=shitanjing
    Processing record for kampene: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kampene
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for faya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=faya
    Processing record for ancud: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ancud
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for nauta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nauta
    Processing record for atar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atar
    Processing record for ati: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ati
    Processing record for galle: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=galle
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for kutum: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kutum
    Processing record for nakusp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nakusp
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for barentsburg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barentsburg
    Pull was unsuccessful
    Processing record for kapoeta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapoeta
    Pull was unsuccessful
    Processing record for berlevag: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=berlevag
    Processing record for pangnirtung: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pangnirtung
    Processing record for dekar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dekar
    Processing record for faanui: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=faanui
    Processing record for luderitz: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=luderitz
    Processing record for loreto: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=loreto
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for nador: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nador
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for souillac: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=souillac
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for sabha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sabha
    Processing record for rawson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rawson
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for chuy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chuy
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for victoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=victoria
    Processing record for warwick: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=warwick
    Processing record for barbar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barbar
    Pull was unsuccessful
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for port hedland: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port hedland
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for ransang: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ransang
    Pull was unsuccessful
    Processing record for chuy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chuy
    Processing record for yellowknife: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yellowknife
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for vestmannaeyjar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vestmannaeyjar
    Processing record for mar del plata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mar del plata
    Processing record for pevek: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pevek
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for marawi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=marawi
    Processing record for lorengau: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lorengau
    Processing record for cermik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cermik
    Processing record for kodiak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kodiak
    Processing record for hasanabad: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hasanabad
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for mae hong son: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mae hong son
    Processing record for grindavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grindavik
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for walvis bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=walvis bay
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for talawdi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=talawdi
    Pull was unsuccessful
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for aklavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=aklavik
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for barentsburg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barentsburg
    Pull was unsuccessful
    Processing record for cherskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cherskiy
    Processing record for half moon bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=half moon bay
    Processing record for berdigestyakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=berdigestyakh
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for bairiki: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bairiki
    Pull was unsuccessful
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for lompoc: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lompoc
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for milkovo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=milkovo
    Processing record for sioux lookout: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sioux lookout
    Processing record for ous: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ous
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for baruun-urt: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=baruun-urt
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for anadyr: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=anadyr
    Processing record for sao filipe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao filipe
    Processing record for kruisfontein: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kruisfontein
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for lompoc: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lompoc
    Processing record for mosquera: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mosquera
    Processing record for naze: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=naze
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for chervone: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chervone
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for nome: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nome
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for provideniya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=provideniya
    Processing record for souillac: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=souillac
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for georgetown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=georgetown
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for bambous virieux: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bambous virieux
    Processing record for maragogi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=maragogi
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for lavrentiya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lavrentiya
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for isangel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=isangel
    Processing record for coquimbo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=coquimbo
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for carutapera: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=carutapera
    Processing record for sabang: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sabang
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for kununurra: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kununurra
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for luderitz: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=luderitz
    Processing record for ketchikan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ketchikan
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for algeciras: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=algeciras
    Processing record for sozopol: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sozopol
    Processing record for dujuma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dujuma
    Pull was unsuccessful
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for broken hill: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=broken hill
    Processing record for pasni: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pasni
    Processing record for sabinas hidalgo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sabinas hidalgo
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for saldanha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saldanha
    Processing record for matagami: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=matagami
    Processing record for saldanha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saldanha
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for play cu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=play cu
    Pull was unsuccessful
    Processing record for east london: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=east london
    Processing record for boende: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=boende
    Processing record for ozgon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ozgon
    Pull was unsuccessful
    Processing record for lodwar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lodwar
    Processing record for banchory: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=banchory
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for kodiak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kodiak
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for barkhan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barkhan
    Processing record for yomitan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yomitan
    Pull was unsuccessful
    Processing record for san cristobal: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=san cristobal
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for oranjemund: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=oranjemund
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for almaznyy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=almaznyy
    Processing record for beringovskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=beringovskiy
    Processing record for coracao de jesus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=coracao de jesus
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for nhulunbuy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nhulunbuy
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for talnakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=talnakh
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for lubin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lubin
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for lieksa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lieksa
    Processing record for grand-lahou: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grand-lahou
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for sao joao da barra: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao joao da barra
    Processing record for ihlow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ihlow
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for palabuhanratu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=palabuhanratu
    Pull was unsuccessful
    Processing record for grindavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grindavik
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for bambous virieux: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bambous virieux
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for kavaratti: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kavaratti
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for sherlovaya gora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sherlovaya gora
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for coihaique: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=coihaique
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for east london: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=east london
    Processing record for tiksi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tiksi
    Processing record for broome: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=broome
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for tautira: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tautira
    Processing record for mar del plata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mar del plata
    Processing record for conceicao da barra: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=conceicao da barra
    Processing record for smithers: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=smithers
    Processing record for hasaki: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hasaki
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for san quintin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=san quintin
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for muli: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=muli
    Processing record for vanderhoof: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vanderhoof
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for saleaula: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saleaula
    Pull was unsuccessful
    Processing record for coihaique: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=coihaique
    Processing record for puri: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puri
    Processing record for talnakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=talnakh
    Processing record for sedelnikovo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sedelnikovo
    Pull was unsuccessful
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for svetlogorsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=svetlogorsk
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for kungurtug: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kungurtug
    Processing record for svetlaya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=svetlaya
    Processing record for nizhneyansk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nizhneyansk
    Pull was unsuccessful
    Processing record for mys shmidta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mys shmidta
    Pull was unsuccessful
    Processing record for utiroa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=utiroa
    Pull was unsuccessful
    Processing record for baykit: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=baykit
    Processing record for palabuhanratu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=palabuhanratu
    Pull was unsuccessful
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for naliya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=naliya
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for vardo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vardo
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for alugan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=alugan
    Processing record for wenchi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=wenchi
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for la ronge: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=la ronge
    Processing record for gazojak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gazojak
    Processing record for victoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=victoria
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for xiaoweizhai: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=xiaoweizhai
    Processing record for severo-kurilsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=severo-kurilsk
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for cockburn town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cockburn town
    Processing record for tiksi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tiksi
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for merauke: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=merauke
    Processing record for haines junction: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=haines junction
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for salalah: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=salalah
    Processing record for manggar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=manggar
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for kirensk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kirensk
    Processing record for narsaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=narsaq
    Processing record for luderitz: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=luderitz
    Processing record for mutsamudu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mutsamudu
    Pull was unsuccessful
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for morvi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=morvi
    Pull was unsuccessful
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for la ronge: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=la ronge
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for port lincoln: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port lincoln
    Processing record for umm kaddadah: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=umm kaddadah
    Processing record for tiksi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tiksi
    Processing record for bato: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bato
    Processing record for luganville: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=luganville
    Processing record for mys shmidta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mys shmidta
    Pull was unsuccessful
    Processing record for talnakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=talnakh
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for goundi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=goundi
    Processing record for solnechnyy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=solnechnyy
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for lavrentiya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lavrentiya
    Processing record for tignere: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tignere
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for arlit: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arlit
    Processing record for aykhal: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=aykhal
    Processing record for bhadasar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bhadasar
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for oistins: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=oistins
    Processing record for koumac: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=koumac
    Processing record for tacna: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tacna
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for tsihombe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tsihombe
    Pull was unsuccessful
    Processing record for mount isa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mount isa
    Processing record for whitianga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=whitianga
    Processing record for louisbourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=louisbourg
    Pull was unsuccessful
    Processing record for semme: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=semme
    Processing record for ancud: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ancud
    Processing record for meulaboh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=meulaboh
    Processing record for salvador: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=salvador
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for haines junction: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=haines junction
    Processing record for quatre cocos: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=quatre cocos
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for shache: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=shache
    Processing record for ribeira grande: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ribeira grande
    Processing record for tigil: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tigil
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for turinsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=turinsk
    Processing record for antofagasta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=antofagasta
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for acapulco: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=acapulco
    Processing record for esperance: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=esperance
    Processing record for chagda: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chagda
    Pull was unsuccessful
    Processing record for nome: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nome
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for vaitupu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaitupu
    Pull was unsuccessful
    Processing record for kununurra: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kununurra
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for biak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=biak
    Processing record for bambous virieux: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bambous virieux
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for riviere-au-renard: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=riviere-au-renard
    Processing record for srednekolymsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=srednekolymsk
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for belmonte: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belmonte
    Processing record for lagos: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lagos
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for chuy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chuy
    Processing record for abadan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=abadan
    Processing record for viedma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=viedma
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for sao filipe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao filipe
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for bethel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bethel
    Processing record for shimoda: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=shimoda
    Processing record for allapalli: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=allapalli
    Processing record for beloha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=beloha
    Processing record for lebu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lebu
    Processing record for port-gentil: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port-gentil
    Processing record for lircay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lircay
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for boyolangu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=boyolangu
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for saskylakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saskylakh
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for marzuq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=marzuq
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for petropavlovsk-kamchatskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=petropavlovsk-kamchatskiy
    Processing record for bentiu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bentiu
    Pull was unsuccessful
    Processing record for soure: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=soure
    Processing record for geraldton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=geraldton
    Processing record for port elizabeth: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port elizabeth
    Processing record for kaitong: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaitong
    Processing record for hualmay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hualmay
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for ambon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ambon
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for bilma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bilma
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for gravdal: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gravdal
    Processing record for kununurra: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kununurra
    Processing record for dagana: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dagana
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for guangyuan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=guangyuan
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for cagayan de tawi-tawi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cagayan de tawi-tawi
    Pull was unsuccessful
    Processing record for midlothian: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=midlothian
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for horodnye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=horodnye
    Pull was unsuccessful
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for port hardy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port hardy
    Processing record for tual: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tual
    Processing record for toliary: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=toliary
    Pull was unsuccessful
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for kingston upon hull: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kingston upon hull
    Pull was unsuccessful
    Processing record for mar del plata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mar del plata
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for east london: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=east london
    Processing record for katsuura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=katsuura
    Processing record for katsuura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=katsuura
    Processing record for praia da vitoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=praia da vitoria
    Processing record for dzilam gonzalez: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dzilam gonzalez
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for rocha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rocha
    Processing record for mys shmidta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mys shmidta
    Pull was unsuccessful
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for ngukurr: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ngukurr
    Pull was unsuccessful
    Processing record for samusu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=samusu
    Pull was unsuccessful
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for nizwa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nizwa
    Processing record for taunggyi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taunggyi
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for carnarvon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=carnarvon
    Processing record for saleaula: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saleaula
    Pull was unsuccessful
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for victoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=victoria
    Processing record for souillac: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=souillac
    Processing record for verkhoyansk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=verkhoyansk
    Processing record for duz: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=duz
    Pull was unsuccessful
    Processing record for morwell: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=morwell
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for hay river: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hay river
    Processing record for sisophon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sisophon
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for pevek: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pevek
    Processing record for gorontalo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gorontalo
    Processing record for waipawa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=waipawa
    Processing record for nizhneyansk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nizhneyansk
    Pull was unsuccessful
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for iqaluit: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=iqaluit
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for kaitangata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaitangata
    Processing record for changji: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=changji
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for touros: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=touros
    Processing record for narsaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=narsaq
    Processing record for sentyabrskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sentyabrskiy
    Pull was unsuccessful
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for cagayan de tawi-tawi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cagayan de tawi-tawi
    Pull was unsuccessful
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for hayange: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hayange
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for tshela: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tshela
    Processing record for kahului: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kahului
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for arari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arari
    Processing record for rosetta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rosetta
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for montepuez: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=montepuez
    Processing record for kysyl-syr: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kysyl-syr
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for dillon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dillon
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for cape girardeau: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape girardeau
    Processing record for zhigansk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=zhigansk
    Processing record for santa cruz: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=santa cruz
    Processing record for ponta delgada: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ponta delgada
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for halalo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=halalo
    Pull was unsuccessful
    Processing record for maragogi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=maragogi
    Processing record for rantepao: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rantepao
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for narsaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=narsaq
    Processing record for kaitangata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaitangata
    Processing record for saint-augustin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-augustin
    Processing record for tual: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tual
    Processing record for sao filipe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao filipe
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for alice springs: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=alice springs
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for solton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=solton
    Pull was unsuccessful
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for tabiauea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tabiauea
    Pull was unsuccessful
    Processing record for saldanha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saldanha
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for tumannyy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tumannyy
    Pull was unsuccessful
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for pangai: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pangai
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for polovinnoye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=polovinnoye
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for maragogi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=maragogi
    Processing record for thompson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=thompson
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for kaitangata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaitangata
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for zyryanka: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=zyryanka
    Processing record for hamilton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hamilton
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for tsybli: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tsybli
    Processing record for grafton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grafton
    Processing record for riyadh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=riyadh
    Processing record for port elizabeth: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port elizabeth
    Processing record for srednekolymsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=srednekolymsk
    Processing record for tasiilaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tasiilaq
    Processing record for porto santo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=porto santo
    Pull was unsuccessful
    Processing record for pahrump: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pahrump
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for kruisfontein: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kruisfontein
    Processing record for coquimbo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=coquimbo
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for christchurch: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=christchurch
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for buala: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=buala
    Processing record for grand gaube: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grand gaube
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for bombay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bombay
    Processing record for dalvik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dalvik
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for lebu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lebu
    Processing record for alghero: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=alghero
    Processing record for bethel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bethel
    Processing record for sterling heights: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sterling heights
    Processing record for salihorsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=salihorsk
    Processing record for yulara: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yulara
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for provideniya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=provideniya
    Processing record for alofi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=alofi
    Processing record for sao filipe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao filipe
    Processing record for siyabuswa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=siyabuswa
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for diourbel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=diourbel
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for nikolskoye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nikolskoye
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for andenes: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=andenes
    Pull was unsuccessful
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for norman wells: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=norman wells
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for bubaque: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bubaque
    Processing record for saldanha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saldanha
    Processing record for san miguel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=san miguel
    Processing record for carnarvon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=carnarvon
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for creel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=creel
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for port elizabeth: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port elizabeth
    Processing record for norman wells: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=norman wells
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for okha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=okha
    Processing record for ngukurr: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ngukurr
    Pull was unsuccessful
    Processing record for doha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=doha
    Processing record for yulara: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yulara
    Processing record for beisfjord: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=beisfjord
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for matara: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=matara
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for moshkovo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=moshkovo
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for gat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gat
    Processing record for porto santo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=porto santo
    Pull was unsuccessful
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for tiksi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tiksi
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for huarmey: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=huarmey
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for walvis bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=walvis bay
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for bengkulu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bengkulu
    Pull was unsuccessful
    Processing record for loreto: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=loreto
    Processing record for pisco: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pisco
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for hasaki: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hasaki
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for port hawkesbury: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port hawkesbury
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for yellowknife: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yellowknife
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for marmande: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=marmande
    Processing record for roald: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=roald
    Processing record for banda aceh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=banda aceh
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for kaitangata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaitangata
    Processing record for grand river south east: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grand river south east
    Pull was unsuccessful
    Processing record for port lincoln: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port lincoln
    Processing record for kaitangata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaitangata
    Processing record for higuey: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=higuey
    Pull was unsuccessful
    Processing record for llangefni: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=llangefni
    Processing record for necochea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=necochea
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for phangnga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=phangnga
    Processing record for manokwari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=manokwari
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for olafsvik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=olafsvik
    Pull was unsuccessful
    Processing record for constitucion: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=constitucion
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for asau: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=asau
    Pull was unsuccessful
    Processing record for tabuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tabuk
    Processing record for saint-joseph: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-joseph
    Processing record for iqaluit: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=iqaluit
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for rabo de peixe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rabo de peixe
    Processing record for hasaki: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hasaki
    Processing record for lazurne: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lazurne
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for hualmay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hualmay
    Processing record for nishihara: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nishihara
    Processing record for ponta do sol: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ponta do sol
    Processing record for broome: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=broome
    Processing record for pevek: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pevek
    Processing record for esperance: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=esperance
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for tateyama: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tateyama
    Processing record for muros: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=muros
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for sao joao da barra: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao joao da barra
    Processing record for adrar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=adrar
    Processing record for longyearbyen: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=longyearbyen
    Processing record for amderma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=amderma
    Pull was unsuccessful
    Processing record for cabo san lucas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cabo san lucas
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for iqaluit: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=iqaluit
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for kathu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kathu
    Processing record for sinnamary: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sinnamary
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for barbosa ferraz: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barbosa ferraz
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for labuhan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=labuhan
    Processing record for nelson bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nelson bay
    Processing record for colomi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=colomi
    Processing record for marsala: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=marsala
    Processing record for guerrero negro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=guerrero negro
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for bolungarvik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bolungarvik
    Pull was unsuccessful
    Processing record for samusu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=samusu
    Pull was unsuccessful
    Processing record for saleaula: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saleaula
    Pull was unsuccessful
    Processing record for chokurdakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chokurdakh
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for kodiak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kodiak
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for sitka: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sitka
    Processing record for mar del plata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mar del plata
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for grand river south east: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grand river south east
    Pull was unsuccessful
    Processing record for jiaozuo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jiaozuo
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for tezpur: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tezpur
    Processing record for itaituba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=itaituba
    Processing record for east london: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=east london
    Processing record for geraldton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=geraldton
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for madaoua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=madaoua
    Processing record for grand river south east: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grand river south east
    Pull was unsuccessful
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for palabuhanratu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=palabuhanratu
    Pull was unsuccessful
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for bambous virieux: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bambous virieux
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for zhigansk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=zhigansk
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for murray bridge: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=murray bridge
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for saint-leu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-leu
    Processing record for haines junction: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=haines junction
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for grand river south east: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grand river south east
    Pull was unsuccessful
    Processing record for katsuura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=katsuura
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for aklavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=aklavik
    Processing record for pevek: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pevek
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for port-cartier: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port-cartier
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for alassio: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=alassio
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for tahoua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tahoua
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for la ronge: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=la ronge
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for itaituba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=itaituba
    Processing record for pueblo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pueblo
    Processing record for port blair: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port blair
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for cidreira: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cidreira
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for clyde river: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=clyde river
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for lashio: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lashio
    Processing record for namibe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=namibe
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for thompson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=thompson
    Processing record for barentsburg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barentsburg
    Pull was unsuccessful
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for husavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=husavik
    Processing record for lambarene: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lambarene
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for ilulissat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ilulissat
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for avera: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avera
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for bambous virieux: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bambous virieux
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for lithakia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lithakia
    Processing record for touros: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=touros
    Processing record for cherskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cherskiy
    Processing record for saiha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saiha
    Processing record for mazamari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mazamari
    Processing record for bandarbeyla: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bandarbeyla
    Processing record for dalbandin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dalbandin
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for ribeira grande: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ribeira grande
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for san vicente: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=san vicente
    Processing record for norden: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=norden
    Processing record for qandala: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qandala
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for marcona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=marcona
    Pull was unsuccessful
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for vilkaviskis: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vilkaviskis
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for macaboboni: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=macaboboni
    Pull was unsuccessful
    Processing record for bonavista: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bonavista
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for victoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=victoria
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for xichang: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=xichang
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for saravan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saravan
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for mahibadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahibadhoo
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for college: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=college
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for taoudenni: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taoudenni
    Processing record for nikolskoye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nikolskoye
    Processing record for mys shmidta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mys shmidta
    Pull was unsuccessful
    Processing record for ribeira grande: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ribeira grande
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for fortuna: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=fortuna
    Processing record for lebu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lebu
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for angoche: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=angoche
    Processing record for belushya guba: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belushya guba
    Pull was unsuccessful
    Processing record for nikolskoye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nikolskoye
    Processing record for sentyabrskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sentyabrskiy
    Pull was unsuccessful
    Processing record for barranca: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barranca
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for nouadhibou: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nouadhibou
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for pierre: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pierre
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for vardo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vardo
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for severo-kurilsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=severo-kurilsk
    Processing record for norman wells: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=norman wells
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for nova olimpia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nova olimpia
    Processing record for azimur: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=azimur
    Pull was unsuccessful
    Processing record for half moon bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=half moon bay
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for severo-kurilsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=severo-kurilsk
    Processing record for pisco: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pisco
    Processing record for biak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=biak
    Processing record for gigmoto: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gigmoto
    Processing record for takab: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=takab
    Processing record for kodiak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kodiak
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for provideniya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=provideniya
    Processing record for ambunti: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ambunti
    Processing record for kaeo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaeo
    Processing record for rapid city: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rapid city
    Processing record for port hardy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port hardy
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for one hundred mile house: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=one hundred mile house
    Pull was unsuccessful
    Processing record for chuy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chuy
    Processing record for san patricio: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=san patricio
    Processing record for kodiak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kodiak
    Processing record for livingston: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=livingston
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for namatanai: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=namatanai
    Processing record for goure: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=goure
    Processing record for izhma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=izhma
    Processing record for rundu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rundu
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for mount gambier: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mount gambier
    Processing record for ingham: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ingham
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for kloulklubed: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kloulklubed
    Processing record for mecca: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mecca
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for atambua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atambua
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for abalak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=abalak
    Processing record for samarai: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=samarai
    Processing record for dunedin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dunedin
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for sentyabrskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sentyabrskiy
    Pull was unsuccessful
    Processing record for gallup: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=gallup
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for talnakh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=talnakh
    Processing record for portland: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=portland
    Processing record for sisimiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sisimiut
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for sechura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sechura
    Processing record for kaitangata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kaitangata
    Processing record for manta: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=manta
    Processing record for mercedes: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mercedes
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for amderma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=amderma
    Pull was unsuccessful
    Processing record for wake forest: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=wake forest
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for kintampo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kintampo
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for nikolskoye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nikolskoye
    Processing record for grindavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grindavik
    Processing record for lorengau: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lorengau
    Processing record for tual: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tual
    Processing record for westport: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=westport
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for bubaque: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bubaque
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for dillon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dillon
    Processing record for mar del plata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mar del plata
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for cururupu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cururupu
    Processing record for dunedin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dunedin
    Processing record for bethel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bethel
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for tasiilaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tasiilaq
    Processing record for tasiilaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tasiilaq
    Processing record for eyl: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=eyl
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for mujiayingzi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mujiayingzi
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for tairua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tairua
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for kununurra: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kununurra
    Processing record for alofi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=alofi
    Processing record for east london: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=east london
    Processing record for tsiroanomandidy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tsiroanomandidy
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for beira: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=beira
    Processing record for arraial do cabo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=arraial do cabo
    Processing record for carnarvon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=carnarvon
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for sao gotardo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sao gotardo
    Processing record for sabha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sabha
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for tecpan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tecpan
    Processing record for maningrida: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=maningrida
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for pitimbu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pitimbu
    Processing record for bambous virieux: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bambous virieux
    Processing record for lavrentiya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lavrentiya
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for portland: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=portland
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for dunedin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dunedin
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for hasaki: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hasaki
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for atambua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atambua
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for dzhusaly: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dzhusaly
    Pull was unsuccessful
    Processing record for jardim: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jardim
    Processing record for kloulklubed: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kloulklubed
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for erdenet: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=erdenet
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for lolua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lolua
    Pull was unsuccessful
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for khandbari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khandbari
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for campoverde: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=campoverde
    Processing record for thompson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=thompson
    Processing record for hay river: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hay river
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for aklavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=aklavik
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for fortuna: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=fortuna
    Processing record for ilulissat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ilulissat
    Processing record for esperance: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=esperance
    Processing record for severo-kurilsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=severo-kurilsk
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for caravelas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=caravelas
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for severo-kurilsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=severo-kurilsk
    Processing record for codrington: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=codrington
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for aviles: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=aviles
    Processing record for ribeira grande: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ribeira grande
    Processing record for praia da vitoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=praia da vitoria
    Processing record for petrolina: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=petrolina
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for barrow: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barrow
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for yellowknife: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yellowknife
    Processing record for luangwa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=luangwa
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for yorkton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yorkton
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for sibolga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sibolga
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for karkaralinsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=karkaralinsk
    Pull was unsuccessful
    Processing record for hamilton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hamilton
    Processing record for srednekolymsk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=srednekolymsk
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for yar-sale: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yar-sale
    Processing record for kuantan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kuantan
    Processing record for waingapu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=waingapu
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for vardo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vardo
    Processing record for ribeira grande: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ribeira grande
    Processing record for kruisfontein: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kruisfontein
    Processing record for batemans bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=batemans bay
    Processing record for edd: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=edd
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for lompoc: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lompoc
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for cherskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cherskiy
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for kodiak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kodiak
    Processing record for alofi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=alofi
    Processing record for rurrenabaque: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rurrenabaque
    Processing record for mar del plata: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mar del plata
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for belyy yar: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=belyy yar
    Processing record for vaitupu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaitupu
    Pull was unsuccessful
    Processing record for broken hill: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=broken hill
    Processing record for tasiilaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tasiilaq
    Processing record for port elizabeth: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port elizabeth
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for katsuura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=katsuura
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for ilulissat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ilulissat
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for lebu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lebu
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for villazon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=villazon
    Pull was unsuccessful
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for buchanan: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=buchanan
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for road town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=road town
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for klaksvik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=klaksvik
    Processing record for zhangjiakou: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=zhangjiakou
    Processing record for kemijarvi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kemijarvi
    Pull was unsuccessful
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for hambantota: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hambantota
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for quisqueya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=quisqueya
    Processing record for wajir: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=wajir
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for araceli: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=araceli
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for ende: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ende
    Processing record for oriximina: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=oriximina
    Processing record for attawapiskat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=attawapiskat
    Pull was unsuccessful
    Processing record for port elizabeth: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port elizabeth
    Processing record for sitka: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sitka
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for kloulklubed: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kloulklubed
    Processing record for port elizabeth: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port elizabeth
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for suluq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=suluq
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for hamilton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hamilton
    Processing record for amderma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=amderma
    Pull was unsuccessful
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for lompoc: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lompoc
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for praia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=praia
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for puerto ayora: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=puerto ayora
    Processing record for rawson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rawson
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for barentsburg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=barentsburg
    Pull was unsuccessful
    Processing record for tual: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tual
    Processing record for shuangyang: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=shuangyang
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for laguna: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=laguna
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for chapais: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chapais
    Processing record for atuona: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=atuona
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for fortuna: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=fortuna
    Processing record for portland: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=portland
    Processing record for kashi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kashi
    Pull was unsuccessful
    Processing record for saldanha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saldanha
    Processing record for kirakira: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kirakira
    Processing record for victoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=victoria
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for orlovskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=orlovskiy
    Processing record for kruisfontein: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kruisfontein
    Processing record for corrales: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=corrales
    Processing record for nelson bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nelson bay
    Processing record for higuey: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=higuey
    Pull was unsuccessful
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for airai: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=airai
    Processing record for ponta do sol: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ponta do sol
    Processing record for avarua: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=avarua
    Processing record for padang: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=padang
    Processing record for aklavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=aklavik
    Processing record for port keats: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port keats
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for isla mujeres: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=isla mujeres
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for carnarvon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=carnarvon
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for bilibino: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bilibino
    Processing record for kant: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kant
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for andenes: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=andenes
    Pull was unsuccessful
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for tual: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tual
    Processing record for tasiilaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tasiilaq
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for mullaitivu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mullaitivu
    Pull was unsuccessful
    Processing record for eirunepe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=eirunepe
    Processing record for eureka: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=eureka
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for thunder bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=thunder bay
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for seminole: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=seminole
    Processing record for dikson: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dikson
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for mount gambier: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mount gambier
    Processing record for norman wells: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=norman wells
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for jinxi: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jinxi
    Processing record for qaanaaq: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=qaanaaq
    Processing record for igarka: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=igarka
    Processing record for concepcion del oro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=concepcion del oro
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for comodoro rivadavia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=comodoro rivadavia
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for babushkin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=babushkin
    Processing record for henties bay: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=henties bay
    Processing record for attawapiskat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=attawapiskat
    Pull was unsuccessful
    Processing record for albany: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=albany
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for namibe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=namibe
    Processing record for tuktoyaktuk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tuktoyaktuk
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for grand river south east: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=grand river south east
    Pull was unsuccessful
    Processing record for guerrero negro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=guerrero negro
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for castro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=castro
    Processing record for bethel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bethel
    Processing record for butaritari: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=butaritari
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for stromness: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=stromness
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for lerwick: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lerwick
    Processing record for ola: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ola
    Processing record for havre-saint-pierre: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=havre-saint-pierre
    Processing record for kahului: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kahului
    Processing record for dolbeau: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=dolbeau
    Pull was unsuccessful
    Processing record for poum: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=poum
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for upernavik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=upernavik
    Processing record for quatis: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=quatis
    Processing record for anloga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=anloga
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for osoyoos: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=osoyoos
    Processing record for evensk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=evensk
    Processing record for saint-philippe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=saint-philippe
    Processing record for nanortalik: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=nanortalik
    Processing record for quelimane: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=quelimane
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for bredasdorp: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bredasdorp
    Processing record for manaus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=manaus
    Processing record for kavieng: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kavieng
    Processing record for hermanus: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hermanus
    Processing record for varzea paulista: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=varzea paulista
    Processing record for lompoc: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lompoc
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for angoche: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=angoche
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for yerbogachen: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=yerbogachen
    Processing record for cape town: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cape town
    Processing record for new norfolk: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=new norfolk
    Processing record for vaini: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=vaini
    Processing record for hobart: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hobart
    Processing record for meulaboh: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=meulaboh
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for tsihombe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=tsihombe
    Pull was unsuccessful
    Processing record for cherskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=cherskiy
    Processing record for ponta do sol: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ponta do sol
    Processing record for boissevain: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=boissevain
    Processing record for pasighat: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=pasighat
    Processing record for juodupe: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=juodupe
    Processing record for allanmyo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=allanmyo
    Pull was unsuccessful
    Processing record for illoqqortoormiut: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=illoqqortoormiut
    Pull was unsuccessful
    Processing record for kiyasovo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kiyasovo
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for prigorodnyy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=prigorodnyy
    Processing record for mataura: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mataura
    Processing record for jamestown: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=jamestown
    Processing record for taolanaro: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=taolanaro
    Pull was unsuccessful
    Processing record for mahebourg: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=mahebourg
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for samusu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=samusu
    Pull was unsuccessful
    Processing record for lebu: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=lebu
    Processing record for bethel: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bethel
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for provideniya: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=provideniya
    Processing record for port alfred: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port alfred
    Processing record for port blair: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port blair
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for hithadhoo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hithadhoo
    Processing record for khatanga: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=khatanga
    Processing record for chuy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=chuy
    Processing record for sokoto: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sokoto
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for punta arenas: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=punta arenas
    Processing record for la reforma: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=la reforma
    Processing record for carnarvon: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=carnarvon
    Processing record for beloha: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=beloha
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for ushuaia: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=ushuaia
    Processing record for muroto: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=muroto
    Processing record for leshukonskoye: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=leshukonskoye
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for rikitea: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=rikitea
    Processing record for kamyshla: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kamyshla
    Processing record for kandrian: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kandrian
    Processing record for palmer: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=palmer
    Processing record for canguaretama: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=canguaretama
    Processing record for sentyabrskiy: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sentyabrskiy
    Pull was unsuccessful
    Processing record for kodiak: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kodiak
    Processing record for bluff: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=bluff
    Processing record for san quintin: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=san quintin
    Processing record for hilo: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=hilo
    Processing record for kapaa: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=kapaa
    Processing record for victoria: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=victoria
    Processing record for sharjah: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=sharjah
    Processing record for busselton: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=busselton
    Processing record for port lincoln: http://api.openweathermap.org/data/2.5/weather?appid=11e0464e05a5d59ffb9bc504a8fa5ea0&units=imperial&q=port lincoln
    


```python
#Putting the weather dictionary into a dataframe
weather_df = pd.DataFrame(weather_dict)
weather_df = weather_df.drop_duplicates(subset="City")
weather_df = weather_df.dropna(how="any",inplace=False)
weather_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>City</th>
      <th>Cloudiness</th>
      <th>Country</th>
      <th>Date</th>
      <th>Humidity</th>
      <th>Lat</th>
      <th>Lon</th>
      <th>Max Temp</th>
      <th>Wind Speed</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>katsuura</td>
      <td>75</td>
      <td>JP</td>
      <td>1528423200</td>
      <td>88</td>
      <td>25.951484</td>
      <td>146.833704</td>
      <td>73.40</td>
      <td>2.24</td>
    </tr>
    <tr>
      <th>1</th>
      <td>cabo san lucas</td>
      <td>75</td>
      <td>MX</td>
      <td>1528422300</td>
      <td>45</td>
      <td>10.599655</td>
      <td>-126.036919</td>
      <td>93.20</td>
      <td>11.41</td>
    </tr>
    <tr>
      <th>2</th>
      <td>bull savanna</td>
      <td>64</td>
      <td>JM</td>
      <td>1528426621</td>
      <td>68</td>
      <td>15.672793</td>
      <td>-78.740796</td>
      <td>79.03</td>
      <td>7.65</td>
    </tr>
    <tr>
      <th>3</th>
      <td>rongcheng</td>
      <td>12</td>
      <td>CN</td>
      <td>1528426622</td>
      <td>79</td>
      <td>26.428794</td>
      <td>103.156759</td>
      <td>75.25</td>
      <td>8.32</td>
    </tr>
    <tr>
      <th>4</th>
      <td>hermon</td>
      <td>80</td>
      <td>GB</td>
      <td>1528422600</td>
      <td>93</td>
      <td>45.073889</td>
      <td>-69.319376</td>
      <td>59.00</td>
      <td>5.82</td>
    </tr>
  </tbody>
</table>
</div>



# Temperature (F) vs. Latitude


```python
plt.scatter(weather_df["Lat"],weather_df["Max Temp"],c="Blue", alpha=0.75)
cur_date = datetime.now()
cur_date = cur_date.strftime("%Y-%m-%d")
plt.xlim(-95,95)
plt.ylim(0,100)
plt.title(f"City Latitude vs. Max Temperature {cur_date}")
plt.xlabel("Latitude")
plt.ylabel("Max Temperature (F)")
plt.grid(True)
plt.savefig("./Images/temp_vs_lat.jpg")
plt.show()
```


![png](output_9_0.png)


# Humidity (%) vs. Latitude


```python
plt.scatter(weather_df["Lat"],weather_df["Humidity"],c="Blue", alpha=0.75)
cur_date = datetime.now()
cur_date = cur_date.strftime("%Y-%m-%d")
plt.xlim(-95,95)
plt.ylim(0,110)
plt.title(f"City Latitude vs. Humidity {cur_date}")
plt.xlabel("Latitude")
plt.ylabel("Humidity (%)")
plt.grid(True)
plt.savefig("./Images/humidity_vs_lat.jpg")
plt.show()
```


![png](output_11_0.png)


# Cloudiness (%) vs. Latitude


```python
plt.scatter(weather_df["Lat"],weather_df["Cloudiness"],c="Blue", alpha=0.75)
cur_date = datetime.now()
cur_date = cur_date.strftime("%Y-%m-%d")
plt.xlim(-95,95)
plt.ylim(-10,120)
plt.title(f"City Latitude vs. Cloudiness {cur_date}")
plt.xlabel("Latitude")
plt.ylabel("Cloudiness (%)")
plt.grid(True)
plt.savefig("./Images/cloudiness_vs_lat.jpg")
plt.show()
```


![png](output_13_0.png)


# Wind Speed (mph) vs. Latitude


```python
plt.scatter(weather_df["Lat"],weather_df["Wind Speed"],c="Blue", alpha=0.75)
cur_date = datetime.now()
cur_date = cur_date.strftime("%Y-%m-%d")
plt.xlim(-95,95)
plt.ylim(-5,50)
plt.title(f"City Latitude vs. Wind Speed {cur_date}")
plt.xlabel("Latitude")
plt.ylabel("Wind Speed (mph)")
plt.grid(True)
plt.savefig("./Images/windspeed_vs_lat.jpg")
plt.show()
```


![png](output_15_0.png)

