# Blaster Master SNES
Blaster Master SNES Port - V 1.1

This is a 1:1 port of the NES version of Blaster Master, running on the SNES. It is utilizing FastROM/HiROM.

This has been tested in Mesen2, a Taki Udon Mister setup, and on original hardware via FxPak Pro.

## Additional Features

The "X" button will act as if you pressed both Down and Y, which will fire your selected special weapon while in the tank.

Addtionally, the following Quality of Life options are available:
1. Choice of two palettes, the default Mesen2 NES palette, or the default FCEUX palette
2. Turn on hover recharge while idle - this will slowly fill your hover gauge as long as you're on the ground not moving.
3. Gun Degrade - FULL (1 bar lost per hit), or 1/4 (lose at 1/4 the rate, although the first hit will drop you down a level)
4. Continues - either unlimited or the original limit of 4
5. Lives - either unlimited or the original limit of 3
6. Saving - The game will automatically save periodically, including when you reach a new area or pick up a key item.  You can choose to load this save when you start the game, which will start you at the beginning of the area you were in, with your items, lives, continues, and sub weapon counts in tact.  You can also choose to change any of the QoL options when you load your save.

## KNOWN ISSUES
* Occassional sprite garbage frames from overload of sprites, and being unable to finish translating them before NMI occurs.

## WHAT & HOW TO REPORT TO ME
If you encounter issues and would like to report them to me, please reach out to @rumbleminze.bsky.social on Blue Sky


Happy Gaming!
-Rumbleminze


## Prerequisites

* [cc65](https://www.cc65.org/) - the 65c816 compiler and linker


## Other Userful Tools I've used for this project

* [Mesen2](https://github.com/SourMesen/Mesen2) - A fantastic emulator for development on a bunch of platforms
* [HxD](https://mh-nexus.de/en/hxd/) - A Hex Editor
* [Visual Studio Code](https://code.visualstudio.com/) - Used as the development environment

## Structure of the Project

* `bankX.asm` - The NES memory PRG banks, there are 8 of them.  This code is heavily edited/altered for the port  
* `chrom-tiles-X.asm` - The NES CHR ROM banks, also 8 of them. These are untouched aside from converting them to the SNES tile format that we use.  The go script takes care of that for you.
* `2a03_xxxxx.asm` - Sound emulation related code
* `bank-snes.asm` - All the code that runs in the `A0` bank, this is where we put most of our routines and logic that we need that is SNES specific.  Also includes various included asm files:

  * `attributes.asm` - dealing with tile and sprite attributes
  * `hardware-status-switches.asm` - various useful methods to handle differences in hardware registers
  * `hud-hdma.asm` - HDMA logic for the player health bars and names to be shown
  * `intro_screen.asm` - Title card that is shown at the start of the game
  * `palette_lookup.asm` and `palette_updates.asm` - palette logic
  * `sprites.asm` - sprite conversion and DMA'ing

* `main.asm` - the main file, root for the project
* `vars.inc`, `registers.inc`, `macros.inc` - helpful includes
* `resetvector.asm` - the reset vector code
* `hirom.cfg` - defines how our ROM is laid out, where each bank lives and how large they are

## Building

* Update the `build.sh` file with the location of your cc65 install
* make sure you've extracted and copied the chr rom banks to `/src`
* run `build.sh`
* The output will be in `out/`
