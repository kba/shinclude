## ### BANNER
##
## Shows a banner using FIGlet or TOIlet
##
## BANNER Runs on **first** pass
## 
##     # BEGIN-BANNER -f standard -w <pre> </pre> foo
##     # END-BANNER
## 
## 
## will be transformed to
## 
##     # BEGIN-BANNER -f standard -w <pre> </pre> foo
##     <pre>
##       __             
##      / _| ___   ___  
##     | |_ / _ \ / _ \ 
##     |  _| (_) | (_) |
##     |_|  \___/ \___/ 
##     </pre>
##     # END-EVAL
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[BANNER]=1

_draw_banner() {
    fontname="standard"
    prefix=""
    suffix=""
    indent=""
    ##
    ## #### Options
    while [[ "$1" = -* ]];do
        case "$1" in 
            ## ##### -f, --font FONT
            ##
            ## Specify font. See `/usr/share/figlet` for a list of fonts.
            ##
            -f|--font) fontname="$2"; shift ;;
            ## ##### -i, --indent INDENT
            ##
            ## Specify indent. Example: `-i "\t"`, `-i '    '`
            ##
            -i|--indent) indent="$2"; shift ;;
            ## ##### -w, --wrap BEFORE AFTER
            ##
            ## Wrap in lines. E.g `-w '<pre>' '</pre'`
            ##
            -w|--wrap) prefix="$2" ; suffix="$3" ; shift ; shift ;;
            *) _error "Unknown option '$1' passed to BANNER" ;;
        esac
        shift
    done
    figletOutput=$(echo -nE "$@" | figlet -w140 -f "$fontname")
    if [[ $? != 0 ]];then
        _error "Figlet threw an error!"
    fi
    [[ ! -z "$prefix" ]] && echo "$prefix"
    echo -nE "$figletOutput" |grep '[^ ]'|sed "s/^/$indent/"
    [[ ! -z "$suffix" ]] && echo "$suffix"
    return 0
}

_block_BANNER() {
    eval set -- "$1"
    _debug 0 "_draw_banner '$1' '$2' '$3' '$4'"
    _draw_banner "$@"
}
