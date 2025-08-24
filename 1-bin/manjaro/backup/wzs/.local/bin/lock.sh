#!/bin/sh
revert() {
  xset dpms 600 1800 3600
}
trap revert HUP INT TERM
xset +dpms dpms 5 1800 3600
i3lock -nfe -i /home/wzs/picture/lock.png
revert
