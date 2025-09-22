mkdir -p build
ca65 -t c64 -l build/korpiq-1.lst -o build/korpiq-1.o asm/korpiq-1.asm
ld65 -C ld65/c64.cfg -o build/korpiq-1.prg build/korpiq-1.o -m build/korpiq-1.map
c1541 -format korpiq-disk,01 d64 korpiq-disk.d64 -attach korpiq-disk.d64 -write build/korpiq-1.prg korpiq-1
