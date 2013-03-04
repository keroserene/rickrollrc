#!/bin/bash
# Rick Astley in your Terminal. Prefers 256-color.
# Execution must occur from same directory
# 2013.03.04 03:24:35
# ~ keroserene <3

NEVER="cp -f -v"
GONNA_GIVE="astley80.lulz"
YOU_UP="$HOME/.never_gonna_let_you_down"
GONNA_TURN_AROUND="astley.sh"
AND_DESERT_YOU="$HOME/.never_gonna_make_you_cry"
NEVER_GONNA_SAY_GOODBYE='http://dl.dropbox.com/u/29033049/lol/astley80.lulz'
NEVER_GONNA_TELL_A_LIE="INT TERM EXIT STOP SUSPEND"
I_JUST_WANNA_TELL_YOU_HOW_IM_FEELING="$HOME/.bashrc"
red='\e[38;5;9m'
purp='\e[38;5;171m'
yell='\e[38;5;216m'
green='\e[38;5;10m'
gr=$(which grep)
NEVER_GONNA_GIVE="cat"
prompt() {
  echo -ne "$yell > $1 $purp[y/n] $red"
  read input
  [[ "$input" == "y"* ]] && return 0
  return 1
}
clean() {
  kill -9 $astleys &> /dev/null
  exit 0
}
unset astleys
astleys=$(ps ax | $gr './astley.sh' | $gr '/bin/' | $gr -v "$$" | awk '{print $1}')

# Safety first m'dears
if [[ "$1" = "stop"* ]]; then
  echo -e "${red}Never gonna say goodbye. |c|=${#astleys[@]}"
  echo -e "${purp}Roll'n PIDs:${yell}"
  echo $astleys
  echo -e "${green} ... goodbye <3"
  clean
fi 

#
if [[ "$1" == "inject" ]]; then
  inject=true
  echo -e "${green}Injection Mode (bashrc)"
  echo -e "${red}Inside, we both know what's been going on.${purp}"

elif [[ "$1" != "lulz"* ]]; then
  echo -e " ${green} Options:${purp}"
  echo  "    lulz : Skip prompts, 'handle' sigs."
  echo  "    inject : Bring a guest to your bashrc."
  echo  "    stop : Done roll'n with astley."
  echo -e " ${green} Astley PIDs:" $astleys
  prompt "May I tell you how I'm feeling?"
  if [[ $? -gt 0 ]]; then
    prompt "Inject into bashrc?"
    [[ $? -gt 0 ]] && echo " Abort. " && clean
    inject=true
  fi
fi

# Append .bashrc for additional lulz
if [[ $inject ]]; then
  echo -en "${yell}cp: "
  $NEVER $GONNA_TURN_AROUND $AND_DESERT_YOU
  echo "$AND_DESERT_YOU lulz" >> $I_JUST_WANNA_TELL_YOU_HOW_IM_FEELING
  echo -e "${purp}...appended to $I_JUST_WANNA_TELL_YOU_HOW_IM_FEELING"
  echo -e "${green}Your astley injections has come to fruition. <3"
  exit 0
fi

# Ensure ready to roll, either via local or wget
if [[ -f $GONNA_GIVE ]]; then
  $NEVER $GONNA_GIVE $YOU_UP
elif [[ ! -f $YOU_UP ]]; then
  echo -e "${red}We're no strangers to love${purp}"
  wget $NEVER_GONNA_SAY_GOODBYE -O "$YOU_UP.dl"
  mv "$YOU_UP.dl" $YOU_UP
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
oooh() {
  echo $1
  [[ "$give" -gt "${#never_gonna[@]}" ]] && give=0
  echo -e "\e[2J\e[35;3H\e[0m${never_gonna[$give]}\e[H"
  (( give++ ))
  kill -CONT $GOTTA_MAKE_YOU_UNDERSTAND
}
# ... you know the rules, and so do I
trap - $NEVER_GONNA_TELL_A_LIE
trap "oooh" 1
trap "oooh" 2
trap "oooh" 15
trap "oooh" 17
trap "oooh" 19
trap "oooh" 20
trap "oooh" 24
# we know the game and we're gonna play it!
echo -e "\e[2J"
$NEVER_GONNA_GIVE $YOU_UP &
GOTTA_MAKE_YOU_UNDERSTAND=$!
while [[ 1 ]]; do
  echo -en ''
done
trap $NEVER_GONNA_TELL_A_LIE

echo -e '\e[u'
