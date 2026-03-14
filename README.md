# Bash config

A personal config with custom settings, commands, bash scripts and helper
functions for various common tasks.

## Architecture

- `_utilities` - a collection of utilities that are used in everyday life.
Has some wrappers around cli-utils like `ripgrep` but it doesn't expect them to
be installed or relies on them in any way.
- `shared-` - a namesapce of **pure bash** functions to make development in
bash easier. Expected to be shared and imported to any module and 3rd-party
script on the computer. At most uses builtin Unix utils like `sed` that are
present at most distributions.
<!-- There may be in the future something like `_adapters` or `_wrappers` for
scripts that interact with 3rd-party programs. But currently scripts are so
small that it's easier to fulfil this role with Nix tools alone. -->

Every other file apart from some platform-spicific `.bashrc`'s and `_alias`'es
are considered a separate finished script. For doing everything you need to do
related to a specific task.
