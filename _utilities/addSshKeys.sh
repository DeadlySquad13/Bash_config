if [[ -x "$(command -v keychain)" ]]; then
    # This method needs password only once per login.

    # Just activate an agent to hook into secret manager. Without requiring any keys yet.
    eval $(keychain --eval --quiet --noask)

    # It requires to enter password manually by default. We want to only use it
    # with secret manager if it is activated. If it is not installed then
    # fallback to manual entry.
    #
    # Let A - secret manager exists,
    # let B - secret manager is running,
    # then:
    #   !A || (A & B) = 1 <=>
    #   (!A || A) & (!A || B) = 1 <=>
    #   !A || B = 1
    SECRET_MANAGER="keepassxc"
    # TODO: Actually we wan't not just running manager but manager that is
    # unlocked.
    if ! [[ -x "$(command -v $SECRET_MANAGER)" ]] || pidof -x "$SECRET_MANAGER" > /dev/null; then
        eval $(keychain --eval --quiet ${keys[@]})
    else
        echo "Run and unlock $SECRET_MANAGER to add ssh keys to agent"
    fi
else
    # [See](https://stackoverflow.com/a/10032655).
    eval $(ssh-agent)

    # Depends on system [check current system in bash](https://stackoverflow.com/a/17072017).
    unameOut="$(uname -s)"
    if [[ "${unameOut}" == "Darwin" ]]; then
        # Stores passwords in apple-keychain an automagically unlocks them at
        # login. You need to enter only user's password to login into system,
        # no need to enter anything at terminal.
        ssh-add --apple-use-keychain # May be need on first start.
        ssh-add --apple-load-keychain
    elif [[ "$(expr substr ${unameOut} 1 5)" == "Linux" ]]; then
        # Enter key at every session for each key.
        ssh-add ${keys[@]}
    fi
fi

