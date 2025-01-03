; values we care about
; Which area the player is in, AND #$07 for areas 1 - 8
; the higher bits are for ???
LEVEL               = $0014 
ABILITY_ENABLED     = $0099
LIVES               = $00DD
GUN_GAUGE           = $00C3
hover               = $0092
CONTINUES_AVAILABLE = $037E ; might get rid of continue limit all together, why would you want it?
BOSSES_DEAD         = $03FB
ITEM_PICKUP         = $03FC
GATES_OPENED        = $03FE
HOMING_MISSILES     = $06F0
LIGHTNING           = $06F1
THREE_WAY_MISSILES  = $06F2



save_game_read_locations:
.byte <(LEVEL)              , >(LEVEL)
.byte <(ABILITY_ENABLED)    , >(ABILITY_ENABLED)   
.byte <(CONTINUES_AVAILABLE), >(CONTINUES_AVAILABLE)
.byte <(BOSSES_DEAD)        , >(BOSSES_DEAD)       
.byte <(ITEM_PICKUP)        , >(ITEM_PICKUP)   
.byte <(GATES_OPENED)       , >(GATES_OPENED)    
.byte <(HOMING_MISSILES)    , >(HOMING_MISSILES)   
.byte <(LIGHTNING)          , >(LIGHTNING)         
.byte <(THREE_WAY_MISSILES) , >(THREE_WAY_MISSILES)
.byte <(QOL_SETTINGS)        , >(QOL_SETTINGS)
.byte <(PALETTE_OPTION)     , >(PALETTE_OPTION)
; lives?
; hover?
; gun?
save_game_read_locations_end:

.define SAVE_GAME_WRITE     $6000
SAVE_ITEMS = ((save_game_read_locations_end - save_game_read_locations) / 2)
CHECK_BYTE = SAVE_GAME_WRITE + SAVE_ITEMS

update_item_pickup_and_save:
    ORA $99
    STA $99
    jmp persist_save_data

update_boss_kill_and_save:
    ORA $03FB
    STA $03FB
    jmp persist_save_data

update_area_info_and_save:
    LDA ($00),Y
    STA $14
    jmp persist_save_data

persist_save_data:
    PHA
    PHX
    PHY
    PHB

    LDA $00
    PHA
    LDA $01
    PHA

    PHK
    PLB

    LDY #$00
    LDX #$00
    STZ CHECK_BYTE
:

    LDA save_game_read_locations, Y
    STA $00
    INY
    LDA save_game_read_locations, Y
    STA $01
    INY

    LDA ($00)
    STA SAVE_GAME_WRITE, X
    CLC
    ADC CHECK_BYTE
    STA CHECK_BYTE
    INX

    CPX #SAVE_ITEMS

    BNE :-

    PLA
    STA $01

    PLA
    STA $00

    PLB
    PLY
    PLX
    PLA

    RTL

load_save_data:
    PHA
    PHX
    PHY
    PHB

    LDA $00
    PHA
    LDA $01
    PHA

    PHK
    PLB

    LDX #$00
    LDY #$00
:   
    LDA save_game_read_locations, Y
    STA $00
    INY

    LDA save_game_read_locations, Y
    STA $01
    INY

    LDA SAVE_GAME_WRITE, X
    STA ($00)
    INX
    CPX #SAVE_ITEMS
    BNE :-

    PLA
    STA $01

    PLA
    STA $00

    PLB
    PLY
    PLX
    PLA

    RTL

check_save_data_long:
    jsr check_valid_save_data
    rtl

check_valid_save_data:
    LDA $00
    PHA

    STZ $00
    LDY #$00

:   LDA SAVE_GAME_WRITE, Y
    CLC
    ADC $00
    STA $00
    INY
    CPY #SAVE_ITEMS
    BNE :-

    LDA $00
    CMP CHECK_BYTE
    BEQ :+
    jsr wipe_save_data
:   PLA
    STA $00
    RTS

wipe_save_data:
    PHY
    LDA #$00
    TAY

:   STA SAVE_GAME_WRITE, Y
    INY
    CPY #SAVE_ITEMS
    BNE :-
    STZ CHECK_BYTE

    PLY
    RTS

start_new_game_or_load_save:
    LDA SAVE_ENABLED
    BNE :+
        LDA #$08
        STA $14
        rtl
:   jslb load_save_data, $a0
    STZ $01
    PLA
    PLA
    PLA

    LDA #$C5
    PHA
    LDA #$42
    PHA
    LDA #$A7
    PHA
    LDA #$F7
    PHA
    LDA #$6D
    PHA
    rtl
