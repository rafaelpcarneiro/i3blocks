#!/bin/bash

## Output examples from the comand acpi -i -b
##-------------------------------------------
##
## Charging
## Battery 0: Unknown, 96%
## Battery 0: design capacity 4591 mAh, last full capacity 2317 mAh = 50%
## 
## Discharging
## Battery 0: Discharging, 97%, 02:05:50 remaining
## Battery 0: design capacity 4639 mAh, last full capacity 2341 mAh = 50%

batStatus=`acpi -b -i | head -n 1| perl -lne 'print $1 if /0: ([^ ,]+)/'`

batMAX=`acpi -b -i | tail -n 1| perl -lne 'print $1 if /([\d]+)%$/'`

batValue=`acpi -b -i |
          head -n 1  |
          perl -lne 'print $2 if /(Unknown|Discharging|Charging), ([\d]+)%/'`

if [[ $batStatus = "Unknown" || $batStatus = "Charging" ]];then
    if [ $batValue -ge 95 ];then
        echo  "Bat: $batValue% | $batMAX%"
        echo  "" # need to echo empty spaces in order to print the color (weird)
    else 
        echo  "Bat: ↑ $batValue% | $batMAX%"
        echo  "" # need to echo empty spaces in order to print the color (weird)
    fi
else
    # Discharging Battery =(

    timeRemaining=`acpi -b -i | 
                   head -n 1  |
                   perl -lne 'print $1 if /([\d:]+) remaining$/'`

    if [ $batValue -ge 95 ];then
        echo  "Bat: ↓ $batValue% | $batMAX%"
        echo  "" # need to echo empty spaces in order to print the color (weird)
    else 
        echo "Bat: ↓ $batValue% - $timeRemaining | $batMAX%"
        echo  "" # need to echo empty spaces in order to print the color (weird)
    fi
fi

[ $batValue -ge 50 ] && echo "#b3b3b3"
[[ $batValue -ge 20 && $batValue -lt 50  ]] && echo "#cc7a00"
[[ $batValue -ge 00 && $batValue -lt 20  ]] && echo "#cc0000"
