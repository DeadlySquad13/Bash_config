# Check if:
#   1. tmux exists on the system,
#   2. we're in an interactive shell,
#   3. tmux doesn't try to run within itself.
if command -v tmux &> /dev/null \
  && [[ -n "$PS1" ]] \
  && [[ ! "$TERM" =~ screen ]] \
  && [[ ! "$TERM" =~ tmux ]] \
  && [[ -z "$TMUX" ]];
then
  tmux attach -t main || tmux new -s main
fi

