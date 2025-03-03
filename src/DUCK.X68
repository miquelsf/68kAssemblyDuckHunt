; ==============================================================================
; DUCK MANAGEMENT
; Manages the initialization, update, collision handling, and plotting of the
; duck. Includes subroutines for duck initialization (DCKINIT, DCKRSPW), 
; updating position and velocity (DCKUPD), and drawing the duck on the screen
; (DCKPLOT).
; ==============================================================================

; ------------------------------------------------------------------------------
DCKINIT
; Initializes the duck's position and velocity with default values.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : DCKPOSX, DCKPOSY, DCKVELX, DCKVELY, DCKVLSX, DCKVLSY, DCKVLI
; ------------------------------------------------------------------------------

            MOVEM.W D0/A0-A2,-(A7)      ; Save registers d0 and a0-a2 on stack

            JSR     RNDGET              ; Generate a random number (0-7) in d0
            MULU.W  #2,D0               ; Multiply the random number by 2

            LEA.L   BINITVEC,A0         ; Load address of binitvec into a0

            MOVE.W  (A0,D0.L),D0        ; Fetch an initial position vector

            MOVE.W  D0,(DCKPOSX)        ; Set the initial x position of the duck
            MOVE.W  #BCKHEIGH-GRSHEIGH,(DCKPOSY)    ; Set the initial y position

            MOVE.W  #1,(DCKDIR)         ; Set the initial duck direction (1 = right, -1 = left)
            
            MOVE.W  #DCKSPEED,(DCKVELX) ; Initialize x velocity
            MOVE.W  #DCKSPEED,(DCKVELY) ; Initialize y velocity
            MOVE.W  #DCKSPEED,(DCKVLSX) ; Initialize scaled x velocity
            MOVE.W  #DCKSPEED,(DCKVLSY) ; Initialize scaled y velocity

            MOVE.W  #DCKSPEED,(DCKVLI)  ; Initialize velocity index

            LEA     .DCKFILE,A1         ; Get file name pointer
            LEA     DCKSPR,A2           ; Get variable pointer
            JSR     SPRINIT             ; Load file into memory

            MOVEM.W (A7)+,D0/A0-A2      ; Restore registers d0 and a0-a2

            RTS                         ; Return from subroutine

.DCKFILE   DC.B    'FILES/DUCK.BMP',0
            DS.W    0

; ------------------------------------------------------------------------------
DCKRSPW
; INITIALIZE DUCK.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0/A0,-(A7)         ; Save registers d0 and a0 on stack

            JSR     RNDGET              ; Generate a random number (0-7) in d0
            MULU.W  #2,D0               ; Multiply the random number by 2
            LEA.L   BINITVEC,A0         ; Load address of binitvec into a0

            MOVE.W  (A0,D0.L),D0        ; Fetch an initial position vector

            MOVE.W  D0,(DCKPOSX)        ; Set the initial x position of the duck
            MOVE.W  #BCKHEIGH-GRSHEIGH,(DCKPOSY)    ; Set the initial y position
            
            MOVE.W  (DCKVLI),(DCKVELX)  ; Initialize x velocity
            MOVE.W  (DCKVLI),(DCKVELY)  ; Initialize y velocity
            MOVE.W  (DCKVLI),(DCKVLSX)  ; Initialize scaled x velocity
            MOVE.W  (DCKVLI),(DCKVLSY)  ; Initialize scaled y velocity

            MOVEM.W (A7)+,D0/A0        ; Restore registers d0 and a0

            RTS                        ; Return from subroutine

; ------------------------------------------------------------------------------
DCKUPD
; UPDATES THE DUCK.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0-D5/A0,-(A7)      ; Save registers d0-d5 and a0 on stack
            CLR.L   D3                  ; Clear d3 (used as a collision flag)

            ; Update duck coordinates
            MOVE.W  (DCKPOSX),D1        ; Load current x position
            MOVE.W  (DCKPOSY),D2        ; Load current y position
            ADD.W   (DCKVLSX),D1        ; Add scaled x velocity
            ADD.W   (DCKVLSY),D2        ; Add scaled y velocity
            
            ; Check horizontal collisions
            CMP.W   #SCRWIDTH-DCKRAD,D1 ; Compare with right boundary
            BGT     .COLRGT             ; If greater, handle right collision
            CMP.W   #DCKRAD,D1          ; Compare with left boundary
            BLT     .COLLFT             ; If less, handle left collision
            
            ; Check vertical collisions
.CHKVERT    CMP.W   #SCRHEIGH-GRSHEIGH-DCKRAD,D2 ; Compare with bottom boundary
            BGT     .COLBOT             ; If greater, handle bottom collision
            CMP.W   #DCKRAD,D2          ; Compare with top boundary
            BLT     .COLTOP             ; If less, handle top collision
            BRA     .DONE               ; If no collision, skip to done

            ; Right side collision
.COLRGT     MOVE.W  #SCRWIDTH-DCKRAD,D1 ; Set x to right boundary
            NEG.W   (DCKVELX)           ; Reverse x velocity
            NEG.W   (DCKVLSX)           ; Reverse scaled x velocity
            NEG.W   (DCKDIR)            ; Reverse direction
            BSET.L  #1,D3               ; Set collision flag
            BRA     .MULTVEL            ; Adjust velocity

            ; Left side collision
.COLLFT     MOVE.W  #DCKRAD,D1          ; Set x to left boundary
            NEG.W   (DCKVELX)           ; Reverse x velocity
            NEG.W   (DCKVLSX)           ; Reverse scaled x velocity
            NEG.W   (DCKDIR)            ; Reverse direction
            BSET.L  #1,D3               ; Set collision flag
            BRA     .MULTVEL            ; Adjust velocity

            ; Bottom collision
.COLBOT     NEG.W   (DCKVELY)           ; Reverse y velocity
            NEG.W   (DCKVLSY)           ; Reverse scaled y velocity
            MOVE.W  #SCRHEIGH-GRSHEIGH-DCKRAD,D2 ; Set y to bottom boundary
            BRA     .MULTVEL            ; Adjust velocity

            ; Top collision
.COLTOP     NEG.W   (DCKVELY)           ; Reverse y velocity
            NEG.W   (DCKVLSY)           ; Reverse scaled y velocity
            MOVE.W  #DCKRAD,D2          ; Set y to top boundary
            BRA     .MULTVEL            ; Adjust velocity

            ; Multiply the velocity when colliding to get a random direction
.MULTVEL    JSR     RNDGET              ; Generate a random number (0-7) in d0
            LEA.L   BVECVELX,A0         ; Load velocity adjustment vector for x

            ; Update x speed
            MOVE.B  (A0,D0.L),D5        ; Fetch random velocity adjustment
            MOVE.W  (DCKVELX),D4        ; Load current x velocity
            MULS.W  D5,D4               ; Scale velocity
            DIVS.W  #100,D4             ; Normalize velocity
            MOVE.W  D4,(DCKVLSX)        ; Update scaled x velocity

            LEA.L   BVECVELY,A0         ; Load velocity adjustment vector for y

            ; Update y speed
            MOVE.B  (A0,D0.L),D5        ; Fetch random velocity adjustment
            MOVE.W  (DCKVELY),D4        ; Load current y velocity
            MULS.W  D5,D4               ; Scale velocity
            DIVS.W  #100,D4             ; Normalize velocity
            MOVE.W  D4,(DCKVLSY)        ; Update scaled y velocity

            MOVE.B  #SNDQUAK,D7         ; Load quack sound code into d7
            TRAP    #SNDPLTN            ; Play quack sound

            ; Test d3 and jump if it's a side collision, else continue to done
            BTST.L  #1,D3               ; Check if horizontal collision occurred
            BNE     .CHKVERT            ; If so, check vertical collisions again

.DONE       MOVE.W  D1,(DCKPOSX)      ; Save updated x position
            MOVE.W  D2,(DCKPOSY)        ; Save updated y position

            MOVEM.W (A7)+,D0-D5/A0      ; Restore saved registers

            RTS                         ; Return from subroutine
  
; ------------------------------------------------------------------------------
DCKPLOT
; PLOT THE DUCK.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D4/A1,-(A7)      ; Save registers d0-d4 and a1 on stack

            MOVE.W  (DCKPOSX),D3        ; Get duck x position
            MOVE.W  (DCKPOSY),D4        ; Get duck y position
            SUB.W   #31,D3              ; Sprite x position correction
            ADD.W   #30,D4              ; Sprite y position correction
            
            LEA     DCKSPR,A1           ; Load address of duck sprite into a1

            MOVE.B  (DCKDIR),D0         ; Get duck direction from dckdir
            BEQ     .DCKRGT             ; If direction is 0, go to dckrgt
			
            ADD.W   #45,D3              ; Adjust sprite x position correction
            ADD.W   #5,D4               ; Adjust sprite y position correction
            JSR     INVERSPR            ; Invert sprite for left direction
            BRA     .CONT               ; Continue to plot

.DCKRGT     JSR     PRINTSPR          ; Print sprite for right direction
            
.CONT       ; Define hitbox coordinates
            MOVE.W  (DCKPOSX),D1                 
            SUB.W   #DCKRAD,D1         ; Calculate x-min coordinate
            MOVE.W  (DCKPOSY),D2                 
            SUB.W   #DCKRAD,D2         ; Calculate y-min coordinate
            MOVE.W  D1,D3               
            ADD.W   #2*DCKRAD,D3       ; Calculate x-max coordinate
            MOVE.W  D2,D4               
            ADD.W   #2*DCKRAD,D4       ; Calculate y-max coordinate

            ; Set hitbox pen color
            MOVE.B  #80,D0              ; Code for setting pen color
            MOVE.L  #BOXPCOL, D1         ; Load hitbox contour color constant into d1
            TRAP    #15                 ; Set pen color
            
            ; Set hitbox fill color (if needed, add code here)

            ; Define hitbox coordinates with adjustment
            MOVE.W  (DCKPOSX),D1                 
            SUB.W   #DCKRAD,D1         ; Calculate preliminary x coordinate
            SUB.W   #10, D1            ; Adjust: x-min coordinate is in d1
            MOVE.W  D1, BOX_XMIN        ; Store x-min coordinate in box_xmin
            ADD.W   #10, D3            ; Adjust: x-max coordinate is in d3
            MOVE.W  D3, BOX_XMAX        ; Store x-max coordinate in box_xmax
            SUB.W   #10, D2            ; Adjust: y-min coordinate is in d2
            MOVE.W  D2, BOX_YMIN        ; Store y-min coordinate in box_ymin
            ADD.W   #10, D4            ; Adjust: y-max coordinate is in d4
            MOVE.W  D4, BOX_YMAX        ; Store y-max coordinate in box_ymax

            ; Draw hitbox (code commented out)
            ; MOVE.B  #90, D0
            ; TRAP    #15
                                        
            MOVEM.L (A7)+,D0-D4/A1      ; Restore registers d0-d4 and a1 from stack

            RTS                         ; Return from subroutine
