#!/bin/bash
cd ~
printf "Paste video url: "
while [[ true ]]; do
  read url

cd Videos/Downloads/Dump

printf "Video is being downloaded\n"
youtube-dl -f 135 $url 2>&1| tee newx
printf "Video has been downloaded\n\n"

printf "Audio is being downloaded"
youtube-dl -f 140 $url 2>&1| tee newy

  sed -i 's/ //2' newx
  sed -i 's/ //2' newy

  video=$(grep -i Destination newx | cut -d : -f 2)
  audio=$(grep -i Destination newy | cut -d : -f 2)

  if [ -z "$audio" ]
  then
  printf "Audio has not been downloaded\n\n"

  printf "Another audio is being downloaded"
  youtube-dl -f 141 $url 2>&1| tee newy
  printf "Audio has been downloaded\n\n"
  audio=$(grep -i Destination newy | cut -d : -f 2)
else
  printf "Audio has been downloaded\n\n"
  fi

  sed -i 's/-/:/g' newx
  output=$(grep -i Destination newx | cut -d : -f 2)

  printf "The video is being merged\n"
  ffmpeg -i "$video" -i "$audio" -c:v copy -c:a aac -strict experimental "$output.mp4"
  printf "The video has been merged\n\n"



while true; do
    read -p "Delete DASH files?" yn
    case $yn in
        [Yy]* ) rm "$video";rm "$audio"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
  mv "$output.mp4" .. 
  printf "The file $output.mp4 has been saved\n\n"
  read -p "Play the video?" yn
    case $yn in
        [Yy]* ) mplayer "../$output.mp4";;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
  printf "Paste another url: "
done
