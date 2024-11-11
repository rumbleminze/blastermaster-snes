PALETTE_START = $0B00
PALETTE_PTR = $90

new_palette_routine:
  PHY
  PHX
  PHA
  LDA PALETTE_PTR
  PHA
  LDA PALETTE_PTR + 1
  PHA
  PHB

  PHK
  PLB
  
  LDY #$00
  LDX #$00
  LDA #$0B
  STA PALETTE_PTR + 1
  STZ PALETTE_PTR
tpe:
  LDA $58, X
  AND #$3F
  TAY
  LDA $EBF4, Y
  ASL
  TAY

  LDA palette_lookup, Y
  STA (PALETTE_PTR)  
  INC PALETTE_PTR

  LDA palette_lookup + 1, Y
  STA (PALETTE_PTR)
  INC PALETTE_PTR
  INX

  LDA PALETTE_PTR
  AND #$08
  BEQ :++
  LDA PALETTE_PTR
  AND #$F0
  ADC #$20
  CMP #$80
  BNE :+
  STZ PALETTE_PTR
  INC PALETTE_PTR + 1
  BRA :++
: STA PALETTE_PTR
: CPX #$20
  BNE tpe

  jsr dma_palette

  PLB
  PLA
  STA PALETTE_PTR + 1
  PLA
  STA PALETTE_PTR
  PLA
  PLX
  PLY
  RTL

dma_palette:
  STZ CGADD

  STZ DMAP0
  LDA #<CGDATA
  STA BBAD0
  
  STZ A1B0
  LDA #$0B
  STA A1T0H
  STZ A1T0L

  LDA #$80
  STA DAS0L
  STZ DAS0H
  LDA #$01
  STA MDMAEN

  LDA #$80
  STA CGADD
  
  LDA #$0C
  STA A1T0H
  STZ A1T0L

  LDA #$80
  STA DAS0L
  STZ DAS0H
  LDA #$01
  STA MDMAEN
  rts


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
      CLC
      LDA CURR_PALETTE_ADDR
      ADC #$10
      STA CGADD
      STA CURR_PALETTE_ADDR
: TXA
  AND #$0F
  CMP #$00
  BNE :+
  ; after 16 entries we write an empty set of palettes
    CLC
    LDA CURR_PALETTE_ADDR
    ADC #$40
    STA CGADD
    STA CURR_PALETTE_ADDR
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
  CPY #$08
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
  CPY #$20
  BNE :-
  rts

new_new_palette:
  PHX
  PHY
  PHB
  PHK
  PLB

  LDX #$00
  PHX
  STZ CURR_PALETTE_ADDR
  STZ CURR_PALETTE_ADDR + 1
load_next_cgadd:
  LDA CURR_PALETTE_ADDR
  STA CGADD
: PLX
  TXY
  ; LDA $0356,Y
  LDA $58, X
  AND #$3F
  TAY
  LDA $EBF4, Y

  TAY
  LDA color_indexes,Y
  TAY
  LDA color_indexes,Y
  STA CGDATA
  INY
  LDA color_indexes,Y
  STA CGDATA
  INX
  CPX #$20
  BEQ exit_nnp
  PHX
  TXA
  LDX CURR_PALETTE_ADDR + 1
  CMP palette_table + $6,X
  BNE :-
  INC CURR_PALETTE_ADDR + 1
  CMP #$10
  BEQ :+
  LDA CURR_PALETTE_ADDR
  CLC
  ADC #$10
  STA CURR_PALETTE_ADDR
  BRA load_next_cgadd
: LDA CURR_PALETTE_ADDR
  CLC
  ADC #$50
  STA CURR_PALETTE_ADDR
  BRA load_next_cgadd
exit_nnp:
  PLB
  PLY
  PLX
  RTL



palette_table:
.byte $43, $47, $52, $41, $4D, $20
.byte $04, $08, $0C, $10, $14, $18, $1C, $00, $00, $00
color_indexes:
.byte $40, $42, $44, $46, $48, $4A, $4C, $4E, $50, $52, $54, $56, $58, $5A, $5C, $5E
.byte $60, $62, $64, $66, $68, $6A, $6C, $6E, $70, $72, $74, $76, $78, $7A, $7C, $7E
.byte $80, $82, $84, $86, $88, $8A, $8C, $8E, $90, $92, $94, $96, $98, $9A, $9C, $9E
snes_color_values:
.byte $A0, $A2, $A4, $A6, $A8, $AA, $AC, $AE, $B0, $B2, $B4, $B6, $B8, $BA, $BC, $BE
.byte $CE, $39, $84, $D8, $00, $54, $08, $4C, $11, $38, $15, $08, $14, $00, $2F, $00
.byte $A8, $00, $00, $01, $40, $01, $E0, $08, $E3, $2C, $00, $00, $00, $00, $00, $00
.byte $F7, $5E, $C0, $75, $E4, $74, $10, $78, $17, $5C, $1C, $2C, $BB, $00, $39, $05
.byte $D1, $01, $40, $02, $A0, $02, $40, $1E, $00, $46, $00, $00, $00, $00, $00, $00
.byte $FF, $7F, $E7, $7E, $4B, $7E, $39, $7E, $FE, $7D, $DF, $59, $DF, $31, $7F, $1E
.byte $FE, $1E, $50, $0B, $69, $27, $EB, $4F, $A0, $6F, $EF, $3D, $00, $00, $00, $00
.byte $FF, $7F, $95, $7F, $58, $7F, $3A, $7F, $1F, $7F, $1F, $6F, $FF, $5A, $7F, $57
.byte $9F, $53, $FC, $53, $D5, $5F, $F6, $67, $F3, $7B, $18, $63, $00, $00, $00, $00
