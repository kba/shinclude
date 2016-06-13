## ### RENDER
##
## Renders a file to markdown using a [shell expression](#render_ext).
##
## The render method is determined by the file extension, see 
## [RENDER STYLES](#render-styles) for a list of render methods
##
## Runs on **first** pass
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[RENDER]=1

_block_RENDER() {
    local renderfile renderpath
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
        renderpath="$dir/$renderfile"
        _debug 2 "RENDER: Trying $renderpath"
        if [[ -e "$renderpath" ]];then
            _debug 1 "RENDER: Rendering $renderpath"
            cmd="${RENDER_STYLE[$style]}"
            cmd=${cmd//__FILENAME__/$renderpath}
            _debug 1 "RENDER: command == '$cmd'"
            output=$(eval "$cmd")
            if (( $? > 0 ));then
                _error "Rendering failed: $output"
            fi
            printf "%s" "$output"
            return
        fi
    done
    _error "No file found in includes: $renderfile"
}
