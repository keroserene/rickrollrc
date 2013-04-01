#!/bin/bash
# Rick Astley in your Terminal. Prefers 256-color.
# 2013.03.04
# ~ keroserene <3
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
red='\e[38;5;9m'
purp='\e[38;5;171m'
yell='\e[38;5;216m'
green='\e[38;5;10m'
gr=$(which grep)
NEVER_GONNA_GIVE="cat"  # Mreow!

echo -e '\e[s'  # Save cursor

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
  echo -en "\e[?25h \e[0m"   # Reset cursor
  [[ -n $save_term ]] || echo -e "\e[2J \e[H <3"
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
# Emit a rick roll lyric.
oooh() {
  [[ "$give" -gt "${#never_gonna[@]}" ]] && give=0
  echo -e "\e[2J\e[35;3H\e[0m${never_gonna[$give]}\e[H"
  (( give++ ))
  kill -CONT $audpid
  # pids=$(jobs -p)
  pids=$(jobs -l)
  kill -CONT $pids
  echo "$pids lulz $vidpid" >> ~/roflzz
}
if [[ $evil ]]; then
  # ... you know the rules, and so do I
  trap - $NEVER_GONNA_TELL_A_LIE
  trap "oooh" 1 2 5 9 15 17 19 20 23 24
fi
trap "quit" EXIT

# we know the game and we're gonna play it!
echo -e "\e[2J"

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
audio="$bean/roll.s16"

# Print out frames, inserting pauses and skipping frames if necessary to stay
# as close as possible to real time.
python <(cat <<EOF
import sys
import time
fps = 25
time_per_frame = 1.0 / fps
begin = time.time()
frame = 0
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
EOF
) < <(obtainium $remote | bunzip2 -q 2> /dev/null)

echo -e '\e[u'  # Restore cursor position.
