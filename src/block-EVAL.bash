## ### EVAL
##
## Evaluates the arguments as a shell expression. **BE CAREFUL**
##
## EVAL Runs on **first** pass
## 
##     # BEGIN-EVAL wc *
##     # END-EVAL
## 
## 
## will be transformed to
## 
##     # BEGIN-EVAL wc *
##
##       21   171  1085 LICENSE
##       51   106   978 Makefile
##      290   461  4058 README.md
##      558  1267 12212 shinclude
##      275   828  5565 shinclude.1
##     1723  4100 36080 total
##
##     # END-EVAL
##
typeset -A BLOCK_PASS
# shellcheck disable=2034
BLOCK_PASS[EVAL]=1

shinclude::block::EVAL () {
    local evalargs prefix suffix
    prefix=""
    suffix=""

    if [[ "$1" = -* ]];then
        evalargs="${1#*-- }"
        eval set -- "${1%% --*}" || shlog -l error -x 2 "Error parsing arguments to BANNER"
        ##
        ## #### Options
        while [[ "$1" = -* ]];do
            case "$1" in
                ## 
                ## ##### -w, --wrap BEFORE AFTER
                ##
                ## Wrap in lines. E.g `-w '<pre>' '</pre'`
                ##
                -w|-wrap|--wrap) prefix="$2\n" ; suffix="\n$3" ; shift ; shift ;;
            esac
            shift
        done
    else
        evalargs="$1"
    fi

    # shlog -l info "prefix=$prefix suffix=$suffix evalargs=$evalargs"
    # y=$(printf "%s\n%s\n%s" "$prefix" "$(eval "${evalargs//\//\/}")" "$suffix")
    # shlog -l info "$y"
    printf "%b%s%b" "$prefix" "$(eval "${evalargs//\//\/}")" "$suffix"
}
