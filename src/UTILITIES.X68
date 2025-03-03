; ==============================================================================
; UTILITIES CODE
; ==============================================================================

;---------------------------------------------------------------------------------------------
UTLPRINT
; PRINT SCREEN CENTERED TEXT
; INPUT    : A0 pointer to zero-terminated string
;          : D0 screen row to print exit
; OUTPUT   : D0.B next row
; MODIFIES : NONE (aside of output)
;---------------------------------------------------------------------------------------------

            MOVEM.L  D0-D1/A0-A1, -(A7)   ; Save registers
            CLR.B   D1                  ; Clear d1
            MOVE.L  A0, A1              ; Copy pointer a0 to a1

.LOOP       TST.B   (A0)+             ; Test next character
            BEQ     .ENDLOOP          ; Branch if end of string
            ADDQ.B  #1, D1              ; Increment counter in d1
            BRA     .LOOP             ; Branch to loop

.ENDLOOP    LSR.B   #1, D1             ; Shift right d1 by 1
            SUB.B   #(SCRWIDTH/ULTCHRWD)/2, D1  ; Subtract half screen width per char from d1
            NEG.B   D1                  ; Negate d1
            ASL.W   #8, D1              ; Shift left d1 by 8
            OR.W    D0, D1              ; Or d0 with d1
            MOVE.B  #11, D0             ; Load command 11 in d0
            TRAP    #15                 ; Execute trap call

            MOVE.B  #13, D0             ; Load command 13 in d0
            TRAP    #15                 ; Execute trap call

            MOVEM.L (A7)+, D0-D1/A0-A1   ; Restore registers
            ADDQ.B  #1, D0              ; Increment d0 by 1
            RTS                         ; Return from subroutine

;---------------------------------------------------------------------------------------------
CONVSTRING_TO_NUMBER
; TURNS A STRING INTO A NUMBER
; INPUT    : A0 pointer to zero-terminated string
;          : D2 number of elements or bytes to convert
; OUTPUT   : The number converted in D2.L
; MODIFIES : NONE (aside of output)
;---------------------------------------------------------------------------------------------
    MOVEM.L D0-D1/A0, -(A7)         ; Save registers
.LOOP
        MOVE.B  (A0)+, D1         ; Load next character into d1
        BEQ     .DONE             ; Branch if end of string
        SUB.B   #48, D1           ; Subtract 48 to convert ascii to number
        MULS.W  #10, D0           ; Multiply accumulated number in d0 by 10
        ADD.L   D1, D0           ; Add digit value from d1 to d0
        DBRA    D2, .LOOP         ; Decrement d2 and branch if not zero
.DONE
        MOVE.L  D0, D2            ; Move result from d0 to d2
        MOVEM.L (A7)+, D0-D1/A0   ; Restore registers
        RTS                      ; Return from subroutine

;---------------------------------------------------------------------------------------------
CONVNUMBER_TO_STRING
; CONVERTS A NUMBER INTO A STRING
; INPUT    : A0 pointer to zero-terminated string which is going to invert
;          : A1 pointer to zero-terminated string which will contain the original number as a string
; OUTPUT   : A2 address to string
; MODIFIES : NONE (aside of output)
;---------------------------------------------------------------------------------------------
            MOVEM.W D0-D2/A0-A2, -(A7)   ; Save registers
            MOVE    D0, D2             ; Copy number from d0 to d2 for conversion
            MOVEA.L A0, A2             ; Save start address of string in a2

CONVERT 
            MOVE.W  D2, D1             ; Copy number to d1
            DIVS.W  #10, D1            ; Divide d1 by 10
            MOVE.W  D1, D2             ; Move quotient to d2
            CLR.W   D1                 ; Clear d1 for remainder
            SWAP    D1                 ; Swap words in d1
            ADD.B   #48, D1            ; Convert remainder to ascii digit
            MOVE.B  D1, (A0)+          ; Store ascii digit into string and increment a0
            CMP.B   #0, D2             ; Compare quotient with 0
            BNE     CONVERT            ; Branch if quotient is not zero
            MOVE.B  #0, (A0)           ; Null-terminate string

            MOVEA.L A2, A0             ; Return to start of string in a0
            JSR     INVERT_STRING      ; Invert the string
                          
            MOVEM.W (A7)+, D0-D2/A0-A2  ; Restore registers
            RTS                      ; Return from subroutine

;---------------------------------------------------------------------------------------------
INVERT_STRING
; INVERTS A STRING
; INPUT    : A0 pointer to zero-terminated string (the original string)
;          : A1 pointer to zero-terminated string (destination for inverted string)
; OUTPUT   : New inverted string in memory
; MODIFIES : NONE (aside of output)
;---------------------------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A1, -(A7)   ; Save registers
LOOP        MOVE.B  (A0)+, D3         ; Load character from original string into d3
            ADDQ.B  #1, D5             ; Increment length counter in d5
            CMP.B   #0, D3             ; Compare d3 with 0 (null terminator)
            BNE     LOOP              ; Branch if not end of string
            SUBQ.B  #2, D5             ; Adjust length counter by subtracting 2
            SUBQ.W  #1, A0             ; Adjust string pointer backwards by 1
SECOND      MOVE.B  -(A0), D4         ; Load character from end of string into d4
            MOVE.B  D4, (A1)+         ; Store character into inverted string and increment a1
            DBRA    D5, SECOND         ; Decrement d5 and branch if not done
            MOVE.B  #0, (A1)+         ; Null-terminate inverted string
            MOVEM.L (A7)+, D0-D7/A0-A1 ; Restore registers
            RTS                      ; Return from subroutine
