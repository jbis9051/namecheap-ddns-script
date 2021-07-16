#!/usr/bin/env bash

CURRENTIP=$(<current.txt)
IP1=$(dig +short myip.opendns.com @resolver1.opendns.com)
IP2=$(curl -s https://ipinfo.io/ip)

error() {
    echo "$(date) - $1" >&2
}


if [[ -z "$PASS" ]]
then
  error "PASS not set!"
  exit 1;
fi

if [[ -z "$DOMAIN" ]]
then
  error "DOMAIN not set!"
  exit 1;
fi

if [[ "$IP1" != "$IP2" ]]
then
  error "IP did not match!"
  exit 1;
fi

if [[ "$IP1" == "$CURRENTIP" ]]
then
  error "IP did not change!"
  exit 0;
fi

echo "$IP1" > current.txt

for host in "@" "*" "www"; do
  curl -s "https://dynamicdns.park-your-domain.com/update?host=$host&domain=$DOMAIN&password=$PASS&ip=$IP1"
done
