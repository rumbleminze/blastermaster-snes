translate_blaster_master_sprites:
  lda PPU_CONTROL_STATE
  and #$20
  bne :+
    jsr clear_8_16_extra_sprites
    jslb translate_8by8only_nes_sprites_to_oam, $a0
    bra :++
: jslb translate_8_by_16_sprites, $a0
  STZ NEED_TO_CLEAR_8x16_SPRITES
  INC NEED_TO_CLEAR_8x16_SPRITES
: jsr clear_sprites_to_f0
  rtl

clear_8_16_extra_sprites:
  LDA NEED_TO_CLEAR_8x16_SPRITES
  BNE :+
  rts
: STZ NEED_TO_CLEAR_8x16_SPRITES
  LDA #$F0  
  STA $1101
  STA $1105
  STA $1109
  STA $110D
  STA $1111
  STA $1115
  STA $1119
  STA $111D
  STA $1121
  STA $1125
  STA $1129
  STA $112D
  STA $1131
  STA $1135
  STA $1139
  STA $113D
  STA $1141
  STA $1145
  STA $1149
  STA $114D
  STA $1151
  STA $1155
  STA $1159
  STA $115D
  STA $1161
  STA $1165
  STA $1169
  STA $116D
  STA $1171
  STA $1175
  STA $1179
  STA $117D
  STA $1181
  STA $1185
  STA $1189
  STA $118D
  STA $1191
  STA $1195
  STA $1199
  STA $119D
  STA $11A1
  STA $11A5
  STA $11A9
  STA $11AD
  STA $11B1
  STA $11B5
  STA $11B9
  STA $11BD
  STA $11C1
  STA $11C5
  STA $11C9
  STA $11CD
  STA $11D1
  STA $11D5
  STA $11D9
  STA $11DD
  STA $11E1
  STA $11E5
  STA $11E9
  STA $11ED
  STA $11F1
  STA $11F5
  STA $11F9
  STA $11FD
  RTS

clear_sprites_to_f0:
  LDA #$F0
  LDX #$00
  STZ $3C
  STZ $3D
  STA $0200
  STA $0204
  STA $0208
  STA $020C
  STA $0210
  STA $0214
  STA $0218
  STA $021C
  STA $0220
  STA $0224
  STA $0228
  STA $022C
  STA $0230
  STA $0234
  STA $0238
  STA $023C
  STA $0240
  STA $0244
  STA $0248
  STA $024C
  STA $0250
  STA $0254
  STA $0258
  STA $025C
  STA $0260
  STA $0264
  STA $0268
  STA $026C
  STA $0270
  STA $0274
  STA $0278
  STA $027C
  STA $0280
  STA $0284
  STA $0288
  STA $028C
  STA $0290
  STA $0294
  STA $0298
  STA $029C
  STA $02A0
  STA $02A4
  STA $02A8
  STA $02AC
  STA $02B0
  STA $02B4
  STA $02B8
  STA $02BC
  STA $02C0
  STA $02C4
  STA $02C8
  STA $02CC
  STA $02D0
  STA $02D4
  STA $02D8
  STA $02DC
  STA $02E0
  STA $02E4
  STA $02E8
  STA $02EC
  STA $02F0
  STA $02F4
  STA $02F8
  STA $02FC
  RTS


translate_8_by_16_sprites:
  jsl disable_nmi_no_store
  LDX #$03
  LDY #$00
traslation_start:
  LDA $0200,X
  STA SNES_OAM_START + 0,Y
  STA SNES_OAM_START + 4,Y
  DEX
  DEX
  DEX
  INY
  LDA $0200,X
  STA SNES_OAM_START + 0,Y
  CLC
  ADC #$08
  BNE :+
  LDA #$F8
: STA SNES_OAM_START + 4,Y
  INX
  INY
  LDA $0200,X
  PHA
  AND #$01
  BEQ :+
  STA $0AFE
  PLA
  DEC
  BRA :++
: PLA
: STA SNES_OAM_START,Y
  INC
  STA SNES_OAM_START + 4,Y
  INX
  INY
  LDA $0200,X
  AND #$80
  BPL :+
  DEY
  LDA SNES_OAM_START + 4,Y
  STA SNES_OAM_START + 0,Y
  DEC
  STA SNES_OAM_START + 4,Y
  INY
: LDA $0200,X
  PHA
  AND #$03
  ASL A
  STA $0AFF
  PLA
  AND #$F0
  EOR #%00110000
  ORA $0AFF
  ORA OBJ_CHR_HB

  STA $0AFF
  LDA $0200,X
  AND #$20
  BEQ :+
  LDA $0AFF
  
  AND #$CF

  BRA :++
: LDA $0AFF
: STA SNES_OAM_START + 0,Y
  STA SNES_OAM_START + 4,Y
  PHA
  LDA $0AFE
  BEQ :+
  PLA
  CLC
  ADC $0AFE
  STA SNES_OAM_START + 0,Y
  STA SNES_OAM_START + 4,Y
  STZ $0AFE
  BRA :++
: STZ $0AFE
  PLA
: INX
  INX
  INX
  INX
  INX
  TYA
  CLC
  ADC #$05
  TAY
  BEQ second_half_of_sprites
  JMP traslation_start
  nop
second_half_of_sprites: 
  LDA $0200,X
  STA SNES_OAM_SECOND_BLOCK + 0,Y
  STA SNES_OAM_SECOND_BLOCK + 4,Y
  DEX
  DEX
  DEX
  INY
  LDA $0200,X
  STA SNES_OAM_SECOND_BLOCK + 0,Y
  CLC
  ADC #$08
  BNE :+
  LDA #$F8
: STA SNES_OAM_SECOND_BLOCK + 4,Y
  INX
  INY
  LDA $0200,X
  PHA
  AND #$01
  BEQ :+
  STA $0AFE
  PLA
  DEC
  BRA :++
: PLA
: STA SNES_OAM_SECOND_BLOCK + 0,Y
  INC
  STA SNES_OAM_SECOND_BLOCK + 4,Y
  INX
  INY
  LDA $0200,X
  AND #$80
  BPL :+
  DEY
  LDA SNES_OAM_SECOND_BLOCK + 4,Y
  STA SNES_OAM_SECOND_BLOCK + 0,Y
  DEC
  STA SNES_OAM_SECOND_BLOCK + 4,Y
  INY
: LDA $0200,X
  PHA
  AND #$03
  ASL A
  STA $0AFF
  PLA
  AND #$F0
  EOR #%00110000
  ORA $0AFF
  ORA OBJ_CHR_HB

  STA $0AFF
  LDA $0200,X
  AND #$20
  BEQ :+
  LDA $0AFF
  ; SEC
  ; SBC #$30  
  AND #$CF
  BRA :++
: LDA $0AFF
: STA SNES_OAM_SECOND_BLOCK + 0,Y
  STA SNES_OAM_SECOND_BLOCK + 4,Y
  PHA
  LDA $0AFE
  BEQ :+
  PLA
  CLC
  ADC $0AFE
  STA SNES_OAM_SECOND_BLOCK + 0,Y
  STA SNES_OAM_SECOND_BLOCK + 4,Y
  STZ $0AFE
  BRA :++
: STZ $0AFE
  PLA
: INX
  INX
  INX
  INX
  INX
  TYA
  CLC
  ADC #$05
  TAY
  BEQ :+
  JMP second_half_of_sprites
: jsl enable_nmi
  RTL

translate_8by8only_nes_sprites_to_oam:
    ; check if we need to do this
    LDA SNES_OAM_TRANSLATE_NEEDED
    BNE :+
    RTL
    ; PHA
    ; PHX
    ; PHY
    ; PHB
    ; we clobber this ZP value, so save it off
:   LDA SPRITE_LOOP_JUNK
    PHA

   setXY16
	LDY #$0000

sprite_loop:	
  
	; byte 0, Tile Y position
	LDA $200,Y
	STA SNES_OAM_START + 1, y
  CMP #$F0
  beq next_sprite

	; byte 1, Tile index
	LDA $201, Y
	STA SNES_OAM_START + 2, y
	; beq empty_sprite

	; byte 3, Tile X Position
	LDA $203, Y
	STA SNES_OAM_START, y 

	; properties
	LDA $202, Y
	PHA
	AND #$03
	ASL A
	STA SPRITE_LOOP_JUNK
	PLA
	AND #$F0
	EOR #%00110000
	ORA SPRITE_LOOP_JUNK
  ORA OBJ_CHR_HB
	; LDA #%00010010

	STA SNES_OAM_START + 3, y
	; bra next_sprite

	next_sprite:
	INY
	INY
	INY
	INY
	CPY #$100
	BNE sprite_loop

  setAXY8
  PLA
  STA SPRITE_LOOP_JUNK
  STZ SNES_OAM_TRANSLATE_NEEDED
	rtl

dma_oam_table_long:
  JSR dma_oam_table
  RTL

dma_oam_table:
  STZ OAMADDL
  STZ OAMADDH
  LDA #<OAMDATA
  STA BBAD2
  LDA #$A0
  STA A1B2

  STZ DMAP2
  LDA #>SNES_OAM_START
  STA A1T2H
  LDA #<SNES_OAM_START
  STA A1T2L
  LDA #$02
  STA DAS2H
  LDA #$20
  STA DAS2L
  LDA DMA_ENABLED_STATE
  ORA #$04
  STA MDMAEN

  INC SNES_OAM_TRANSLATE_NEEDED
  RTS

zero_oam:

  setXY16
  ldx #$0000

: stz SNES_OAM_START, x
  lda #$f0
  STA SNES_OAM_START + 1, x
  STZ SNES_OAM_START + 2, x
  STZ SNES_OAM_START + 3, x
  INX
  INX
  INX
  INX
  CPX #$200
  bne :-
: stz SNES_OAM_START, X
  inx
  CPX #$220
  bne :-
  setAXY8
  RTS
