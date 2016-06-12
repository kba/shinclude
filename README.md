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
	* [-p PATH](#-p-path)
	* [--shinclude-path PATH](#--shinclude-path-path)
	* [-c COMMENT_STYLE](#-c-comment_style)
	* [--comment-style COMMENT_STYLE](#--comment-style-comment_style)
	* [-cs COMMENT_START](#-cs-comment_start)
	* [--comment-start COMMENT_START](#--comment-start-comment_start)
	* [-ce COMMENT_END](#-ce-comment_end)
	* [--comment-end COMMENT_END](#--comment-end-comment_end)
	* [-d](#-d)
	* [--info](#--info)
	* [-dd](#-dd)
	* [--debug](#--debug)
	* [-ddd](#-ddd)
	* [--trace](#--trace)
* [BLOCK DIRECTIVES](#block-directives)
	* [EVAL](#eval)
	* [INCLUDE](#include)
	* [RENDER](#render)
	* [MARKDOWN-TOC](#markdown-toc)
		* [`$MARKDOWN_TOC_INDENT`](#markdown_toc_indent)
		* [`$HEADING_REGEX`](#heading_regex)
		* [Heading-to-Link algorithm](#heading-to-link-algorithm)
* [DIAGNOSTICS](#diagnostics)
	* [`$LOGLEVEL`](#loglevel)
* [RENDER STYLES](#render-styles)
	* [cat](#cat)
	* [doublepound](#doublepound)
	* [jade](#jade)
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

### -p PATH
### --shinclude-path PATH

Add path to path to look for `INCLUDE` and `RENDER`.

Can be repeated to add multiple paths.

Default: `("$PWD")`

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
### --info

Enable debug logging ([`$LOGLEVEL=1`](#loglevel))

### -dd
### --debug

Enable trace logging (`$LOGLEVEL=2`).

### -ddd
### --trace

Enable trace logging (`$LOGLEVEL=2`) and print every statement as it is executed.

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

String to indent a single level. Default: `\t`

#### `$HEADING_REGEX`

Regex used to detect and tokenize headings.

Default: `^(##+)\s*(.*)`

#### Heading-to-Link algorithm

Indentation: Concatenate `$MARKDOWN_TOC_INDENT` times  the number of leading `#`- 2

Link target: Start with Link Text

* lowercase
* remove `` $ ` ( ) . ``
* Replace all non-alphanumeric characters with `-`
* If link target not used previously
* then set `EXISTING_HEADINGS[$link_target]` to `1`
* else increase `EXISTING_HEADINGS[$link_target]` by one and concatenate

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/logging.bash -->

## DIAGNOSTICS

### `$LOGLEVEL`

Default: 0

See [`-d`](#-d) and [`-dd`](#-dd)

<!-- END-RENDER -->

<!-- BEGIN-RENDER src/style.bash -->


## RENDER STYLES

### cat

* Echo the lines. Just like INCLUDE

File Extensions:

* `*.md`
* `*.markdown`
* `*.ronn`
* `*.txt`

### doublepound

  * Prefix comments to render with `##`
  * Replace `74` with current line
  * Replace `75` with current line

File Extensions:

  * `*.sh`
  * `*.bash`

### jade

Render style:

  * Run through `jade` template engine

Extensions:

  * `*.jade`
  * `*.pug`


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

<!-- END-RENDER -->
