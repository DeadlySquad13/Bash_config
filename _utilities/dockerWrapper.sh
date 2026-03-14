# Docker shorthands for common commands.
# Example:
# # Will show currently working docker services
# dockerWrapper ps
# # Both will do the same: show logs for the services in current compose.
# dockerWrapper compose logs
# dockerWrapper c logs
dockerWrapper() {
    if [[ "$1" = "c" ]] || [[ "$1" = "compose" ]]; then
        shift;
        docker compose "$@"
    else
        docker "$@"
    fi
}

# INFO: Testing docker completion with:
# `BASH_COMP_DEBUG_FILE="$(pwd)/comp.log"` and `tail -f comp.log`


# Custom completion for dockerWrapper.
_dockerWrapper_completion() {
    # INFO: Requries `eval "$(docker completion bash)"` beforehand. We assume in this
    # module that it's already done.
    REQUIRES_FUNCS __start_docker

    # Save original globals.
    local original_words original_cword original_line original_point
    original_words=("${COMP_WORDS[@]}")
    original_cword=$COMP_CWORD
    original_line="$COMP_LINE"
    original_point=$COMP_POINT

    # Transform arguments.
    local words cword
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD

    # Always pretend the command is 'docker'.
    words[0]="docker"

    # If the first argument is 'c', map it to 'compose'.
    if [[ ${#words[@]} -gt 1 && "${words[1]}" == "c" ]]; then
        words[1]="compose"
    fi

    # Reconstruct the new command line with cursor at the end.
    local new_line=""
    local i
    for i in "${!words[@]}"; do
        if [[ $i -eq 0 ]]; then
            new_line="${words[$i]}"
        else
            new_line="$new_line ${words[$i]}"
        fi
    done
    local new_point=${#new_line}  # cursor at end of line

    # Override globals for the duration of the completion function.
    COMP_WORDS=("${words[@]}")
    COMP_CWORD=$cword
    COMP_LINE="$new_line"
    COMP_POINT=$new_point

    # Call the original docker completion function (sets COMPREPLY).
    __start_docker

    # Restore original globals so the shell uses the user's original line for insertion.
    # COMP_WORDS=("${original_words[@]}")
    # COMP_CWORD=$original_cword
    # COMP_LINE="$original_line"
    # COMP_POINT=$original_point
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F _dockerWrapper_completion dockerWrapper
else
    complete -o default -o nospace -F _dockerWrapper_completion dockerWrapper
fi
