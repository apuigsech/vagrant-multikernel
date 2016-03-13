#!/bin/bash

sudo apt-get install -y --no-install-recommends wget tar unzip git subversion python-pip python-dev > /dev/null

function install-packages {
	packages=$@
	sudo apt-get install -y --no-install-recommends $packages > /dev/null
}

function install-kernel {
    version=$1
    major=$(echo $version | cut -d . -f1)
    minor=$(echo $version | cut -d . -f2)
    release=$(echo $version | cut -d . -f3 | cut -d '-' -f1)

    if [ $major -lt 3 ] ; then
        folder=v${major}.${minor}
    fi
    if [ $major == 3 ] ; then
        if [ $minor == 0 ]; then
            folder=v${major}.${minor}
        else
            folder=v${major}.x
        fi
    fi
    if [ $major -gt 3 ] ; then
        folder=v${major}.x
    fi

    url=https://kernel.org/pub/linux/kernel/${folder}/linux-${version}.tar.gz
    download-url ${url}

    cd ${SRC_LOCAL_PATH}/linux-${version}

    currentconfig=/boot/config-$(uname -r)
    sudo rm -f .config
    sudo make defconfig

    sudo ${SRC_LOCAL_PATH}/linux-${version}/scripts/kconfig/merge_config.sh .config $currentconfig

    sudo make -j5

    sudo make modules
    sudo make modules_install
    sudo make install
}

function install-pip {
	pip=$@
	sudo pip install $@ > /dev/null
}

function download-git {
	git_url=$1
	git_name=$(basename $1 | cut -d . -f1)
	sudo git clone --depth 1 $1 ${SRC_LOCAL_PATH}/${git_name} > /dev/null
	P=${SRC_LOCAL_PATH}/${git_name}
}

function download-svn {
	svn_url=$1
	svn_name=$(basename $1 | cut -d . -f1)
	sudo svn co $1 ${SRC_LOCAL_PATH}/${git_name} > /dev/null
	P=${SRC_LOCAL_PATH}/${git_name}
}

function download-url {
	url=$1
	name=$(basename $1)
	ext=$(basename $1 | cut -d . -f2)
	sudo wget $1 -O ${SRC_LOCAL_PATH}/${name} -o /dev/null > /dev/null
	extract ${SRC_LOCAL_PATH}/${name} ${SRC_LOCAL_PATH} > /dev/null 
	P=${SRC_LOCAL_PATH}/${name}
}

function make-install {
	opts=$@
	sudo ./configure --prefix=${LOCAL_PATH} ${opts} || echo "./configure is not needed">/dev/null
	sudo make > /dev/null
	sudo make install > /dev/null
}

function extract {
    file=$1
    dest=$2
    if [ -z "${dest}" ] ; then
        dest=.
    fi
    cd $dest
    if [ -f $1 ] ; then
         case $1 in
            *.tar.bz2)   
                sudo tar xvjf $1
                ;;
            *.tar.gz)    
                sudo tar xvzf $1     
                ;;
            *.bz2)       
                sudo bunzip2 $1      
                ;;
            *.rar)
                sudo unrar x $1      
                ;;
            *.gz)
                sudo gunzip $1       
                ;;
            *.tar)
                sudo tar xvf $1      
                ;;
            *.tbz2)
                sudo tar xvjf $1     
                ;;
            *.tgz)
                sudo tar xvzf $1     
                ;;
            *.zip)
                sudo unzip $1        
                ;;
            *.Z)
                sudo uncompress $1   
                ;;
            *.7z)
                sudo 7z x $1         
                ;;
            *)  
                echo "'$1' cannot be extracted via extract" 
                ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
    cd -
}