#!/bin/bash

# Fetch weather data from the API
weather_data=$(curl -s "https://api.weather.gov/gridpoints/ILN/43,59/forecast")

# Extract the current period's data (first period in the forecast)
temperature=$(echo "$weather_data" | jq -r '.properties.periods[0].temperature')
condition=$(echo "$weather_data" | jq -r '.properties.periods[0].shortForecast')
wind_speed=$(echo "$weather_data" | jq -r '.properties.periods[0].windSpeed')
icon=$(echo "$weather_data" | jq -r '.properties.periods[0].icon')

# Output results
echo "Station Name: Springboro OH"
echo "Condition: ${condition}"
echo "Icon: ${icon}"
echo "Temperature: ${temperature}°F"
echo "Wind Speed: ${wind_speed}"
