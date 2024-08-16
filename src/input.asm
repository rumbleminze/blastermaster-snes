PLAYER_1_INPUT = $F7
PLAYER_2_INPUT = $F8

PLAYER_1_SNES_CURRENT_INPUT = $80
PLAYER_1_SNES_NEW_INPUT = $81


; UP_BUTTON       = $08
; DOWN_BUTTON     = $04
; LEFT_BUTTON     = $02
; RIGHT_BUTTON    = $01

; A_BUTTON        = $80
; B_BUTTON        = $40
; START_BUTTON    = $10
; SELECT_BUTTON   = $20

augment_input:

    ; origingal code
    LDX $FB
    INX
    STX JOYSER0 ; Ctrl1_4016
    DEX
    STX JOYSER0 ; Ctrl1_4016
    LDX #$08

:   LDA JOYSER0 ; Ctrl1_4016
    AND #$03
    CMP #$01
    ROL PLAYER_1_INPUT

    LDA JOYSER1 ; Ctrl2_FrameCtr_4017
    AND #$03
    CMP #$01
    ROL $F8

    DEX
    BNE :-

    ; we're also ready the next bit, which is the SNES "A" button
    ; A 
    lda JOYSER0
    AND #$01
    BEQ :+

    ; X - treat as down + Y
:   lda JOYSER0
    AND #$01    
    BEQ :+

    LDA PLAYER_1_INPUT
    ORA #$44
    STA PLAYER_1_INPUT

    ; L
:   lda JOYSER0
    AND #$01
    BEQ :+

    LDA PLAYER_1_SNES_CURRENT_INPUT
    BNE :++
    INC PLAYER_1_SNES_CURRENT_INPUT
    ; jsr increment_subweapon
    jsr heal
    BRA :++
:   STZ PLAYER_1_SNES_CURRENT_INPUT

:   lda JOYSER0
    AND #$01
    BEQ :+
    
:   RTL

heal:
    LDA #$FF
    STA $040D
    rts

increment_subweapon:
    LDA $BA
    INC 
    CMP #$03
    BNE :+
    STZ $BA
    RTS

:   STA $BA
    RTS

decrement_subweapon:
    DEC $BA
    BNE :+
    LDA #$02
    STA $BA
:   RTS