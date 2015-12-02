#!/bin/bash

function printHelp() {
    echo "Syntax: user:pass[:e][:[uid][:gid]]..."
    echo "Use --readme for information and examples."
}

function printReadme() {
    cat /README.md
}

function createUser() {
    IFS=':' read -a param <<< $@
    user="${param[0]}"
    pass="${param[1]}"

    if [ -z "$user" -o -z "$pass" ]; then
        echo "You must at least provide a username and a password."
        printHelp
        exit 1
    fi

    if [ "${param[2]}" == "e" ]; then
        chpasswdOptions="-e"
        uid="${param[3]}"
        gid="${param[4]}"
    else
        uid="${param[2]}"
        gid="${param[3]}"
    fi

    useraddOptions="-D"

    if [ -n "$uid" ]; then
        useraddOptions="$useraddOptions -u $uid"
    fi

    if [ -n "$gid" ]; then
        useraddOptions="$useraddOptions -G $gid"
        addgroup -g $gid $gid
    fi

    adduser $useraddOptions $user
    chown root:root /home/$user
    chmod 755 /home/$user

    if [ -z "$pass" ]; then
        pass="$(echo `</dev/urandom tr -dc A-Za-z0-9 | head -c256`)"
        chpasswdOptions=""
    fi

    echo "$user:$pass" | chpasswd $chpasswdOptions

    if [ -d "/home/$user/.ssh/keys" ]; then
      cat /home/$user/.ssh/keys/* >> /home/$user/.ssh/authorized_keys
      chown $user /home/$user/.ssh/authorized_keys
      chmod 600 /home/$user/.ssh/authorized_keys
    fi

}

if [[ -z $1 || $1 =~ ^--help$|^-h$ ]]; then
    printHelp
    exit 0
fi

if [ "$1" == "--readme" ]; then
    printReadme
    exit 0
fi

for user in "$@"; do
    createUser $user
done

# generate host keys if not present
ssh-keygen -A

# do not detach (-D), log to stderr (-e), passthrough other arguments
# exec /usr/sbin/sshd -D -e $@
exec /usr/sbin/sshd -D
