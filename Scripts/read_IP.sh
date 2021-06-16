#!/bin/bash

echo "IP addresses are being extracted for location!"
echo "98.234.56.78" >> ip_Address.txt

# Curls the IP addresses of remote computers
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" ip_Address.txt | while read -r line;
do
	echo $line
	curl "http://api.ipstack.com/"$line"?access_key=d2eea3c8951d49014fcfc3e8ce95edcf&format=1&fields=latitude,longitude" >> output_Location.txt
	sleep 2
done

echo "All IP addresses have extracted for geolocations!"

# Extracts latitude and longitude into separate files
grep 'latitude' output_Location.txt > LATITUDE.txt
grep 'longitude' output_Location.txt > LONGITUDE.txt
sed -e 's/.*:.//g' LATITUDE.txt > number_LATITUDE.txt
sed -e 's/,.*//g' number_LATITUDE.txt > number_correctLATITUDE.txt

sed -e 's/.*://g' LONGITUDE.txt > number_LONGITUDE.txt
sed -e 's/,.*//g' number_LONGITUDE.txt > number_correctLONGITUDE.txt

rm LATITUDE.txt && rm LONGITUDE.txt
rm number_LATITUDE.txt && rm number_LONGITUDE.txt
echo "Latitude and Longitude have been prepared for mapping!"
