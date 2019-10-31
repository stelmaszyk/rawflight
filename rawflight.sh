#!/bin/bash



# adres ip hosta na ktorm jest dump1090
dump1090_ip=127.0.0.1

# Twoj port na serwerze rawflight
client_port=10005

#echo starting...
while [ 0 ]; do
   socat TCP:rawflight.eu:$client_port TCP:$dump1090_ip:30003
   sleep 10;
   #echo restarting...
done
chmod +x nazwa_pliku
