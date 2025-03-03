; -------------------------------------------------------------------------------------------
; INTRODUCTION SCREEN
; Manages the game's introductory screen, displaying the title and a prompt for
; the player to start the game by pressing the "Space Bar."
; -------------------------------------------------------------------------------------------

; -------------------------------------------------------------------------------------------
INTROINIT
; INTRODUCTION SCREEN INIT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Placeholder subroutine for initializing the introduction screen.
;              Currently, no initialization is required.
; -------------------------------------------------------------------------------------------

            RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
INTROUPD
; INTRODUCTION SCREEN UPDATE
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Checks for player input (pressing the "Space Bar"). If detected, 
;              transitions the state to the next stage of the game.
; -------------------------------------------------------------------------------------------

        BTST.B  #7, (KBDEDGE)         ; Test bit #7 in keyboard edge register
        BEQ     .CONT                 ; If space bar not pressed, continue without change
        MOVE.W  #1, (STANEXT)         ; If space bar pressed, set next state to 1

.CONT   
        RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
INTROPLOT
; INTRODUCTION SCREEN PLOT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Renders the introduction screen by displaying the game title and 
;              the prompt to press "Space Bar" to start.
; -------------------------------------------------------------------------------------------

        MOVEM.L D0-D1/A0, -(A7)       ; Save registers d0, d1, and a0 on stack

        CLR.L   D1                    ; Clear d1 for a clean state
        MOVE.B  #81, D0               ; Load code for setting background color
        TRAP    #15                   ; Execute system call

        ; Print the game title
        
        LEA     .TXT1, A0             ; Load address of game title into a0
        MOVE.B  #5, D0                ; Set row position for title
        JSR     UTLPRINT              ; Call uTLPRINT to render text

        BTST.B  #4, (SCRCYCCT)         ; Check display cycle bit
        BEQ     .DONE                 ; If bit equals 0, skip prompt

        ; Print the "Press Space Bar to Start" prompt
        
        LEA     .TXT2, A0             ; Load address of prompt text into a0
        MOVE.B  #20, D0               ; Set row position for prompt
        JSR     UTLPRINT              ; Call uTLPRINT to render text

.DONE   MOVEM.L (A7)+, D0-D1/A0      ; Restore registers d0, d1, and a0 from stack

        RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
; TEXT STRINGS FOR INTRODUCTION SCREEN
; These strings are null-terminated and represent the title and prompt text.
; -------------------------------------------------------------------------------------------
.TXT1   DC.B    'ASSEMBLY DUCK HUNT', 0          ; Title text for the introduction screen
.TXT2   DC.B    'Press SpaceBar To Start', 0     ; Prompt text to start the game
        DS.W    0                                ; Reserve space for additional text if needed
