; ==============================================================================
; GAME STATE MANAGEMENT
; ==============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITIALIZES THE STATE MANAGER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)       ; Set current state to STANONE
            CLR.W   (STANEXT)              ; Clear next state
            RTS                         ; Return from subroutine

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INITIALIZATION IF NECESSARY
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)            ; Save registers d0 and a0 to stack

            CLR.L   D0                     ; Clear d0
            MOVE.W  (STANEXT),D0           ; Load next state into d0
            CMP.W   (STACUR),D0            ; Compare current state with next state
            BEQ     .DOUPD                 ; If equal, skip initialization

            MOVE.W  D0,(STACUR)            ; Update current state to next state
            LSL.L   #2,D0                  ; Multiply state value by 4 (word offset for lookup)
            MOVE.L  D0,A0                  ; Load address offset into a0
            MOVE.L  .INITBL(A0),A0         ; Get corresponding init routine from INITBL

            JSR     (A0)                   ; Jump to the initialization routine

.DOUPD      CLR.L   D0                     ; Clear d0
            MOVE.W  (STACUR),D0            ; Load current state into d0
            LSL.L   #2,D0                  ; Multiply state value by 4 (word offset for lookup)
            MOVE.L  D0,A0                  ; Load address offset into a0
            MOVE.L  .UPDTBL(A0),A0         ; Get corresponding update routine from UPDTBL

            JSR     (A0)                   ; Jump to the update routine

            MOVEM.L (A7)+,D0/A0            ; Restore registers d0 and a0 from stack

            RTS                         ; Return from subroutine

.INITBL     DC.L    INTROINIT,INSINIT,GAMINIT,OVERINIT ; State initialization routines
.UPDTBL     DC.L    INTROUPD,INSUPD,GAMUPD,OVERUPD     ; State update routines

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)            ; Save registers d0 and a0 to stack

            CLR.L   D0                     ; Clear d0
            MOVE.W  (STACUR),D0            ; Load current state into d0
            LSL.L   #2,D0                  ; Multiply state value by 4 (word offset for lookup)
            MOVE.L  D0,A0                  ; Load address offset into a0
            MOVE.L  .PLTTBL(A0),A0         ; Get corresponding plot routine from PLTTBL

            JSR     (A0)                   ; Jump to the plot routine

            MOVEM.L (A7)+,D0/A0            ; Restore registers d0 and a0 from stack

            RTS                         ; Return from subroutine

.PLTTBL     DC.L    INTROPLOT,INSPLOT,GAMPLOT,OVERPLOT ; State plot routines

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; NOTE     : JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS                         ; Return from subroutine

; -----------------------------------------------------------------------------
GAMINIT
; INITIALIZES THE GAMEPLAY STATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
            JSR     DCKINIT                ; Initialize duck logic
            JSR     SCOINIT                ; Initialize score system
            JSR     RNDINIT                ; Initialize random number generator
            JSR     SNDINIT                ; Initialize sound system  
            RTS                         ; Return from subroutine

; -----------------------------------------------------------------------------
GAMUPD
; UPDATES THE GAMEPLAY STATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
            JSR     DCKUPD                 ; Update duck logic
            JSR     CURSORUPD              ; Update cursor logic
            RTS                         ; Return from subroutine

; -----------------------------------------------------------------------------
GAMPLOT
; RENDERS THE GAMEPLAY STATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
            JSR     BCKPLOT                ; Plot background
            JSR     SCOPLOT                ; Plot score
            JSR     DCKPLOT                ; Plot duck
            JSR     CURSORPLOT             ; Plot cursor
            RTS                         ; Return from subroutine
