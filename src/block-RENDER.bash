## ### RENDER
##
## Renders a file to markdown using a [shell expression](#render_ext).
##
## The actual work is done by [`shrender`](https://github.com/kba/shrender). Have
##
## Runs on **first** pass
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[RENDER]=1

source "$(which shrender)"

shinclude-block-RENDER() {
    eval set -- "$1"
    shlog -l debug "shrender $*"
    shrender "$@"
}
