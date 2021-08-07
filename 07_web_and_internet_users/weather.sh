# 58 Keeping Track of the Weather
#!/bin/bash

# weather--Users the Wunderground API to get the wather for a given ZIP code
if [ $# -ne 1 ] ; then
  echo "Usage: $0 <zipcode>"
  exit 1
fi

apikey=""

weather=`curl -s \
  "https://api.wunderground.com/api/$apikey/conditions/q/$1.xml"`
state=`xmllint --xpath \
  //response/current_observation/display_location/full/text\(\) \
  < (echo $weather)`
zip=`xmllint --xpath \
  //response/current_observation/display_location/zip/text\(\) \
  < (echo $weather)`
current=`xmllint --xpath \
  //response/current_observation/temp_f/text\(\) \
  < (echo $weather)`
condition=`xmllint --xpath \
  //response/current_observation/weather/text/(\) \
  < (echo $weather)`

echo $state" ("$zip"): Current tmp "$current"F and "$condition" outside."

exit 0
