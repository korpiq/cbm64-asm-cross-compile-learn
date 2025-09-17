; korpiq-1.asm
.feature pc_assignment


.export start

*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
.byte 11, 8, 0, 0, 158, 50, 48, 54, 49, 0, 0, 0
*=2061
start:
    sei ; avoid blinking caused by interrupts
@loop:
    lda $d012
@wait:
    cmp $d012
    beq @wait
    ora #$05
    sta $d021
    sta $d020
    jmp @loop
.bss
