export IN_DISTROBOX=1
distrobox-host-exec ls 2> /dev/null > /dev/null || export IN_DISTROBOX=0

if [ "$IN_DISTROBOX" = "0" ]; then

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export PATH=$PATH:$(brew --prefix)/bin/
    export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:$(brew --prefix)/lib/pkgconfig/

fi
