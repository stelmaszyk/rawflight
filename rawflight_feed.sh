#!/bin/bash
configure_rawflight() {
  echo "Dump1090 is installed. Preparing your configuration. Please wait. "
  sleep 3
  touch rawflight.sh
  echo "#!/bin/bash
  while [ 0 ]; do
    socat TCP:rawflight.eu:48581 TCP:127.0.0.1:30005
    sleep 3;
  done" > rawflight.sh
  sleep 3
  echo "Script created. Creating directories."
  mkdir /root/rawflight
  echo "Moving script to directory /root/rawflight/"
  mv rawflight.sh /root/rawflight
  echo "Making script executable"
  chmod +x /root/rawflight/rawflight.sh
  sleep 3
  echo "Script created. Continuing to Service File Creator"
  sleep 5
}

create_service() {
  echo "Creating service file for RawFlight Feeder."
  sleep 3
  echo "Creating file"
  touch rawflight.service
  echo "[Unit]
  Description=Socat service to push receiver via socat to VRS
  After=network-online.target
  [Timer]
  OnBootSec=60
  [Service]
  Type=simple
  ExecStart=/root/rawflight/rawflight.sh
  user=root
  Restart=on-failure
  StartLimitBurst=2
  [Install]
  WantedBy=multi-user.target
" > rawflight.service
  sleep 3
  echo "Service File Created. Moving it to /etc/systemd/system."
  mv rawflight.sh /etc/systemd/system
  echo "File moved. Starting service."
  service rawflight start
  echo "Enabling RawFlight Service"
  systemctl enable rawflight
  echo "RawFlight Service Created. Since now, RawFlight Feeder will start automatically."
  echo "Press any key to finish installation."
  read exitkey
  case "$exitkey" in
    "*") echo "Install Complete. Please wait a moment." 
         sleep 3
         exit 1;;
  esac
}

download() {
  echo "Downloading Dump1090. It'll few seconds"
  wget "http://rawflight.eu/download/dump1090.deb"
  sleep 3
  echo "Installing Dump1090. It'll take some time"
  dpkg -i dump1090.deb
  sleep 3
  echo "Installing missing dependencies. It'll take some time. "
  apt-get --fix-broken install
  sleep 3
  echo "Starting Dump1090. "
  service dump1090-fa start
  sleep 3
  echo "Adding Dump1090 to autostart."
  systemctl enable dump1090-fa
  sleep 3
  echo "Dump1090 is activated and ready to use. Continuing to configuration."
  sleep 3
}

if [ "$(whoami)" != "root" ]
  then echo "Script is not run as root! Please run it as sudoer or superuser."
  
  else 
    echo "That script will configure your Feeder and connect it to RawFlight.eu. "
    if [ -x /usr/bin/dump1090-fa ] || [ -x /usr/bin/dump1090-mutability ] || [ -x /usr/bin/dump1090 ]; then {
      configure_rawflight
      create_service
      }
     else 
      echo "Dump1090 is not installed. Do you want to install it? (y/n)"
      read key
      case "$key" in
        "y")  download
              configure_rawflight
              create_service;;
        "n")  echo "User denied installation. Exiting" 
              exit 1;;
        "*")  echo "Unknown key. Exiting."
              exit 1;;
      esac
      }
      fi
fi
