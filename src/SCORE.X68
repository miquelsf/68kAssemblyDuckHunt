; ==============================================================================
; SCOREBOARD MANAGEMENT
; Handles the initialization and rendering of the scoreboard, including score,
; bullets, and round information.
; ==============================================================================

; ------------------------------------------------------------------------------
SCOINIT
; INITIALIZE SCOREBOARD
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; DESCRIPTION: Resets the scoreboard values, including points, bullets, and 
;              rounds, to their default starting state.
; ------------------------------------------------------------------------------
            
            CLR.W   (SCOPNT)         ; Clear current score
            CLR.W   (SCOBUL)         ; Clear bullets count
            CLR.W   (SCORND)         ; Clear round count
            ADD.W   #BULLETN, SCOBUL ; Set initial number of bullets to BULLETN
            RTS                      ; Return from subroutine
            
; ------------------------------------------------------------------------------
SCOPLOT
; PLOT THE SCOREBOARD
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; DESCRIPTION: Displays the scoreboard on the screen, showing the player's 
;              current score, bullets remaining, and round number.
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1/A1,-(A7)   ; Save registers d0, d1, and a1 on stack

            ; Set background color
            MOVE.B  #81, D0          ; Load code for setting background color
            MOVE.L  #SCOFCOL, D1     ; Load background color constant
            TRAP    #15              ; Execute system call

            ; Set first line position
            MOVE.B  #11, D0          ; Load code for setting cursor position
            MOVE.W  #SCOLINE1, D1    ; Load y-coordinate for first line
            TRAP    #15              ; Execute system call

            ; Print first line (Score)
            LEA     .TXT1, A1        ; Load address of "SCORE:" text
            CLR.L   D1               ; Clear d1 for appending score value
            MOVE.W  (SCOPNT), D1     ; Load current score into d1
            MOVE.B  #17, D0          ; Load code for printing text
            TRAP    #15              ; Print "SCORE: [value]"

            ; Set second line position
            MOVE.B  #11, D0          ; Load code for setting cursor position
            MOVE.W  #SCOLINE2, D1    ; Load y-coordinate for second line
            TRAP    #15              ; Execute system call

            ; Print second line (Bullets)
            LEA     .TXT2, A1        ; Load address of "BULLETS:" text
            CLR.L   D1               ; Clear d1 for appending bullets value
            MOVE.W  (SCOBUL), D1     ; Load current bullets count into d1
            MOVE.B  #17, D0          ; Load code for printing text
            TRAP    #15              ; Print "BULLETS: [value]"

            ; Set third line position
            MOVE.B  #11, D0          ; Load code for setting cursor position
            MOVE.W  #SCOLINE3, D1    ; Load y-coordinate for third line
            TRAP    #15              ; Execute system call

            ; Print third line (Round)
            LEA     .TXT3, A1        ; Load address of "ROUND:" text
            CLR.L   D1               ; Clear d1 for appending round value
            MOVE.W  (SCORND), D1     ; Load current round number into d1
            MOVE.B  #17, D0          ; Load code for printing text
            TRAP    #15              ; Print "ROUND: [value]"
            
            MOVEM.L (A7)+, D0-D1/A1  ; Restore registers d0, d1, and a1 from stack
            
            RTS                      ; Return from subroutine

; ------------------------------------------------------------------------------
; TEXT STRINGS FOR SCOREBOARD
; These strings are null-terminated and represent the labels for the scoreboard.
; ------------------------------------------------------------------------------
.TXT1       DC.B    'SCORE:', 0          ; Label for "SCORE:"
.TXT2       DC.B    'BULLETS:', 0        ; Label for "BULLETS:"
.TXT3       DC.B    'ROUND:', 0          ; Label for "ROUND:"
            DS.W    0                    ; Reserve space for additional text if needed
