#!/bin/bash
# Rick Astley in your Terminal.
# By Serene and Justine Tunney <3
version='1.2'
rick='https://keroserene.net/lol'
video="$rick/astley80.full.bz2"
video_md5="edbbfe95554503c234b06fe67cc2015c"
# TODO: I'll let someone with mac or windows machine send a pull request
# to get gsm going again :)
audio_gsm="$rick/roll.gsm"
audio_gsm_md5="3340e14b6bbe21caed75342270002476"
audio_raw="$rick/roll.s16"
audio_raw_md5="1d658ad26815df86063a22641d69ff3e"
audpid=0
NEVER_GONNA='curl -s -L http://bit.ly/10hA8iC | bash'
MAKE_YOU_CRY="$HOME/.bashrc"
red='\x1b[38;5;9m'
yell='\x1b[38;5;216m'
green='\x1b[38;5;10m'
purp='\x1b[38;5;171m'
echo -en '\x1b[s'  # Save cursor.

# cache dir
if [ -d "$XDG_CACHE_HOME" ]; then
  # Linux
  full_commitment="$XDG_CACHE_HOME"
elif [ -d "$HOME/.cache" ]; then
  # The XDG spec defines ~/.cache as the default for XDG_CACHE_HOME
  full_commitment="$HOME/.cache"
elif [ -d "$HOME/Library/Caches" ]; then
  # Mac
  full_commitment="$HOME/Library/Caches"
else
  full_commitment="/tmp"
fi

full_commitment="$full_commitment/astley"

has?() { hash $1 2>/dev/null; }
cleanup() { (( audpid > 1 )) && kill $audpid 2>/dev/null; }
quit() { echo -e "\x1b[2J \x1b[0H ${purp}<3 \x1b[?25h \x1b[u \x1b[m"; }

usage () {
  echo -en "${green}Rick Astley performs ♪ Never Gonna Give You Up ♪ on STDOUT."
  echo -e "  ${purp}[v$version]"
  echo -e "${yell}Usage: ./astley.sh [OPTIONS...]"
  echo -e "${purp}OPTIONS : ${yell}"
  echo -e " help   - Show this message."
  echo -e " inject - Append to ${purp}${USER}${yell}'s bashrc. (Recommended :D)"
}
for arg in "$@"; do
  if [[ "$arg" == "help"* || "$arg" == "-h"* || "$arg" == "--h"* ]]; then
    usage && exit
  elif [[ "$arg" == "inject" ]]; then
    echo -en "${red}[Inject] "
    echo $NEVER_GONNA >> $MAKE_YOU_CRY
    echo -e "${green}Appended to $MAKE_YOU_CRY. <3"
    echo -en "${yell}If you've astley overdosed, "
    echo -e "delete the line ${purp}\"$NEVER_GONNA\"${yell}."
    exit
  else
    echo -e "${red}Unrecognized option: \"$arg\""
    usage && exit
  fi
done
trap "cleanup" INT
trap "quit" EXIT

# Bean streamin' - agnostic to curl or wget availability.
obtainium() {
  if has? curl; then curl -s $1
  elif has? wget; then wget -q -O - $1
  else echo "Cannot has internets. :(" && exit
  fi
}
# Verify files - agnostic to md5 or md5sum availability.
verify() {
  local MD5=
  if has? md5sum; then MD5=md5sum
  elif has? md5; then MD5=md5
  else return
  fi
  "$MD5" "$1" | grep -iq "$2"
}
echo -en "\x1b[?25l \x1b[2J \x1b[H"  # Hide cursor, clear screen.

# Ensure cache dir exists
[ -d "$full_commitment" ] || mkdir -p "$full_commitment"

#echo -e "${yell}Fetching audio..."
if has? afplay; then
  # On Mac OS, if |afplay| available, pre-fetch compressed audio.
  [ -f "$full_commitment/roll.s16" ] && verify "$full_commitment/roll.s16" "$audio_raw_md5" || obtainium $audio_raw >"$full_commitment/roll.s16"
  afplay "$full_commitment/roll.s16" &
elif has? aplay; then
  # On Linux, if |aplay| available, stream raw sound.
  if [ -f "$full_commitment/roll.s16" ] && verify "$full_commitment/roll.s16" "$audio_raw_md5"; then
    aplay -Dplug:default -q -f S16_LE -r 8000 "$full_commitment/roll.s16" &
  else
    obtainium $audio_raw | tee "$full_commitment/roll.s16" | aplay -Dplug:default -q -f S16_LE -r 8000 &
  fi
elif has? play; then
  # On Cygwin, if |play| is available (via sox), pre-fetch compressed audio.
  [ -f "$full_commitment/roll.gsm.wav" ] && verify "$full_commitment/roll.gsm.wav" "$audio_gsm_md5" || obtainium $audio_gsm >"$full_commitment/roll.gsm.wav"
  play -q "$full_commitment/roll.gsm.wav" &
fi
audpid=$!

#echo -e "${yell}Fetching video..."
# Sync FPS to reality as best as possible. Mac's freebsd version of date cannot
# has nanoseconds so inject python. :/
python <(cat <<EOF
import sys
import time
fps = 25; time_per_frame = 1.0 / fps
buf = ''; frame = 0; next_frame = 0
begin = time.time()
try:
  for i, line in enumerate(sys.stdin):
    if i % 32 == 0:
      frame += 1
      sys.stdout.write(buf); buf = ''
      elapsed = time.time() - begin
      repose = (frame * time_per_frame) - elapsed
      if repose > 0.0:
        time.sleep(repose)
      next_frame = elapsed / time_per_frame
    if frame >= next_frame:
      buf += line
except KeyboardInterrupt:
  pass
EOF
) < <(if [ -f "$full_commitment/astley80.full.bz2" ] && verify "$full_commitment/astley80.full.bz2" "$video_md5"; then
  bzcat -q "$full_commitment/astley80.full.bz2" 2> /dev/null
else
  obtainium $video | tee "$full_commitment/astley80.full.bz2" | bunzip2 -q 2> /dev/null
fi
)
