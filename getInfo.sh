#!/bin/bash

dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
if [ "$1" = status ]; then
  dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | tail -n1 | cut -d'"' -f2
elif [ "$1" = artist ]; then
  dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk -f "$dir/awk/artist.awk"
elif [ "$1" = album ]; then
  dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk -f "$dir/awk/album.awk"
elif [ "$1" = song ]; then
  dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk -f "$dir/awk/title.awk"
elif [ "$1" = length ]; then
  length=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk -f "$dir/awk/length.awk")
  echo $(( length / 1000000 ))
elif [ "$1" = position ]; then
  # Returns position of current song in seconds
  position=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Position' | tail -n1 | sed "s/ \+/ /g" | cut -d" " -f4)
  echo $(( position / 1000000 ))
elif [ "$1" = checkup ]; then
  dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' > /dev/null 2>&1 && echo 1 || echo 0
else
  echo "Unrecognised info key '$1'. Available keys are 'status', 'artist', 'song', 'length', 'position', 'checkup'."
fi
