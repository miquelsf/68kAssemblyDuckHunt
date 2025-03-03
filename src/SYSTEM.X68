; ==============================================================================
; SYSTEM
; ==============================================================================

; ------------------------------------------------------------------------------
SYSINIT
; SYSTEM INITIALIZATION ROUTINE
; Initializes key system functions such as screen plotting, keyboard updates, 
; sound playback, and timed interrupts.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.L  #SCRPLOT,($80+SCRUPTN*4)    ; Set screen update routine in trap vector
            MOVE.L  #KBDUPD,($80+KBDUPTN*4)     ; Set keyboard update routine in trap vector
            MOVE.L  #SNDPLAY,($80+SNDPLTN*4)    ; Set sound playback routine in trap vector
            MOVE.L  #SCRTIM,($60+SCRINTN*4)     ; Set timed interrupt routine in vector table

            JSR     SCRINIT                     ; Initialize screen settings
            JSR     KBDINIT                     ; Initialize keyboard settings

            MOVE.W  SR,-(A7)                    ; Push status register onto stack
            ANDI.W  #$D8FF,(A7)                 ; Configure interrupt settings

            RTE                                 ; Return from exception (restore program state)

; ------------------------------------------------------------------------------
SNDINIT
; INITIALIZE SOUND SYSTEM
; Loads sound files into memory and prepares them for playback.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A0-A1,-(A7)           ; Save registers d0-d1 and a0-a1 on stack

            CLR.B   D1                          ; Clear sound index
            LEA     .SNDLIST,A0                 ; Load address of sound list into a0
.LOOP       MOVE.L  (A0)+,D0                  ; Load next sound file pointer
            BEQ     .DONE                       ; Exit loop if end of list is reached
            MOVE.L  D0,A1                       ; Load sound file path into a1
            MOVE.B  #71,D0                      ; Set sound load command
            TRAP    #15                         ; System call to load sound
            ADDQ.B  #1,D1                       ; Increment sound index
            BRA     .LOOP                       ; Repeat for the next sound file

.DONE       MOVEM.L (A7)+,D0-D1/A0-A1           ; Restore registers
            RTS                                 ; Return from subroutine

.SNDQUAK    DC.B    'FILES/SND/quack.wav',0           ; Sound file: duck quack
.SNDSHOT    DC.B    'FILES/SND/gunshot.wav',0         ; Sound file: gunshot
.SNDLOSE    DC.B    'FILES/SND/lose.wav',0            ; Sound file: game over sound
.SNDLIST    DC.L    .SNDQUAK,.SNDSHOT,.SNDLOSE,0     ; List of sound files (null-terminated)

; ------------------------------------------------------------------------------
SNDPLAY
; PLAY SOUND ROUTINE
; Plays a sound based on the index in register D7.
; INPUT    : D7 (Sound index)
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)                 ; Save registers d0-d1 on stack
            MOVE.B  #72,D0                      ; Set sound play command
            MOVE.B  D7,D1                       ; Load sound index into d1
            TRAP    #15                         ; System call to play sound
            MOVEM.W (A7)+,D0-D1                 ; Restore registers d0-d1
            RTE                                 ; Return from exception

; ------------------------------------------------------------------------------
SCRINIT
; INITIALIZE SCREEN
; Sets the screen resolution, clears the screen, enables double buffering,
; and configures timed interrupts for synchronization.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)                 ; Save registers d0-d1 on stack

            ; Set screen resolution
            MOVE.B  #33,D0                      ; Set resolution command
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1   ; Set width and height in d1
            TRAP    #15                         ; System call to configure resolution
            
            ; Set windowed mode
            MOVE.L  #1,D1                       ; Windowed mode setting
            TRAP    #15                         ; System call to configure mode
            
            ; Clear screen
            MOVE.B  #11,D0                      ; Clear screen command
            MOVE.W  #$FF00,D1                   ; Fill screen with black
            TRAP    #15                         ; System call to clear screen

            ; Enable double buffering
            MOVE.B  #92,D0                      ; Enable double buffer command
            MOVE.B  #17,D1                      ; Enable setting value
            TRAP    #15                         ; System call to enable buffering

            ; Enable timed interrupt
            MOVE.B  #32,D0                      ; Enable interrupt command
            MOVE.B  #6,D1                       ; Timer interrupt type
            MOVE.B  #$80|SCRINTN,D2             ; Interrupt priority and number in d2
            MOVE.L  #1000/SCRFPS,D3             ; Set timer interval based on frames per second
            TRAP    #15                         ; System call to configure interrupt

            ; Clear interrupt counter
            CLR.W   (SCRINTCT)                  ; Reset screen interrupt counter

            MOVEM.L (A7)+,D0-D1                 ; Restore registers d0-d1
            RTS                                 ; Return from subroutine

; ------------------------------------------------------------------------------
SCRPLOT
; SCREEN PLOTTING ROUTINE
; Updates the display using double buffering and clears hidden buffers.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)                 ; Save registers d0-d1 on stack

            ; Switch display buffers
            MOVE.B  #94,D0                      ; Command to switch display buffer
            TRAP    #15                         ; System call to switch buffers

            ; Clear hidden buffer
            MOVE.B  #11,D0                      ; Clear buffer command
            MOVE.W  #$FF00,D1                   ; Fill with black
            TRAP    #15                         ; System call to clear buffer

            MOVEM.W (A7)+,D0-D1                 ; Restore registers d0-d1
            RTE                                 ; Return from exception

; ------------------------------------------------------------------------------
SCRTIM
; TIMED INTERRUPT SERVICE ROUTINE
; Increments the screen interrupt counter for synchronization.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Screen interrupt counter (SCRINTCT) and cycle counter (SCRCYCCT)
; ------------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)               ; Increment screen interrupt counter
            ADDQ.B  #1,(SCRCYCCT)               ; Increment cycle counter
            RTE                                 ; Return from exception

; ------------------------------------------------------------------------------
KBDINIT
; INITIALIZE KEYBOARD
; Clears keyboard values and edge triggers.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Keyboard values (KBDVAL) and edge triggers (KBDEDGE)
; ------------------------------------------------------------------------------
            CLR.B   (KBDVAL)                    ; Clear current keyboard values
            CLR.B   (KBDEDGE)                   ; Clear keyboard edge triggers
            RTS                                 ; Return from subroutine

; ------------------------------------------------------------------------------
KBDUPD
; UPDATE KEYBOARD INFORMATION
; Reads the current keyboard state and calculates edge-triggered inputs.
; INPUT    : NONE
; OUTPUT   : Updates KBDVAL and KBDEDGE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D3,-(A7)                 ; Save registers d0-d3 on stack

            ; Read first part of keyboard inputs
            MOVE.B  #19,D0                      ; Set command to read keyboard input
            MOVE.L  #KBDSTART<<24|KBDSHOOT<<16|KBDQ<<8|KBDE,D1 ; Configure input bits in d1
            TRAP    #15                         ; System call to read keyboard

            ; Pack bits into desired format
            JSR     .PACK                       ; Pack bits subroutine

            ; Read second part of keyboard inputs
            MOVE.L  #KBDW<<24|KBDA<<16|KBDS<<8|KBDD,D1 ; Configure next set of input bits
            TRAP    #15                         ; System call to read keyboard

            ; Pack bits into desired format
            JSR     .PACK                       ; Pack bits subroutine

            ; Compute edge-triggered inputs (KBDEDGE)
            MOVE.B  (KBDVAL),D0                 ; Load current keyboard values into d0
            NOT.B   D0                          ; Invert d0 to detect changes
            AND.B   D2,D0                       ; Apply mask to get edge changes
            MOVE.B  D0,(KBDEDGE)                ; Store edge-triggered inputs

            ; Store new keyboard state
            MOVE.B  D2,(KBDVAL)                 ; Update KBDVAL with new state

            MOVEM.W (A7)+,D0-D3                 ; Restore registers d0-d3
            RTE                                 ; Return from exception

.PACK       ; Subroutine to pack bits into desired format
            MOVE.W  #3,D3                       ; Initialize bit counter (3 iterations)
.LOOP       LSL.L   #8,D1                     ; Shift left by 8 bits in d1
            ROXL.B  #1,D2                       ; Rotate left with extend d2
            DBRA    D3,.LOOP                    ; Loop until all bits are processed
            RTS                                 ; Return from subroutine
