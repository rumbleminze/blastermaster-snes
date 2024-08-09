reset_to_stored_screen_offsets:
  LDA STORED_OFFSETS_SET
  BEQ :+
  LDA UNPAUSE_BG1_HOFS_LB
  STA HOFS_LB
  LDA UNPAUSE_BG1_HOFS_HB
  STA HOFS_HB
  LDA UNPAUSE_BG1_VOFS_LB
  STA VOFS_LB
  LDA UNPAUSE_BG1_VOFS_HB
  ; STA VOFS_HB

  STZ STORED_OFFSETS_SET
: RTL

no_scroll_screen_enable:
  LDA HOFS_LB
  STA UNPAUSE_BG1_HOFS_LB
  LDA HOFS_HB
  STA UNPAUSE_BG1_HOFS_HB
  LDA VOFS_LB
  STA UNPAUSE_BG1_VOFS_LB
  LDA VOFS_HB
  STA UNPAUSE_BG1_VOFS_HB

  STZ HOFS_LB 
  STZ HOFS_HB 
  STZ VOFS_LB
  STZ VOFS_HB
  INC STORED_OFFSETS_SET
   
  lda PPU_CONTROL_STATE
  AND #$FC                 
  STA PPU_CONTROL_STATE
  RTL 
infidelitys_scroll_handling:

  LDA PPU_CONTROL_STATE
  PHA 
  AND #$80
  BNE :+
  LDA #$00
  BRA :++
: LDA #$80
: STA NMITIMEN
  PLA        
  PHA 
  AND #$04
  ; A now has the BG table address
  BNE :+
  LDA #$00
  BRA :++
: LDA #$01   
: STA VMAIN 
  PLA 
  AND #$03
  BEQ :+
  CMP #$01
  BEQ :++
  CMP #$02
  BEQ :+++
  CMP #$03
  BEQ :++++
: STZ HOFS_HB
  STZ VOFS_HB
  BRA :++++   ; RTL
: LDA #$01
  STA HOFS_HB
  STZ VOFS_HB
  BRA :+++    ; RTL
: STZ HOFS_HB
  LDA #$01
  ; STA VOFS_HB
  BRA :++     ; RTL
: LDA #$01
  STA HOFS_HB
  ; STA VOFS_HB
: RTL 


setup_hdma:
  LDX VOFS_LB
  LDA $A0A080,X
  STA $0900
  LDA $A0A170,X
  STA $0903
  LDA $A0A260,X
  STA $0905
  LDA $A0A350,X
  STA $0908
  LDA $A0A440,X
  STA $090A
  LDA $A0A520,X
  STA $090D

  LDA HOFS_LB
  STA $0901
  STA $0906
  STA $090B
  
  lda PPU_CONTROL_STATE
  STA $0902
  STA $0907
  STA $090C

  LDX PPU_CONTROL_STATE  
  LDA $A0A610,X
  STA $0904
  STA $0909
  STA $090E
  STZ $090F

  RTL

default_scrolling_hdma_values:
.byte $6F, $00, $92, $00, $C9, $58, $00, $92, $00, $C9, $27, $00, $00, $00, $01, $00

set_scrolling_hdma_defaults:

  LDA $3D
  AND #$04
  BEQ :+
  LDA $3E
  AND #$01
  BEQ :+
  jmp simple_scrolling

: PHY
  PHB
  LDA #$A0
  PHA
  PLB
  LDY #$00
: LDA default_scrolling_hdma_values, Y
  CPY #$0f
  BEQ :+
  STA SCROLL_HDMA_START, Y
  INY
  BRA :-

: PLB
  PLY
  RTL

  ; used where we just want to set the scroll to 0,0 and not worry about 
; attributes, because they'll naturally be offscreen
simple_scrolling:
  LDA #$08
  STA BG1VOFS
  LDA #$01
  STA BG1VOFS
  STZ BG1HOFS
  STZ BG1HOFS
  STZ SCROLL_HDMA_START
  STZ SCROLL_HDMA_START + 1
  STZ SCROLL_HDMA_START + 2
  RTL