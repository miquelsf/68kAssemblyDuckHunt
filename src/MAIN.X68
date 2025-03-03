; ==============================================================================
; TITLE       : ASSEMBLY DUCK HUNT
; AUTHORS     : Aaron Tudor and Miquel Sanso
; CREATION    : 9/11/2024
; ==============================================================================

            ORG     $1000               ; Start program at memory location $1000

            INCLUDE "CONST.X68"         ; Include constants used in the program
            INCLUDE "SYSCONST.X68"      ; Include system-related constants
            INCLUDE "SYSTEM.X68"        ; Include system functions
            INCLUDE "RANDOM.X68"        ; Include random number generation utilities
            INCLUDE "DUCK.X68"          ; Include duck-related functions (likely for duck movement)
            INCLUDE "BCKGROUN.X68"      ; Include background drawing utilities
            INCLUDE "SCORE.X68"         ; Include scoring system functions
            INCLUDE "CURSOR.X68"        ; Include cursor management utilities
            INCLUDE "ROUND.X68"         ; Include functions related to game rounds
            INCLUDE "UTILITIES.X68"     ; Include utility functions
            INCLUDE "INSTRUCTIONS.X68"  ; Include instructions for gameplay
            INCLUDE "INTRO.X68"         ; Include introduction screen utilities
            INCLUDE "OVER.X68"          ; Include game over screen utilities
            INCLUDE "STATES.X68"        ; Include game state management utilities
            INCLUDE "SPRITES.X68"       ; Include images management utilities
            INCLUDE "FILEOPERATOR.X68"  ; Include file management

START

; --- INITIALIZATION -----------------------------------------------------------
             
            ORI.W   #$0700,SR           ; Disable interrupts by setting interrupt mask in the status register
            JSR     SYSINIT             ; Call system initialization routine
            JSR     STAINIT             ; Call state initialization routine
           
.LOOP

; --- UPDATE -------------------------------------------------------------------

; READ INPUT DEVICES
            TRAP    #KBDUPTN            ; Check input from keyboard or input device

; --- SYNC ---------------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)          ; Test if the screen interrupt counter is zero
            BEQ     .WINT               ; Wait here if it's not yet time to update (synchronize game loop)
            CLR.B   (SCRINTCT)          ; Clear the screen interrupt counter to reset sync

; UPDATE GAME LOGIC
            JSR     STAUPD              ; Update game state (e.g., position of ducks, score, etc.)

; --- PLOT ---------------------------------------------------------------------
            JSR     STAPLOT             ; Plot graphics (update visual representation of game state)
            TRAP    #SCRUPTN            ; Trigger screen update to display changes (double buffering)
            BRA     .LOOP               ; Branch to start of the game loop (infinite loop)

            SIMHALT                     ; Simulation halt (end of program execution)
            
            INCLUDE "VARS.X68"          ; Include variables specific to the game
            INCLUDE "SYSVARS.X68"       ; Include system variables

            END     START               ; End of program; define the entry point as "START"
