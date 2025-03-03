; ==============================================================================
; ROUND MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
ROUINIT
; INITIALIZE SYSTEM.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            ADDQ.W  #1,(DCKVLI)        ; Increment duck velocity index by 1
            MOVE.W  #BULLETN, SCOBUL    ; Set the initial number of bullets to BULLETN
            MOVE.W  #1,(DCKDIR)         ; Set the initial direction to 1
            ADDQ.W  #1,SCORND          ; Increment the round counter by 1

            JSR     DCKRSPW           ; Initialize duck sprite and position

            RTS                       ; Return from subroutine
