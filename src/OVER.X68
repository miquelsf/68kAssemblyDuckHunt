; -------------------------------------------------------------------------------------------
; GAME OVER SCREEN
; Handles the game over state, including updating (sound playback) and plotting 
; the game over screen text.
; -------------------------------------------------------------------------------------------

; -------------------------------------------------------------------------------------------
OVERINIT
; GAME OVER SCREEN INIT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Plays the "game over" sound effect.
; -------------------------------------------------------------------------------------------

        RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
OVERUPD
; GAME OVER SCREEN UPDATE
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Plays the "game over" sound effect.
; -------------------------------------------------------------------------------------------

        MOVE.B  #SNDLOSE, D7        ; Load the game over sound identifier into d7
        TRAP    #SNDPLTN            ; Trigger the sound playback system call

        RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
OVERPLOT
; GAME OVER SCREEN PLOT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Displays the "Game Over" screen, showing text such as "GAME OVER," 
;              "YOUR SCORE," and "HIGHEST SCORE" on specific rows.
; -------------------------------------------------------------------------------------------

        MOVEM.L D0-D1/A0-A1, -(A7)  ; Save d0, d1, and a0 registers on stack

        CLR.L   D1                  ; Clear d1 for clean use
        MOVE.B  #81, D0             ; Set code for clearing the screen in d0
        TRAP    #15                 ; Clear the screen using the system call
            
        LEA     .TXT1, A0           ; Load the address of "GAME OVER" text into a0
        MOVE.B  #5, D0              ; Set row position to 5 for the first line of text
        JSR     UTLPRINT            ; Call utlprint to display the text

        ; Print first line (Score)
        LEA     .TXT2, A1           ; Load the address of "YOUR SCORE:" text into a1
        MOVE.W  #$2014, D1          ; Set parameters for printing score text
        MOVE.B  #11, D0             ; Set row position for score display
        TRAP    #15                 ; Display the text
        CLR.L   D1                  ; Clear d1 to prepare for appending score value
        MOVE.W  (SCOPNT), D1        ; Load the current score into d1
        MOVE.B  #17, D0             ; Set code for printing text with score value
        TRAP    #15                 ; Print "YOUR SCORE: [value]"

        LEA     .TXT3, A1           ; Load the address of "HIGHEST SCORE:" text into a0
        MOVE.W  #$2016, D1          ; Set parameters for printing high score text
        MOVE.B  #11, D0             ; Set row position for high score display
        TRAP    #15                 ; Display the text
        CLR.L   D1                  ; Clear d1 to prepare for number conversion
        CLR.L   D0                  ; Clear d0 for a clean state
        CLR.L   D2                  ; Clear d2 for a clean state
        JSR     FILEREADER          ; Read high score from file
        LEA     BUFFER, A0          ; Load buffer address into a0
            
        JSR     CONVSTRING_TO_NUMBER ; Convert string to number
        MOVE.L  D2, D1              ; Store converted high score in d1
        MOVE.B  #17, D0             ; Set code for printing text with high score
        TRAP    #15                 ; Print "HIGHEST SCORE: [value]"
             
        ; Compare current score with high score and update if necessary
        MOVE.W  (SCOPNT), D1        ; Load current score into d1
        CMP.W   D1, D2              ; Compare current score with high score
        BHS     .DONE               ; If current score is less or equal, skip update
        MOVE    D1, D0             ; Move current score into d0 for conversion
        LEA     INVSCS, A0          ; Load address for inverted score string into a0
        LEA     BUFFER, A1          ; Load buffer address into a1
        JSR     CONVNUMBER_TO_STRING ; Convert current score to string
        JSR     FILEWRITER          ; Write new high score to file

.DONE   MOVEM.L (A7)+, D0-D1/A0-A1 ; Restore d0, d1, and a0 registers from stack

        RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
; TEXT STRINGS FOR GAME OVER SCREEN
; -------------------------------------------------------------------------------------------
.TXT1   DC.B    'GAME OVER', 0          ; "GAME OVER" string (null-terminated)
.TXT2   DC.B    'YOUR SCORE: ', 0       ; "YOUR SCORE:" string (null-terminated)
.TXT3   DC.B    'HIGHEST SCORE: ', 0    ; "HIGHEST SCORE:" string (null-terminated)
        DS.W    0                     ; Reserve space for additional text if needed
