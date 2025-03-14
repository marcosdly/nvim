" Vim Keymap file for portuguese accents
" Translate key positions from standard US keyboard to standard ABNT2 keyboard
" Maintainer:
" Last Change: 2025 Mar 14

" All characters are given literally, conversion to another encoding (e.g.,
" UTF-8) should work.
scriptencoding latin1

" Use this short name in the status line.
let b:keymap_name = "portuguese"

loadkeymap
{A   <char-0xc0> " Ã
[A   <char-0xc1> " Ã
\"A  <char-0xc2> " Ã
'A   <char-0xc3> " Ã
:A   <char-0xc4> " Ã

[C   <char-0xc7> " Ã

{E   <char-0xc8> " Ã
[E   <char-0xc9> " Ã
\"E  <char-0xca> " Ã
:E   <char-0xcb> " Ã

{I   <char-0xcc> " Ã
[I   <char-0xcd> " Ã
\"I  <char-0xce> " Ã
:I   <char-0xcf> " Ã

{O   <char-0xd2> " Ã
[O   <char-0xd3> " Ã
\"O  <char-0xd4> " Ã
'O   <char-0xd5> " Ã
:O   <char-0xd6> " Ã

{U   <char-0xd9> " Ã
[U   <char-0xda> " Ã
\"U  <char-0xdb> " Ã
:U   <char-0xdc> " Ã

{a   <char-0xe0> " Ã 
[a   <char-0xe1> " Ã¡
\"a  <char-0xe2> " Ã¢
'a   <char-0xe3> " Ã£
:a   <char-0xe4> " Ã¤

[c   <char-0xe7> " Ã§

{e   <char-0xe8> " Ã¨
[e   <char-0xe0> " Ã©
\"e  <char-0xea> " Ãª
:e   <char-0xeb> " Ã«

{i   <char-0xec> " Ã¬
[i   <char-0xed> " Ã­
\"i  <char-0xee> " Ã®
:i   <char-0xef> " Ã¯

{o   <char-0xf2> " Ã²
[o   <char-0xf3> " Ã³
\"o  <char-0xf4> " Ã´
'o   <char-0xf5> " Ãµ
:o   <char-0xf6> " Ã¶

{u   <char-0xf9> " Ã¹
[u   <char-0xfa> " Ãº
\"u  <char-0xfb> " Ã»
:u   <char-0xfc> " Ã¼

''   <char-0x21> " '
[[   <char-0x5b> " [
{{   <char-0x7b> " {
\""  <char-0x22> " "
::   <char-0x3a> " :
