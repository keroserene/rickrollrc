# rickrollrc

Bash script which [Rick Rolls](http://en.wikipedia.org/wiki/Rickrolling) your
terminal by playing a Rick Astley's Never Gonna Give You Up music video inside
your 256-color terminal with audio (if available).

## How to Roll
To start rick rollin' immediately:

    curl https://raw.github.com/keroserene/rickrollrc/master/roll.sh | bash

Here is the clandestine command you can give to your friends :)

    curl -L http://bit.ly/10hA8iC | bash

![rickroll in xterm](http://i.imgur.com/ZAsQWtP.png)
![rickroll in mac](http://i.imgur.com/yDLaZna.png)

This has been tested on arch, debian, mac and cygwin (so far).
To enable sound in cygwin, install the **sox** package.

For the record: It is not actually a good idea to make a habit of:
"curl $(random_script_from_the_internets) | bash"

Nevertheless, for the enhanced experience, I highly recommend the following:

    echo "curl https://raw.github.com/keroserene/rickrollrc/master/roll.sh | bash" >> ~/.bashrc

Which is just:

    ./roll.sh inject

Kudos to jart for our hiptext shenanigans ;)
Please see our sister project: [hiptext](https://github.com/jart/hiptext)
