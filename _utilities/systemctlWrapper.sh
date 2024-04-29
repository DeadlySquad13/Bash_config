# Sytemctl shorthands for common commands.
# Source: alzee. “Answer to ‘How to Make Alias to Systemctl with Autocomplete.’” Ask Ubuntu, April 9, 2022. https://askubuntu.com/a/1401610.
# ?: Always sudo, what about --user?
systemctlWrapper() {
    case $1 in
        e)
            shift;
            sudo systemctl enable --now "$@"
        ;;
        d)
            shift;
            sudo systemctl disable --now "$@"
        ;;
        s)
            shift;
            systemctl status "$@"
        ;;
        S)
            shift;
            sudo systemctl stop "$@"
        ;;
        r)
            shift;
            sudo systemctl restart "$@"
        ;;
        *)
            systemctl "$@"
        ;;
    esac
}
