; =============================================================================
; TITLE    : PSEUDO-RANDOM NUMBER GENERATOR
; AUTHOR   : ANTONI BURGUERA (modified by ASSEMBLY DUCK HUNT authors)
; COMMENTS : Very lazy and inefficient "algorithm" implemented.
; HISTORY  : XX-XXX-201X - Creation
;            11-Oct-2020 - Minor changes
;            XX-Dec-2024 - Minor comment changes for compatibility with Assembly Duck Hunt
; =============================================================================

; -----------------------------------------------------------------------------
RNDINIT
; INITIALIZES RANDOM NUMBER GENERATOR
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
            CLR.B   (RNDINDEX)          ; Set rndindex to 0
            RTS                         ; Return from subroutine

; -----------------------------------------------------------------------------
RNDGET
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    : NONE
; OUTPUT   : D0.L random value (only byte)
; MODIFIES : NONE (aside from output)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)            ; Save register a0 on stack
            LEA     .RANDVEC,A0         ; Load address of random vector into a0
            CLR.L   D0                  ; Clear d0 to ensure clean value
            MOVE.B  (RNDINDEX),D0       ; Load current rndindex into d0
            MOVE.B  (A0,D0.L),D0        ; Fetch value from random vector using index
            
.CONTINUE
            ADDQ.B  #1,(RNDINDEX)       ; Increment rndindex for next call
            MOVE.L  (A7)+,A0            ; Restore register a0 from stack
            RTS                         ; Return from subroutine

.RANDVEC    DC.B    2, 6, 0, 0, 3, 0, 0, 2  ; Random vector data
            DC.B    3, 5, 1, 4, 5, 4, 2, 5
            DC.B    3, 4, 6, 6, 2, 0, 1, 3
            DC.B    3, 0, 2, 4, 3, 6, 1, 6
            DC.B    2, 6, 5, 3, 6, 0, 5, 0
            DC.B    2, 5, 4, 2, 1, 6, 5, 6
            DC.B    3, 5, 2, 6, 5, 0, 6, 1
            DC.B    1, 1, 0, 4, 0, 6, 3, 4
            DC.B    1, 5, 3, 1, 6, 2, 4, 1
            DC.B    5, 6, 1, 2, 6, 4, 4, 2
            DC.B    0, 5, 2, 0, 6, 1, 5, 4
            DC.B    4, 1, 2, 3, 1, 0, 6, 6
            DC.B    4, 0, 5, 6, 4, 0, 4, 3
            DC.B    1, 5, 4, 5, 5, 3, 1, 5
            DC.B    6, 6, 2, 0, 2, 4, 4, 1
            DC.B    0, 4, 2, 3, 1, 5, 4, 5
            DC.B    6, 3, 2, 5, 6, 5, 0, 1
            DC.B    4, 2, 5, 3, 5, 6, 1, 1
            DC.B    5, 1, 6, 5, 0, 5, 6, 5
            DC.B    3, 4, 2, 5, 6, 0, 3, 3
            DC.B    6, 4, 6, 6, 4, 0, 4, 1
            DC.B    6, 3, 1, 4, 0, 6, 4, 4
            DC.B    3, 6, 4, 3, 4, 6, 1, 3
            DC.B    3, 3, 3, 1, 3, 2, 2, 2
            DC.B    1, 2, 1, 5, 2, 1, 4, 2
            DC.B    0, 2, 2, 1, 0, 4, 2, 6
            DC.B    3, 6, 0, 1, 1, 3, 1, 2
            DC.B    3, 5, 6, 5, 3, 4, 0, 4
            DC.B    1, 5, 5, 6, 2, 1, 6, 0
            DC.B    0, 3, 3, 5, 0, 5, 6, 6
            DC.B    6, 1, 2, 2, 4, 6, 6, 6
            DC.B    6, 5, 4, 1, 2, 5, 6, 4
