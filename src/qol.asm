; QOL_SETTINGS = $081D
; HOVER_TICK   = $081F

QOL_HOVER        = 1 << 0 ; restore hover when idle
QOL_GUN_DECREASE = 1 << 1 ; decrease gun level slower
QOL_LIVES        = 1 << 2 ; unlimited lives
QOL_CONTINUES    = 1 << 3 ; unlimited continues

ITEMS_PICKED_UP = $99
ITEM_HOVER = 1 << 0
ITEM_DIVE  = 1 << 1
ITEM_WALL1 = 1 << 2
ITEM_WALL2 = 1 << 3
ITEM_CRSHR = 1 << 4
ITEM_NONE  = 1 << 5
ITEM_HYPER = 1 << 6
ITEM_KEY   = 1 << 7

JUMP_STATE = $040A
H_SPEED    = $0406

JS_WINDUP  = 1
JS_IN_AIR  = 2
JS_LANDING = 3


HOVER_LEVEL          = $92
HOVER_REFILL_RATE    = 80   ; how many frames to wait until we refill 32 hover (1 bar)

in_air:
    STZ HOVER_TICK

early_rts:
    PLA
    RTS

handle_hover_recharge:
    PHA
    LDA QOL_SETTINGS
    AND #QOL_HOVER
    BEQ early_rts
    
    ; check if we even have hover
    LDA ITEMS_PICKED_UP
    AND #ITEM_HOVER
    BEQ early_rts

    ; check if we're in air, on ground == 0
    LDA JUMP_STATE
    BNE in_air

    ; check if we're moving left/right
    LDA H_SPEED
    BNE early_rts

    ; we're stationary on ground, bump the tick
    INC HOVER_TICK
    LDA HOVER_TICK
    CMP #HOVER_REFILL_RATE
    BNE early_rts

    ; time for refill!
    STZ HOVER_TICK
    LDA HOVER_LEVEL
    CMP #$FF
    BEQ early_rts

    AND #%11100000
    CLC
    ADC #$20

    BCC :+
    ; carry set, set hover to FF
    LDA #$FF
:   STA HOVER_LEVEL
    PLA
    RTS

handle_limited_continues_new_game_l:
    LDA QOL_SETTINGS
    AND #QOL_CONTINUES
    BNE :+
    LDA #$05    ; game default, value of 5 gives 4 continues
    BRA :++
:   LDA #$00    ; setting to 0 gives us 256 continues
:   STA CONTINUES_AVAILABLE
    RTL

handle_limited_lives:
    LDA QOL_SETTINGS
    AND #QOL_LIVES
    BNE :+
    DEC LIVES    ; game default, decrement lives
:   RTL

; powers down the gun, but at 1/4 the speed
; the vanilla game decreases it every frame for
; 20 frames, we use a secondary counter
handle_gun_power_down_l:
    LDA GUN_GAUGE
    BEQ :++
    LDA QOL_SETTINGS
    AND #QOL_GUN_DECREASE
    BEQ :+
    INC QOL_GUN_DECREASE_TIMER
    LDA QOL_GUN_DECREASE_TIMER
    AND #$03
    BNE :++
:   DEC GUN_GAUGE
:   rtl

; quick swap window
; when we swap weapons, it'd be neat if the selected sub weapon appeared in a window
; to do this we'll have all 3 options on BG2, and we'll use H/V OFF to have the right 
; one be shown via a window.  maybe. 
