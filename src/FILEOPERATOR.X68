; ==============================================================================
; FILE MANAGEMENT
; ==============================================================================

;-------------------------------------------------------------------------------
FILEREADER
; OPENS AN EXISTING FILE TO READ IT
; INPUT    : (A1) Contains the null terminated file name
;            D1.L Contains the file ID (FID)
;            D2.L Contains the number of bytes to read
; OUTPUT   : D2.L Contains the real amount of bytes that have been read, counting from 0.
; MODIFIES : NONE 
;-------------------------------------------------------------------------------

       MOVEM.L D0-D1/A0-A1, -(A7)       ; Save registers
        LEA FILENM, A1                  ; Load file name address into A1
        MOVE.B #51, D0                  ; Set code to open file for reading
        TRAP #15                        ; System call for file open
        
       ; D1.L file ID

        LEA BUFFER, A1                  ; Load buffer address into A1
        MOVE.L #100, D2                 ; Set number of bytes to read
        MOVE.B #53, D0                  ; Set code to read file
        TRAP #15                        ; System call for file read

        ; D2.L contains the number of bytes actually read (including 0)
        SUBQ.B #1, D2                   ; Decrement by 1

        ; Close file
        MOVE.B #56, D0                  ; Set code to close file
        TRAP #15                        ; System call for file close

        MOVEM.L (A7)+, D0-D1/A0-A1      ; Restore registers

        RTS                             ; Return from subroutine

;-------------------------------------------------------------------------------
FILEWRITER
; OPENS AN EXISTING FILE TO WRITE IN IT
; INPUT    : (A1) Contains the null terminated file name
;            D1.L Contains the file ID (FID)
;            D2.L Contains the number of bytes to write
; OUTPUT   : NONE
; MODIFIES : NONE 
;-------------------------------------------------------------------------------

        MOVEM.L D0-D2/A0-A1, -(A7)      ; Save registers

        LEA FILENM, A1                  ; Load file name address into A1
        MOVE.B #52, D0                  ; Set code to open file for writing
        TRAP #15                        ; System call for file open

       ; D1.L file ID

        LEA BUFFER, A1                  ; Load buffer address into A1
        MOVE.L #100, D2                 ; Set number of bytes to write
        MOVE.B #54, D0                  ; Set code to write to file
        TRAP #15                        ; System call for file write

        ; Close file
        MOVE.B #56, D0                  ; Set code to close file
        TRAP #15                        ; System call for file close

        MOVEM.L (A7)+, D0-D2/A0-A1      ; Restore registers

        RTS                             ; Return from subroutine
