; korpiq-1.asm
.feature pc_assignment


.export start

*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
start:
    ldy #$00 ; FIXME: figure out how to store "0SYS2061" to skip this random BASIC protection hack
loop1:
    lda $d012
    sta $d021
    sta $d020
    jmp loop1
.bss
