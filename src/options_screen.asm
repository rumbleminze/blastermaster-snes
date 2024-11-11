; Options Screen
;
; Palette           > NES      FCEUX    ????
; Continue          > Yes         No
;                 Area: X
;
;   [graphic]

; layout:
; address, # tiles, tile values.  
option_tiles:

.byte $2B, $20, $08, P6, $28, P6, $29, P6, $2d, P6, $22, P6, $28, P6, $27, P6, $2C, P6, $36    ; Options-
.byte $62, $20, $07, P6, $29, P6, $1a, P6, $25, P6, $1e, P6, $2d, P6, $2d, P6, $1e             ; Palette
.byte $70, $20, $03, P6, $27, P6, $1E, P6, $2C                                                 ; NES
.byte $78, $20, $05, P6, $1F, P6, $1C, P6, $1E, P6, $2E, P6, $31                               ; FCEUX

.byte $82, $20, $03, P6, $2A, P6, $28, P6, $25
.byte $90, $20, $03, P6, $32, P6, $1E, P6, $2C                                                 ; YES
.byte $98, $20, $02, P6, $27, P6, $28                                                          ; NO


; HOVER RCHRG
.byte $82, $20, $0B, P6, $21, P6, $28, P6, $2f, P6, $1e, P6, $2b, P6, $34, P6, $2b, P6, $1c, P6, $21, P6, $2b, P6, $20
.byte $90, $20, $03, P6, $32, P6, $1E, P6, $2C                                                 ; YES
.byte $98, $20, $02, P6, $27, P6, $28   

; GUN DEGRADE
.byte $a2, $20, $0B, P6, $20, P6, $2e, P6, $27, P6, $34, P6, $1d, P6, $1e, P6, $20, P6, $2b, P6, $1a, P6, $1d, P6, $1e
.byte $B0, $20, $03, P6, $11, P6, $3E, P6, $14                                                 ; 1/4
.byte $B8, $20, $04, P6, $1f, P6, $2e, P6, $25, P6, $25                                        ; FULL

; CONTINUES
.byte $c2, $20, $09, P6, $1c, P6, $28, P6, $27, P6, $2d, P6, $22, P6, $27, P6, $2e, P6, $1e, P6, $2c
.byte $d0, $20, $03, P6, $2e, P6, $27, P6, $25                                                 ; UNL
.byte $d8, $20, $01, P6, $14                                                                   ; 4 

; LIVES
.byte $e2, $20, $05, P6, $25, P6, $22, P6, $2f, P6, $1e, P6, $2c
.byte $f0, $20, $03, P6, $2e, P6, $27, P6, $25                                                 ; UNL
.byte $f8, $20, $01, P6, $13                                                                   ; 3 

; LOAD
.byte $02, $21, $09, P6, $25, P6, $28, P6, $1a, P6, $1d, P6, $34, P6, $2c, P6, $1a, P6, $2f, P6, $1e ; LOAD SAVE
.byte $10, $21, $03, P6, $32, P6, $1E, P6, $2C                                                 ; YES
.byte $18, $21, $02, P6, $27, P6, $28                                                          ; NO

; save info
.byte $24, $21, $04, P6, $1a, P6, $2b, P6, $1e, P6, $1a ; AREA

; PRESS START
.byte $64, $21, $0B, P6, $29, P6, $2b, P6, $1e, P6, $2c, P6, $2c, P6, $34, P6, $2c, P6, $2d, P6, $1a, P6, $2b, P6, $2d

P0 = $00
P1 = $04
P2 = $08
P3 = $0C
P4 = $10
P5 = $14
P6 = $18
P7 = $1C

P0_3 = $12
P1_3 = $16
P2_3 = $1A
P3_3 = $1E

; fun 8 x 8 BG
.byte $6C, $22, $08, P0, $9A, P0, $6D, P0, $6D, P0, $6D, P0, $6D, P0, $6D, P0, $6D, P0, $6A
.byte $8C, $22, $08, P0, $8D, P0, $9D, P0, $6A, P0, $7A, P0, $8A, P0, $6D, P0, $6D, P0, $7D
.byte $AC, $22, $08, P0, $8E, P0, $9E, P0, $6B, P0, $7B, P0, $8B, P0, $9B, P0, $6E, P0, $7E
.byte $CC, $22, $08, P0, $8F, P0, $9F, P0, $6C, P0, $7C, P0, $8C, P0, $9C, P0, $6F, P0, $7F
.byte $EC, $22, $08, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40
.byte $0C, $23, $08, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40, P0, $40

.byte $2C, $23, $08, P3, $42, P3, $51, P3, $51, P3, $51, P3, $51, P3, $51, P3, $51, P3, $52 
.byte $4C, $23, $08, P3, $46, P3, $56, P3, $46, P3, $56, P3, $46, P3, $56, P3, $46, P3, $56

; full palette preview
.byte $A3, $21, $10, P0_3, $00, P0_3, $01, P0_3, $02, P0_3, $03, P0_3, $04, P0_3, $05, P0_3, $06, P0_3, $07, P0_3, $08, P0_3, $09, P0_3, $0A, P0_3, $0B, P0_3, $0C, P0_3, $0D, P0_3, $0E, P0_3, $0F
.byte $C3, $21, $10, P1_3, $00, P1_3, $01, P1_3, $02, P1_3, $03, P1_3, $04, P1_3, $05, P1_3, $06, P1_3, $07, P1_3, $08, P1_3, $09, P1_3, $0A, P1_3, $0B, P1_3, $0C, P1_3, $0D, P1_3, $0E, P1_3, $0F
.byte $E3, $21, $10, P2_3, $00, P2_3, $01, P2_3, $02, P2_3, $03, P2_3, $04, P2_3, $05, P2_3, $06, P2_3, $07, P2_3, $08, P2_3, $09, P2_3, $0A, P2_3, $0B, P2_3, $0C, P2_3, $0D, P2_3, $0E, P2_3, $0F
.byte $03, $22, $10, P3_3, $00, P3_3, $01, P3_3, $02, P3_3, $03, P3_3, $04, P3_3, $05, P3_3, $06, P3_3, $07, P3_3, $08, P3_3, $09, P3_3, $0A, P3_3, $0B, P3_3, $0C, P3_3, $0D, P3_3, $0E, P3_3, $0F

.byte $FF

msu_unavailable_tiles:
.byte $AB, $20, $44, $3d, $30, $45, $30, $38, $3B, $30, $31, $3B, $34

show_options_screen:
    STZ CURR_OPTION

    LDA VMAIN_STATE
    AND #$0F
    STA VMAIN
    LDA #$80
    STA INIDISP
    JSR clearvm

    LDA #$00
    STA CHR_BANK_BANK_TO_LOAD
    LDA #$00
    STA CHR_BANK_TARGET_BANK
    JSL load_chr_table_to_vm

    LDA #$20
    STA CHR_BANK_BANK_TO_LOAD
    LDA #$01
    STA CHR_BANK_TARGET_BANK
    JSL load_chr_table_to_vm

;     ; if MSU starts here at 0 then it's not available at all
;     LDA MSU_SELECTED
;     BNE :+
;     INC MSU_UNAVAILABLE
; :   
    jsr check_valid_save_data
    jslb load_save_data, $a0
    LDA #$01
    STA SAVE_ENABLED

    JSR write_option_tiles
    JSR write_option_palette
    JSR write_option_palette_from_indexes
    JSR load_options_sprites
    jsr write_current_save_level_deets
    jsr write_single_color_tiles_to_3000
    JSR dma_oam_table
    LDA #$0F
    STA INIDISP
    LDX #$FF


    ; check for input
NEEDS_OAM_DMA = $11
input_loop:
    LDA RDNMI
    BPL :+
    LDA NEEDS_OAM_DMA
    BEQ :+
    JSR dma_oam_table
    STZ NEEDS_OAM_DMA
:   
    jsr read_input
    LDA JOYTRIGGER1

    CMP #DOWN_BUTTON
    BNE :+
    jsr next_option
    bra input_loop

:   CMP #UP_BUTTON
    BNE :+
    jsr prev_option
    bra input_loop

:   CMP #RIGHT_BUTTON
    BNE :+
    jsr toggle_current_option
    bra input_loop

:   CMP #LEFT_BUTTON
    BNE :+
    jsr toggle_current_option
    bra input_loop

:   CMP #START_BUTTON
    BEQ exit_options
    BRA input_loop

exit_options:
    jsr clear_extra_palattes
    jslb persist_save_data, $a0
    LDA #$FF
    LDY #$00

:   STA CHR_BANK_LOADED_TABLE, Y
    INY
    CPY #$08
    BNE :-

    STZ CURR_OPTION
    LDA INIDISP_STATE
    STA INIDISP

    RTS

clear_extra_palattes:
    LDA RDNMI
:   LDA RDNMI
    BPL :-
    LDA #$40
    STA CGADD
:   STZ CGDATA
    DEC
    BNE :-
    rts

NUM_OPTIONS = 6
CURR_OPTION = $10
; MSU_UNAVAILABLE = $12

option_sprite_y_pos:
.byte $16, $1E, $26, $2E, $36, $3E

next_option:
    LDA CURR_OPTION
    INC
    STA CURR_OPTION
    CMP #NUM_OPTIONS
    BNE :+
    STZ CURR_OPTION
:   jsr update_option_pos
    RTS

prev_option:
    LDA CURR_OPTION
    BNE :+
    LDA #NUM_OPTIONS    
:   DEC 
    STA CURR_OPTION
    jsr update_option_pos
    RTS

update_option_pos:
    LDA CURR_OPTION
    TAY
    LDA option_sprite_y_pos, Y
    STA SNES_OAM_START + 24 + 1
    LDA #$01
    sta NEEDS_OAM_DMA
    rts

toggle_current_option:
    LDA #$01
    sta NEEDS_OAM_DMA
    LDA CURR_OPTION
    BNE :+
        jsr toggle_palette
        rts
:   
    CMP #$01
    BNE :+
        jsr toggle_hover
        rts
:   
    CMP #$02
    BNE :+
        jsr toggle_gun_degrade
        rts
:   
    CMP #$03
    BNE :+
        jsr toggle_continue
        rts

:   
    CMP #$04
    BNE :+
        jsr toggle_lives
        rts    

:   
    CMP #$05
    BNE :+
        jsr toggle_save
        rts    

:   ; should never get here but whatever
    RTS

FIRST_OPTION  = $77
SECOND_OPTION = $B7 

PAL_OPTION_SPRITE   = SNES_OAM_START + (0 * 4)
QOL_HOVER_OPTION    = SNES_OAM_START + (1 * 4)
QOL_GUN_OPTION      = SNES_OAM_START + (2 * 4)
QOL_CONTINUE_OPTION = SNES_OAM_START + (3 * 4)
QOL_LIVES_OPTION    = SNES_OAM_START + (4 * 4)
SAVE_OPTION         = SNES_OAM_START + (5 * 4)

toggle_hover:
    LDA QOL_SETTINGS
    AND #QOL_HOVER
    BEQ :+
        LDA #QOL_HOVER
        EOR #$FF
        AND QOL_SETTINGS
        STA QOL_SETTINGS
        LDA #SECOND_OPTION
        BRA :++
    :
        ; turn them all on for now.
        LDA QOL_SETTINGS
        ORA #QOL_HOVER
        STA QOL_SETTINGS
        LDA #FIRST_OPTION
    :   STA QOL_HOVER_OPTION

    rts

toggle_gun_degrade:
    LDA QOL_SETTINGS
    AND #QOL_GUN_DECREASE
    BEQ :+
        LDA #QOL_GUN_DECREASE
        EOR #$FF
        AND QOL_SETTINGS
        STA QOL_SETTINGS
        LDA #SECOND_OPTION
        BRA :++
    :
        ; turn them all on for now.
        LDA QOL_SETTINGS
        ORA #QOL_GUN_DECREASE
        STA QOL_SETTINGS
        LDA #FIRST_OPTION
    :   STA QOL_GUN_OPTION

    rts

toggle_continue:
    LDA QOL_SETTINGS
    AND #QOL_CONTINUES
    BEQ :+
        LDA #QOL_CONTINUES
        EOR #$FF
        AND QOL_SETTINGS
        STA QOL_SETTINGS
        LDA #SECOND_OPTION
        BRA :++
    :
        LDA QOL_SETTINGS
        ORA #QOL_CONTINUES
        STA QOL_SETTINGS
        LDA #FIRST_OPTION
    :   STA QOL_CONTINUE_OPTION

    rts

toggle_lives:
    LDA QOL_SETTINGS
    AND #QOL_LIVES
    BEQ :+
        LDA #QOL_LIVES
        EOR #$FF
        AND QOL_SETTINGS
        STA QOL_SETTINGS
        LDA #SECOND_OPTION
        BRA :++
    :
        LDA QOL_SETTINGS
        ORA #QOL_LIVES
        STA QOL_SETTINGS
        LDA #FIRST_OPTION
    :   STA QOL_LIVES_OPTION

    rts


toggle_save:
    LDA SAVE_ENABLED
    BEQ :+
        STZ SAVE_ENABLED
        LDA #SECOND_OPTION
        BRA :++
    :
        INC SAVE_ENABLED
        LDA #FIRST_OPTION
    :   STA SAVE_OPTION

    rts

toggle_palette:
    LDA PALETTE_OPTION
    BEQ :+
        STZ PALETTE_OPTION
        jsr write_option_palette
        LDA #FIRST_OPTION
        BRA :++
    :
        INC PALETTE_OPTION
        jsr write_alt_option_palette
        LDA #SECOND_OPTION
    :       
    STA PAL_OPTION_SPRITE
    jsr write_option_palette_from_indexes
    rts

write_option_palette:
    LDA RDNMI
:   LDA RDNMI
    BPL :-

    LDA #$41
    STA CGADD
    LDX #$80
    LDY #$00

:   LDA palette_lookup, Y
    STA CGDATA
    INY
    DEX
    BNE :-

    RTS

write_alt_option_palette:
    LDA RDNMI
:   LDA RDNMI
    BPL :-

    LDA #$41
    STA CGADD
    LDX #$80
    LDY #$00

:   LDA alt_palette, Y
    STA CGDATA
    INY
    DEX
    BNE :-

    RTS

write_option_palette_from_indexes:
    LDA RDNMI
:   LDA RDNMI
    BPL :-

    STZ CGADD
    LDY #$00
    LDX #$00

option_palette_loop:
    LDA default_options_bg_palette_indexes, Y
    ASL A
    TAX

    LDA PALETTE_OPTION
    BNE :+  
        LDA palette_lookup, X
        STA CGDATA
        LDA palette_lookup + 1, X
        STA CGDATA
        bra :++
    : 
        LDA alt_palette, X
        STA CGDATA
        LDA alt_palette + 1, X
        STA CGDATA
    :
    INY
    ; every 4 we need to write a bunch of empty palette entries
    TYA
    AND #$03
    BNE :+

    CLC
    LDA CURR_PALETTE_ADDR
    ADC #$10
    STA CGADD
    STA CURR_PALETTE_ADDR

:
    TYA
    AND #$0F
    CMP #$00
    BNE :+
    ; after 16 entries we write an empty set of palettes
    CLC
    LDA CURR_PALETTE_ADDR
    ADC #$40
    STA CGADD
    STA CURR_PALETTE_ADDR 

:
    CPY #$20
    BNE option_palette_loop
    rts    

write_option_tiles:
    setXY16
    LDY #$0000

next_option_bg_line:
    ; get starting address
    LDA option_tiles, Y
    CMP #$FF
    BEQ exit_options_write

    PHA
    INY    
    LDA option_tiles, Y
    STA VMADDH
    PLA
    STA VMADDL
    INY
    LDA option_tiles, Y
    TAX
    INY

:   LDA option_tiles, Y
    STA VMDATAH
    INY
    LDA option_tiles, Y
    STA VMDATAL
    INY
    DEX
    BEQ next_option_bg_line
    BRA :-

exit_options_write:
    setAXY8
    RTS



load_options_sprites:
    LDY #$00
:   LDA options_sprites, Y
    CMP #$FF
    BEQ :+
    STA SNES_OAM_START, Y
    INY
    BRA :-

:    
    LDA QOL_SETTINGS
    AND #QOL_HOVER
    BNE :+
        LDA #SECOND_OPTION
        STA QOL_HOVER_OPTION
    :

    LDA QOL_SETTINGS
    AND #QOL_GUN_DECREASE
    BNE :+
        LDA #SECOND_OPTION
        STA QOL_GUN_OPTION
    :

    LDA QOL_SETTINGS
    AND #QOL_CONTINUES
    BNE :+
        LDA #SECOND_OPTION
        STA QOL_CONTINUE_OPTION
    :

    LDA QOL_SETTINGS
    AND #QOL_LIVES
    BNE :+
        LDA #SECOND_OPTION
        STA QOL_LIVES_OPTION
    :

    LDA PALETTE_OPTION
    BEQ :+
        LDA #SECOND_OPTION
        STA PAL_OPTION_SPRITE
    :

; :   
;     LDA MSU_UNAVAILABLE
;     BEQ :+
;         STZ MSU_SELECTED
;         LDA #SECOND_OPTION
;         STA MSU_OPTION
;         jsr disable_msu_option
    RTS

read_input:
    lda #$01
    STA JOYSER0
    STA buttons
    LSR A
    sta JOYSER0
@loop:
    lda JOYSER0
    lsr a
    rol buttons
    bcc @loop

    lda buttons
    ldy JOYPAD1
    sta JOYPAD1
    tya
    eor JOYPAD1
    and JOYPAD1
    sta JOYTRIGGER1
    beq :+ 

    tya
    and JOYPAD1
    sta JOYHELD1
:   rts


write_single_color_tiles_to_3000:
    LDA #$30
    STA VMADDH
    LDA #$00
    STA VMADDL

    LDY #$00
    LDX #$02

:   
    LDA single_color_tiles + 1, Y
    STA VMDATAH
    LDA single_color_tiles, Y
    STA VMDATAL
    INY
    INY

    BNE :-

:   LDA single_color_tiles + $100 + 1, Y
    STA VMDATAH
    LDA single_color_tiles + $100, Y
    STA VMDATAL
    INY
    INY
    
    BNE :-

    rts


write_current_save_level_deets:
    LDA CHECK_BYTE
    BNE :+
    jsr write_new_game
    rts
:   
    LDA #$21
    STA VMADDH
    LDA #$29
    STA VMADDL
    LDA #P6
    STA VMDATAH

    LDA LEVEL
    AND #$07
    ADC #$10
    STA VMDATAL

    rts

new_game_tiles:
.byte P3, $27, P3, $28, P3, $34, P3, $2c, P3, $1a, P3, $2f, P3, $1e
; new game info
write_new_game:
    LDA #$21
    STA VMADDH
    LDA #$04
    STA VMADDL

    LDY #$00
    LDX #$00

:   LDA new_game_tiles, Y
    STA VMDATAH
    INY
    LDA new_game_tiles, Y
    STA VMDATAL
    INY
    INX
    CPX #$07
    BNE :-

    rts



; X, Y, Tile, attributes
options_sprites:
.byte  $77, $18, $7E, $42   ; Palette Selection
.byte  $77, $20, $7E, $42   ; Hover Option selection
.byte  $77, $28, $7E, $42   ; GUN Option selection
.byte  $77, $30, $7E, $42   ; Continues Option selection
.byte  $77, $38, $7E, $42   ; Lives Option selection
.byte  $77, $40, $7E, $42   ; Load Save Option Selection
.byte  $04, $16, $7E, $42   ; Option Selection

.byte 120, 184, $20, $40 ; tank sprite 1/6
.byte 128, 184, $10, $40 ; tank sprite 2/6
.byte 136, 184, $15, $20 ; tank sprite 3/6
.byte 120, 192, $30, $20 ; tank sprite 4/6
.byte 128, 192, $0C, $20 ; tank sprite 5/6
.byte 136, 192, $40, $20 ; tank sprite 6/6

.byte 104, 184, $F9, $20 ; Enemy Sprint x/4
.byte  96, 184, $E9, $20 ; Enemy Sprint x/4
.byte 104, 192, $FB, $20 ; Enemy Sprint x/4
.byte  96, 192, $EB, $20 ; Enemy Sprint x/4


.byte $FF

default_options_bg_palette_indexes:
.byte $0F, $07, $00, $01, $0F, $02, $01, $1C, $0F, $0A, $18, $28, $0F, $17, $19, $10

default_options_sprite_palette_indexes:
.byte $0F, $30, $15, $0F, $0F, $30, $00, $0F, $0F, $3B, $1B, $0F, $0F, $06, $16, $38

default_options_palette:
.byte $00, $00, $FF, $7F, $74, $64, $42, $50, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $F7, $02, $33, $01, $6A, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $29, $6F, $07, $02, $A0, $44, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $BF, $65, $8C, $31, $76, $3C, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

options_sprite_palette:
.byte $00, $00, $FF, $7F, $1F, $3A, $6A, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $78, $7F, $42, $50, $76, $3C, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $08, $7D, $D8, $7D, $78, $7F, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $0D, $00, $D6, $10, $9C, $4B, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; 16 4bpp tiles that use all of a single color
; used to show the full NES palette we're currently using
single_color_tiles:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00

.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF

.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF