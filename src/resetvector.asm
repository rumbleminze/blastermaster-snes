start:
SEI
CLC
XCE

setXY16
LDX #$01FF
TXS
LDA #$A0
PHA
PLB
JSL $A08000

; this needs to be the NES game's reset vector
JML $A1FFF4
nmi:
    PHP
    PHA
    PHX
    PHY
    
    ; jslb setup_hdma, $a0
    jslb snes_nmi, $a0
    
    ; jump to NES NMI
    CLC
    LDA ACTIVE_NES_BANK
    INC
    ADC #$A0
    STA RESET_VECTOR_BS_DB    
    PHA
    PLB

    ; This assume the NES NMI is at $EB7E
    LDA #$EB
    STA RESET_VECTOR_BS_HB
    LDA #$7E
    STA RESET_VECTOR_BS_LB
    JML [RESET_VECTOR_BS_LB]

return_from_nes_nmi:
    ; jslb setup_hdma, $a0
    ; handle sprite traslation last, since if that bleeds out of vblank it's ok    
    jslb msu_nmi_check, $b2
    jslb translate_blaster_master_sprites, $a0
    PLY
    PLX
    PLA
    PLP
    RTI

; this is used by the MSU video player, ignore it if you don't use it.
_rti:
    JML $C7FF14 
    LDA $01B0
    BEQ :+
    LDA $E6
    BEQ :+
    JSR $D000
:   LDA #$A1
    PHA
    PLB
    BRA start

    rti