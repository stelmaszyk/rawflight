#!/bin/bash
while [ 0 ]; do
  #open port 3394
   socat tcp-l:3394,fork,reuseaddr tcp:127.0.0.1:3395
   sleep 10;
   #echo restarting... In case netcat has stopped working.
done
