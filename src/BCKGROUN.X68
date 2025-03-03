; ==============================================================================
; BACKGROUND MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
BCKPLOT
; PLOT THE BACKGROUND.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D4,-(A7)          ; Save registers D0-D4 on stack

            ; sky graphics
            MOVE.L  #BCKPCOL,D1          ; Load background color constant into D1
            MOVE.B  #80,D0               ; Load pen color code into D0
            TRAP    #15                  ; Set pen color
            MOVE.B  #81,D0               ; Load fill color code into D0
            TRAP    #15                  ; Set fill color
            
            MOVE.W  #BCKPOSX-BCKWIDTH/2,D1  ; Calculate left x-coordinate for background rectangle
            MOVE.W  #BCKPOSX+BCKWIDTH/2,D3  ; Calculate right x-coordinate for background rectangle
            MOVE.W  (BCKPOSY),D2         ; Load base y-coordinate from memory into D2
            MOVE.W  D2,D4               ; Copy y-coordinate to D4 as starting coordinate
            ADD.W   #BCKHEIGH,D4         ; Add height to y-coordinate to define bottom edge
            
            MOVE.B  #87,D0               ; Load rectangle drawing code into D0
            TRAP    #15                  ; Draw rectangle
            
            ; grass constants
            MOVE.L  #GRSPCOL,D1          ; Load grass color constant into D1
            MOVE.B  #80,D0               ; Load pen color code into D0
            TRAP    #15                  ; Set pen color
            
            MOVE.B  #81,D0               ; Load fill color code into D0
            TRAP    #15                  ; Set fill color

            MOVE.W  #GRSPOSX,D1          ; Load left x-coordinate for grass rectangle into D1  
            MOVE.W  #GRSPOSX+GRSWIDTH,D3 ; Calculate right x-coordinate for grass rectangle and store in D3
            MOVE.W  #GRSPOSY,D2          ; Load base y-coordinate for grass rectangle into D2
            MOVE.W  D2,D4               ; Copy y-coordinate to D4 as starting coordinate
            ADD.W   #GRSHEIGH,D4         ; Add height to y-coordinate to define top edge
            
            MOVE.B  #87,D0               ; Load rectangle drawing code into D0
            TRAP    #15                  ; Draw rectangle

            MOVEM.L (A7)+,D0-D4          ; Restore registers D0-D4 from stack

            RTS                        ; Return from subroutine
