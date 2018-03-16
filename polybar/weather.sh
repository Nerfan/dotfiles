#!/bin/sh
# Grabs the current temperature from darksky.net
# and prints the current temperature and the "feels like"
# i.e. <temp>° <feels>°

URL='https://darksky.net/forecast/43.1548,-77.6192/us12/en'

wget -q -O- "$URL" | \
awk -F'[:,]' '/currently = \{/ \
    {printf("%d° %d°\n", $16, $18)}'| head -1
