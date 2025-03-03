; ==============================================================================
; SYSTEM CONSTANTS
; ==============================================================================

; --- SCREEN RELATED CONSTANTS -------------------------------------------------

SCRWIDTH    EQU     640                      ; SCREEN WIDTH
SCRHEIGH    EQU     480                      ; SCREEN HEIGHT
SCRFPS      EQU     60                       ; SCREEN FRAME PER SECOND

; --- KEYCODES -----------------------------------------------------------------

KBDSTART    EQU     ' '
KBDSHOOT    EQU     'P'
KBDQ        EQU     'Q'
KBDW        EQU     'W'
KBDA        EQU     'A'
KBDS        EQU     'S'
KBDD        EQU     'D'
KBDE        EQU     'E'

; --- TRAP NUMBERS -------------------------------------------------------------

SCRUPTN     EQU     0                       ; SCREEN UPDATE TRAP NUMBER
KBDUPTN     EQU     1                       ; KEYBOARD UPDATE TRAP NUMBER
SNDPLTN     EQU     2                       ; SOUND PLAY TRAP NUMBER

; --- INTERRUPT NUMBERS --------------------------------------------------------

SCRINTN     EQU     1                       ; Screen timed interrupt number
