shinclude
=========
Include file contents or ouptut of shell commands in a code/markup comments

[![Build Status](https://travis-ci.org/kba/shinclude.svg?branch=master)](https://travis-ci.org/kba/shinclude)

<!-- BEGIN-BANNER -f "DOS Rebel" -i "\t" shinclude -->
<!-- END-BANNER -->

<!-- BEGIN-MARKDOWN-TOC -->
<!-- END-MARKDOWN-TOC -->

## INSTALL

```
make install
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

<!-- BEGIN-RENDER src/logging.bash -->
<!-- END-RENDER -->

<!-- BEGIN-RENDER src/style.bash -->
<!-- END-RENDER -->
