#!/usr/bin/env bash

CURRENTIP=$(<current.txt)
IP1=$(dig +short myip.opendns.com @resolver1.opendns.com)
IP2=$(curl -s https://ipinfo.io/ip)

if [[ -z "$PASS" ]]
then
  echo "PASS not set!" >&2
  exit 1;
fi

if [[ -z "$DOMAIN" ]]
then
  echo "DOMAIN not set!" >&2
  exit 1;
fi

if [[ "$IP1" != "$IP2" ]]
then
  echo "IP did not match!" >&2
  exit 1;
fi

if [[ "$IP1" == "$CURRENTIP" ]]
then
  echo "IP did not change!" >&2
  exit 0;
fi

echo "$IP1" > current.txt

for host in "@" "*" "www"; do
  curl -s "https://dynamicdns.park-your-domain.com/update?host=$host&domain=$DOMAIN&password=$PASS&ip=$IP1"
done
