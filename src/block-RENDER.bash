## ### RENDER
##
## Renders a file to markdown using a [shell expression](#render_ext).
##
## Runs on **first** pass
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[RENDER]=1

_block_RENDER() {
    renderfile="$1"
    ext=${renderfile##*.}
    _debug 2 "RENDER: extension == '$ext'"
    style="${EXT_TO_RENDER_STYLE[$ext]}"
    if [[ -z "$style" ]];then
        _error "Cannot render '$ext'. Define \$EXT_TO_RENDER_STYLE[$ext]."
    fi
    render="${RENDER_STYLE[$style]}"
    if [[ -z "$render" ]];then
        _error "Cannot render '$style'. Define \$RENDER_STYLE[$style]."
    fi
    # shellcheck disable=2059
    for dir in "${SHINCLUDE_PATH[@]}";do
        _debug 2 "RENDER: Trying $dir/$renderfile"
        if [[ -e "$dir/$renderfile" ]];then
            _debug 1 "RENDER: Rendering $dir/$renderfile"
            cmd=$(printf "${RENDER_STYLE[$style]}" "$dir/$renderfile")
            _debug 2 "RENDER: command == '$cmd'"
            printf "%s" "$(eval "$cmd")"
            return
        fi
    done
    _error "No file found in includes: $renderfile"
}
