#/bin/bash

REPO_DIR=~/.aur

initialise () {
    mkdir -p $REPO_DIR
    cd $REPO_DIR
}

fetch () {
    cd $REPO_DIR
    if [ ! -d "$REPO_DIR/$1" ]
    then
        echo "Fetching $1 from AUR"
        git clone https://aur.archlinux.org/$1.git
    else
        echo "Updating $1 from AUR"
        cd "$REPO_DIR/$1"
        git pull
    fi
}

install () {
    echo "Installing $1 from AUR"
    cd "$REPO_DIR/$1"
    echo "Inspect PKGBUILD for $1? (Y/n)"
    read RESP
    if [ ! "$RESP" = "n" ] || [ -z "$RESP" ]
    then
        less PKGBUILD 
    fi

    echo "Continue with build and install? (y/N)"
    read RESP
    if [ "$RESP" = "y" ]
    then
        echo "Building and installing $1"
        makepkg -si
        echo "Done installing $1"
    else
        echo "Package $1 not installed"
    fi
}

remove () {
    sudo pacman -R $1
    rm -rf "$REPO_DIR/$1"
    echo "Package $1 removed"
}

initialise

if [ $1 = "fetch" ] || [ $1 = "f" ] 
then
    echo "Running fetch"
    fetch $2
elif [ $1 = 'install' ] || [ $1 = 'i' ] 
then 
    if [ ! -d "$REPO_DIR/$2" ] 
    then
        fetch $2
    fi
    install $2
elif [ $1 = 'remove' ] || [ $1 = 'r' ] 
then
    remove $2
fi
