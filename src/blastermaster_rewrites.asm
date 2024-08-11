; a rewrite of the routine at E953
; which loads a full screen of tiles and attributes
; start at VM address $2000
; load the number of tiles (X).
;    if the number is >= #$80, then subtract #$80 and write the next X bytes as those values
;    if the number is < #$80 then write the next tile X times
; continue until you input a value of 0 for X
;
;  so the values of
;  20 01 85 10 20 30 40 50 00
; would write $01 20 times, then write 10, 20, 30, 40, 50, then be done.

; e93f - done
done_drawing:
  jslb enable_nmi_and_store, $a0
  RTL

; e6f0 - turn off sprites bgs
prep_ppu_mask:
  LDA $FE
  AND #$E1
  jslb set_ppu_mask_to_accumulator_and_store, $a0
  RTS

WRITE_COUNT = $B0
ATTR_CACHE_PTR = $B2
ATTR_CACHE = $1B00

load_full_screen_cutscene:
  LDY #$00
  LDA #$FF
  STA WRITE_COUNT
  STA WRITE_COUNT + 1
  STZ ATTR_CACHE_PTR
  LDA #$1B
  STA ATTR_CACHE_PTR + 1

  jslb disable_nmi_and_store, $a0
  JSR prep_ppu_mask
  jslb set_vram_increment_to_1_and_store, $a0
: JSR load_next_value
  BEQ :++
  BMI :+
  JSR handle_repeated_value
  JMP :- 
: JSR handle_nonrepeated_value
  JMP :--
: JMP done_drawing

handle_repeated_value:
  PHA
  JSR load_next_value
  PLA
: PHA
  LDA $00
  JSR write_to_vm
  PLA
  SEC
  SBC #$01
  BNE :-
  RTS

handle_nonrepeated_value:
: PHA  
  JSR load_next_value
  JSR write_to_vm
  PLA
  SEC
  SBC #$01
  AND #$7F
  BNE :-
  RTS

load_next_value:
  LDA ($7A),Y
  STA $00
  INY
  BNE :+
  INC $7B
: LDA $00
  RTS

write_to_vm:
  PHA
  CLC
  INC WRITE_COUNT
  BNE :+
  INC WRITE_COUNT + 1
: 
  LDA WRITE_COUNT + 1
  AND #$03
  CMP #$03
  BNE :+
  LDA WRITE_COUNT
  AND #$C0
  CMP #$C0
  BNE :+
  ; handle attributes
  PLA
  PHA
  STA (ATTR_CACHE_PTR)
  INC ATTR_CACHE_PTR
: PLA
  STA VMDATAL
  RTS

; this should be called after everything has been prepped / written
write_attributes_for_full_screen:
  PHB
  PHA
  PHY
  PHX

  
  jslb disable_nmi_no_store, $a0
  LDY #$1F
  LDA #$00
  STA ATTR_NES_VM_ATTR_START+1, Y
: LDA ATTR_CACHE, Y
  STA ATTR_NES_VM_ATTR_START, Y
  DEY
  BPL :-
  LDA #$23
  STA ATTR_NES_VM_ADDR_HB
  LDA #$C0
  STA ATTR_NES_VM_ADDR_LB
  LDA #$20
  STA ATTR_NES_VM_COUNT
  LDA #$01
  STA ATTR_NES_HAS_VALUES
  jslb convert_nes_attributes_and_immediately_dma_them_skinny, $a0

  LDY #$1F
  LDA #$00
  STA ATTR_NES_VM_ATTR_START+1, Y
: LDA ATTR_CACHE+32, Y
  STA ATTR_NES_VM_ATTR_START, Y
  DEY
  BPL :-

  LDA #$23
  STA ATTR_NES_VM_ADDR_HB
  LDA #$E0
  STA ATTR_NES_VM_ADDR_LB
  LDA #$20
  STA ATTR_NES_VM_COUNT
  LDA #$01
  STA ATTR_NES_HAS_VALUES

  jslb convert_nes_attributes_and_immediately_dma_them_skinny, $a0

; first half of 2nd bg
  LDY #$1F
  LDA #$00
  STA ATTR_NES_VM_ATTR_START+1, Y
: LDA ATTR_CACHE+32+32, Y
  STA ATTR_NES_VM_ATTR_START, Y
  DEY
  BPL :-

  LDA #$27
  STA ATTR_NES_VM_ADDR_HB
  LDA #$C0
  STA ATTR_NES_VM_ADDR_LB
  LDA #$20
  STA ATTR_NES_VM_COUNT
  LDA #$01
  STA ATTR_NES_HAS_VALUES

  jslb convert_nes_attributes_and_immediately_dma_them_skinny, $a0

; second half of 2nd bg
  LDY #$1F
  LDA #$00
  STA ATTR_NES_VM_ATTR_START+1, Y
: LDA ATTR_CACHE+32+32+32, Y
  STA ATTR_NES_VM_ATTR_START, Y
  DEY
  BPL :-

  LDA #$27
  STA ATTR_NES_VM_ADDR_HB
  LDA #$E0
  STA ATTR_NES_VM_ADDR_LB
  LDA #$20
  STA ATTR_NES_VM_COUNT
  LDA #$01
  STA ATTR_NES_HAS_VALUES

  jslb convert_nes_attributes_and_immediately_dma_them_skinny, $a0

  jslb reset_nmi_status, $a0

  PLX
  PLY
  PLA
  PLB
  
  RTL

  ; tile writing / level loading
  ; format:
  ; VML, VMH, COUNT - Vynn nnnn 
  ;                     V = vertical write
  ;                     y = 0 count values, 1 = repeated
  ;                     nn nnnn = count
  handle_tile_attribute_write:
    INX
    INX
    LDA $0300, X
    PHA
    INX

    AND #$40
    bne column_attributes
    PLA
    AND #$3F
    STA ATTR_NES_VM_COUNT

    LDY #$00
:   LDA $0300, X
    STA ATTR_NES_VM_ATTR_START, Y
    INX
    INY
    CPY ATTR_NES_VM_COUNT
    BNE :-

    LDA $1B 
    STA ATTR_NES_VM_ADDR_HB

    LDA $1A
    STA ATTR_NES_VM_ADDR_LB

    LDA #$01
    STA ATTR_NES_HAS_VALUES

    LDA #$00
    STA ATTR_NES_VM_ATTR_START, Y

    jslb convert_nes_attributes_and_immediately_dma_them, $a0

    rtl

column_attributes:
    PLA
    AND #$3F
    STA COL_ATTR_VM_COUNT
    LDA $1B 
    STA COL_ATTR_VM_HB
    LDA $1A
    STA COL_ATTR_VM_LB

    LDY #$00
:   LDA $0300, X
    STA COL_ATTR_VM_START, Y
    INY
    INX
    CPY COL_ATTR_VM_COUNT
    BCC :-
    LDA #$00
    STA COL_ATTR_VM_START, Y
    STZ COL_ATTR_HAS_VALUES
    INC COL_ATTR_HAS_VALUES
    PHA
    PHX
    PHY
    jsr convert_column_of_tiles
    jsr dma_column_attributes
    PLY
    PLX
    PLA
    rtl