nsf_track_lookup:
.byte $00, $54, $06, $04, $02, $13, $07, $05, $37, $2B, $09, $2A, $3a, $17, $3D


show_msu_track_screen:

    LDX #$20
    LDA RDNMI
    : LDA RDNMI
    BPL :-
    DEX
    BPL :-

    LDA #$01
    STA CURR_OPTION

    LDA VMAIN_STATE
    AND #$0F
    STA VMAIN
    LDA #$80
    STA INIDISP

    JSR clearvm
    jsr clear_sprites
    ; jsr dma_oam_table

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

    jsr write_msu_option_tiles
    
    JSR load_msu_options_sprites
    JSR dma_oam_table

    LDY #$01
    LDA nsf_track_lookup, Y

    jslb msu_check, $b2

    LDA #$0F
    STA INIDISP

@input_loop:
    LDA RDNMI
    BPL :+
    
    jslb msu_nmi_check, $b2
    LDA NEEDS_OAM_DMA
    BEQ :+
    JSR dma_oam_table
    STZ NEEDS_OAM_DMA
:   
    jsr read_input
    LDA JOYTRIGGER1

    CMP #RIGHT_BUTTON
    BNE :+
        jsr toggle_current_msu_option
        jsr play_current_option_msu_if_enabled
        bra @input_loop
    :
    CMP #LEFT_BUTTON
    BNE :+
        jsr toggle_current_msu_option
        jsr play_current_option_msu_if_enabled
        bra @input_loop
    :
    CMP #DOWN_BUTTON
    BNE :+        
        jsr @next_option     
        jsr play_current_option_msu_if_enabled
        BRA @input_loop
    :

    CMP #UP_BUTTON
    BNE :+
        jsr @prev_option
        jsr play_current_option_msu_if_enabled
        bra @input_loop
    :

    CMP #SELECT_BUTTON
    BEQ @exit_options
    BRA @input_loop

@exit_options:
    jslb stop_msu_only, $b2
    rts


@next_option:
    INC CURR_OPTION
    LDA CURR_OPTION
    CMP #(NUM_MSU_OPTIONS + 1)
    BNE :+
    LDA #$01
    STA CURR_OPTION
:   jsr update_msu_option_pos
    rts

@prev_option:
    DEC CURR_OPTION
    BNE :+
    LDA #NUM_MSU_OPTIONS
    STA CURR_OPTION
:   jsr update_msu_option_pos
    rts



update_msu_option_pos:
    LDA CURR_OPTION
    ASL
    ASL
    ASL
    CLC
    ADC #$0e
    
    STA SNES_OAM_START + 1
    LDA #$01
    sta NEEDS_OAM_DMA
    rts


play_current_option_msu_if_enabled:
    LDA CURR_OPTION
    TAY
    LDA TRACKS_ENABLED, Y
    BEQ :+
    LDA nsf_track_lookup, Y
    jslb msu_check, $B2
    bra :++
:   jslb stop_msu_only, $b2   
:
    RTS


toggle_current_msu_option:
    LDA CURR_OPTION
    TAY
    LDA #$01
    EOR TRACKS_ENABLED, Y
    STA TRACKS_ENABLED, Y
    jsr update_msu_track_enabled_pos
    rts

update_msu_track_enabled_pos:
    LDA CURR_OPTION
    TAY
    LDA TRACKS_ENABLED,y
    BNE :+
        LDA #SECOND_OPTION
        bra :++
    :   LDA #FIRST_OPTION
    : PHA
    
    LDA CURR_OPTION
    ASL
    ASL
    TAY
    PLA
    STA SNES_OAM_START, Y

    LDA #$01
    sta NEEDS_OAM_DMA
    rts

write_msu_option_tiles:
    setXY16
    LDY #$0000

next_msu_option_bg_line:
    ; get starting address
    LDA msu_option_tiles, Y
    CMP #$FF
    BEQ exit_msu_options_write

    PHA
    INY    
    LDA msu_option_tiles, Y
    STA VMADDH
    PLA
    STA VMADDL
    INY
    LDA msu_option_tiles, Y
    TAX
    INY

:   LDA msu_option_tiles, Y
    STA VMDATAH
    INY
    LDA msu_option_tiles, Y
    STA VMDATAL
    INY
    DEX
    BEQ next_msu_option_bg_line
    BRA :-

exit_msu_options_write:
    setAXY8
    RTS


load_msu_options_sprites:
    LDY #$00
:   LDA msu_options_sprites, Y
    CMP #$FF
    BEQ :+
    STA SNES_OAM_START, Y
    INY
    BRA :-
:
    rts

; :   
;     LDA MSU_UNAVAILABLE
;     BEQ :+
;         STZ MSU_SELECTED
;         LDA #SECOND_OPTION
;         STA MSU_OPTION
;         jsr disable_msu_option
    RTS

option_name_start = $2062
option1_start = $2070
option2_start = $2078
msu_option_tiles:
.byte $2B, $20, $0E, P6, $26, P6, $2c, P6, $2e, P6, $36, P6, $11, P6, $34, P6, $28, P6, $29, P6, $2d, P6, $22, P6, $28, P6, $27, P6, $2C, P6, $36    ; Options-

.word option_name_start + ($20 * 0)
.byte $05, P6, $22, P6, $27, P6, $2d, P6, $2b, P6, $28                                     ; Opening
.word option1_start + ($20 * 0)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 0)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 1)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $11                                     ; Area 1
.word option1_start + ($20 * 1)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 1)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 2)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $12                                     ; Area 2
.word option1_start + ($20 * 2)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 2)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 3)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $13                                     ; Area 3
.word option1_start + ($20 * 3)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 3)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 4)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $14                                     ; Area 4
.word option1_start + ($20 * 4)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 4)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 5)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $15                                     ; Area 5
.word option1_start + ($20 * 5)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 5)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 6)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $16                                     ; Area 6
.word option1_start + ($20 * 6)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 6)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 7)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $17                                     ; Area 7 
.word option1_start + ($20 * 7)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 7)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 8)
.byte $06, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $18                                     ; Area 8
.word option1_start + ($20 * 8)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 8)
.byte $02, P6, $27, P6, $28                                                                         ; NO
   
.word option_name_start + ($20 * 9)
.byte $06, P6, $1b, P6, $28, P6, $2c, P6, $2c, P6, $36, P6, $11                                     ; Boss 1 
.word option1_start + ($20 * 9)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 9)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 10)
.byte $06, P6, $1b, P6, $28, P6, $2c, P6, $2c, P6, $36, P6, $12                                     ; Boss 2
.word option1_start + ($20 * 10)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 10)
.byte $02, P6, $27, P6, $28                                                                         ; NO


.word option_name_start + ($20 * 11)
.byte $0A, P6, $1a, P6, $2b, P6, $1e, P6, $1a, P6, $34, P6, $1c, P6, $25, P6, $1e, P6, $1a, P6, $2b ; Area Clear
.word option1_start + ($20 * 11)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 11)
.byte $02, P6, $27, P6, $28                                                                         ; NO
               

.word option_name_start + ($20 * 12)
.byte $06, P6, $1e, P6, $27, P6, $1d, P6, $22, P6, $27, P6, $20                                     ; Ending
.word option1_start + ($20 * 12)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 12)
.byte $02, P6, $27, P6, $28                                                                         ; NO
                  
.word option_name_start + ($20 * 13)
.byte $09, P6, $20, P6, $1a, P6, $26, P6, $1e, P6, $34, P6, $28, P6, $2f, P6, $1e, P6, $2b          ; Game Over
.word option1_start + ($20 * 13)
.byte $03, P6, $32, P6, $1E, P6, $2C                                                                ; YES
.word option2_start + ($20 * 13)
.byte $02, P6, $27, P6, $28       ; NO
         
.addr $2264
.byte $14, P6, $29, P6, $2b, P6, $1e, P6, $2c, P6, $2c, P6, $34 ; PRESS 
.byte P6, $2c, P6, $1e, P6, $25, P6, $1e, P6, $1c, P6, $2d, P6, $34 ; SELECT
.byte P6, $2d, P6, $28, P6, $34, P6, $1e, P6, $31, P6, $22, P6, $2d ; TO EXIT                                                     
.byte $FF
; Track Option Graphics
; MSU - TRACK SELECTION
; TRACK      AVAILABLE      ON  OFF
; AREA1         x          >ON  OFF
; ....
; PRESS START TO RETURN TO OPTIONS

NUM_MSU_OPTIONS = 14
; X, Y, Tile, attributes

msu_options_sprites:
.byte $04, $16, $7E, $42   ; Option Selection

.byte $77, $18, $7E, $42   ; Intro
.byte $77, $20, $7E, $42   ; Area 1
.byte $77, $28, $7E, $42   ; Area 2
.byte $77, $30, $7E, $42   ; Area 3
.byte $77, $38, $7E, $42   ; Area 4
.byte $77, $40, $7E, $42   ; Area 5
.byte $77, $48, $7E, $42   ; Area 6
.byte $77, $50, $7E, $42   ; Area 7
.byte $77, $58, $7E, $42   ; Area 8
.byte $77, $60, $7E, $42   ; Area Clear
.byte $77, $68, $7E, $42   ; Boss 1
.byte $77, $70, $7E, $42   ; Boss 2
.byte $77, $78, $7E, $42   ; Ending
.byte $77, $80, $7E, $42   ; Game Over
.byte $FF