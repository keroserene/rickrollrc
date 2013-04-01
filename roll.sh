#!/bin/bash
# Rick Astley in your Terminal.
# By Serene Han and Justine Tunney <3
version='1.0'
my_head=${BASH_SOURCE[0]}
base_dir=$(dirname $my_head)
NEVER_GONNA_TELL_A_LIE="INT TERM EXIT STOP SUSPEND"  # For evil mode.
bean="http://bean.vixentele.com/~keroserene"
remote="$bean/astley80.full.bz2"
AND_HURT_YOU="$HOME/.bashrc"
# Terminal helpers (Assumes 256 ttcolors).
red='\x1b[38;5;9m'
purp='\x1b[38;5;171m'
yell='\x1b[38;5;216m'
green='\x1b[38;5;10m'
echo -e '\x1b[s'  # Save cursor
usage () {
  echo -e "${green}Rick Astley performs ♪ Never Gonna Give You Up ♪ on STDOUT."
  echo -e "${yell}Usage: ./astley.sh [OPTIONS...]"
  echo
  echo -e "${purp}Options:${yell}"
  echo -e "  help   - Show this message."
  echo -e "  inject - Append to ${purp}${USER}${yell}'s bashrc. (Recommended :D)"
  echo
}
prompt() {
  echo -ne "$yell > $1 $purp[y/n] $red"
  read input
  [[ "$input" == "y"* ]] && return 0
  return 1
}
quit() {
  echo -en "\x1b[?25h \x1b[0m"   # Reset cursor
  [[ -n $save_term ]] || echo -e "\x1b[2J \x1b[H <3"
  [[ -n $return_mode ]] && return 0 || exit 0
}
for arg in "$@"; do
  if [[ "$arg" == "help"* || "$arg" == "-h"* ]]; then
    usage && exit
  elif [[ "$arg" == "evil"* ]]; then
    evil=true
  elif [[ "$arg" == "inject"* ]]; then
    inject=true
    save_term=true
  else
    echo -e "${red}Unrecognized option: $arg"
    usage && exit
  fi
done
[[ $evil ]] && echo -en "${red}[Evil] "
[[ $inject ]] && echo -en "${yell}[Injection]"
echo
if [[ $inject ]]; then
  # Just inject, no rendering fun this time. Do preserve the evil flag, though.
  [[ $evil ]] && earg="evil"
  echo "curl -L http://bit.ly/10hA8iC | bash" >> $AND_HURT_YOU
  echo -e "${green}Rick Rolls appended to $AND_HURT_YOU. <3"
  quit
fi

never_gonna=(
"We're no strangers to love"
"You know the rules and so do I"
"A full commitment's what I'm thinking of"
"You wouldn't get this from any other guy"
"I just wanna tell you how I'm feeling"
"Gotta make you understand"
"Never gonna give you up"
"Never gonna let you down"
"Never gonna run around and desert you"
"Never gonna make you cry"
"Never gonna say goodbye"
"Never gonna tell a lie and hurt you"
"We've known each other for so long"
"Your heart's been aching, but"
"You're too shy to say it"
"Inside, we both know what's been going on"
"We know the game and we're gonna play it"
"And if you ask me how I'm feeling"
"Don't tell me you're too blind to see"
"I just wanna tell you how I'm feeling"
"Gotta make you understand"
"Never gonna give you up"
"Never gonna let you down"
"Never gonna run around and desert you"
"Never gonna make you cry"
"Never gonna say goodbye"
"Never gonna tell a lie and hurt you")
give=0
audpid=0
# Emit a rick roll lyric.
oooh() {
  [[ "$give" -gt "${#never_gonna[@]}" ]] && give=0
  echo -e "\x1b[2J\x1b[35;3H\x1b[0m${never_gonna[$give]}\x1b[H"
  (( give++ ))
  # (( audpid > 1 )) && kill -CONT $audpid
  kill -CONT $(jobs -p)
}
cleanup() {
  (( audpid > 1 )) && kill $audpid
}
if [[ $evil ]]; then
  # ... you know the rules, and so do I
  trap - $NEVER_GONNA_TELL_A_LIE
  trap "oooh" 1 2 5 9 15 17 19 20 23 24
else
  trap "cleanup" INT
fi
trap "quit" EXIT
echo -e "\x1b[2J"
# Bean streamin'- agnostic to curl or wget availability.
obtainium() {
  if hash curl 2>/dev/null; then
    curl -s $1
  else
    wget -q -O - $1
  fi
}

if hash afplay 2>/dev/null; then
  # On Mac OS we pre-fetch compressed audio and use afplay.
  echo "downloading audio..."
  obtainium $bean/roll.gsm.wav >/tmp/roll.gsm.wav
  afplay /tmp/roll.gsm.wav &
  audpid=$!
elif hash aplay 2>/dev/null; then
  # On Linux if the aplay command is available, stream raw sound.
  obtainium $bean/roll.s16 | aplay -q -f S16_LE -r 8000 &
  audpid=$!
fi

# Sync FPS to reality as best as possible. Mac's freebsd version of date cannot
# has nanoseconds so inject python. :/
python <(cat <<EOF
import sys
import time
fps = 25
time_per_frame = 1.0 / fps
begin = time.time()
frame = 0
try:
  for i, line in enumerate(sys.stdin):
    if i % 32 == 0:
      frame += 1
      now = time.time()
      elapsed = now - begin
      next_frame = elapsed / time_per_frame
      repose = frame * time_per_frame - elapsed
      if repose > 0.0:
        time.sleep(repose)
    if frame >= next_frame:
      sys.stdout.write(line)
except KeyboardInterrupt:
  pass
EOF
) < <(obtainium $remote | bunzip2 -q 2> /dev/null)
echo -e '\x1b[u'  # Restore cursor position.
