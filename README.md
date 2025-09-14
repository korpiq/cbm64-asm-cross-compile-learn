
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


## ISSUES

- PRG lacks the two-byte load address header, that should specify $0801
- IDK how to make `x64` load a lone `.prg` file.
