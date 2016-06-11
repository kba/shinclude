# #### `$EXT_TO_STYLE`
#
# Associative array of file extesions (w/o dot) to language.
#
#       EXT_TO_STYLE[md]="markdown"
#       EXT_TO_STYLE[markdown]="markdown"
#       EXT_TO_STYLE[ronn]="markdown"
#
typeset -A EXT_TO_STYLE
export EXT_TO_STYLE=()

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
EXT_TO_STYLE[html]='xml'
EXT_TO_STYLE[xml]='xml'

## ### markdown
##
## Comment style:
##
##     []: BEGIN-...
##     []: END-...
##
COMMENT_STYLE_START[markdown]="[]:"
COMMENT_STYLE_END[markdown]=""
## Render style:
## * Just like INCLUDE
##
RENDER_STYLE[markdown]="cat '%s'"
##
## Extensions:
##   * `*.ronn`
##   * `*.md`
##
EXT_TO_STYLE[md]='markdown'
EXT_TO_STYLE[markdown]='markdown'
EXT_TO_STYLE[ronn]='markdown'

## ### pound
##
## Comment style:
##
##     # BEGIN-...
##     # END-...
##
COMMENT_STYLE_START[pound]="#"
COMMENT_STYLE_END[pound]=""
## Render style:
##
##   * Prefix comments to render with `##`
##
RENDER_STYLE[pound]="grep '^\\s*##' '%s'|sed 's/^\\s*## \\\?//'"
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
EXT_TO_STYLE[sh]='pound'
EXT_TO_STYLE[bash]='pound'
EXT_TO_STYLE[zsh]='pound'
EXT_TO_STYLE[py]='pound'
EXT_TO_STYLE[pl]='pound'
EXT_TO_STYLE[PL]='pound'
EXT_TO_STYLE[coffee]='pound'

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
EXT_TO_STYLE[cpp]='slashstar'
EXT_TO_STYLE[cxx]='slashstar'
EXT_TO_STYLE[java]='slashstar'
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
EXT_TO_STYLE[js]='doubleslash'
EXT_TO_STYLE[c]='doubleslash'

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
EXT_TO_STYLE[vim]='doublequote'

## ### doubleslashbang
##
## Comment style:
##
##     //! BEGIN-...
##     //! END-...
##
COMMENT_STYLE_START[doubleslashbang]="//!"
COMMENT_STYLE_END[doubleslashbang]=""
## Render style:
##
##   * Run through `jade` template engine
##
RENDER_STYLE[jade]="jade -P < '%s'|sed -n '2,\$p'"
## Extensions:
##
##   * `*.jade`
##   * `*.pug`
##
EXT_TO_STYLE[jade]='doubleslashbang'
EXT_TO_STYLE[pug]='doubleslashbang'

# ### _detect_style
# 
# Detect comment style by file extension. Default: 'xml'
#
#     _detect_style "foo.md"    # -> 'markdown'
#     _detect_style "foo.pl"    # -> 'pound'
#
_detect_style() {
    local ext
    ext=${1##*.}
    if [[ ! -z "${EXT_TO_STYLE[$ext]}" ]];then
        echo "${EXT_TO_STYLE[$ext]}"
    else
        _debug 0 "Unknown extension $ext, defaulting to 'xml'"
        echo 'xml'
    fi
}
