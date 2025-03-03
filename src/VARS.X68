; ==============================================================================
; GAME VARIABLES
; ==============================================================================

; --- DUCK RELATED VARIABLES ---------------------------------------------------
DCKPOSX     DS.W    1                       ; Duck x coordinate
DCKPOSY     DS.W    1                       ; Duck y coordinate
DCKVELX     DS.W    1                       ; Duck x velocity
DCKVELY     DS.W    1                       ; Duck y velocity
DCKVLSX     DS.W    1                       ; Duck support velocity (x)
DCKVLSY     DS.W    1                       ; Duck support velocity (y)

DCKDIR      DS.B    1                       ; Duck direction

DCKVLI      DS.W    1                       ; Duck increment velocity

DCKSPR      DS.B    768                     ; Duck BMP sprite size
            DS.W    0

; --- CURSOR RELATED VARIABLES -------------------------------------------------
MOUSEX      DS.W    1                       ; Mouse x coordinate
MOUSEY      DS.W    1                       ; Mouse y coordinate
PREV_STATE  DS.B    1                       ; Previous mouse state

MSCLICK_X   DS.W    1                       ; Mouse click x coordinate
MSCLICK_Y   DS.W    1                       ; Mouse click y coordinate

; --- VERTICAL RECTANGLE -------------------------------------------------------
RVTPOSX     DS.W    1                       ; Vertical rectangle x coordinate
RVTPOSY     DS.W    1                       ; Vertical rectangle y coordinate

; --- HORIZONTAL RECTANGLE -----------------------------------------------------
RHZPOSX     DS.W    1                       ; Horizontal rectangle x coordinate
RHZPOSY     DS.W    1                       ; Horizontal rectangle y coordinate

; --- SCOREBOARD RELATED VARIABLES ---------------------------------------------
SCOPNT      DS.W    1                       ; Number of points (score)
SCOBUL      DS.W    1                       ; Number of bullets
SCORND      DS.W    1                       ; Number of rounds

; --- RANDOM RELATED VARIABLES -------------------------------------------------
RNDINDEX    DS.B    1                       ; Random index
            DS.W    0

; --- HITBOX RELATED VARIABLES -------------------------------------------------
BOX_XMIN    DS.W    1                       ; Hitbox minimum x
BOX_XMAX    DS.W    1                       ; Hitbox maximum x
BOX_YMIN    DS.W    1                       ; Hitbox minimum y
BOX_YMAX    DS.W    1                       ; Hitbox maximum y

; --- AUDIO RELATED VARIABLES --------------------------------------------------
AUDACCSN    DS.B    1                       ; Accept new sounds flag
            DS.W    0

; --- SPRITES RELATED VARIABLES ------------------------------------------------
FILE_POS    DS.B    1                       ; Sprite file position
            DS.W    0

; --- STATE RELATED VARIABLES --------------------------------------------------
STACUR      DS.W    1                       ; Current state
STANEXT     DS.W    1                       ; Next state
