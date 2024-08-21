# Sytemctl shorthands for common commands.
# Source: alzee. “Answer to ‘How to Make Alias to Systemctl with Autocomplete.’” Ask Ubuntu, April 9, 2022. https://askubuntu.com/a/1401610.
# Do we need sudo in user mode?
# Example:
# # Will show status for docker service for current user.
# systemctlWrapper u s docker
systemctlWrapper() {
    userMode=false

    if [[ "$1" = "u" ]] || [[ "$1" = "user" ]]; then
        shift;
        userMode=true
    fi

    case $1 in
        e)
            shift;
            if [[ "$userMode" = true ]]; then
                systemctl enable --now --user "$@"
            else
                sudo systemctl enable --now "$@"
            fi
        ;;
        d)
            shift;
            if [[ "$userMode" = true ]]; then
                systemctl disable --now --user "$@"
            else
                sudo systemctl disable --now "$@"
            fi
        ;;
        s)
            shift;
            if [[ "$userMode" = true ]]; then
                systemctl status --user "$@"
            else
                systemctl status "$@"
            fi
        ;;
        S)
            shift;
            if [[ "$userMode" = true ]]; then
                systemctl start --user "$@"
            else
                sudo systemctl start "$@"
            fi
        ;;
        x)
            shift;
            if [[ "$userMode" = true ]]; then
                systemctl stop --user "$@"
            else
                sudo systemctl stop "$@"
            fi
        ;;
        r)
            shift;
            if [[ "$userMode" = true ]]; then
                systemctl restart --user "$@"
            else
                sudo systemctl restart "$@"
            fi
        ;;
        *)
            if [[ "$userMode" = true ]]; then
                systemctl --user "$@"
            else
                systemctl "$@"
            fi
        ;;
    esac
}
