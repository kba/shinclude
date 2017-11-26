## ### BANNER
##
## Shows a banner using FIGlet or TOIlet
##
## BANNER Runs on **first** pass
## 
##     # BEGIN-BANNER -f standard -w '<pre>' '</pre>' -C '2016 John Doe' foo
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
##
##     Copyright (c) 2016 John Doe
##
##     </pre>
##     # END-EVAL
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[BANNER]=1

# shellcheck disable=SC2059
shinclude::block::BANNER() {
    eval set -- "$1" || shlog -l error -x 2 "Error parsing arguments to BANNER"
    shlog -l trace "_draw_banner '$1' '$2' '$3' '$4' '$5' '$6' '$7' '$8'"
    local fontname="standard"
    local prefix=""
    local suffix=""
    local indent=""
    local license_printf="\nThis software may be modified and distributed under the terms
of the %s license.  See the LICENSE file for details.\n \n"
    local copyright_printf="\nCopyright (c) %s\n \n"
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
            ## ##### -b, --blurb TEXT
            ##
            ## Text to append, e.g. license information. Example: `-b 'Licensed under MIT'
            ##
            -b|--blurb) blurb="$2"; shift ;;
            ## ##### -L, --license TEXT
            ##
            ## License of the file. Example `-L MIT`
            ##
            -L|--license) blurb+=$(printf "$license_printf" "$2"); shift ;;
            ## ##### -C, --copyright TEXT
            ##
            ## Copyright of the file. Example `-L "2016, John Doe`
            ##
            -C|--copyright) blurb+=$(printf "$copyright_printf" "$2"); shift ;;
            *) shlog -l error -x 2 "Unknown option '$1' passed to BANNER" ;;
        esac
        shift
    done
    local text="$*"
    if [[ -z "$text" ]];then
        text="$SHINCLUDE_INFILE"
        text="${text##*/}"
        text="${text%.*}"
    fi
    local bundledfont="$SHINCLUDESHARE/deps/figlet-fonts/fonts/${fontname}.flf"
    if [[ -e "$bundledfont" ]];then
        shlog -l info "Using bundled font '$bundledfont'."
        fontname="$bundledfont"
    else
        shlog -l info "Font not bundled: '$bundledfont'."
    fi
    if which figlet >/dev/null;then
        figletOutput=$(echo -nE "$text" | figlet -w140 -f "$fontname")
    else
        shlog -l warn "Figlet not installed"
        figletOutput="    $*"
    fi
    if [[ $? != 0 ]];then
        shlog -l error -x 2 "Figlet threw an error!"
    fi
    {
        [[ ! -z "$prefix" ]] && echo -e "$prefix"
        echo -nE "$figletOutput" |grep '[^ ]'
        echo -ne "$blurb"
        [[ ! -z "$suffix" ]] && echo -e "$suffix"
    }  |sed "s/^/$indent/"|sed 's/\s*$//'
    return 0
}
