.segment "PRGB2"

; Audio Tracks for Blaster Master
; Setting $377 to these values will play the sound/music
; 01 - Area Load
; 02 - Area 3
; 04 - Area 2
; 05 - Area 6
; 06 - Area 1
; 07 - Area 5
; 08 - Boss Intro
; 09 - Boss Fight
; 13 - Area 4
; 17 - Ending
; 2a - Boss Fight 2
; 2b - Area 8
; 37 - Area 7
; 3d - game over
; 54 - Intro 

; not used
; 31 - item pickup
; 3a - item pickup
; 4a - Vehicle Expload
; 51 - player dead
; 0b ? boss dead
.DEFINE NUM_TRACKS        17

; Read Flags
.DEFINE MSU_STATUS      $2000
.DEFINE MSU_READ        $2001
.DEFINE MSU_ID          $2002   ; 2002 - 2007

; Write flags
.DEFINE MSU_SEEK        $2000
.DEFINE MSU_TRACK       $2004   ; 2004 - 2005
.DEFINE MSU_VOLUME      $2006
.DEFINE MSU_CONTROL     $2007

; game specific flags, needs to be updated
.DEFINE NSF_STOP        #$00
.DEFINE NSF_PAUSE       #$F3
.DEFINE NSF_RESUME      #$F4
.DEFINE NSF_MUTE        #$00


play_track_hijack:
    TAX 
    LDA $0370,x
    bne :+
    rtl
:
    PHA
    jsl msu_check
    CMP NSF_MUTE
    BEQ :+

    PLA
    rtl

:   PLA
    jsr mute_nsf_routine
    LDA NSF_MUTE
    rtl


mute_nsf_routine:
  LDA #$00
  STA $E0
  LDX #$B4
: DEX
  STA $0700,X
  BNE :-
  rts


wait_a_frame:
  LDA RDNMI
: LDA RDNMI
  BPL :-
  rts


check_for_all_tracks_present:
  PHB
  LDA #$B2
  PHA
  PLB
  LDA MSU_ID		; load first byte of msu-1 identification string
  CMP #$53		    ; is it "M" present from "MSU-1" string?
  BEQ :+
  PLB
  RTL ; no MSU exit early

: STZ MSU_VOLUME
  LDY #NUM_TRACKS
  INY
: 
  jsr wait_a_frame
  STZ MSU_CONTROL

  DEY
  BMI :+
  
  LDA #$00
  STA TRACKS_AVAILABLE, Y
  STA TRACKS_ENABLED, Y

  TYA
  STA MSU_TRACK
  STZ MSU_TRACK + 1 

  msu_status_check:
    LDA MSU_STATUS
    AND #$40
    BNE msu_status_check
  ; LDA #$FF
  ; :		; check msu ready status (required for sd2snes hardware compatibility)
  ;   bit MSU_STATUS
  ;   bvs :-

  LDA MSU_STATUS ; load track STAtus
  AND #$08		; isolate PCM track present byte
        		; is PCM track present after attempting to play using STA $2004?
  
  BNE :-
  LDA #$01
  STA TRACKS_AVAILABLE, Y  
  STA TRACKS_ENABLED, Y
  BRA :-
: 
  LDA #$01
  STA MSU_SELECTED
  PLB
  RTL

mute_nsf:
  LDA MSU_ENABLE		; retrieve NSF mute flag
  CMP #$FF		; is it set? then mute NSF music
  BNE no_nsf_mute
  LDA NSF_MUTE
;   LDA #$00
;   LDX #$00
; : STA $032B, X
;   INX
;   CPX #$0D
;   BNE :-

  RTL
no_nsf_mute:
  RTL

;org $E2F5F5
; stop_nsf:
;   LDX #$00		; native code
;   LDY #$00		; native code
;   PHA
;   LDA CURRENT_NSF		; load currently playing msu-1 track
;   CMP #$5B		; is it the Title Screen?
;   BNE skip_mute
;   STZ MSU_CONTROL		; mute msu-1 (from title screen)
; skip_mute:
;   PLA
;   RTL

; Checks for MSU track for audio track in Accumulator
msu_check:
  PHB
  PHK
  PLB
  PHY
  PHX
  PHA  

  LDA MSU_SELECTED
  BEQ fall_through


  LDA MSU_ID		; load first byte of msu-1 identification string
  CMP #$53		    ; is it "M" present from "MSU-1" string?
  BNE fall_through  ; No MSU-1 support, fall back to NSF
  
  ; check if we have a track for this value

  PLA
  STA CURRENT_NSF		; store current nsf track-id for later retrieval
  PHA
      ; CMP NSF_STOP
      ; BEQ stop_msu

      ; CMP NSF_PAUSE
      ; BEQ pause_msu

      ; CMP NSF_RESUME
      ; BEQ resume_msu
  TAY
  LDA msu_track_lookup, Y
  CMP #$FF
  BEQ fall_through

  TAY
  LDA TRACKS_ENABLED, Y
  BEQ fall_back_to_nsf
  TYA

  ; non-FF value means we have an MSU track
  BRA msu_available

fall_back_to_nsf:
  bra stop_msu

stop_msu:
; is msu playing?  if not, just exit
    LDA MSU_ENABLE
    BEQ fall_through
    STZ MSU_CONTROL
    STZ MSU_CURR_CTRL
    BRA fall_through

pause_msu:
    LDA MSU_ENABLE
    BEQ fall_through
    STZ MSU_CONTROL
    STZ MSU_CURR_CTRL
    BRA fall_through

resume_msu:
    LDA MSU_ENABLE
    BEQ fall_through
    LDA MSU_TRACK_IDX
    TAY
    LDA msu_track_loops, Y
    STA MSU_CONTROL
    STA MSU_CURR_CTRL

  ; fall through to default
fall_through:
  PLA
  PLX
  PLY
  PLB
  RTL

pause_msu_only:
  PHB
  PHK
  PLB
  PHY
  PHX
  PHA  

  LDA MSU_SELECTED
  BEQ fall_through


  LDA MSU_ID		; load first byte of msu-1 identification string
  CMP #$53		    ; is it "M" present from "MSU-1" string?
  BNE fall_through  ; No MSU-1 support, fall back to NSF
  BRA pause_msu


resume_msu_only:
  PHB
  PHK
  PLB
  PHY
  PHX
  PHA  

  LDA MSU_SELECTED
  BEQ fall_through

  LDA MSU_ID		; load first byte of msu-1 identification string
  CMP #$53		    ; is it "M" present from "MSU-1" string?
  BNE fall_through  ; No MSU-1 support, fall back to NSF
  BRA resume_msu

stop_msu_only:
  PHB
  PHK
  PLB
  PHY
  PHX
  PHA  

  LDA MSU_SELECTED
  BEQ fall_through

  LDA MSU_ID		; load first byte of msu-1 identification string
  CMP #$53		    ; is it "M" present from "MSU-1" string?
  BNE fall_through  ; No MSU-1 support, fall back to NSF
  BRA stop_msu

  ; if msu is present, process msu routine
msu_available:
  TAY
  PLA
  PHY                   ; push the MSU-1 track 
  PHA                   ; repush the NSF track

  LDA #$00		        ; clear disable/enable nsf music flag
  STA MSU_ENABLE		; clear disable/enable nsf music flag

  PLA
  STA CURRENT_NSF		; store current nsf track-id for later retrieval

  LDA #$01
  STA MSU_TRIGGER
  LDA #$FF		       
  STA MSU_ENABLE		; set mute NSF flag (writing FF in RAM location)

  pla
  STA MSU_TRACK_IDX		; store current re-mapped nsf track-id for later retrieval
  STA MSU_TRACK		    ; store current valid NSF track-ID
  stz MSU_TRACK + 1	    ; must zero out high byte or current msu-1 track will not play !!!

  ; jsl msu_nmi_check

  PLX
  PLY
  PLB
  LDA NSF_MUTE ; set nsf music to mute since we are playing msu  

  RTL


: 
  LDA MSU_CURR_VOLUME
  STA MSU_VOLUME
  RTL

msu_nmi_check:
  jsr decrement_timer_if_needed
  LDA MSU_TRIGGER
  BEQ :-
  LDA MSU_STATUS
  AND #$40
  BNE :-
  LDA MSU_STATUS

  PHB
  PHK
  PLB
  STZ MSU_TRIGGER

  LDA MSU_TRACK_IDX ; pull the current MSU-1 Track
  TAY
  LDA msu_track_loops, Y
  STA MSU_CONTROL		; write current loop value
  STA MSU_CURR_CTRL
  LDA msu_track_volume, Y
  STA MSU_VOLUME		; write max volume value
  STA MSU_CURR_VOLUME

  jsr set_timer_if_needed

  PLB
  RTL


set_timer_if_needed:  
  PHB
  PHK
  PLB
  LDA $00
  PHA
  LDA $01
  PHA

  LDA MSU_TRACK_IDX
  ASL a
  TAY

  LDA track_timers, Y
  STA $00
  INY 
  LDA track_timers, y
  STA $01
  
  LDY #$01
  ; the high bit of the timer is always != 0
  LDA ($00),Y
  BEQ :+

    STA MSU_TIMER_HB
    DEY
    LDA ($00),Y
    STA MSU_TIMER_LB
    STZ MSU_TIMER_INDX
    INC MSU_TIMER_ON
    
  :

  PLA
  STA $01
  PLA
  STA $00
  PLB
  rts

check_if_msu_is_available:
  STZ MSU_AVAILABLE
  LDA MSU_ID
  CMP #$53
  BNE :+
    LDA #$01
    STA MSU_AVAILABLE
  : 
  rtl

decrement_timer_if_needed:
  LDA MSU_TIMER_ON
  BEQ :++

  setAXY16
  DEC MSU_TIMER_LB
  setAXY8

  BNE :++

  PHB
  PHK
  PLB

  LDA $00
  PHA
  LDA $01
  PHA

  STZ MSU_TIMER_ON
  LDA #$01
  STA $E0
  INC MSU_TIMER_INDX

  LDA MSU_TRACK_IDX
  ASL
  TAY
  LDA track_timers, Y
  STA $00
  INY 
  LDA track_timers, y
  STA $01

  LDA MSU_TIMER_INDX
  ASL
  INC A
  TAY
  LDA ($00),Y
  beq :+

    STA MSU_TIMER_HB
    DEY
    LDA ($00),Y
    STA MSU_TIMER_LB
    INC MSU_TIMER_ON
  :
  
  PLA
  STA $01
  PLA
  STA $00
  PLB
: 
  rts
; this 0x100 byte lookup table maps the NSF track to the MSU-1 track
; 54 - Intro          - 01
; 06 - Area 1         - 02
; 04 - Area 2         - 03
; 02 - Area 3         - 04
; 13 - Area 4         - 05
; 07 - Area 5         - 06
; 05 - Area 6         - 07
; 37 - Area 7         - 08
; 2b - Area 8         - 09
; 09 - Boss Fight     - 0A
; 2a - Boss Fight 2   - 0B
; 3a - Area Clear     - 0C ?
; 17 - Ending         - 0D
; 3d - game over      - 0E

; unused but marked as supported so it shuts off MSU when played
; 01 - level load
; 08 - Boss intro DUNN DUNN DUNNN
; 2d?
; 4a - tank dead
; 51 - player dead
; 0B - boss dead

msu_track_lookup:
.byte $FF, $10, $04, $FF, $03, $07, $02, $06, $0F, $0A, $FF, $13, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $05, $FF, $FF, $FF, $0D, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $0B, $09, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $08, $FF, $FF, $0C, $FF, $ff, $0E, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $11, $FF, $FF, $FF, $FF, $FF
.byte $FF, $12, $FF, $FF, $01, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; this 0x100 byte lookup table maps the NSF track to the if it loops ($03) or no ($01)
msu_track_loops:
.byte $00, $01, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $01, $01, $01, $01
.byte $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; this 0x100 byte lookup table maps the NSF track to the MSU-1 volume ($FF is max, $4F is half)
msu_track_volume:
.byte $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50
.byte $50, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F

msu_track_e0_delay_options:
.word $0100, $068B, $0f4a

track_timers:
.addr no_timer  ; 00 not used
.addr no_timer  ; 54 - Intro          - 01
.addr area1_timer  ; 06 - Area 1         - 02
.addr no_timer  ; 04 - Area 2         - 03
.addr no_timer  ; 02 - Area 3         - 04
.addr no_timer  ; 13 - Area 4         - 05
.addr no_timer  ; 07 - Area 5         - 06
.addr no_timer  ; 05 - Area 6         - 07
.addr no_timer  ; 37 - Area 7         - 08
.addr no_timer  ; 2b - Area 8         - 09
.addr no_timer  ; 09 - Boss Fight     - 0A
.addr no_timer  ; 2a - Boss Fight 2   - 0B
.addr area_clear_timer  ; 3a - Area Clear     - 0C ?
.addr ending_timer  ; 17 - Ending         - 0D
.addr no_timer  ; 3d - game over      - 0E

no_timer:
.word $0000                 ; track 0 - No Track
area1_timer:
.word $0100, $0100, $0000   ; Area 1         - 02 - technically should be DB
area_clear_timer:
.word $0100, $0000          ; Area Clear     - 0C
ending_timer:
.word $068b, $0f4a, $0000   ; Ending         - 0D
