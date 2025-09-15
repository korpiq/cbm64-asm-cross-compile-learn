## compile

```sh
ca65 -t c64 -l asm/korpiq-1.lst asm/korpiq-1.asm
```

## link

```sh
ld65 -C ld65/c64.cfg -o korpiq-1.prg asm/korpiq-1.o -m asm/korpiq-1.map
```

## hex dump

```sh
hexdump -e '"%07.7_ax " 8/1 "%02x " "\n"' korpiq-1.prg
```

## disassemble

```sh
da65 korpiq-1.prg
```

## create disk containing prg

```sh
c1541 -format korpiq-disk,01 d64 korpiq-disk.d64 -attach korpiq-disk.d64 -write korpiq-1.prg korpiq-1
```

## run

```
x64 korpiq-disk.d64
```

### prerequisites

```
sudo apt install vice
cd /usr/share/vice
sudo chown -r $USER:$USER .
```

Then clone this repository there: https://github.com/asig/vice-roms

## ISSUES

- none known right now, sample code too simple
