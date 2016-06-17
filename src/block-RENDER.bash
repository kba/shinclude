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
    eval set -- "$1"
    _debug 0 "_block_RENDER $*"
    local renderfile="${!#}"
    local ext=${renderfile##*.}
    local to_render
    local renderfunc
    while [[ "$1" = -* ]];do
        case "$1" in
            #help:|-f,--func FUNCTION|Render function
            -f|--func*) renderfunc="$2"; shift ;;
            *) break ;;
        esac
        shift
    done
    if [[ -z "$renderfunc" ]];then
        _debug 1 "RENDER: Detecting render function by extension '$ext'"
        renderfunc="${EXT_TO_RENDER_FUNC[$ext]}"
        if [[ -z "$renderfunc" ]];then
            _debug 1 "RENDER: Fall back to  'prefix' render function"
            renderfunc='prefix'
        fi
    fi
    if ! declare -f "_render_$renderfunc" >/dev/null;then
        _error "Undefined render function '$renderfunc'."
    fi
    for dir in "${SHINCLUDE_PATH[@]}";do
        to_render="$dir/$renderfile"
        _debug 2 "RENDER: Trying $to_render"
        if [[ ! -e "$to_render" ]];then
            continue;
        fi
        _debug 1 "RENDER: Rendering $to_render"
        _debug 0 "_render_$renderfunc '$*'"
        # _render_prefix
        # _render_jade
        "_render_$renderfunc" "$@"
        if (( $? > 0 ));then
            _error "Rendering failed: $output"
        fi
        return
    done
    _error "No file found in includes: $renderfile"
}

_render_prefix() {
    local prefix
    local renderfile="${!#}"
    local ext=${renderfile##*.}
    _debug 1 "RENDER: Derive render prefix from extension '$ext'"
    local prefix="${EXT_TO_RENDER_PREFIX[$ext]}"
    while [[ "$1" = -* ]];do
        case "$1" in
            -p|--prefix) prefix="$2"; shift ;;
            *) _error "Unknown option '$1' to _render_prefix" ;;
        esac
        shift
    done
    if [[ -z "$prefix" ]];then
        _debug 0 "Cannot derive render prefix from '$ext'."
        _debug 0 "Falling back to renderprefix='##'."
        _debug 0 "Define EXT_TO_RENDER_PREFIX[$ext]='...' to override.\n"
        prefix='##'
    fi
    awk '{gsub("__CURLINE__",NR,$0);print}' "$1" \
        | grep "^\s*$prefix" \
        | sed "s/^\s*$prefix\s\?//"
}

_render_jade() {
    local renderfile="${!#}"
    # shellcheck disable=2094
    jade -p "$renderfile" -P < "$renderfile" |sed -n '2,$p'
}
