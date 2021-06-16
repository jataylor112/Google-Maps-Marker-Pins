#!/bin/bash

{
echo "<!DOCTYPE html>"
echo "<html>"
echo "<head>"
echo "	<title>Customer Locations via Google Maps</title>"
echo "<style>"
echo " 	#map {"
echo "		height: 800px;"
echo "		width: 100%;"
echo "	}"
echo "	body {"
echo "		background-color: #ff9999"
echo "	}"
echo "</style>"
echo "</head>"
echo "<body>"
echo "/* The first step I've took to solving this problem was implementing a script"
echo "that curls all IP addresses in a loop then extracts them for their latitude"
echo "and longitude. Next, I wrote another script that reads through the same IPs,"
echo "setting each IP next to its latitude and longitude extracted via the same line"
echo "number in the separate geolocation files from the previous script. Afterwards,"
echo "the script extracts the same IP addresses again, sorts them by unique values,"
echo "and puts them into a separate array that'd be used to determine its color"
echo "marker based off how frequent it appears in the list. As the loops created the"
echo "arrays, separate files were made as temporary storage until it was needed."
echo "These files were then removed upon completion, saving the final text files as"
echo "MIDDLE.txt that'd be combined with other text files. In this script, I've"
echo "also wrote separate text files for the first half of this HTML file, and the"
echo "last half that comes after the middle part, where the arrays are created."
echo "In the first part of this script, I've specified the map's size and its"
echo "background color alongside the start of the function that specifies the map as"
echo "HEAD.txt. In the last half, I've finished the function specifications,"
echo "including its IP popup and how the markers should be colored before setting the"
echo "Google API key to generate the map as TAIL.txt. These files were put together"
echo "to form a single HTML file titled markerMAP.html in conclusion. */"
echo "<h1>Customer Locations via Google Maps</h1>"
echo "<div id="map"></div>"
echo "<script type="text/javascript">"
echo "function initMap() {"
echo "	      var map = new google.maps.Map(document.getElementById('map'), {"
echo "			zoom: 3,"
echo "			center: {lat: 25, lng: 0},"
echo "			mapTypeId: google.maps.MapTypeId.ROADMAP"
echo "	      });"
echo " 	var markerLocations = ["
} > HEAD.txt

int=0
IPtotal=$(cat ip_Address.txt | wc -l)

grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" ip_Address.txt | while read -r line;
do
        int=$((int+1))
        latitude=`head -$int number_correctLATITUDE.txt | tail -1`
        longitude=`head -$int number_correctLONGITUDE.txt | tail -1`
        if (( $int < $IPtotal ))
        then
                echo -n "['"$line"', "$latitude", "$longitude"]," >> MIDDLE.txt
        else
                echo -n "['"$line"', "$latitude", "$longitude"]];" >> MIDDLE.txt
        fi
done

echo " " >> MIDDLE.txt
echo "var sort_markerLocations = [" >> MIDDLE.txt

grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" ip_Address.txt | while read -r line;
do
	echo "'"$line"']" >> MIDDLETEXT.txt
done

#sort -u MIDDLETEXT.txt > MIDDLENEXT.txt
#uniq -ic MIDDLENEXT.txt > MIDDLESORT.txt
cut -f 1 MIDDLETEXT.txt | sort | uniq -c > MIDDLESORT.txt
cat MIDDLESORT.txt | sed 's/\>/,/;s/,$//' > MIDDLEFINAL.txt

cat MIDDLEFINAL.txt | while read -r line;
do
	echo "[$line," >> MIDDLE.txt
done
echo "];" >> MIDDLE.txt
echo " " >> MIDDLE.txt

rm MIDDLETEXT.txt && rm MIDDLESORT.txt && rm MIDDLEFINAL.txt
echo "The middle text of HTML is complete!"

{
echo "  infowindow = new google.maps.InfoWindow();"
echo "  for (var location = 0; location < markerLocations.length; location++) {"
echo "        var ipLocation = markerLocations[location];"
echo "        var markerPin = new google.maps.Marker({"
echo "     position: {lat: ipLocation[1],lng: ipLocation[2]},"
echo "     map: map,"
echo "     title: ipLocation[0],"
echo "       });"
echo "     for (var index = 0; index < sort_markerLocations.length; index++) {"
echo "          var sort_Index = sort_markerLocations[index][1];"
echo "          var sort_Frequency = sort_markerLocations[index][0];"
echo "          if (sort_Index == markerPin.title) {"
echo "                  if (sort_Frequency == 1) {"
echo "                          markerPin.setIcon( 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|8F00FF' );"
echo "                  }"
echo "                  else if (sort_Frequency > 1 && sort_Frequency <= 5) {"
echo "                          markerPin.setIcon( 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|4B0082' );"
echo "                  }"
echo "                  else if (sort_Frequency > 5 && sort_Frequency <= 10) {"
echo "                          markerPin.setIcon( 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|0000FF' );"
echo "                  }"
echo "                  else if (sort_Frequency > 10 && sort_Frequency <= 28) {"
echo "                          markerPin.setIcon( 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|00FF00' );"
echo "                  }"
echo "                  else if (sort_Frequency > 28 && sort_Frequency <= 60) {"
echo "                          markerPin.setIcon( 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FFFF00' );"
echo "                  }"
echo "                  else if (sort_Frequency > 60 && sort_Frequency <= 178) {"
echo "                          markerPin.setIcon( 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FF7F00' );"
echo "                  }"
echo "                  else {"
echo "                          markerPin.setIcon( 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FF0000' );"
echo "                  }"
echo "          }"
echo "     }"
echo "     google.maps.event.addListener(markerPin, 'click', (function(markerPin, location) {"
echo "          return function() {"
echo "          infowindow.setContent(markerLocations[location][0]);"
echo "          infowindow.open(map, markerPin);"
echo "          }"
echo "    })(markerPin, location));"
echo "  }"
echo "}"
echo "</script> <script async defer src='https://maps.googleapis.com/maps/api/js?key=AIzaSyD9rIDcTNecNHWOnNriuFi6eCKugagx8XE&callback=initMap'></script>"
echo " <p><b>Jarrett Taylor: CSC382 - FINAL PROJECT</b></p>"
echo "</body>"
echo "</html>"
} > TAIL.txt

cat HEAD.txt MIDDLE.txt TAIL.txt > markerMAP.html
echo "markerMAP.html has been generated!"
