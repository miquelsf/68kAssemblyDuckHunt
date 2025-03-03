; -------------------------------------------------------------------------------------------
; INSTRUCTIONS SCREEN
; Handles the instructions screen, providing gameplay details to the player. Displays
; the goal, controls, and motivation for playing the game.
; -------------------------------------------------------------------------------------------

; -------------------------------------------------------------------------------------------
INSINIT
; INSTRUCTIONS SCREEN INIT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Placeholder subroutine for initializing the instructions screen.
;              Currently, no initialization is required.
; -------------------------------------------------------------------------------------------

            RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
INSUPD
; INSTRUCTIONS SCREEN UPDATE
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Checks for player input (pressing the "Space Bar"). If detected,
;              transitions the state to the next stage of the game.
; -------------------------------------------------------------------------------------------

        BTST.B  #7,(KBDEDGE)           ; Check if space bar is pressed
        BEQ     .CONT                  ; If not pressed, continue checking
        MOVE.W  #2,(STANEXT)           ; Set next state to 2

.CONT   
        RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
INSPLOT
; INSTRUCTIONS SCREEN PLOT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; DESCRIPTION: Renders the instructions screen by sequentially displaying the lines
;              of instructional text stored in `.TXTLST`.
; -------------------------------------------------------------------------------------------

        MOVEM.L D0-D4/A0-A1, -(A7)    ; Save registers d0-d4 and a0-a1 on stack

        ; Set contour color
            MOVE.B  #80,D0           ; Set code for pen color
            MOVE.L  #$00FFFFFF,D1     ; Load white color constant into d1
            TRAP    #15               ; Set pen color
            
            ; Define rectangle coordinates
            MOVE.W  #BCKPOSX-BCKWIDTH/3,D1 ; Calculate left coordinate for rectangle
            MOVE.W  #BCKPOSX+BCKWIDTH/3,D3 ; Calculate right coordinate for rectangle
            
            MOVE.W  #82,D2           ; Set rectangle highest point (y coordinate)
            MOVE.W  #BCKHEIGH,D4     ; Set rectangle lowest point (y coordinate)
            SUB.W  D2,D4             ; Compute height of rectangle   
            
            ; Draw rectangle
            MOVE.B  #87,D0           ; Set code for drawing rectangle
            TRAP    #15               ; Draw rectangle

        MOVE.B  #8, D0               ; Initialize row position for printing text
        LEA     .TXTLST, A1         ; Load address of text list into a1

.LOOP   MOVE.L  (A1)+, D1           ; Load address of the next string into d1
        BEQ     .FINISHED           ; If null, exit loop
        MOVE.L  D1, A0              ; Set string address into a0
        JSR     UTLPRINT            ; Call UTLPRINT to render the text
        BRA     .LOOP               ; Repeat for next line

.FINISHED 
        BTST.B #4, (SCRCYCCT)        ; Check display cycle (16 cycles 0, 16 cycles 1)
        BEQ     .DONE               ; If bit equals 0, do not draw prompt
                                    ; If bit equals 1, draw prompt
        
        ; Print the "Press SpaceBar To Continue" prompt
        LEA     .TXT18, A0          ; Load address of prompt text into a0
        MOVE.B  #28, D0             ; Set row position for the prompt

        JSR     UTLPRINT            ; Render the prompt text

.DONE       MOVEM.L (A7)+, D0-D4/A0-A1 ; Restore registers d0-d4 and a0-a1 from stack

        RTS                         ; Return from subroutine

; -------------------------------------------------------------------------------------------
; TEXT STRINGS FOR INSTRUCTIONS SCREEN
; Contains lines of instructional text, null-terminated. The list is referenced
; by the `.TXTLST` table.
; -------------------------------------------------------------------------------------------

.TXT1     DC.B    'YOUR FELLOW FARMER HAS ASIGNED YOU A TASK,',0   ; Guide text
.TXT2     DC.B    'THE TASK CONSISTS IN HUNTING DUCKS', 0
.TXT3     DC.B    'THE REASON IS DUE TO THE DAMAGE THEY DO TO THE CROPS',0 
.TXT4     DC.B    '----------------------------------------------------',0
.TXT5     DC.B    'TO DO SO, YOU HAVE BEEN GIFTED A GUN AND 7 BULLETS', 0
.TXT6     DC.B    'IN ORDER TO SHOOT, YOU MUST USE "LEFT CLICK"', 0 
.TXT7     DC.B    '----------------------------------------------------',0   ; Guide text
.TXT8     DC.B    'EACH TIME A DUCK IS SHOT, A NEW ROUND STARTS', 0       ; Guide text
.TXT9     DC.B    'WITH EVERY ROUND THE DUCKS GET FASTER', 0            ; Guide text
.TXT10    DC.B    'AND THEREFORE THE GAME BECOMES HARDER', 0
.TXT11    DC.B    '----------------------------------------------------',0
.TXT12    DC.B    'EVERY DUCK YOU SHOOT GIVES YOU A TOTAL OF 100 POINTS',0
.TXT13    DC.B    'YOUR OBJECTIVE IS TO BEAT THE PREVIOUS HIGH SCORE', 0
.TXT14    DC.B    'EACH TIME YOU HIT A DUCK YOUR GUN RELOADS FULLY',0
.TXT15    DC.B    'IF YOU END UP WITH 0 BULLETS THE GAME ENDS', 0
.TXT16    DC.B    '----------------------------------------------------',0
.TXT17    DC.B    'GOOD LUCK!', 0 
.TXT18    DC.B    'Press SpaceBar To Continue', 0
          DS.W    0
.TXTLST  DC.L    .TXT1,.TXT2,.TXT3,.TXT4,.TXT5,.TXT6,.TXT7,.TXT8,.TXT9,.TXT10, .TXT11, .TXT12, .TXT13, .TXT14, .TXT15, .TXT16, .TXT17, 0
