#!/bin/bash

printf "Paste video url: "

while [[ true ]]; do
  read url
  youtube-dl -f 135 $url > newx
  youtube-dl -f 140 $url > newy

  sed -i 's/ //1' newx
  sed -i 's/ //1' newy

grep -i downloaded newy | cut -d ] -f 2 > audio
sed -i 's/ has already been downloaded//1' audio
audio=$(grep -i m4a audio)

grep -i downloaded newx | cut -d ] -f 2 > video
sed -i 's/ has already been downloaded//1' video
video=$(grep -i mp4 video)

output=$(grep -i mp4 video | cut -d - -f 1)
{
  ffmpeg -i "$video" -i "$audio" -c:v copy -c:a aac -strict experimental "$output.mp4"
} &> /dev/null



  printf "\nYour video have been downloaded\n\n"
  printf "Paste another url: "
done
