; moved logic from EBC0ish
title_screen_palette_updates:
  PHY
  PHX
  PHA

  PHB
  PHK
  PLB

  STZ CURR_PALETTE_ADDR
  STZ CGADD

  LDY #$00
  LDX #$00

title_palette_entry:
  LDA $58, X
  AND #$3F
  TAY
  LDA $EBF4,Y

  ASL
  TAY
  LDA palette_lookup, Y
  STA CGDATA
  LDA palette_lookup + 1, Y
  STA CGDATA

  INX
  TXA

  AND #$03
  BNE :+
  jsr write_3_empty_rows
: TXA
  AND #$0F
  CMP #$00
  BNE :+
  ; after 16 entries we write an empty set of palettes
  jsr write_4_empty_entries
: CPX #$20
  BNE title_palette_entry

  ; jsr make_first_palette_greyscale

  PLB
  PLA
  PLX
  PLY
  RTL

write_3_empty_rows:
  CLC
  LDA CURR_PALETTE_ADDR
  ADC #$10
  STA CGADD
  STA CURR_PALETTE_ADDR
  RTS

write_4_empty_entries:
  CLC
  LDA CURR_PALETTE_ADDR
  ADC #$40
  STA CGADD
  STA CURR_PALETTE_ADDR
  rts

write_palette_data:
  PHX
  PHY
  PHA

  setAXY8
  LDA #$A0
  
  PHA
  PLB
  LDY #$00
  STZ CURR_PALETTE_ADDR
  STZ CGADD
  ; CND stores the current palettes at 0x0300
  ; BG is 0330 - 033F
  ; Sprites are 0340 - 034F

  ; lookup our 2 byte color from palette_lookup, color * 2
  ; Our palettes are written by writing to CGDATA
palette_entry:
  LDA $0300, Y
  ASL A
  TAX
  LDA palette_lookup, X
  STA CGDATA
  LDA palette_lookup + 1, X
  STA CGDATA
  INY
  ; every 4 we need to write a bunch of empty palette entries
  TYA
  AND #$03
  BNE :+
  jsr write_3_empty_rows
: TYA
  AND #$0F
  CMP #$00
  BNE :+
  ; after 16 entries we write an empty set of palettes
  jsr write_4_empty_entries
: CPY #$20
  BNE palette_entry

  LDA ACTIVE_NES_BANK
  INC A
  ORA #$A0
  PHA
  PLB
  PLA
  PLY  
  PLX
  ; done after $20
  RTL
  
zero_all_palette:
  LDY #$00
  LDX #$02

  STZ CGADD

: STZ CGDATA
  DEY
  BNE :-
  DEX
  BNE :-

  RTS

greyscale_palette:
.byte  $00, $00, $29, $25, $B5, $56, $FF, $7F
make_first_palette_greyscale:
  LDA #$00
  sta CGADD
  LDY #$00
: LDA greyscale_palette, y
  STA CGDATA
  INY
  CMP #$08
  BNE :-
  rts

snes_sprite_palatte:
; .byte $D6, $10, $FF, $7F, $D6, $10, $00, $00, $91, $29, $CE, $39, $5B, $29, $35, $3A
; .byte $77, $46, $B5, $56, $B9, $4E, $FB, $56, $3D, $5F, $7B, $6F, $FC, $7F, $FF, $7F
.byte $1F, $00, $FF, $7F, $53, $08, $00, $00, $91, $29, $CE, $39, $5B, $29, $35, $3A
.byte $77, $46, $B5, $56, $B9, $4E, $FB, $56, $3D, $5F, $7B, $6F, $D7, $18, $FF, $7F
write_default_palettes:
  LDA #$80
  sta CGADD
  LDY #$00
: LDA snes_sprite_palatte, y
  STA CGDATA
  INY
  CMP #$20
  BNE :-
  rts