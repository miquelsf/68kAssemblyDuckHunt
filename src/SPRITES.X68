; ==============================================================================
; SPRITE MANAGEMENT ROUTINES
; ==============================================================================

; ------------------------------------------------------------------------------
SPRINIT
; DESCRIPTION: Loads a 16x16 sprite from a file into memory.
; INPUTS:   A1 - Pointer to the file name
;           A2 - Target memory location to store the sprite
; OUTPUTS:  None
; ------------------------------------------------------------------------------
            MOVEM.L D0-D2/A1-A2,-(A7)  ; Save registers
            MOVE.B  #50,D0             ; Set code to close all open files
            TRAP    #15                ; Execute file close
            MOVE.B  #51,D0             ; Set code to open the specified file
            TRAP    #15                ; Open file; file id stored in D1.L
            MOVE.L  #10,D2             ; Set file position to 10
            MOVE.B  #55,D0             ; Set code to initiate file read
            TRAP    #15                ; Perform file seek
            LEA     FILE_POS,A1        ; Load FILE_POS address into A1
            MOVE.L  #1,D2              ; Set byte count to 1
            MOVE.B  #53,D0             ; Set code for read operation
            TRAP    #15                ; Retrieve file start position
            MOVE.B  (FILE_POS),D2      ; Load file start position value into D2
            MOVE.B  #55,D0             ; Set code to read file data
            TRAP    #15                ; Read file data
            MOVE.L  A2,A1              ; Set target memory location (A1 = A2)
            MOVE.L  #$300,D2           ; Set byte count to 768 (16x16 pixels)
            MOVE.B  #53,D0             ; Set code for data read
            TRAP    #15                ; Read sprite data into memory
            MOVE.B  #50,D0             ; Set code to close the file
            TRAP    #15                ; Execute file close
            MOVEM.L (A7)+,D0-D2/A1-A2  ; Restore registers
            RTS                       ; Return from subroutine

; ------------------------------------------------------------------------------
PRINTSPR
; DESCRIPTION: Draws a 16x16 sprite on the screen, rescaled according to RSCLFCTR.
; INPUTS:   A1 - Pointer to the sprite image
;           D3.W - X coordinate
;           D4.W - Y coordinate
; OUTPUTS:  None
; ------------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)     ; Save registers
            JSR     PRINTINIT           ; Initialize drawing parameters

.YLOOP      MOVE.L  #15,D7            ; Set x loop counter to 15
            MOVE.W  D5,D3             ; Reset x position from saved value

.XLOOP      MOVE.B  (A1)+,D1          ; Read blue component from sprite data
            LSL.L   #8,D1             ; Shift blue component into position
            MOVE.B  (A1)+,D1          ; Read green component from sprite data
            LSL.L   #8,D1             ; Shift green component into position
            MOVE.B  (A1)+,D1          ; Read red component from sprite data
            MOVE.B  #80,D0            ; Set code for setting pen color
            TRAP    #15               ; Execute system call to set pen color
            MOVE.B  #81,D0            ; Set code for setting fill color
            TRAP    #15               ; Execute system call to set fill color
            CMP     #$0000FF00,D1     ; Compare color with green value
            BEQ     .SKIPCLR          ; If color is green, skip drawing
            MOVE.W  D3,D1             ; Save current x position in d1
            MOVE.W  D4,D2             ; Save current y position in d2
            ADDQ.W  #RSCLFCTR,D3      ; Increment x coordinate by scaling factor
            ADDQ.W  #RSCLFCTR,D4      ; Increment y coordinate by scaling factor
            MOVE.B  #87,D0            ; Set code to draw filled square
            TRAP    #15               ; Execute drawing operation
            MOVE.W  D1,D3             ; Restore original x position from d1
            MOVE.W  D2,D4             ; Restore original y position from d2

.SKIPCLR    ADDQ.W  #RSCLFCTR,D3      ; Increment x coordinate by scaling factor
            CLR.L   D1                ; Clear d1
            DBRA    D7,.XLOOP         ; Decrement loop counter and branch if not done
            SUBQ.W  #RSCLFCTR,D4      ; Decrement y coordinate by scaling factor
            DBRA    D6,.YLOOP         ; Decrement y loop counter and branch if not done
            MOVEM.L (A7)+,D0-D7/A1     ; Restore registers
            RTS                       ; Return from subroutine

; ------------------------------------------------------------------------------
INVERSPR
; DESCRIPTION: Draws an inverted 16x16 sprite on the screen.
; INPUTS:   A1 - Pointer to the sprite image
;           D3.W - X coordinate
;           D4.W - Y coordinate
; OUTPUTS:  None
; ------------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)     ; Save registers
            JSR     PRINTINIT           ; Initialize drawing parameters

.YLOOP      MOVE.L  #15,D7            ; Set x loop counter to 15
            MOVE.W  D5,D3             ; Reset x coordinate from saved value

.XLOOP      MOVE.B  (A1)+,D1          ; Read blue component from sprite data
            LSL.L   #8,D1             ; Shift blue component into position
            MOVE.B  (A1)+,D1          ; Read green component from sprite data
            LSL.L   #8,D1             ; Shift green component into position
            MOVE.B  (A1)+,D1          ; Read red component from sprite data
            MOVE.B  #80,D0            ; Set code for setting pen color
            TRAP    #15               ; Execute system call to set pen color
            MOVE.B  #81,D0            ; Set code for setting fill color
            TRAP    #15               ; Execute system call to set fill color
            CMP     #$0000FF00,D1     ; Compare color with green value
            BEQ     .SKIPCLR          ; If color is green, skip drawing
            MOVE.W  D3,D1             ; Save current x coordinate in d1
            MOVE.W  D4,D2             ; Save current y coordinate in d2
            SUBQ.W  #RSCLFCTR,D3      ; Decrement x coordinate by scaling factor
            SUBQ.W  #RSCLFCTR,D4      ; Decrement y coordinate by scaling factor
            MOVE.B  #87,D0            ; Set code to draw filled square
            TRAP    #15               ; Execute drawing operation
            MOVE.W  D1,D3             ; Restore original x coordinate from d1
            MOVE.W  D2,D4             ; Restore original y coordinate from d2

.SKIPCLR    SUBQ.W  #RSCLFCTR,D3      ; Decrement x coordinate by scaling factor
            CLR.L   D1                ; Clear d1
            DBRA    D7,.XLOOP         ; Decrement loop counter and branch if not done
            SUBQ.W  #RSCLFCTR,D4      ; Decrement y coordinate by scaling factor
            DBRA    D6,.YLOOP         ; Decrement y loop counter and branch if not done
            MOVEM.L (A7)+,D0-D7/A1     ; Restore registers
            RTS                       ; Return from subroutine

; ------------------------------------------------------------------------------
PRINTINIT
; DESCRIPTION: Sets up parameters for sprite drawing.
; ------------------------------------------------------------------------------
            CLR.L   D1                ; Clear d1
            ADD.W   #16,D3            ; Adjust starting x coordinate
            SUBQ.W  #1,D4             ; Adjust starting y coordinate
            MOVE.W  D3,D5             ; Save initial x coordinate in d5
            MOVE.L  #15,D6            ; Set y loop counter in d6
            RTS                       ; Return from subroutine
