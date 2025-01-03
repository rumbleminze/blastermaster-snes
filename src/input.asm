PLAYER_1_INPUT = $F7
PLAYER_2_INPUT = $F8

PLAYER_1_INPUT_SNES = $EE
PLAYER_1_INPUT_SNES_HELD = $EF


; UP_BUTTON       = $08
; DOWN_BUTTON     = $04
; LEFT_BUTTON     = $02
; RIGHT_BUTTON    = $01

; A_BUTTON        = $80
; B_BUTTON        = $40
; START_BUTTON    = $10
; SELECT_BUTTON   = $20

    ; X = 08
    ; A = 04
    ; L = 02
    ; R = 01
.define SNES_A_BUTTON #$08
.define SNES_X_BUTTON #$04
.define SNES_L_BUTTON #$02
.define SNES_R_BUTTON #$01

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

    STZ PLAYER_1_INPUT_SNES
    ; read other 4 SNES buttons    

    LDX #$04

:   LDA JOYSER0 ; Ctrl1_4016
    AND #$03
    CMP #$01
    ROL PLAYER_1_INPUT_SNES

    ; LDA JOYSER1 ; Ctrl2_FrameCtr_4017
    ; AND #$03
    ; CMP #$01
    ; ROL PLAYER_2_INPUT_SNES

    DEX
    BNE :-

    LDA PLAYER_1_INPUT_SNES
    PHA    
    LDA PLAYER_1_INPUT_SNES
    EOR PLAYER_1_INPUT_SNES_HELD
    AND PLAYER_1_INPUT_SNES
    STA PLAYER_1_INPUT_SNES
    PLA
    STA PLAYER_1_INPUT_SNES_HELD

    lda PLAYER_1_INPUT_SNES
    AND SNES_X_BUTTON
    Beq :+
    LDA PLAYER_1_INPUT
    ORA #(DOWN_BUTTON + B_BUTTON)
    STA PLAYER_1_INPUT
:   
    LDA PLAYER_1_INPUT_SNES_HELD
    AND SNES_R_BUTTON
    beq :+
    LDA PLAYER_1_INPUT
    ORA #(A_BUTTON)
    STA PLAYER_1_INPUT
:
    RTL

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