# rickrollrc

Bash script which [Rick Rolls](http://en.wikipedia.org/wiki/Rickrolling) your
terminal by playing Rick Astley's "Never Gonna Give You Up" with ANSI 256-color
coded UTF-8 characters + audio (if available).

## How to Roll
To start rick rollin' immediately:

    curl https://raw.github.com/keroserene/rickrollrc/master/roll.sh | bash

Here is the clandestine command you can give to your friends :)

    curl -L http://bit.ly/10hA8iC | bash

![rickroll in xterm](http://i.imgur.com/ZAsQWtP.png)
![rickroll in mac](http://i.imgur.com/yDLaZna.png)

(For the record: It is not actually a good idea to make a habit of:
"curl $(random_script_from_the_internets) | bash")


Nevertheless, for the enhanced experience, I highly recommend the following:

    ./roll.sh inject

Which essentially just does:

    echo "curl -L http://bit.ly/10hA8iC | bash" >> ~/.bashrc

## Misc.

This has been tested on arch, debian, mac and cygwin (so far).
To enable sound in cygwin, install the **sox** package.

Since this is a colorful hobby, you need to ensure 256-color mode is enabled or
astley will look sad.

For example, if you use GNU screen, ensure your ~/.screenrc contains something
like:

    termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'
    defbce "on"

Kudos to jart our lovely hiptext shenanigans.
Please see our sister project: [hiptext](https://github.com/jart/hiptext), which
generates ANSI color codes for any image or video.

<3,

~serene ([@kiserene](http://twitter.com/kiserene))
