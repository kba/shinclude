shinclude
=========
Include file contents or ouptut of shell commands in a code/markup comments

[![Build Status](https://travis-ci.org/kba/shinclude.svg?branch=master)](https://travis-ci.org/kba/shinclude)

<!-- BEGIN-BANNER -f "DOS Rebel" -i "\t" shinclude -->
<!-- END-BANNER -->

<!-- BEGIN-MARKDOWN-TOC -->
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

<!-- BEGIN-RENDER src/shinclude.bash -->
<!-- END-RENDER -->

<!-- BEGIN-INCLUDE doc/SYNTAX.md -->
<!-- END-INCLUDE -->

## BLOCK DIRECTIVES

<!-- BEGIN-RENDER src/block-EVAL.bash -->
<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-INCLUDE.bash -->
<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-RENDER.bash -->
<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-MARKDOWN-TOC.bash -->
<!-- END-RENDER -->

<!-- BEGIN-RENDER src/block-BANNER.bash -->
<!-- END-RENDER -->

<!-- BEGIN-RENDER src/style.bash -->
<!-- END-RENDER -->
