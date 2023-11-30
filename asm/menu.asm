arch snes.cpu

define Letter_A	$a0
define Letter_B	$a1
define Letter_C	$a2
define Letter_D	$a3
define Letter_E	$a4
define Letter_F	$a5
define Letter_G	$a6
define Letter_H	$a7

define Letter_I	$b0
define Letter_J $b1
define Letter_K	$b2
define Letter_L	$b3
define Letter_M	$b4
define Letter_N	$b5
define Letter_O	$b6
define Letter_P	$b7

define Letter_Q	$c0
define Letter_R $c1
define Letter_S	$c2
define Letter_T $c3
define Letter_U	$c4
define Letter_V	$c5
define Letter_W	$c6
define Letter_X	$c7

define Letter_Y	$d0
define Letter_?	$d1

define Letter_DisableSave_S	$50
define Letter_DisableSave_A	$51
define Letter_DisableSave_V	$52
define Letter_DisableSave_E	$42

//Format hex to ASM db thing
//Find: [0-9A-Z][0-9A-Z]
//Replace: ,\$$&
//Replace example: xxxxxxxxx$&xxxxxxxxx

// \$[A-Z0-9][A-Z0-9],\$[A-Z0-9][A-Z0-9],\$[A-Z0-9][A-Z0-9],\$[A-Z0-9][A-Z0-9]
// db $&\n

// [^\u0000-\u0080{}]+
// Special chars

org $11F10; base $C11F10; fill $378, $FF

//==============================
// Hint menu
//==============================

// The hint box is stored as a bunch of sprites.
// Sprites listed first have a priority over later listed ones.

// XX YY ID TilesToUse/Palette/Delimeter

//-------------------
// "Yes" view
//-------------------
org $1D700; base $C1D700
MarioHintYesMenu:
// Cursor
db $f8,$17,$0b,$07

// Use a hint? text
db $f8,$07,{Letter_U},$06
db $00,$07,{Letter_S},$06
db $08,$07,{Letter_E},$06

db $18,$07,{Letter_A},$06

db $28,$07,{Letter_H},$06
db $30,$07,{Letter_I},$06
db $38,$07,{Letter_N},$06
db $40,$07,{Letter_T},$06
db $48,$07,{Letter_?},$06

db $00,$17,{Letter_Y},$06
db $08,$17,{Letter_E},$06
db $10,$17,{Letter_S},$06

db $20,$17,{Letter_N},$06
db $28,$17,{Letter_O},$06

// ????
db $00,$ff,$b9,$06


// Right borders 
db $50,$ff,$43,$17
db $50,$0f,$53,$17
db $50,$1f,$49,$17 // Right corner

// Bottom Border
db $e8,$1f,$45,$17 // Left corner
db $f0,$07,$bc,$06
db $f8,$1f,$47,$17
db $08,$1f,$47,$17
db $18,$1f,$47,$17
db $28,$1f,$47,$17
db $38,$1f,$47,$17 // Added
db $48,$1f,$47,$17 // Added
db $F0,$f7,$a8,$16

db $e8,$0f,$ab,$16

// Top border
db $08,$f7,$a9,$16
db $18,$f7,$a9,$16
db $28,$f7,$a9,$16
db $38,$f7,$a9,$16 // Added
db $48,$f7,$a9,$16 // Added

// BG for lower part
db $f8,$0f,$30,$17
db $08,$0f,$30,$17
db $18,$0f,$30,$17
db $28,$0f,$30,$17
db $38,$0f,$30,$17
db $48,$0f,$30,$17

// BG for upper part
db $08,$00,$30,$17
db $18,$00,$30,$17
db $48,$00,$30,$37

//-------------------
// "No" view
//-------------------
MarioHintNoMenu:
db $18,$17,$0b,$07 // Cursor

// Use a hint? text
db $f8,$07,{Letter_U},$06
db $00,$07,{Letter_S},$06
db $08,$07,{Letter_E},$06

db $18,$07,{Letter_A},$06

db $28,$07,{Letter_H},$06
db $30,$07,{Letter_I},$06
db $38,$07,{Letter_N},$06
db $40,$07,{Letter_T},$06
db $48,$07,{Letter_?},$06

db $00,$17,{Letter_Y},$06
db $08,$17,{Letter_E},$06
db $10,$17,{Letter_S},$06

db $20,$17,{Letter_N},$06
db $28,$17,{Letter_O},$06

// ????
db $00,$ff,$b9,$06


// Right borders 
db $50,$ff,$43,$17
db $50,$0f,$53,$17
db $50,$1f,$49,$17 // Right corner

// Bottom Border
db $e8,$1f,$45,$17 // Left corner
db $f0,$07,$bc,$06
db $f8,$1f,$47,$17
db $08,$1f,$47,$17
db $18,$1f,$47,$17
db $28,$1f,$47,$17
db $38,$1f,$47,$17 // Added
db $48,$1f,$47,$17 // Added
db $F0,$f7,$a8,$16

db $e8,$0f,$ab,$16

// Top border
db $08,$f7,$a9,$16
db $18,$f7,$a9,$16
db $28,$f7,$a9,$16
db $38,$f7,$a9,$16 // Added
db $48,$f7,$a9,$16 // Added

// BG for lower part
db $f8,$0f,$30,$17
db $08,$0f,$30,$17
db $18,$0f,$30,$17
db $28,$0f,$30,$17
db $38,$0f,$30,$17
db $48,$0f,$30,$17

// BG for upper part
db $08,$00,$30,$17
db $18,$00,$30,$17
db $48,$00,$30,$37

//==============================
// Puzzle menu: Mario
//==============================

MarioPuzzleMenu:
db $48,$ff,$43,$17 // Right border
db $48,$0f,$53,$17 // Right border
db $48,$1f,$53,$17 // Right border

db $f8,$07,$ab,$16 // Left border
db $f8,$17,$ab,$16 // Left border

db $f8,$2f,$45,$17 // Bottom border
db $00,$27,$ac,$06 // Bottom border
db $08,$2f,$47,$17 // Bottom border
db $18,$2f,$47,$17 // Bottom border
db $28,$2f,$47,$17 // Bottom border
db $38,$2f,$47,$17 // Bottom border
db $48,$2f,$49,$17 // Bottom border

db $00,$f7,$a8,$16 // Top border
db $10,$f7,$a9,$16 // Top border
db $20,$f7,$a9,$16 // Top border
db $30,$f7,$a9,$16 // Top border
db $40,$ff,$ba,$06 // Top border

// Letters

// 1
db $10,$07,{Letter_G},$06
db $18,$07,{Letter_I},$06
db $20,$07,{Letter_V},$06
db $28,$07,{Letter_E},$06

db $38,$07,{Letter_U},$06
db $40,$07,{Letter_P},$06

// 2
db $10,$0F,{Letter_S},$06
db $18,$0F,{Letter_A},$06
db $20,$0F,{Letter_V},$06
db $28,$0F,{Letter_E},$06

// 3
db $10,$17,{Letter_M},$06
db $18,$17,{Letter_U},$06
db $20,$17,{Letter_S},$06
db $28,$17,{Letter_I},$06
db $30,$17,{Letter_C},$06

// 3
db $10,$1F,{Letter_S},$06
db $18,$1F,{Letter_T},$06
db $20,$1F,{Letter_E},$06
db $28,$1F,{Letter_R},$06
db $30,$1F,{Letter_E},$06
db $38,$1F,{Letter_O},$06

// 4
db $10,$27,{Letter_H},$06
db $18,$27,{Letter_I},$06
db $20,$27,{Letter_N},$06
db $28,$27,{Letter_T},$06

db $38,$27,$f3,$06 // -
db $40,$27,$f7,$06 // 5

// BG: Top
db $08,$00,$30,$17
//db $18,$00,$30,$17
db $28,$00,$30,$17
db $38,$00,$30,$17

// BG: Middle
db $08,$0f,$30,$07
db $08,$17,$40,$07

db $30,$0f,$31,$07

db $38,$0f,$30,$17

// BG: Bottom
db $08,$1f,$30,$07
db $08,$27,$40,$07

db $30,$27,$41,$07

db $38,$1f,$30,$37

//==============================
// Yes/No menu
//==============================

YesNoMenu:
db $10,$07,{Letter_Y},$06
db $18,$07,{Letter_E},$06
db $20,$07,{Letter_S},$06

db $10,$0f,{Letter_N},$06
db $18,$0f,{Letter_O},$06

db $20,$ff,$ba,$06
db $f8,$07,$ab,$16
db $f8,$17,$45,$17
db $08,$17,$47,$17
db $18,$17,$47,$17
db $28,$17,$49,$17
db $28,$07,$53,$17
db $28,$ff,$43,$17
db $10,$f7,$a9,$16
db $00,$f7,$a8,$16

// BG
db $08,$07,$30,$07
db $08,$0f,$31,$07

db $18,$07,$30,$37

//==============================
// Music Menu 123
//==============================

Music123Menu:
db $10,$07,$00,$07 // 1
db $10,$0f,$01,$07 // 2
db $10,$17,$02,$07 // 3

db $20,$17,$30,$07 // BG
db $08,$1f,$40,$07 // BG
db $10,$1f,{Letter_O},$06
db $18,$1f,{Letter_F},$06
db $20,$1f,{Letter_F},$06

db $00,$17,$bc,$06

db $08,$17,$31,$07 // BG
db $18,$17,$31,$07 // BG

db $00,$1f,$ac,$06
db $18,$07,$30,$17
db $08,$07,$30,$17
db $20,$ff,$b9,$06

db $18,$27,$47,$17
db $28,$27,$49,$17
db $10,$27,$47,$17
db $00,$27,$46,$17
db $f8,$07,$ab,$16
db $28,$17,$53,$17
db $28,$07,$53,$17
db $28,$ff,$43,$17
db $10,$f7,$a9,$16
db $00,$f7,$a8,$36

//==============================
// Music Menu 1234
//==============================

Music1234Menu:
db $10,$07,$00,$07 // 1
db $10,$0f,$01,$07 // 2
db $10,$17,$02,$07 // 3
db $10,$1f,$03,$07 // 4

db $10,$27,{Letter_O},$06
db $18,$27,{Letter_F},$06
db $20,$27,{Letter_F},$06

db $00,$17,$bc,$06



db $08,$07,$30,$07 // BG
db $08,$0f,$30,$07 // BG
db $08,$17,$30,$07 // BG
db $08,$1f,$30,$07 // BG
db $08,$27,$30,$07 // BG

db $18,$07,$30,$17 // BG
db $18,$17,$30,$17 // BG



db $20,$ff,$b9,$06

db $00,$2f,$46,$17 // Bottom border
db $18,$2f,$47,$17 // Bottom border
db $10,$2f,$47,$17 // Bottom border
db $28,$2f,$49,$17 // Bottom border

db $F8,$1F,$AB,$16 // Left border
db $f8,$07,$ab,$16 // Left border

db $28,$07,$53,$17 // Right border
db $28,$17,$53,$17 // Right border
db $28,$27,$53,$17 // Right border

db $28,$ff,$43,$17 // Top border
db $10,$f7,$a9,$16 // Top border
db $00,$f7,$a8,$36 // Top border


//==============================
// Stereo Menu
//==============================

StereoMenu:
db $10,$07,{Letter_O},$06
db $18,$07,{Letter_N},$06
db $20,$07,$40,$07

db $10,$0f,{Letter_O},$06
db $18,$0f,{Letter_F},$06
db $20,$0f,{Letter_F},$06

db $08,$07,$30,$17

db $08,$0f,$5e,$07
db $20,$ff,$ba,$06
db $f8,$07,$ab,$16
db $f8,$17,$45,$17
db $08,$17,$47,$17
db $18,$17,$47,$17
db $28,$17,$49,$17
db $28,$07,$53,$17
db $28,$ff,$43,$17
db $10,$f7,$a9,$16
db $00,$f7,$a8,$36

//==============================
// Cursor
//==============================
Cursor:
db $00,$FF,$0B,$27

//==============================
// Puzzle menu: Wario
//==============================

WarioPuzzleMenu1:
db $48,$ff,$43,$17 // Right border
db $48,$0f,$53,$17 // Right border
db $48,$1f,$53,$17 // Right border

db $f8,$07,$ab,$16 // Left border
db $f8,$17,$ab,$16 // Left border

db $f8,$2f,$45,$17 // Bottom border
db $00,$27,$ac,$06 // Bottom border
db $08,$2f,$47,$17 // Bottom border
db $18,$2f,$47,$17 // Bottom border
db $28,$2f,$47,$17 // Bottom border
db $38,$2f,$47,$17 // Bottom border
db $48,$2f,$49,$17 // Bottom border

db $00,$f7,$a8,$16 // Top border
db $10,$f7,$a9,$16 // Top border
db $20,$f7,$a9,$16 // Top border
db $30,$f7,$a9,$16 // Top border
db $40,$ff,$ba,$06 // Top border

// Letters

// 1
db $10,$07,{Letter_G},$06
db $18,$07,{Letter_I},$06
db $20,$07,{Letter_V},$06
db $28,$07,{Letter_E},$06

db $38,$07,{Letter_U},$06
db $40,$07,{Letter_P},$06

// 2
db $10,$0F,{Letter_S},$06
db $18,$0F,{Letter_A},$06
db $20,$0F,{Letter_V},$06
db $28,$0F,{Letter_E},$06

// 3
db $10,$17,{Letter_M},$06
db $18,$17,{Letter_U},$06
db $20,$17,{Letter_S},$06
db $28,$17,{Letter_I},$06
db $30,$17,{Letter_C},$06

// 3
db $10,$1F,{Letter_S},$06
db $18,$1F,{Letter_T},$06
db $20,$1F,{Letter_E},$06
db $28,$1F,{Letter_R},$06
db $30,$1F,{Letter_E},$06
db $38,$1F,{Letter_O},$06

// 4
db $10,$27,{Letter_?},$06

db $20,$27,{Letter_S},$06
db $28,$27,{Letter_T},$06
db $30,$27,{Letter_A},$06
db $38,$27,{Letter_R},$06
db $40,$27,{Letter_T},$06


// BG: Top
db $08,$00,$30,$17
//db $18,$00,$30,$17
db $28,$00,$30,$17
db $38,$00,$30,$17

// BG: Middle
db $08,$0f,$30,$07
db $08,$17,$40,$07

db $30,$0f,$31,$07

db $38,$0f,$30,$17

// BG: Bottom
db $08,$1f,$30,$07
db $08,$27,$40,$07
db $18,$27,$40,$07

db $38,$1f,$30,$37

//==============================
// Puzzle menu: Wario #2
//==============================

WarioPuzzleMenu2:
db $48,$ff,$43,$17 // Right border
db $48,$0f,$53,$17 // Right border
db $48,$1f,$53,$17 // Right border

db $f8,$07,$ab,$16 // Left border
db $f8,$17,$ab,$16 // Left border

db $f8,$2f,$45,$17 // Bottom border
db $00,$27,$ac,$06 // Bottom border
db $08,$2f,$47,$17 // Bottom border
db $18,$2f,$47,$17 // Bottom border
db $28,$2f,$47,$17 // Bottom border
db $38,$2f,$47,$17 // Bottom border
db $48,$2f,$49,$17 // Bottom border

db $00,$f7,$a8,$16 // Top border
db $10,$f7,$a9,$16 // Top border
db $20,$f7,$a9,$16 // Top border
db $30,$f7,$a9,$16 // Top border
db $40,$ff,$ba,$06 // Top border

// Letters

// 1
db $10,$07,{Letter_G},$06
db $18,$07,{Letter_I},$06
db $20,$07,{Letter_V},$06
db $28,$07,{Letter_E},$06

db $38,$07,{Letter_U},$06
db $40,$07,{Letter_P},$06

// 2
db $10,$0F,{Letter_DisableSave_S},$07
db $18,$0F,{Letter_DisableSave_A},$07
db $20,$0F,{Letter_DisableSave_V},$07
db $28,$0F,{Letter_DisableSave_E},$07

// 3
db $10,$17,{Letter_M},$06
db $18,$17,{Letter_U},$06
db $20,$17,{Letter_S},$06
db $28,$17,{Letter_I},$06
db $30,$17,{Letter_C},$06

// 3
db $10,$1F,{Letter_S},$06
db $18,$1F,{Letter_T},$06
db $20,$1F,{Letter_E},$06
db $28,$1F,{Letter_R},$06
db $30,$1F,{Letter_E},$06
db $38,$1F,{Letter_O},$06

// 4
db $10,$27,{Letter_?},$06

db $20,$27,{Letter_E},$06
db $28,$27,{Letter_N},$06
db $30,$27,{Letter_D},$06

// BG: Top
db $08,$00,$30,$17
//db $18,$00,$30,$17
db $28,$00,$30,$17
db $38,$00,$30,$17

// BG: Middle
db $08,$0f,$30,$07
db $08,$17,$40,$07

db $30,$0f,$31,$07

db $38,$0f,$30,$17

// BG: Bottom
db $08,$1f,$30,$07
db $08,$27,$40,$07
db $18,$27,$40,$07

db $38,$1f,$30,$37

//==============================
// Puzzle menu: Wario #2: You sure?
//==============================

WarioYouSure:
db $00,$07,{Letter_Y},$06
db $08,$07,{Letter_O},$06
db $10,$07,{Letter_U},$06

db $20,$07,{Letter_S},$06
db $28,$07,{Letter_U},$06
db $30,$07,{Letter_R},$06
db $38,$07,{Letter_E},$06
db $40,$07,{Letter_?},$06

db $08,$17,{Letter_Y},$06
db $10,$17,{Letter_E},$06
db $18,$17,{Letter_S},$06

db $28,$17,{Letter_N},$06
db $30,$17,{Letter_O},$06

// Top BG
db $00,$07,$30,$17 //BG
db $10,$07,$30,$17 //BG
db $20,$07,$30,$17 //BG
db $30,$07,$30,$17 //BG
db $40,$0f,$41,$07 //BG

db $48,$1F,$49,$17 // bottom right border
db $00,$1F,$47,$17 // Bottom border
db $10,$1F,$47,$17 // Bottom border
db $20,$1F,$47,$17 // Bottom border
db $30,$1F,$47,$17 // Bottom border
db $40,$1F,$47,$17 // Bottom border


db $f0,$1F,$45,$17 // Bottom left border
db $f8,$07,$BC,$06 // Left border
db $f0,$0F,$AB,$16 // Left border
db $f8,$F7,$A8,$16 // Top right border

db $48,$0F,$53,$17 // Right border
db $48,$FF,$43,$17 // Right border

db $08,$F7,$A9,$16 // Top border
db $18,$F7,$A9,$16 // Top border
db $28,$F7,$A9,$16 // Top border
db $38,$F7,$A9,$16 // Top border

// Bottom BG
db $00,$17,$30,$07 //BG
db $20,$17,$30,$07 //BG
db $38,$17,$30,$37 //BG

//==============================
// Puzzle menu: Mario: No hints available
//==============================

MarioPuzzleNoHintsMenu:
db $48,$ff,$43,$17 // Right border
db $48,$0f,$53,$17 // Right border
db $48,$1f,$53,$17 // Right border

db $f8,$07,$ab,$16 // Left border
db $f8,$17,$ab,$16 // Left border

db $f8,$2f,$45,$17 // Bottom border
db $00,$27,$ac,$06 // Bottom border
db $08,$2f,$47,$17 // Bottom border
db $18,$2f,$47,$17 // Bottom border
db $28,$2f,$47,$17 // Bottom border
db $38,$2f,$47,$17 // Bottom border
db $48,$2f,$49,$17 // Bottom border

db $00,$f7,$a8,$16 // Top border
db $10,$f7,$a9,$16 // Top border
db $20,$f7,$a9,$16 // Top border
db $30,$f7,$a9,$16 // Top border
db $40,$ff,$ba,$06 // Top border

// Letters

// 1
db $10,$07,{Letter_G},$06
db $18,$07,{Letter_I},$06
db $20,$07,{Letter_V},$06
db $28,$07,{Letter_E},$06

db $38,$07,{Letter_U},$06
db $40,$07,{Letter_P},$06

// 2
db $10,$0F,{Letter_S},$06
db $18,$0F,{Letter_A},$06
db $20,$0F,{Letter_V},$06
db $28,$0F,{Letter_E},$06

// 3
db $10,$17,{Letter_M},$06
db $18,$17,{Letter_U},$06
db $20,$17,{Letter_S},$06
db $28,$17,{Letter_I},$06
db $30,$17,{Letter_C},$06

// 3
db $10,$1F,{Letter_S},$06
db $18,$1F,{Letter_T},$06
db $20,$1F,{Letter_E},$06
db $28,$1F,{Letter_R},$06
db $30,$1F,{Letter_E},$06
db $38,$1F,{Letter_O},$06

// 4
db $10,$27,$E1,$06 //HINT
db $18,$27,$E2,$06
db $20,$27,$E3,$06
db $28,$27,$E4,$06

db $38,$27,$e6,$06 // -
db $40,$27,$e7,$06 // 5

// BG: Top
db $08,$00,$30,$17
//db $18,$00,$30,$17
db $28,$00,$30,$17
db $38,$00,$30,$17

// BG: Middle
db $08,$0f,$30,$07
db $08,$17,$40,$07

db $30,$0f,$31,$07

db $38,$0f,$30,$17

// BG: Bottom
db $08,$1f,$30,$07
db $08,$27,$40,$07

db $30,$27,$41,$07

db $38,$1f,$30,$37

//==============================
// Adjust menu menu pointers
//==============================

// Hint menu: yes
org $103A4; base $C103A4
db MarioHintYesMenu&$FF,MarioHintYesMenu>>8&$FF,MarioHintYesMenu>>16&$FF

// Hint menu: no
org $103A8; base $C103A8
db MarioHintNoMenu&$FF,MarioHintNoMenu>>8&$FF,MarioHintNoMenu>>16&$FF

// Main menu: Mario
org $103AC; base $C103AC
db MarioPuzzleMenu&$FF,MarioPuzzleMenu>>8&$FF,MarioPuzzleMenu>>16&$FF

// Yes/no menu
org $103B0; base $C103B0
db YesNoMenu&$FF,YesNoMenu>>8&$FF,YesNoMenu>>16&$FF

// Music menu
org $103B4; base $C103B4
db Music123Menu&$FF,Music123Menu>>8&$FF,Music123Menu>>16&$FF

org $103DC; base $C103DC
db Music1234Menu&$FF,Music1234Menu>>8&$FF,Music1234Menu>>16&$FF

// Stereo menu
org $103B8; base $C103B8
db StereoMenu&$FF,StereoMenu>>8&$FF,StereoMenu>>16&$FF

// Cursor
org $103BC; base $C103BC
db Cursor&$FF,Cursor>>8&$FF,Cursor>>16&$FF

// Main menu: Wario
org $103c0; base $C103c0
db WarioPuzzleMenu1&$FF,WarioPuzzleMenu1>>8&$FF,WarioPuzzleMenu1>>16&$FF

// Main menu: Wario #2
org $103c4; base $C103c4
db WarioPuzzleMenu2&$FF,WarioPuzzleMenu2>>8&$FF,WarioPuzzleMenu2>>16&$FF

// Puzzle menu: Wario #2: You sure?
org $103c8; base $C103c8
db WarioYouSure&$FF,WarioYouSure>>8&$FF,WarioYouSure>>16&$FF

// Puzzle menu: Mario: No hints available
org $103CC; base $C103CC
db MarioPuzzleNoHintsMenu&$FF,MarioPuzzleNoHintsMenu>>8&$FF,MarioPuzzleNoHintsMenu>>16&$FF

//==============================
// Puzzle menu: Wario #2: You sure? X,Y
//==============================
org $4f06; base $c04f06; fill $16, $ea
org $4f06; base $c04f06
jmp YouSureCursor
YouSureCursorOut:

org $0D000; base $C0D000
YouSureCursor:
lda $1b36
asl
asl
asl
asl
asl
clc 
adc #$0058
pha
db $F4,$88,$00 //pea #$0088
jsl $c0117c
jmp YouSureCursorOut
