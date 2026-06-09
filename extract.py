import requests
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning) 
import pandas as pd
import time

# FUNCIONES BASE

def get_all(endpoint):
    """Pagina automáticamente todos los resultados de la SWAPI"""
    results = []
    url = f"https://swapi.py4e.com/api/{endpoint}/"
    while url:
        response = requests.get(url, verify=False)
        data = response.json()
        results.extend(data["results"])
        url = data["next"]
        time.sleep(0.3)
    return results

# EXTRACCIÓN

print("Extrayendo People...")
people = get_all("people")

print("Extrayendo Starships...")
starships = get_all("starships")

print("Extrayendo Planets...")
planets = get_all("planets")

print("Extrayendo Species...")
species = get_all("species")

# TRANSFORMACIÓN A DATAFRAME

# PEOPLE
df_people = pd.DataFrame(people)
df_people = df_people[[
    "name","height","mass","hair_color","skin_color",
    "eye_color","birth_year","gender","homeworld","species","films"
]]
df_people["species_count"] = df_people["species"].apply(len)
df_people["films_count"] = df_people["films"].apply(len)
df_people["homeworld_url"] = df_people["homeworld"]

# STARSHIPS
df_starships = pd.DataFrame(starships)
df_starships = df_starships[[
    "name","model","manufacturer","cost_in_credits",
    "length","max_atmosphering_speed","crew","passengers",
    "cargo_capacity","starship_class","pilots","films"
]]
df_starships["pilots_count"] = df_starships["pilots"].apply(len)
df_starships["films_count"] = df_starships["films"].apply(len)

# PLANETS
df_planets = pd.DataFrame(planets)
df_planets = df_planets[[
    "name","rotation_period","orbital_period","diameter",
    "climate","gravity","terrain","surface_water",
    "population","residents","films"
]]
df_planets["residents_count"] = df_planets["residents"].apply(len)
df_planets["films_count"] = df_planets["films"].apply(len)
df_planets["url"] = [p["url"] for p in planets]

# GUARDAR CSVs
df_people.to_csv("people.csv", index=False)
df_starships.to_csv("starships.csv", index=False)
df_planets.to_csv("planets.csv", index=False)

print("Datos extraídos y guardados correctamente.")
print(f"   People: {len(df_people)} registros")
print(f"   Starships: {len(df_starships)} registros")
print(f"   Planets: {len(df_planets)} registros")