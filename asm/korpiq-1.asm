; korpiq-1.asm
.feature pc_assignment


.export start

*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
.byte 11, 8, 221, 49, 158, 50, 48, 54, 49, 0, 0, 0 ; SYS2061
*=2061
start:
    sei ; avoid blinking caused by interrupts
@loop:
    lda $d012
    tay
    ora #$05
@wait:
    cpy $d012
    beq @wait
    sta $d020
    sta $d021
    jmp @loop
.bss
