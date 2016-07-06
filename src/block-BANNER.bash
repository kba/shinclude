## ### BANNER
##
## Shows a banner using FIGlet or TOIlet
##
## BANNER Runs on **first** pass
## 
##     # BEGIN-BANNER -f standard -w '<pre>' '</pre>' foo
##     # END-BANNER
## 
## 
## will be transformed to
## 
##     # BEGIN-BANNER -f standard -w '<pre>' '</pre>' foo
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

shinclude-block-BANNER() {
    eval set -- "$1" || shlog -l error -x 2 "Error parsing arguments to BANNER"
    shlog -l trace "_draw_banner '$1' '$2' '$3' '$4' '$5' '$6' '$7' '$8'"
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
            -w|-wrap|--wrap) prefix="$2" ; suffix="$3" ; shift ; shift ;;
            *) shlog -l error -x 2 "Unknown option '$1' passed to BANNER" ;;
        esac
        shift
    done
    local bundledfont="$SHINCLUDESHARE/deps/figlet-fonts/fonts/${fontname}.flf"
    if [[ -e "$bundledfont" ]];then
        shlog -l info "Using bundled font '$bundledfont'."
        fontname="$bundledfont"
    fi
    if which figlet >/dev/null;then
        figletOutput=$(echo -nE "$@" | figlet -w140 -f "$fontname")
    else
        shlog -l warn "Figlet not installed"
        figletOutput="    $*"
    fi
    if [[ $? != 0 ]];then
        shlog -l error -x 2 "Figlet threw an error!"
    fi
    [[ ! -z "$prefix" ]] && echo -e "$prefix"
    echo -nE "$figletOutput" |grep '[^ ]'|sed "s/^/$indent/"
    [[ ! -z "$suffix" ]] && echo -e "$suffix"
    return 0
}
