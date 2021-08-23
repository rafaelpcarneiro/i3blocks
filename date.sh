#!/bin/sh


if [ $1 -gt 1 ]; then
    echo `date "+%a, %d %B %Y %H:%M (UTC -3)"`
else
    echo `date "+%H:%M"`
fi

exit 0
