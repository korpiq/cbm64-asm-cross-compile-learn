; korpiq-1.asm
.feature pc_assignment


.export start

*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
start:
    ldy #$00
loop1:
    dey
    sty $d020
    sty $d021
    bne loop1
    rts
.bss
