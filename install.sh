#!/bin/sh
#
# Flussonic installer

set -e
set -u

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

if [ `uname -m` != "x86_64" ]; then
    echo Flussonic needs x86_64 machine # but we run on ARM too
    exit 1
fi


if [ -f /etc/debian_version ]; then
    distro=debian
elif [ -f /etc/redhat-release ]; then
    distro=redhat
else
    echo Unknown Linux distro
    echo Debian or RedHat wanted  
    exit 1
fi


echo Distro: $distro


case $distro in
    debian)
        debian_updated=no
        pkg_install="dpkg -i"
        ;;
    redhat)
        pkg_install="rpm -Uv"
        ;;
esac


if [ `id -u` != 0 ]; then
    echo Must run as root
    exit 1
fi


debian_update()
{
    if [ $debian_updated = no ]; then
        apt-get update
        debian_updated=yes
    fi
}


debian_repo_install()
{
    debian_update
    apt-get -y install $1
}


redhat_repo_install()
{
    yum -y -q $1
}


check_curl()
{
    if [ ! -x /usr/bin/curl ]; then
        ${distro}_repo_install curl
    fi
}


debian_install()
{
    curl -sSf http://apt.flussonic.com/binary/gpg.key | apt-key add -;
    rm -f /etc/apt/sources.list.d/erlyvideo.list
    echo "deb http://apt.flussonic.com binary/" > /etc/apt/sources.list.d/flussonic.list
    debian_update
    apt-get -y --install-recommends --install-suggests install flussonic
}


redhat_install()
{
    cat > /etc/yum.repos.d/Flussonic.repo <<EOF
[flussonic]
name=Flussonic
baseurl=http://apt.flussonic.com/rpm
enabled=1
gpgcheck=0
EOF
    yum -y install flussonic-erlang flussonic flussonic-transcoder
}


debian_can_install_master()
{
    if status=`dpkg-query -f='${Status} ${Version}\n' -W flussonic 2>/dev/null`; then
        # echo DEBUG status: \"$status\"
        if ver=`expr match "$status" 'install ok installed \([0-9.]\+\)\(-[0-9]\+-g[a-f0-9]\+\)\?$'`; then
            if [ "$ver" != "$last_version" ]; then
                echo Package flussonic have version ${ver}, while last version is ${last_version}
                echo Upgrade via apt-get to the latest version
                exit 1
            fi
            # echo DEBUG can install master
            return
        fi

        echo Package flussonic have wrong status: \"$status\"
        exit 1
    fi

    echo Package flussonic not installed
    echo Install it as described here: http://flussonic.com/doc/installation
    exit 1
}


redhat_can_install_master()
{
    if ver=`rpm -q --qf '%{VERSION}' flussonic 2>/dev/null`; then
        if [ "$ver" != "$last_version" ]; then
            echo Package flussonic have version ${ver}, while last version is ${last_version}
            echo Upgrade via "yum update" to the latest version
            exit 1
        fi
        return
    fi
    echo Package flussonic not installed
    echo Install it as described here: http://flussonic.com/doc/installation
    exit 1
}


install_release()
{
    check_curl

    ${distro}_install

    echo
    echo Flussonic installed, run it:
    echo
    echo /etc/init.d/flussonic start
}


install_master()
{
    check_curl

    last_version_s=`curl -sfS http://apt.flussonic.com/binary/last_version.txt`
    last_version=`expr match "$last_version_s" 'last_version: \([0-9]\+\.[0-9]\+\.[0-9]\+\)$'`
    # echo DEBUG last version: $last_version

    ${distro}_can_install_master

    case $distro in
        debian)
            pkg_file="flussonic_latest_amd64.deb"
            ;;
        redhat)
            pkg_file="flussonic-latest-1.x86_64.rpm"
            ;;
    esac
    latest_url="http://apt.flussonic.com/nightly/${pkg_file}"
    echo $latest_url
    pkg_path="/tmp/${pkg_file}"
    rm -f $pkg_path
    curl -f -o $pkg_path $latest_url
    # ls -l $pkg_path
    ${pkg_install} ${pkg_path}
    rm -f $pkg_path
    
    echo
    echo The very latest version of Flussonic installed
    echo Restart Flussonic:
    echo
    echo /etc/init.d/flussonic restart
}


####


action=install_release


if [ $# -gt 0 ]; then
    case "$1" in
        master|-master)
            action=install_master
            ;;
        *)
            echo Invalid usage
            exit 1
    esac
fi


${action}
