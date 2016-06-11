shinclude
=========
Include file contents or ouptut of shell commands in a code/markup comments

[![Build Status](https://travis-ci.org/kba/shinclude.svg?branch=master)](https://travis-ci.org/kba/shinclude)

<!-- BEGIN-EVAL echo '<pre>';echo shinclude|figlet -f slant;echo '</pre>' -->

<pre>
         __    _            __          __
   _____/ /_  (_)___  _____/ /_  ______/ /__
  / ___/ __ \/ / __ \/ ___/ / / / / __  / _ \
 (__  ) / / / / / / / /__/ / /_/ / /_/ /  __/
/____/_/ /_/_/_/ /_/\___/_/\__,_/\__,_/\___/

</pre>

<!-- END-EVAL -->


<!-- BEGIN-MARKDOWN-TOC -->
* [INSTALL](#install)
* [OPTIONS](#options)
	* [-h](#-h)
	* [--help](#--help)
	* [-i](#-i)
	* [--inplace](#--inplace)
	* [-c COMMENT_STYLE](#-c-comment_style)
	* [--comment-style COMMENT_STYLE](#--comment-style-comment_style)
	* [-cs COMMENT_START](#-cs-comment_start)
	* [--comment-start COMMENT_START](#--comment-start-comment_start)
	* [-ce COMMENT_END](#-ce-comment_end)
	* [--comment-end COMMENT_END](#--comment-end-comment_end)
	* [-d](#-d)
	* [--debug](#--debug)
	* [-dd](#-dd)
	* [--trace](#--trace)
* [BLOCK DIRECTIVES](#block-directives)
	* [EVAL](#eval)
	* [INCLUDE](#include)
	* [RENDER](#render)
	* [MARKDOWN-TOC](#markdown-toc)
		* [`$MARKDOWN_TOC_INDENT`](#markdown_toc_indent)
* [DIAGNOSTICS](#diagnostics)
	* [`$LOGLEVEL`](#loglevel)
* [COMMENT STYLES](#comment-styles)
	* [xml](#xml)
	* [markdown](#markdown)
	* [pound](#pound)
	* [slashstar](#slashstar)
	* [doubleslash](#doubleslash)
	* [doublequote](#doublequote)
	* [doubleslashbang](#doubleslashbang)

<!-- END-MARKDOWN-TOC -->

## INSTALL

```
make install
```

<!-- BEGIN-RENDER src/shinclude.bash -->

## OPTIONS
### -h
### --help

help

### -i
### --inplace

Edit the file in-place

### -c COMMENT_STYLE
### --comment-style COMMENT_STYLE

Comment style. See [COMMENT STYLES](#comment-styles).

### -cs COMMENT_START
### --comment-start COMMENT_START

 Comment start. Overrides language-specific comment start.

See [COMMENT STYLES](#comment-styles).

### -ce COMMENT_END
### --comment-end COMMENT_END

 Comment end. Overrides language-specific comment end.

See [COMMENT STYLES](#comment-styles).

### -d
### --debug

Enable debug logging ([`$LOGLEVEL=1`](#loglevel))

### -dd
### --trace

Enable trace logging (`$LOGLEVEL=2`). Prints every statement the shell executes.

<!-- END-RENDER -->

<!-- BEGIN-INCLUDE doc/SYNTAX.md -->

Included content is fenced by comments that contain
`BEGIN-<block-type>` and `END-<block-type>` respectively.

Fencing comments **must** start at the start of the line.

    <block-type> ::= "EVAL" | "INCLUDE" | "RENDER"
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

Renders a file to markdown using a [shell expression](#render_ext).

Runs on **first** pass

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-MARKDOWN-TOC.bash -->

### MARKDOWN-TOC

Reads in the file and outputs a table of contents of
the markdown headings.

Runs on **second** pass

    # First Heading

    []: BEGIN-MARKDOWN-TOC
    []: END-MARKDOWN-TOC

    ## Second-Level Heading

will be transformed to

    # First Heading

    []: BEGIN-MARKDOWN-TOC

    * [First Heading](#first-heading)
    	* [Second-Level  Heading](#second-level-heading)

    []: END-MARKDOWN-TOC

    ## Second-Level Heading
Runs on first pass
#### `$MARKDOWN_TOC_INDENT`

String to indent a single level. Default: `\t`

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/logging.bash -->

## DIAGNOSTICS

### `$LOGLEVEL`

Default: 0

See [`-d`](#-d) and [`-dd`](#-dd)

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

Render style:
* Just like INCLUDE


Extensions:
  * `*.ronn`
  * `*.md`

### pound

Comment style:

    # BEGIN-...
    # END-...

Render style:

  * Prefix comments to render with `##`

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

Render style:

  * Run through `jade` template engine

Extensions:

  * `*.jade`
  * `*.pug`

<!-- END-RENDER -->
