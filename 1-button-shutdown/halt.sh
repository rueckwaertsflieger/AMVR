#!/bin/bash
# Datei /home/pi/halt.sh
# declaration of hardware pins
reset=18
LED=22
gpio -1 mode $reset in
gpio -1 mode $LED out
# let LED blink and stay lit
gpio -1 write $LED 1
sleep 0.5
gpio -1 write $LED 0
sleep 0.5
gpio -1 write $LED 1
# wait for button state change
gpio -1 wfi $reset both
# let LED blink increasingly fast and shutdown
gpio -1 write $LED 0
sleep 0.5
gpio -1 write $LED 1
sleep 0.5
gpio -1 write $LED 0
sleep 0.5
gpio -1 write $LED 1
#from here, LED writes may be deleted after testing
sleep 0.5
gpio -1 write $LED 0
sleep 0.25
gpio -1 write $LED 1
sleep 0.25
gpio -1 write $LED 0
sleep 0.25
gpio -1 write $LED 1
sleep 0.25
gpio -1 write $LED 0
sleep 0.125
gpio -1 write $LED 1
sleep 0.125
gpio -1 write $LED 0
sleep 0.125
gpio -1 write $LED 1
sleep 0.125
gpio -1 write $LED 0
sleep 0.125
gpio -1 write $LED 1
sleep 0.125
gpio -1 write $LED 0
sleep 0.125
gpio -1 write $LED 1
sleep 0.125
gpio -1 write $LED 0
sleep 0.125
gpio -1 write $LED 1

#logger Shutdown button pressed
sudo shutdown -h now
