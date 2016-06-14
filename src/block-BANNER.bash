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
    while [[ "$1" = -* ]];do
        case "$1" in 
            -f|--font) fontname="$2"; shift ;;
            -i|--indent) indent="$2"; shift ;;
            -w*|--wrap) prefix="$2" ; suffix="$3" ; shift ; shift ;;
            *) _error "Unknown option '$1' passed to BANNER" ;;
        esac
        shift
    done
    [[ ! -z "$prefix" ]] && echo "$prefix"
    echo -nE "$@" | figlet -w140 -f "$fontname" |grep '[^ ]'|sed "s/^/$indent/"
    [[ ! -z "$suffix" ]] && echo "$suffix"
}

_block_BANNER() {
    # local blockargs fontname prefix suffix
    eval set -- "$1"
    # local IFS=" ";read -r -a blockargs <<< "$1"
    _debug 0 "_draw_banner '$1' '$2' '$3' '$4'"
    _draw_banner "$@"
}
