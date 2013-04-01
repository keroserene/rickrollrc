#!/bin/bash
# Rick Astley in your Terminal.
# By Serene Han and Justine Tunney <3
version='1.0'
my_head=${BASH_SOURCE[0]}
base_dir=$(dirname $my_head)
script='astley.sh'

NEVER="cp -f"
# GONNA_GIVE="${base_dir}/${render}"
# YOU_UP="$HOME/.${render}"  # Rendering destination.
GONNA_TURN_AROUND="${base_dir}/${script}"
AND_DESERT_YOU="$HOME/.${script}"  # Script destination.
NEVER_GONNA_TELL_A_LIE="INT TERM EXIT STOP SUSPEND"  # For evil mode.
AND_HURT_YOU="$HOME/.bashrc"

# Terminal helpers (Assumes 256 colors).
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
  echo "  evil   - No prompts. Replaces shell signals with Rick Roll lyrics."
  echo "  stop   - Actually Gonna Give You Up. (Stop all roll'n processes) :("
  echo
}

prompt() {
  echo -ne "$yell > $1 $purp[y/n] $red"
  read input
  [[ "$input" == "y"* ]] && return 0
  return 1
}

clean() {
  [[ -f "$YOU_UP.dl" ]] && rm "$YOU_UP.dl"
  echo -e "${green}Goodbye. (I said it!)"
  quit
}

quit() {
  echo -en "\x1b[?25h \x1b[0m"   # Reset cursor
  [[ -n $save_term ]] || echo -e "\x1b[2J \x1b[H <3"
  [[ -n $return_mode ]] && return 0 || exit 0
}

nanosec() {
  date +%s%N
}

# Begin the things.
for arg in "$@"; do
  if [[ "$arg" == "help"* || "$arg" == "-h"* ]]; then
    argged=true
    usage && exit
  elif [[ "$arg" == "inject"* ]]; then
    argged=true
    inject=true
    save_term=true
  elif [[ "$arg" == "evil"* ]]; then
    argged=true
    evil=true
  elif [[ "$1" = "stop"* ]]; then
    argged=true
    save_term=true
    clean
  elif [[ "$arg" == "src"* ]]; then
    return_mode=true
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
  echo "$AND_DESERT_YOU $earg" >> $AND_HURT_YOU
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
  (( audpid > 1 )) && kill -CONT $audpid
  # pids=$(jobs -p)
  pids=$(jobs -l)
  kill -CONT $pids
  echo "$pids lulz $vidpid" >> ~/roflzz
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

# we know the game and we're gonna play it!
echo -e "\x1b[2J"

# Agnostic to curl or wget availability.
obtainium() {
  if hash curl 2>/dev/null; then
    curl -s $1
  else
    wget -q -O - $1
  fi
}

# Bean streamin'
bean="http://bean.vixentele.com/~keroserene"
remote="$bean/astley80.full.bz2"

if hash afplay 2>/dev/null; then
  # On Mac OS we pre-fetch compressed audio and use afplay.
  #remote="$bean/astley80.mac.bz2"
  echo "downloading audio..."
  obtainium $bean/roll.gsm.wav >/tmp/roll.gsm.wav
  afplay /tmp/roll.gsm.wav &
  audpid=$!
elif hash afplay 2>/dev/null; then
  # On Linux if the aplay command is available, we stream raw sound.
  obtainium $bean/roll.s16 | aplay -q -f S16_LE -r 8000 &
  audpid=$!
fi

# Print out frames, inserting pauses and skipping frames if necessary to stay
# as close as possible to real time.
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
