shinclude(1) -- include directives for code/markup comments
===========================================================

## SYNOPSIS

`shinclude` [options...] <file><br>
`shinclude` [options...] <-><br>

[]: BEGIN-RENDER src/shinclude.bash
[]: END-RENDER

## BLOCK DIRECTIVES

[]: BEGIN-INCLUDE doc/SYNTAX.md
[]: END-INCLUDE
[]: BEGIN-RENDER src/block-EVAL.bash
[]: END-RENDER
[]: BEGIN-RENDER src/block-INCLUDE.bash
[]: END-RENDER
[]: BEGIN-RENDER src/block-RENDER.bash
[]: END-RENDER
[]: BEGIN-RENDER src/block-MARKDOWN-TOC.bash
[]: END-RENDER
[]: BEGIN-RENDER src/style.bash
[]: END-RENDER

## AUTHOR

Konstantin Baierer <https://github.com/kba>

## SEE ALSO

`shrender(1)`, `figlet(1)`, `shlog(1)`

## COPYRIGHT

[]: BEGIN-INCLUDE LICENSE
[]: END-INCLUDE

