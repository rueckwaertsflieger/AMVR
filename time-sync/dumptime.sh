#!/bin/bash

# This is a script for Rasberry Pi and other computers,
# not equipped with a real time clock. The script sets
# the system clock with ntpd from network ntp sources or
# with time from a GPS receiver through gpsd. The script
# exits either if the clock was set successfully or the
# loop reaches the 10th attempt to do so. This is likely
# to happen, if there is no network access AND GPS re-
# ception available at all. The script is intended for
# headless systems to be powered and run.
# There is much stuff for debugging only contained.

# Needed: ntp with ATOM support, gpsd and gps utilities
# and gpstime.py

# Killing other configurations to start in a determinist-
# ic state. Likely to be discarded, when entire setup is
# under control. Rarely there are cases needing double
# kill. (Overkill?) That is why killall is invoked just
# before doing so in loop again.
sudo killall ntpd
sudo killall gpsd

echo "date after boot:"
date
echo ""

clockattempt=0 # loop counter for setting sysclock
errorgps=124 # error exit level set to timeout
errorntp=124 # error exit level set to timeout

while [ $errorgps -eq 124 ] && [ $errorntp -eq 124 ] && [ $clockattempt -lt 10 ]
    do
         echo "killing ntp and gps daemons"
         sudo killall ntpd
         sleep 2
         sudo killall gpsd
         sleep 2

         echo "trying gpstime.........."
         timeout 20 python /home/pi/gpstime/gpstime.py
         let errorgps=$?
         echo "errorgpslevel is" $errorgps
         echo "date after gpstime: "
         date
         echo ""
         sleep 2

         echo "trying ntp time.........."
         sudo timeout 20 sudo ntpd -gq -c /etc/ntp.conf
         let errorntp=$?
         echo "ntpstatus"
         ps -aux | grep ntp
         echo ""
         sleep 2
         echo "errorntplevel is" $errorntp
         echo "date after ntp time: "
         date
         echo ""
         sleep 2

         let clockattempt=clockattempt+1
         echo "clockattempt is" $clockattempt
         echo ""
    done



# Just to make sure, gpsd and ntpd are running even after
# gpstime failed
echo "Restarting gpsd"
sudo /etc/init.d/gpsd restart
sleep 2

sudo killall ntpd
echo "Restarting ntpd"
sudo service ntp restart
echo ""
sleep 2

# Debuginfo
ps -aux | grep ntp
ps -aux | grep gps

# From here custom processes startup
