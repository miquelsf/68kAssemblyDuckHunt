; ==============================================================================
; GAME CONSTANTS
; ==============================================================================

; --- DUCK RELATED CONSTANTS ----------------------------------------------------

DCKRAD      EQU     30                       ; Duck radius
DCKPCOL     EQU     $00000000                ; Duck contour color
DCKFCOL     EQU     $00AAAAAA                ; Duck fill color
DCKSPEED    EQU     2                        ; Magnitude of the initial duck speed
BINITVEC    DC.W    0, 91, 182, 273, 364, 455, 640  ; Duck initial direction vector
BVECVELX    DC.B    51, 67, 83, 100, 100, 100, 100  ; Duck x direction velocity vectors
BVECVELY    DC.B    100, 100, 100, 100, 83, 67, 51  ; Duck y direction velocity vectors

; --- BACKGROUND RELATED CONSTANTS ---------------------------------------------

BCKWIDTH    EQU     640                     ; Sky width
BCKHEIGH    EQU     480                     ; Sky height
BCKPOSX     EQU     320                     ; Sky x position
BCKPOSY     EQU     240                     ; Sky y coordinate
BCKPCOL     EQU     $00FFAD63               ; Sky contour color
BCKFCOL     EQU     $00FFAD63               ; Sky fill color

GRSWIDTH    EQU     640                     ; Grass width
GRSHEIGH    EQU     80                      ; Grass height
GRSPOSX     EQU     0                       ; Grass x position
GRSPOSY     EQU     400                     ; Grass y position
GRSPCOL     EQU     $0000D78D               ; Grass contour color
GRSFCOL     EQU     $0000D78D               ; Grass fill color

; --- PLAYER RELATED CONSTANTS -------------------------------------------------

PLYWIDTH    EQU     20                      ; Player width
PLYHEIGH    EQU     20                      ; Player height
PLYPOSX     EQU     320                     ; Player x position
PLYPOSY     DS.W    1                       ; Player y coordinate
PLYPCOL     EQU     $004444FF               ; Player contour color
PLYFCOL     EQU     $006565FF               ; Player fill color

; --- SCOREBOARD RELATED CONSTANTS ---------------------------------------------

SCOFCOL     EQU     $00000000               ; Text background color
SCOLINE1    EQU     $3E1D                   ; First text line coordinates
SCOLINE2    EQU     $091D                   ; Second text line coordinates
SCOLINE3    EQU     $231D                   ; Third text line coordinates

; --- VERTICAL RECTANGLE -------------------------------------------------------

RVTWIDTH    EQU     5  
RVTHEIGH    EQU     30
RVTPCOL     EQU     $000000FF              ; Rectangle contour color
RVTFCOL     EQU     $000000FF              ; Rectangle fill color

; --- HORIZONTAL RECTANGLE -----------------------------------------------------

RHZWIDTH    EQU     30
RHZHEIGH    EQU     5
RHZPCOL     EQU     $000000FF              ; Rectangle contour color
RHZFCOL     EQU     $000000FF              ; Rectangle fill color

; --- HITBOX RELATED CONSTANTS -------------------------------------------------

BOXWIDTH    EQU     30                     ; Hitbox width
BOXHEIGH    EQU     30                     ; Hitbox height
BOXPCOL     EQU     $00FF1100              ; Hitbox contour

; --- SCORE RELATED CONSTANTS --------------------------------------------------

BULLETN     EQU     7                      ; Number of bullets per round

; --- AUDIO RELATED CONSTANTS --------------------------------------------------

SNDQUAK     EQU    0                       ; Duck sound
SNDSHOT     EQU    1                       ; Shot sound 
SNDLOSE     EQU    2                       ; Game over sound

; --- TEXT RELATED CONSTANTS ---------------------------------------------------

ULTCHRWD    EQU     8                       ; Character size

; --- FILE RELATED CONSTANTS ---------------------------------------------------

BUFFER      DS.B    20                      ; Buffer
FILENM      DC.W    'Registro.txt', 0       ; File name

INVSCS      DS.B    4                       ; Score string (Inverted)
SCSTR       DS.B    4                       ; Original score string

; --- SPRITES RELATED CONSTANTS ------------------------------------------------

RSCLFCTR	EQU     4						; Rescale factor

; --- STATE RELATED CONSTANTS --------------------------------------------------

STANONE     EQU     -1                      ; Non-existent state number
