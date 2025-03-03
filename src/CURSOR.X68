; ==============================================================================
; CURSOR MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
CURSORUPD
; UPDATES CURSOR
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

        MOVEM.W D0-D3, -(A7)          ; Save registers d0-d3 on stack

        MOVE    #61, D0               ; Code to read the mouse position (trap 61)
        TRAP    #15                   ; System call to handle peripherals
        
        ; Extract x and y coordinates from d1
        MOVE.L  D1, D2               ; Copy d1 to d2 for manipulation
        ANDI.L  #$FFFF, D2           ; Extract x coordinate (low 16 bits)
        MOVE.L  D1, D3               ; Copy d1 to d3 for manipulation
        SWAP    D3                   ; Swap high and low words
        ANDI.L  #$FFFF, D3           ; Extract y coordinate (low 16 bits)
        
        ; Store coordinates in variables
        MOVE.W  D2, MOUSEX           ; Store x coordinate in mousex
        MOVE.W  D3, MOUSEY           ; Store y coordinate in mousey
        
        ; Update additional variables for cursor drawing
        MOVE.W  D2, RVTPOSX          ; Store x coordinate in rvtposx
        MOVE.W  D2, RHZPOSX          ; Store x coordinate in rhzposx
        MOVE.W  D3, RVTPOSY          ; Store y coordinate in rvtposy
        MOVE.W  D3, RHZPOSY          ; Store y coordinate in rhzposy

        ; Read the current mouse state
        MOVE.B  #61, D0              ; Set to read mouse state
        MOVE.B  #00, D1              ; Check current state
        TRAP    #15                  ; Call to get state

        ; Check if left button is pressed
        BTST.L  #0, D0              ; Check if bit 0 (left button) is active
        BEQ     BUTTON_RELEASED     ; If not pressed, handle release

        ; Extract x and y coordinates from d1 (for click position)
        MOVE.L  D1, D2              ; Copy d1 to d2 for manipulation
        ANDI.L  #$FFFF, D2          ; Extract x coordinate (low 16 bits)
        MOVE.W  D2, (MSCLICK_X)     ; Store x coordinate in msclick_x
        MOVE.L  D1, D3              ; Copy d1 to d3 for manipulation
        SWAP    D3                  ; Swap high and low words
        ANDI.L  #$FFFF, D3          ; Extract y coordinate (low 16 bits)
        MOVE.W  D3, (MSCLICK_Y)     ; Store y coordinate in msclick_y

        MOVE.B  PREV_STATE, D2      ; Load previous state into d2
        CMP.B   #1, D2              ; Compare with 1 (was already pressed)
        BEQ     Done                ; If already pressed, do nothing

        SUB.W   #1, SCOBUL          ; Decrement available shots counter

        MOVE.B  #SNDSHOT, D7        ; Load shot sound code into d7
        TRAP    #SNDPLTN            ; Play gunshot sound

        ; Check if the mouse click is within the target box
        MOVE.W  (BOX_XMIN), D3       ; Get minimum x-coordinate of hitbox
        CMP.W   (MSCLICK_X), D3      ; Compare if mouse x is greater or equal to xmin
        BLS     .MAYOR_XMIN         ; If below xmin, jump to coordinate reset
        BRA     RESET_COORDS

.MAYOR_XMIN
        MOVE.W  (BOX_XMAX), D3       ; Get maximum x-coordinate of hitbox
        CMP.W   (MSCLICK_X), D3      ; Compare if mouse x is less or equal to xmax
        BHS     .MAYOR_YMIN         ; If above xmax, jump to coordinate reset
        BRA     RESET_COORDS

.MAYOR_YMIN
        MOVE.W  (BOX_YMIN), D3       ; Get minimum y-coordinate of hitbox
        CMP.W   (MSCLICK_Y), D3      ; Compare if mouse y is greater or equal to ymin
        BLS     .MENOR_YMAX         ; If below ymin, jump to coordinate reset
        BRA     RESET_COORDS

.MENOR_YMAX
        MOVE.W  (BOX_YMAX), D3       ; Get maximum y-coordinate of hitbox
        CMP.W   (MSCLICK_Y), D3      ; Compare if mouse y is less or equal to ymax
        BHS     .ADD_SCORE          ; If within range, add score
        BRA     RESET_COORDS

.ADD_SCORE        
        ; New click detected, add to the score counter
        ADD.W   #100, SCOPNT         ; Increment the counter by 100           
        JSR     ROUINIT             ; Call routine to update related state

RESET_COORDS
        CLR.W   MSCLICK_X           ; Clear msclick_x coordinate
        CLR.W   MSCLICK_Y           ; Clear msclick_y coordinate

        ; Update previous state to indicate button pressed
        MOVE.B  #1, PREV_STATE       ; Store current state as pressed
        BRA     Done                ; Jump to end

BUTTON_RELEASED
        ; Update previous state to indicate button not pressed
        MOVE.B  #0, PREV_STATE       ; Store current state as not pressed

        ; Check if the game is over (no more shots available)
        TST.W   SCOBUL              ; Test if scobul is 0
        BNE     DONE                ; If not 0, continue
        MOVE.W  #3, (STANEXT)        ; Change to game over screen

DONE                
        MOVEM.W (A7)+, D0-D3        ; Restore registers d0-d3 from stack
        RTS                         ; Return from subroutine

; ------------------------------------------------------------------------------
CURSORPLOT
; PLOT THE CURSOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

        MOVEM.L D0-D4, -(A7)        ; Save registers d0-d4 on stack
        
        ; Vertical rectangle cursor
        ; Set pen color for vertical rectangle
        MOVE.B  #80, D0             ; Code for setting pen color
        MOVE.L  #RVTPCOL, D1        ; Load vertical rectangle pen color constant into d1
        TRAP    #15                 ; Set pen color
            
        ; Set fill color for vertical rectangle
        MOVE.B  #81, D0             ; Code for setting fill color
        MOVE.L  #RVTFCOL, D1        ; Load vertical rectangle fill color constant into d1
        TRAP    #15                 ; Set fill color

        ; Define coordinates for vertical rectangle cursor
        MOVE.W  (RVTPOSX), D1       ; Load x coordinate from rvtposx into d1
        MOVE.W  D1, D3             ; Copy x coordinate to d3
        SUB.W   #RVTWIDTH/2, D1     ; Subtract half of the rectangle width from d1
        ADD.W   #RVTWIDTH/2, D3     ; Add half of the rectangle width to d3

        MOVE.W  (RVTPOSY), D2       ; Load y coordinate from rvtposy into d2
        MOVE.W  D2, D4             ; Copy y coordinate to d4
        SUB.W   #RVTHEIGH/2, D2     ; Subtract half of the rectangle height from d2
        ADD.W   #RVTHEIGH/2, D4     ; Add half of the rectangle height to d4

        ; Draw vertical rectangle cursor
        MOVE.B  #87, D0             ; Code for drawing rectangle
        TRAP    #15                 ; Draw rectangle

        ; Horizontal rectangle cursor
        ; Set pen color for horizontal rectangle
        MOVE.B  #80, D0             ; Code for setting pen color
        MOVE.L  #RHZPCOL, D1        ; Load horizontal rectangle pen color constant into d1
        TRAP    #15                 ; Set pen color
            
        ; Set fill color for horizontal rectangle
        MOVE.B  #81, D0             ; Code for setting fill color
        MOVE.L  #RHZFCOL, D1        ; Load horizontal rectangle fill color constant into d1
        TRAP    #15                 ; Set fill color

        ; Define coordinates for horizontal rectangle cursor
        MOVE.W  (RHZPOSX), D1       ; Load x coordinate from rhzposx into d1
        MOVE.W  D1, D3             ; Copy x coordinate to d3
        SUB.W   #RHZWIDTH/2, D1     ; Subtract half of the rectangle width from d1
        ADD.W   #RHZWIDTH/2, D3     ; Add half of the rectangle width to d3

        MOVE.W  (RHZPOSY), D2       ; Load y coordinate from rhzposy into d2
        MOVE.W  D2, D4             ; Copy y coordinate to d4
        SUB.W   #RHZHEIGH/2, D2     ; Subtract half of the rectangle height from d2
        ADD.W   #RHZHEIGH/2, D4     ; Add half of the rectangle height to d4

        ; Draw horizontal rectangle cursor
        MOVE.B  #87, D0             ; Code for drawing rectangle
        TRAP    #15                 ; Draw rectangle

        MOVEM.L (A7)+, D0-D4         ; Restore registers d0-d4 from stack
            
        RTS                         ; Return from subroutine
