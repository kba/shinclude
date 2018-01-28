# #### `$EXT_TO_COMMENT_STYLE`
#
# Associative array of file extesions (w/o dot) to comment style.
#
#       EXT_TO_COMMENT_STYLE[md]="markdown"
#       EXT_TO_COMMENT_STYLE[markdown]="markdown"
#       EXT_TO_COMMENT_STYLE[ronn]="markdown"
#
typeset -A EXT_TO_COMMENT_STYLE
export EXT_TO_COMMENT_STYLE=()

# #### `$COMMENT_STYLE_START`
#
# Associative array of comment start strings for select languages
#
#       COMMENT_STYLE_START[html]="<!--"
#
typeset -A COMMENT_STYLE_START
export COMMENT_STYLE_START=()

# #### `$COMMENT_STYLE_START_ALTERNATIVE`
#
# Associative array of comment start strings for select languages
#
#       COMMENT_STYLE_START_ALTERNATIVE[html]="<!--"
#
typeset -A COMMENT_STYLE_START_ALTERNATIVE
export COMMENT_STYLE_START_ALTERNATIVE=()

# #### `$COMMENT_STYLE_END`
#
# Associative array of comment start strings for select languages
#
#       COMMENT_STYLE_END[html]="-->"
#
typeset -A COMMENT_STYLE_END
export COMMENT_STYLE_END=()

##
## ## COMMENT STYLES
##

## ### xml
##
## Comment style:
##
##       <!-- BEGIN-... -->
##       <!-- END-... -->
##
COMMENT_STYLE_START[xml]="<!--"
COMMENT_STYLE_END[xml]="-->"
##
## File Extensions:
##
## * `.html`
## * `*.xml`
##
EXT_TO_COMMENT_STYLE[html]='xml'
EXT_TO_COMMENT_STYLE[xml]='xml'

## ### markdown
##
## Comment style:
##
##     []: BEGIN-...
##     []: END-...
##
COMMENT_STYLE_START[markdown]="[]:"
COMMENT_STYLE_END[markdown]=""
##
## Extensions:
##   * `*.ronn`
##   * `*.md`
##
EXT_TO_COMMENT_STYLE[md]='markdown'
EXT_TO_COMMENT_STYLE[markdown]='markdown'
EXT_TO_COMMENT_STYLE[ronn]='markdown'

## ### pound
##
## Comment style:
##
##     # BEGIN-...
##     # END-...
##
COMMENT_STYLE_START[pound]="#"
COMMENT_STYLE_END[pound]=""
## Extensions:
##
##   * `*.sh`
##   * `*.bash`
##   * `*.zsh`
##   * `*.py`
##   * `*.pl`
##   * `*.PL`
##   * `*.coffee`
##
EXT_TO_COMMENT_STYLE[sh]='pound'
EXT_TO_COMMENT_STYLE[bash]='pound'
EXT_TO_COMMENT_STYLE[zsh]='pound'
EXT_TO_COMMENT_STYLE[py]='pound'
EXT_TO_COMMENT_STYLE[pl]='pound'
EXT_TO_COMMENT_STYLE[PL]='pound'
EXT_TO_COMMENT_STYLE[coffee]='pound'

## ### slashstar
##
## Comment style:
##
##     /* BEGIN-... */
##     /* END-... */
##
## File Extensions:
##
## * `*.cpp`
## * `*.cxx`
## * `*.java`
##
EXT_TO_COMMENT_STYLE[cpp]='slashstar'
EXT_TO_COMMENT_STYLE[cxx]='slashstar'
EXT_TO_COMMENT_STYLE[java]='slashstar'
COMMENT_STYLE_START[slashstar]="/*"
COMMENT_STYLE_END[slashstar]="*/"

## ### doubleslash
##
## File Extensions:
##
##     // BEGIN-...
##     // END-...
##
COMMENT_STYLE_START[doubleslash]="//"
COMMENT_STYLE_END[doubleslash]=""
##
## File Extensions:
##
##   * `*.c`
##   * `*.js`
##
EXT_TO_COMMENT_STYLE[js]='doubleslash'
EXT_TO_COMMENT_STYLE[c]='doubleslash'

## ### doublequote
##
## Comment style:
##
##     " BEGIN-...
##     " END-...
##
COMMENT_STYLE_START[doublequote]="\""
COMMENT_STYLE_END[doubleslash]=""
##
## File Extensions:
##
## * `*.vim`
##
EXT_TO_COMMENT_STYLE[vim]='doublequote'

## ### doubleslashbang
##
## Comment style:
##
##     //! BEGIN-...
##     //! END-...
##
COMMENT_STYLE_START[doubleslashbang]="//!"
COMMENT_STYLE_END[doubleslashbang]=""
## Extensions:
##
##   * `*.jade`
##   * `*.pug`
##
EXT_TO_COMMENT_STYLE[jade]='doubleslashbang'
EXT_TO_COMMENT_STYLE[pug]='doubleslashbang'

## ### Vim fold
##
## Comment style:
##
##     #{{{ BEGIN-...
##     #}}} END-...
##
COMMENT_STYLE_START[vimfold]="#{{{"
COMMENT_STYLE_START_ALTERNATIVE[vimfold]="#}}}"
COMMENT_STYLE_END[vimfold]=""

# ### _detect_comment_style
# 
# Detect comment style by file extension. Default: 'xml'
#
#     _detect_comment_style "foo.md"    # -> 'markdown'
#     _detect_comment_style "foo.pl"    # -> 'pound'
#
_detect_comment_style() {
    local ext
    ext=${1##*.}
    if [[ ! -z "${EXT_TO_COMMENT_STYLE[$ext]}" ]];then
        echo "${EXT_TO_COMMENT_STYLE[$ext]}"
    else
        shlog -l info "Unknown extension $ext, defaulting to 'xml'"
        echo 'xml'
    fi
}
