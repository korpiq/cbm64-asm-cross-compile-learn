; korpiq-1.asm
;.feature pc_assignment
;*=$0801

.export start

start:
    ldy #$00
loop1:
    dey
    sty $d020
    sty $d021
    bne loop1
    rts
.bss
