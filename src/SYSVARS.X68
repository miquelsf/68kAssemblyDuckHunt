; ==============================================================================
; SYSTEM VARIABLES
; ==============================================================================

; --- KEYBOARD RELATED VARIABLES -----------------------------------------------

KBDVAL      DS.B    1                       ; Key State
KBDEDGE     DS.B    1                       ; Key Edge

; --- TIMER INTERRUPT RELATED VARIABLES ----------------------------------------

SCRINTCT    DS.B    1                       ; Interrupt counter
SCRCYCCT    DS.B    1                       ; Cycle counter
            DS.W    0