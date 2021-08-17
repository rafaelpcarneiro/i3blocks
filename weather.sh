#!/bin/bash

# Location Santana, SP - Brazil
str=`curl -Ss 'https://darksky.net/forecast/-23.4861,-46.628/si12/en'| \
        perl -lne 'print "$1 $2" if /(Feels Like:|Low:|High:)[^\d]*(\d{1,2})/'`

temp=`echo $str|
      perl -lne 'print $1 if /Feels Like: (\d{1,2})/'`

low=`echo $str|
     perl -lne 'print $1 if /Low: (\d{1,2})/'`

high=`echo $str|
      perl -lne 'print $1 if /High: (\d{1,2})/'`

echo "☼ Temp "$temp"°C «Min: "$low""°C, Max: "$high""°C»"

exit 0
