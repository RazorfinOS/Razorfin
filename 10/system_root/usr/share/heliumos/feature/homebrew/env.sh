export IN_DISTROBOX=1
distrobox-host-exec ls 2> /dev/null > /dev/null || export IN_DISTROBOX=0

if [ "$IN_DISTROBOX" = "0" ]; then

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export PATH=$PATH:$(brew --prefix)/bin/
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:$(brew --prefix)/include/
    export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$(brew --prefix)/include/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(brew --prefix)/lib/
    export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:$(brew --prefix)/lib/pkgconfig/

fi
