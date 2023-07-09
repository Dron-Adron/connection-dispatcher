#!/bin/bash

ip=127.0.0.1
duration=15

apt-get update
apt-get install iptables -y
iptables-save > iptables.rules
disconnect() {
  echo "Disconnecting stream..."
  iptables -F
  iptables -I OUTPUT -d $ip -j DROP
  sleep $duration
  iptables -D OUTPUT -d $ip -j DROP
  iptables-restore < iptables.rules
  echo "Connection alive!"
}

change_parameters() {
  read -p "Enter the new ip (current: $ip): " new_ip
  read -p "Enter the new duration in seconds (current: $duration): " new_duration

  if [[ -n $new_ip ]]; then
    ip=$new_ip
  fi

  if [[ -n $new_duration ]]; then
    duration=$new_duration
  fi

  echo "Parameters updated:"
  echo "IP: $ip"
  echo "Duration: $duration seconds"
}

while true; do
  echo "Enter 'c' to change parameters"
  echo "Enter 'e' to exit"
  echo "Enter something another to kill connection"
  read -p ">> " input

  case $input in
    c)
      change_parameters
      ;;
    e)
      echo "Exiting the script..."
      exit 0
      ;;
    *)
      disconnect
      ;;
  esac

done
