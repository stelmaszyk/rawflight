#!/bin/bash

echo "Dump1090 is installed. Now we will configure everything. "
sleep 3
echo "Configuring script........"
echo " " ;
read -p "In a message from us, you should get an individual port numer. Rewrite it down here: " portnumber
touch rawflight.sh
echo "#!/bin/bash
while [ 0 ]; do
  socat TCP:rawflight.eu:"$(portnumber)" TCP:127.0.0.1:30003
  sleep 3;
done" > rawflight.sh
