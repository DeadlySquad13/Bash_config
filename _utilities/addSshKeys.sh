if [ -x "$(command -v keychain)" ]; then
    # Needs password only once per login.
    eval $(keychain --eval --quiet ${keys[@]})
else
    # [See](https://stackoverflow.com/a/10032655).
    eval $(ssh-agent)

    # Depends on system [check current system in bash](https://stackoverflow.com/a/17072017).
    unameOut="$(uname -s)"
    if [ "${unameOut}" == "Darwin" ]; then
        # Stores passwords in apple-keychain an automagically unlocks them at
        # login. You need to enter only user's password to login into system,
        # no need to enter anything at terminal.
        ssh-add --apple-use-keychain # May be need on first start.
        ssh-add --apple-load-keychain
    elif [ "$(expr substr ${unameOut} 1 5)" == "Linux" ]; then
        # Enter key at every session for each key.
        ssh-add ${keys[@]}
    fi
fi

