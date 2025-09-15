ca65 -t c64 -l asm/korpiq-1.lst asm/korpiq-1.asm
ld65 -C ld65/c64.cfg -o korpiq-1.prg asm/korpiq-1.o -m asm/korpiq-1.map
c1541 -format korpiq-disk,01 d64 korpiq-disk.d64 -attach korpiq-disk.d64 -write korpiq-1.prg korpiq-1
