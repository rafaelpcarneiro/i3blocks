#!/bin/sh
# vim: foldmethod=marker:

# To obtain information over the battery I will use the programs
#     (apm fpr freeBSD) and (acpi for arch linux)


print_info_gnu_linux () {
    #{{{1
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
              perl -lne 'print $2 if 
                         /(Unknown|Discharging|Charging|Full), ([\d]+)%/'`

    if [[ $batStatus = "Unknown"  || \
          $batStatus = "Charging" || \
          $batStatus = "Full" ]]
    then
        if [ $batValue -ge 95 ];then
            echo  "Bat: $batValue% | $batMAX%"
            echo  "" # need to echo empty spaces in order 
                     # to print the color (weird)
        else 
            echo  "Bat: ↑ $batValue% | $batMAX%"
            echo  "" # need to echo empty spaces in order 
                     # to print the color (weird)
        fi
    else
        # Discharging Battery =(

        timeRemaining=`acpi -b -i | 
                       head -n 1  |
                       perl -lne 'print $1 if /([\d:]+) remaining$/'`

        if [ $batValue -ge 95 ];then
            echo  "Bat: ↓ $batValue% | $batMAX%"
            echo  "" # need to echo empty spaces in order 
                     # to print the color (weird)
        else 
            echo "Bat: ↓ $batValue% - $timeRemaining | $batMAX%"
            echo  "" # need to echo empty spaces in order 
                     # to print the color (weird)
        fi
    fi

    [ $batValue -ge 50 ] && echo "#b3b3b3"
    [ $batValue -ge 20 -a $batValue -lt 50 ] && echo "#cc7a00"
    [ $batValue -ge 00 -a $batValue -lt 20 ] && echo "#cc0000"
#1}}}
}

print_info_freebsd () {
    #{{{1

    batStatus=`apm -a`

    batValue=`apm -l`

    if [ $batStatus -eq 1 ]; then
        if [ $batValue -ge 95 ]; then
            echo  "Bat: $batValue%"
        else 
            echo  "Bat: ↑ $batValue%"
        fi
    else
        # Discharging Battery =(

        timeLeft=`apm -t`              # in seconds
        timeLeft=$((timeLeft / 60))    # in min

        timeLeft_H=$((timeLeft / 60))
        timeLeft_M=$((timeLeft - timeLeft_H*60))


        if [ $batValue -ge 95 ]; then
            echo  "Bat: ↓ $batValue%"
        else 
            if [ $timeLeft_M -lt 10 ]; then
                echo "Bat: ↓ $batValue% - $timeLeft_H:0$timeLeft_M"
            else
                echo "Bat: ↓ $batValue% - $timeLeft_H:$timeLeft_M"
            fi

        fi
    fi
#1}}}
}

checkOS=`uname -a|grep -o -E "^[^ ]+"`

if [ $checkOS = "FreeBSD" ]; then
    print_info_freebsd
else
    print_info_gnu_linux
fi

