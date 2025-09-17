# Too complex way to handle raster interrupts

This may cause more work than we can do in the time allowed by screen drawing speed. Especially the interrupt handler machine code buffer size may become questionable.

- maybe add book keeping so that generated handlers can be reused?

  - could work until too many sprites move by each other

## Virtual Sprite data bytes

0. Number of previous Virtual Sprite in coordinate order
1. Number of next Virtual Sprite in coordinate order
2. Bits; each set Sprite# bit

   0. X high bit -> $d010
   1. X expansion -> $d01d
   2. Y expansion -> $d017
   3. over text -> $d01b
   4. multicolor -> $d0ic
   5. Enabled -> $d015
   6. Unused
   7. isSprite -> if 0, this record is not sprite, this byte its type id

3. X-coordinate -> $d001 + 2 x Sprite#
4. Y-coordinate -> $d000 + 2 x Sprite#
5. Z-coordinate: used to stack actual Sprites correctly.
6. Color (4 bits) -> $d027 + Sprite#

   - upper nybble = color for every other rendering round to mix colors

7. Shape# -> $07F8 (char screen last page end) + Sprite#
8. X width of sprite (1 to 48):

   - after this many pixels right no need to consider overlap

9. Y height of sprite (-42 to 42):

   - 0: full height (21, or 42 if Y expansion is on)
   - if positive, after exactly that many raster lines this sprite MUST be disabled, can be reused (to use only upper part of shape)
   - if negative, reduce Y coordinate that much, and MUST set this sprite at the exact original Y coordinate raster line (to use only lower part of shape)

10. Which sprite to draw
    - bits 0-2: actual Sprite# 0-7
    - bit 3: draw this sprite on even cycles
    - bit 4: draw this sprite on odd cycles

### Virtual Sprite data in memory

256 sprites x 11 bytes = 3072 bytes total.

Each different type of byte may be grouped together onto one 256 byte page to have 10 pages, where each virtual sprite's entry is at the offset by its number. This way each type of byte can be accessed by Absolute+Register without crossing page to keep each access time as 4 cycles.

## Modifying virtual sprite data

Virtual sprite data can be modified while it is not being read for next rendering cycle.

Other modifications can occur directly, but to update X,Y,Z coordinates, we need to use a function that updates previous and next pointers accordingly to keep the sprites in order.

### Ordering by coordinates

Tough nut, but could be great, needs more love.

1. Order primarily on Y coordinate, then X / Z ?
2. for sprites that overlap on Y axis (Y1 <= Y2 <= Y1 + height1)

   - if overlap on X axis (X1 <= X2 <= X1 + width1), select available (look back in linked list) Sprite# for each to honor Z.

     - otherwise just pick some available Sprite# (anticipate needs up list?)

     - rethink design if this proves too hard.

   - if more than 8 sprites overlap on Y axis, set two to toggle on same Sprite#, repeat until no more overlaps or all 16 used.

     - when no overlap, toggles should be switched off.

## Planning rendering cycle

1. Planning must complete before first raster interrupt needs to happen.
2. Planning will write machine code to a double buffer

   - each raster interrupt will start at its individual address and ends with setting the next interrupt
   - last (closest to the bottom of the screen) interrupt shall switch to the first interrupt of the other double buffer (always offset 0)
   - planning can start writing onto a buffer page soon as raster interrupts start running from the other one.

### Double buffers

#### machine code

Machine code buffers are write-only. Code to handle each interrupt is written to one buffer while the other one is in use.

#### VIC-II registers

Two buffers should be used so that

1. At beginning of writing an interrupt handler, both buffers are equal
2. Preparing the interrupt handler updates on buffer
3. differences between the buffers are used to generate machine code to put the new values in place all at once, and to update the other buffer.

### Loop to write machine code for the interrupts

1. Settle on a raster line where sprites will be handled

   - generally wait up to right before Y start of a virtual sprite not yet put on screen, then draw as many of them as there are real sprites available
   - need to be handled at exactly right line:
     - sprites with negative height need to be made visible on the exact line
     - sprites with positive height need to be cut short after the exact line
     - non-sprite changes

2. for each sprite to draw

   - take each of its piece of data to change
   - write to double buffer of VIC registers

3. for each change in double buffer of VIC registers

   - if changed compared to the other buffer

     - write machine code to set the new value
     - this way all the bit fields will be written at once without and/or during the interrupt

4. apply handlers of the non-sprite types to produce machine code to e.g. switch background colors

5. continue until everything that can be handled at this interrupt has been done.

   - for activities for raster lines close to each other, wait until the next one can be done and do it within the same interrupt.

6. complete the interrupt code with commands to

   - write the next interrupt address (presumably right after this one)
   - exit the interrupt.
