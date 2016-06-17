# #### `$EXT_TO_RENDER_PREFIX`
#
# Associative array of file extesions (w/o dot) to render prefix.
#
#       EXT_TO_RENDER_PREFIX[sh]="##"
#       EXT_TO_RENDER_PREFIX[cpp]="*##"
#
typeset -A EXT_TO_RENDER_PREFIX
export EXT_TO_RENDER_PREFIX=()

# #### `$EXT_TO_RENDER_FUNC
#
# Associative array of file extesions (w/o dot) to render function.
#
#       EXT_TO_RENDER_PREFIX[sh]="prefix"
#       EXT_TO_RENDER_PREFIX[jade]="jade"
#
typeset -A EXT_TO_RENDER_FUNC
export EXT_TO_RENDER_FUNC=()

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

# #### `$COMMENT_STYLE_END`
#
# Associative array of comment start strings for select languages
#
#       COMMENT_STYLE_END[html]="-->"
#
typeset -A COMMENT_STYLE_END
export COMMENT_STYLE_END=()

# #### `$RENDER_STYLE`
#
# Shell command to RENDER by extension
#
#     RENDER_STYLE[perl]="grep '^#='"
#
typeset -A RENDER_STYLE
export RENDER_STYLE=()

##
## ## RENDER STYLES
##

## ### cat
##
## * Echo the lines. Just like INCLUDE
##
## File Extensions:
##
## * `*.md`
## * `*.markdown`
## * `*.ronn`
## * `*.txt`
##
RENDER_STYLE[cat]="cat '__FILENAME__'"
EXT_TO_RENDER_PREFIX[md]="cat"
EXT_TO_RENDER_PREFIX[markdown]="cat"
EXT_TO_RENDER_PREFIX[ronn]="cat"
EXT_TO_RENDER_PREFIX[txt]="cat"

## ### doublepound
##
##   * Prefix comments to render with `##`
##   * Replace `__CURLINE__` with current line
##   * Replace `__CURLINE__` with current line
##
## File Extensions:
##
##   * `*.sh`
##   * `*.bash`
##
EXT_TO_RENDER_PREFIX[sh]="##"
EXT_TO_RENDER_PREFIX[zsh]="##"
EXT_TO_RENDER_PREFIX[bash]="##"

## ### jade
##
## Render style:
##
##   * Run through `jade` template engine
##
## Extensions:
##
##   * `*.jade`
##   * `*.pug`
##
RENDER_STYLE[jade]="jade -p '__FILENAME__' -P < '__FILENAME__'|sed -n '2,\$p'"
EXT_TO_RENDER_FUNC[jade]="jade"
EXT_TO_RENDER_FUNC[pug]="jade"

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
        _debug 0 "Unknown extension $ext, defaulting to 'xml'"
        echo 'xml'
    fi
}
