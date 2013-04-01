#!/bin/bash
# Rick Astley in your Terminal. Prefers 256-color.
# 2013.03.04
# ~ keroserene <3
version='1.0'
my_head=${BASH_SOURCE[0]}
base_dir=$(dirname $my_head)
render='astley80.lulz'
# render='astley80.full'
script='astley.sh'

NEVER="cp -f"
GONNA_GIVE="${base_dir}/${render}"
YOU_UP="$HOME/.${render}"  # Rendering destination.
GONNA_TURN_AROUND="${base_dir}/${script}"
AND_DESERT_YOU="$HOME/.${script}"  # Script destination.
NEVER_GONNA_SAY_GOODBYE="http://dl.dropbox.com/u/29033049/lol/${render}"
NEVER_GONNA_TELL_A_LIE="INT TERM EXIT STOP SUSPEND"  # For evil mode.
AND_HURT_YOU="$HOME/.bashrc"

# Terminal helpers (Assumes 256 colors).
red='\e[38;5;9m'
purp='\e[38;5;171m'
yell='\e[38;5;216m'
green='\e[38;5;10m'
gr=$(which grep)
NEVER_GONNA_GIVE="cat"  # Mreow!

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
  unset astleys
  astleys=$(ps ax | $gr "${script} \| *${render}" | $gr -v "grep \| vim" | $gr -v $$ | awk '{print $1}')
  echo -en "${purp}Pending rick roll pids: ${yell}"
  echo -n $astleys
  echo -n " ... "
  kill -9 $astleys &> /dev/null
  echo -e "${red}Stopped."
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
# [[ -z $argged ]] && interactive

[[ $evil ]] && echo -en "${red}[Evil] "
[[ $inject ]] && echo -en "${yell}[Injection]"
echo

# Install local astley render if available.
if [[ -f $GONNA_GIVE ]]; then
  $NEVER $GONNA_GIVE $YOU_UP
elif [[ ! -f $YOU_UP ]]; then
  wget $NEVER_GONNA_SAY_GOODBYE -O "$YOU_UP.dl"
  mv "$YOU_UP.dl" $YOU_UP
fi

if [[ $inject ]]; then
  # Just inject, no rendering fun this time. Do preserve the evil flag, though.
  [[ $evil ]] && earg="evil"
  echo "$AND_DESERT_YOU $earg" >> $AND_HURT_YOU
  echo -e "${green}Rick Rolls appended to $AND_HURT_YOU. <3"
  quit
fi

bgmode=''
[[ $evil ]] && bgmode='&'

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
oooh() {
  echo $1
  [[ "$give" -gt "${#never_gonna[@]}" ]] && give=0
  echo -e "\e[2J\e[35;3H\e[0m${never_gonna[$give]}\e[H"
  (( give++ ))
  kill -CONT $GOTTA_MAKE_YOU_UNDERSTAND
}
if [[ $evil ]]; then
  # ... you know the rules, and so do I
  trap - $NEVER_GONNA_TELL_A_LIE
  trap "oooh" 1 2 9 15 17 19 20 23 24
fi
trap "clean" EXIT
# we know the game and we're gonna play it!
echo -e "\e[2J"

if [[ $evil ]]; then
  $NEVER_GONNA_GIVE $YOU_UP &
  GOTTA_MAKE_YOU_UNDERSTAND=$!
else
  # $NEVER_GONNA_GIVE $YOU_UP
  cnt=0
  fps=25
  ns_per_frame=$((1000000000 / fps))
  skip=0
  begin=$(nanosec)
  prev=$begin
  frame=0
  next_frame=0
  while read p; do
    ((cnt++))
    skip=0
    if [[ $cnt == 32 ]]; then
      cnt=0
      ((frame++))
      now=$(nanosec)
      elapsed=$((now - begin))
      next_frame=$((elapsed / ns_per_frame))
      repose=$((frame * ns_per_frame - elapsed))
      ((repose > 0)) && sleep $(printf 0.%09d $repose)
    fi
    # Only print if no frame skips are necessary.
    (( frame >= next_frame )) && echo -e "$p"
  done < $GONNA_GIVE
  quit
fi

while [[ 1 ]]; do
  echo -en ''
done
[[ $evil ]] && trap $NEVER_GONNA_TELL_A_LIE

echo -e '\e[u'
