## ## DIAGNOSTICS
##
## ### `$LOGLEVEL`
##
## Default: 0
##
## See [`-d`](#-d) and [`-dd`](#-dd)
##
LOGLEVEL=${LOGLEVEL:-0}

_debug() {
    level="$1"
    shift
    if ((LOGLEVEL >= level));then
        echo -e "# \e[35;1mDEBUG\e[39;0m $*" >&2
    fi
}

_error() {
    echo -e "\e[31;1mERROR\e[39;0m $*" >&2
    exit 2
}
