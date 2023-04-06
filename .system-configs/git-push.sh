#!/usr/bin/env bash

path="/home/pi/printer_data/config"
echo "Watching $path"

# watch for changes in the path
while inotifywait -e modify -e create -e delete -e move -e attrib $path; do
  echo "Change detected in $path"
  echo "Pushing to git"
  # cd to path
  /usr/bin/git --git-dir=$path/.git --work-tree=$path add $path
  # commit with date
  /usr/bin/git --git-dir=$path/.git --work-tree=$path commit -m $(date +'%Y%m%d.%H%M')
  # push to git repo
  /usr/bin/git --git-dir=$path/.git --work-tree=$path push
  echo "Pushed to git"
done
