#!/bin/sh
# Grabs the current temperature from darksky.net
# and prints the current temperature and the "feels like"
# i.e. <temp>° <feels>°

URL='https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/43.1548%2C-77.6192/today?unitGroup=us&elements=temp%2Cfeelslike&include=current&key=2EJMZLE3N9PBX66U8BS7R3NDT&contentType=json'

currentConditions=`wget -q -O- "$URL" | grep -Po '"currentConditions":\s*{.*?}'`
temp=`echo "$currentConditions" | sed -nr 's/.*"temp":(.*?),.*/\1/p'`
feelsLike=`echo "$currentConditions" | sed -nr 's/.*"feelslike":(.*?)}.*/\1/p'`
echo $temp° $feelsLike°
