Included content is fenced by comments that contain
`BEGIN-<block-type>` and `END-<block-type>` respectively.

Fencing comments **must** start at the start of the line.

    <block-type> ::= "EVAL" | "INCLUDE" | "RENDER" | "BANNER" | "MARKDOWN-TOC"
    <nl> ::= "\n"
    <spc> ::= " "
    <begin-line> ::= <com-start> <spc> BEGIN-<block-type> <block-arg>+ <spc>?  <com-end>?
    <end-line> ::= <com-start> <spc> END-<block-type> <spc>? <com-end>?
    <directive> ::= <begin-line> <nl> <content-line>* <end-line> <nl>

