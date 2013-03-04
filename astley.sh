#!/bin/bash
# 2013.03.04 03:24:35
# ~ keroserene <3
NEVER="cp -f"
GONNA_GIVE="astley80.lulz"
YOU_UP="$HOME/.never_gonna_let_you_down"
GONNA_TURN_AROUND="astley.sh"
AND_DESERT_YOU="$HOME/.never_gonna_make_you_cry"
NEVER_GONNA_GIVE="cat"
I_JUST_WANNA_TELL_YOU_HOW_IM_FEELING="$HOME/.bashrc"
red='\e[38;5;9m'
purp='\e[38;5;171m'

`$NEVER $GONNA_GIVE $YOU_UP`

if [[ "$1" = "inject"* ]]; then
  `$NEVER $GONNA_TURN_AROUND $AND_DESERT_YOU`
  echo ". $AND_DESERT_YOU" >> $I_JUST_WANNA_TELL_YOU_HOW_IM_FEELING
  echo -e "${red}Rick Astley injection complete. <3"
  exit 0
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
trap - INT TERM EXIT STOP SUSPEND
trap "oooh" 1
trap "oooh" 2
trap "oooh" 15
trap "oooh" 17
trap "oooh" 19
trap "oooh" 20
trap "oooh" 24

# we know the game and we're gonna play it!
$NEVER_GONNA_GIVE $YOU_UP &
GOTTA_MAKE_YOU_UNDERSTAND=$!
while [[ 1 ]]; do
  echo -en ''
done

[[ $evil ]] && $trap 2

echo -e '\e[u'
