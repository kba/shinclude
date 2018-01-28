shinclude
=========
Include file contents or ouptut of shell commands in a code/markup comments

[![Build Status](https://travis-ci.org/kba/shinclude.svg?branch=master)](https://travis-ci.org/kba/shinclude)

<!-- BEGIN-BANNER -f "DOS Rebel" -i "\t" shinclude -->
	         █████       ███                      ████                 █████
	        ░░███       ░░░                      ░░███                ░░███
	  █████  ░███████   ████  ████████    ██████  ░███  █████ ████  ███████   ██████
	 ███░░   ░███░░███ ░░███ ░░███░░███  ███░░███ ░███ ░░███ ░███  ███░░███  ███░░███
	░░█████  ░███ ░███  ░███  ░███ ░███ ░███ ░░░  ░███  ░███ ░███ ░███ ░███ ░███████
	 ░░░░███ ░███ ░███  ░███  ░███ ░███ ░███  ███ ░███  ░███ ░███ ░███ ░███ ░███░░░
	 ██████  ████ █████ █████ ████ █████░░██████  █████ ░░████████░░████████░░██████
	░░░░░░  ░░░░ ░░░░░ ░░░░░ ░░░░ ░░░░░  ░░░░░░  ░░░░░   ░░░░░░░░  ░░░░░░░░  ░░░░░░

<!-- END-BANNER -->

<!-- BEGIN-MARKDOWN-TOC -->
* [INSTALL](#install)
	* [Project specific](#project-specific)
	* [System-wide](#system-wide)
	* [Home directory](#home-directory)
* [OPTIONS](#options)
	* [-h, --help](#-h---help)
	* [-i, --inplace](#-i---inplace)
	* [-p, --shinclude-path PATH](#-p---shinclude-path-path)
	* [-c, --comment-style COMMENT_STYLE](#-c---comment-style-comment_style)
	* [-cs, --comment-start COMMENT_START](#-cs---comment-start-comment_start)
	* [-csa, --comment-start-alternative COMMENT_START_ALTERNATIVE](#-csa---comment-start-alternative-comment_start_alternative)
	* [-ce, --comment-end COMMENT_END](#-ce---comment-end-comment_end)
	* [-d, --info](#-d---info)
	* [-dd, --debug](#-dd---debug)
	* [-ddd, --trace](#-ddd---trace)
* [BLOCK DIRECTIVES](#block-directives)
	* [EVAL](#eval)
		* [Options](#options-1)
			* [-w, --wrap BEFORE AFTER](#-w---wrap-before-after)
	* [INCLUDE](#include)
	* [RENDER](#render)
	* [MARKDOWN-TOC](#markdown-toc)
		* [`$MARKDOWN_TOC_INDENT`](#markdown_toc_indent)
		* [`$HEADING_REGEX`](#heading_regex)
		* [Heading-to-Link algorithm](#heading-to-link-algorithm)
	* [BANNER](#banner)
		* [Options](#options-2)
			* [-f, --font FONT](#-f---font-font)
			* [-i, --indent INDENT](#-i---indent-indent)
			* [-w, --wrap BEFORE AFTER](#-w---wrap-before-after-1)
			* [-b, --blurb TEXT](#-b---blurb-text)
			* [-L, --license TEXT](#-l---license-text)
			* [-C, --copyright TEXT](#-c---copyright-text)
* [COMMENT STYLES](#comment-styles)
	* [xml](#xml)
	* [markdown](#markdown)
	* [pound](#pound)
	* [slashstar](#slashstar)
	* [doubleslash](#doubleslash)
	* [doublequote](#doublequote)
	* [doubleslashbang](#doubleslashbang)
	* [Vim fold](#vim-fold)

<!-- END-MARKDOWN-TOC -->

## INSTALL

### Project specific

You can just clone the repository and call the [`shinclude`](./shinclude) binary.

If you want to use it in your scripts, Makefile or git hooks, use
either the full path to the `shinclude` script or add it to the
`PATH`:

```
export PATH="/path/to/shinclude/repo:$PATH"
./myscript.sh
```

### System-wide

To install system-wide (`/usr/local/bin/shinclude`):

```
make install
```

### Home directory

To install to your home directory (`$HOME/.local/bin/shinclude`):

```
make install PREFIX=$HOME/.local
```

<!-- BEGIN-RENDER src/cli.bash -->
## OPTIONS
### -h, --help

help

### -i, --inplace

Edit the file in-place

### -p, --shinclude-path PATH

Add path to path to look for `INCLUDE` and `RENDER`.

Can be repeated to add multiple paths.

Default: `("$PWD")`

### -c, --comment-style COMMENT_STYLE

Comment style. See [COMMENT STYLES](#comment-styles).

Use `-c list` to get a list of available styles.

### -cs, --comment-start COMMENT_START

 Comment start. Overrides language-specific comment start.

See [COMMENT STYLES](#comment-styles).

### -csa, --comment-start-alternative COMMENT_START_ALTERNATIVE

 Alternative comment start. Overrides language-specific comment start.

Useful for vim folds

See [COMMENT STYLES](#comment-styles).

### -ce, --comment-end COMMENT_END

 Comment end. Overrides language-specific comment end.

See [COMMENT STYLES](#comment-styles).

### -d, --info

Enable debug logging ([`$LOGLEVEL=1`](#loglevel))

### -dd, --debug

Enable trace logging (`$LOGLEVEL=2`).

### -ddd, --trace

Enable trace logging (`$LOGLEVEL=2`) and print every statement as it is executed.

<!-- END-RENDER -->

<!-- BEGIN-INCLUDE doc/SYNTAX.md -->
Included content is fenced by comments that contain
`BEGIN-<block-type>` and `END-<block-type>` respectively.

Fencing comments **must** start at the start of the line.

    <block-type> ::= "EVAL" | "INCLUDE" | "RENDER" | "BANNER" | "MARKDOWN-TOC"
    <nl> ::= "\n"
    <spc> ::= " "
    <begin-line> ::= <com-start> <spc> BEGIN-<block-type> <block-arg>+ <spc>?  <com-end>?
    <end-line> ::= <com-start> <spc> END-<block-type> <spc>? <com-end>?
    <directive> ::= <begin-line> <nl> <content-line>* <end-line> <nl>

<!-- END-INCLUDE -->

## BLOCK DIRECTIVES

<!-- BEGIN-RENDER src/block-EVAL.bash -->
### EVAL

Evaluates the arguments as a shell expression. **BE CAREFUL**

EVAL Runs on **first** pass

    # BEGIN-EVAL wc *
    # END-EVAL


will be transformed to

    # BEGIN-EVAL wc *

      21   171  1085 LICENSE
      51   106   978 Makefile
     290   461  4058 README.md
     558  1267 12212 shinclude
     275   828  5565 shinclude.1
    1723  4100 36080 total

    # END-EVAL


#### Options

##### -w, --wrap BEFORE AFTER

Wrap in lines. E.g `-w '<pre>' '</pre'`

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-INCLUDE.bash -->
### INCLUDE

Include data from a file.

`INCLUDE` runs on **first** pass.

    # BEGIN-INCLUDE LICENSE
    # END-INCLUDE

will be transformed to

    # BEGIN-INCLUDE LICENSE
    The MIT License (MIT)
    
    Copyright (c) 2016 Konstantin Baierer
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    # END-INCLUDE

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-RENDER.bash -->
### RENDER

Renders a file to markdown using a [`shrender`](https://github.com/kba/shrender).

Runs on **first** pass

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-MARKDOWN-TOC.bash -->
### MARKDOWN-TOC

([source](./src/block-MARKDOWN-TOC.bash#L3), [test](./test/MARKDOWN-TOC))

Reads in the file and outputs a table of contents of
the markdown headings.

Runs on **second** pass


    # First Heading

    [rem]: BEGIN-MARKDOWN-TOC
    [rem]: END-MARKDOWN-TOC

    ## Second-Level Heading

will be transformed to (`shinclude -cs '[rem]:' -ce '' -`)

    # First Heading

    [rem]: BEGIN-MARKDOWN-TOC

    * [First Heading](#first-heading)
    	* [Second-Level  Heading](#second-level-heading)

    [rem]: END-MARKDOWN-TOC

    ## Second-Level Heading
#### `$MARKDOWN_TOC_INDENT`

String to indent a single level. Default: `	`

#### `$HEADING_REGEX`

Regex used to detect and tokenize headings.

Default: `^(##+)\s*(.*)`

#### Heading-to-Link algorithm

Replace markdown links in heading with just the link text
Link text: Remove `[ ]`
Indentation: Concatenate `$MARKDOWN_TOC_INDENT` times  the number of leading `#`- 2

Link target: Start with Link Text

* lowercase
* remove `` $ ` ( ) . , % : ? / @ ! [ ]``
* Replace all non-alphanumeric characters with `-`
* If link target not used previously
* then set `EXISTING_HEADINGS[$link_target]` to `1`
* else increase `EXISTING_HEADINGS[$link_target]` by one and concatenate

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-BANNER.bash -->
### BANNER

Shows a banner using FIGlet or TOIlet

BANNER Runs on **first** pass

    # BEGIN-BANNER -f standard -w '<pre>' '</pre>' -C '2016 John Doe' foo
    # END-BANNER


will be transformed to

    # BEGIN-BANNER -f standard -w '<pre>' '</pre>' foo
    <pre>
      __             
     / _| ___   ___  
    | |_ / _ \ / _ \ 
    |  _| (_) | (_) |
    |_|  \___/ \___/ 

    Copyright (c) 2016 John Doe

    </pre>
    # END-EVAL


#### Options
##### -f, --font FONT

Specify font. See `/usr/share/figlet` for a list of fonts.

##### -i, --indent INDENT

Specify indent. Example: `-i "	"`, `-i '    '`

##### -w, --wrap BEFORE AFTER

Wrap in lines. E.g `-w '<pre>' '</pre'`

##### -b, --blurb TEXT

Text to append, e.g. license information. Example: `-b 'Licensed under MIT'

##### -L, --license TEXT

License of the file. Example `-L MIT`

##### -C, --copyright TEXT

Copyright of the file. Example `-L "2016, John Doe`

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/style.bash -->

## COMMENT STYLES

### xml

Comment style:

      <!-- BEGIN-... -->
      <!-- END-... -->


File Extensions:

* `.html`
* `*.xml`

### markdown

Comment style:

    []: BEGIN-...
    []: END-...


Extensions:
  * `*.ronn`
  * `*.md`

### pound

Comment style:

    # BEGIN-...
    # END-...

Extensions:

  * `*.sh`
  * `*.bash`
  * `*.zsh`
  * `*.py`
  * `*.pl`
  * `*.PL`
  * `*.coffee`

### slashstar

Comment style:

    /* BEGIN-... */
    /* END-... */

File Extensions:

* `*.cpp`
* `*.cxx`
* `*.java`

### doubleslash

File Extensions:

    // BEGIN-...
    // END-...


File Extensions:

  * `*.c`
  * `*.js`

### doublequote

Comment style:

    " BEGIN-...
    " END-...


File Extensions:

* `*.vim`

### doubleslashbang

Comment style:

    //! BEGIN-...
    //! END-...

Extensions:

  * `*.jade`
  * `*.pug`

### Vim fold

Comment style:

    #{{{ BEGIN-...
    #}}} END-...

<!-- END-RENDER -->
