arch snes.cpu

define SpaceId						#$0000
define CurrentStringLength			$01		//$1FDD

// Having the puzzle name length immediately followed by some
// other data is annoying. Transfer this data to a zero-page instead
define PuzzleLength					$1140
define PuzzleLengthNew				$1160
define PuzzlePixelLengthNew			$01F0

define PuzzleTextLengthOffsetNew	$0200
define PuzzleTextHeightOffsetNew	$1162

define PuzzleScreenTextboxLength	#$01FE

define PuzzleName					$0140 // Original location $1141 ($801141)
define CharacterAddition			#$01d0
define CharacterLengthAddressLoHi	$c127b4
define CharacterLengthAddressBank	$c127b6

define CompressedIndex				$03
define TotalCompressedSize			$05
define CompressionBuffer			$0D
define CompressionBufferBank		$0F
define CompressionLength			$01
define DecompressionBuffer			$0000

//==============================
// Change header
//==============================
// Set region
org $FFD9
db $01

// Set version identifier
org $FFDB
db $05

// I could remove the save file sanity check so I can change the game code,
// however, it seems like a risky move for an small gain. 

//org $FFB2
//db "ACXU"

// Truncate the game code sanity check
//org $DA1; base $C00DA1
//ldx #$0004

//==============================
// Puzzle selection: Name Print
//==============================

org $0B577
//jmp $4308

org $AF54; base $c0af54; fill $36, $ea
org $AF54; base $c0af54
lda #$0008
sta {PuzzleTextHeightOffsetNew}
sta {PuzzleTextLengthOffsetNew}

jsr PuzzleNameVWFRoutine

//==============================
// Expand the puzzle names
//==============================
// I assume this limit was in place because 
// a) 99% of the game has the puzzle names bounded within textboxes
//    so they will never be this long 
// b) to prevent reading garbage data.
// 
// In other words, it's a sanity check. Since we expanded the names,
// we can increase this limit a bit.

org $17C8; base $C017C8
cmp #$00AE // originally #$003E

//==============================
// Relocate puzzle name data
//==============================
org $17C3; base $C017C3
sta {PuzzleName},x

//==============================
// Puzzle complete: Name Print
//==============================
org $7D97; base $c07d97; fill $36, $ea
org $7D97; base $c07d97
stz {PuzzleTextHeightOffsetNew}
lda #$0008
sta {PuzzleTextLengthOffsetNew}
jsr PuzzleNameVWFRoutine

//==============================
// Weird Decompression algorith => LZ1 compression
//==============================

org $1939; base $c01939; fill $7F, $ea
org $1939; base $c01939
jmp LZDecompress

//==============================
// Free Space
//==============================
org $CE00; base $C0CE00

//-------------
// Puzzle selection Name: VWF Routine
//-------------

// Textbox start:	#$0044
// Textbox end:		#$01C7
// Textbox length:	#$0183
// (LengthOfTextbox - LengthOfString) / #$2 = centered text located

// The original games writes the characters from right to left
// Additionally, the original text, while monospaced, uses the same VWF character
// writing routine used in the tutorial.
// I would assume this is done to save clock cycles to center the text.
PuzzleNameVWFRoutine:

clc
lda {PuzzleLength}
and #$00FF
sta {PuzzleLengthNew}

jsr PuzzleNameCalculateWordLength
sta {PuzzlePixelLengthNew}
lda {PuzzleScreenTextboxLength}
sbc {PuzzlePixelLengthNew}
clc

lsr
clc
adc {PuzzleTextLengthOffsetNew}
clc
sta {CurrentStringLength}

lda #$0000
tax

Loop:
rep #$20
phx

// Push character
lda {PuzzleName},x
and #$00FF
clc  
adc {CharacterAddition}
pha
clc
lda {PuzzleTextHeightOffsetNew}
pha

// Push the position to write
lda {CurrentStringLength}
pha

// Get the length of the character
lda {PuzzleName},x
and #$00FF
jsr GetCharacterLength
adc {CurrentStringLength}
sta {CurrentStringLength}

// 1st byte in stack: Position to write onscreen
// 2nd byte in stack: ???
// 3rd byte in stack: Character to write

WriteCharacter:
jsl $c013c5

pla
pla
pla
plx
inx
inx

cpx {PuzzleLengthNew}
bne Loop
rts

//-------------
// Picross Puzzle Name: Calculate String Length
//-------------

PuzzleNameCalculateWordLength:
lda #$0000
sta {CurrentStringLength}
tax


// Characters are stored in two bytes. The start from 00 and count up
// For whatever reason, the puzzle names characters lo bytes are written but not hi.
// But they're stored like they're encoded with two bytes. As a result, the Japanese version
// never uses characters above 0xFF for puzzlenames, which is just the kanji characters.
// Also, since we want more characters, we've relocated PuzzleName.
WordLengthLoop:
lda {PuzzleName},x
and #$00FF
phx
jsr GetCharacterLength
plx
adc {CurrentStringLength}
sta {CurrentStringLength}

inx
inx

cpx {PuzzleLengthNew}
bmi WordLengthLoop
rts

//-------------
// Get Character Length
//-------------
// A is expected to contain the character Id

GetCharacterLength:
cmp {SpaceId}
beq GetCharacterLengthSpaceException

clc  
adc {CharacterAddition}

asl
asl
tax

lda {CharacterLengthAddressLoHi},x
sta $05
lda {CharacterLengthAddressBank},x
sta $07
lda [$05]
and #$00ff 
rts

// The game handles space weird.
// and does exactly what this function accomplishes:
//  hardcodes the character length of 8
// c0c192 cmp #$0000
// c0c195 beq $c1b8
GetCharacterLengthSpaceException:
lda #$0008
rts

//==============================
// Weird Decompression algorith => LZ1 compression
//==============================

LZDecompress:

phb
phd
tsc
sec
sbc #$0006
tcs
tcd
pea $7f00
plb
plb

lda [{CompressionBuffer}]
sta {TotalCompressedSize}

bne SizeNotZero
jmp DecompessEnd

SizeNotZero:
inc {CompressionBuffer}
inc {CompressionBuffer}

stz {CompressionLength}
stz {CompressedIndex}
inc {CompressedIndex}

ldx #$0000

LoadCommand:
lda [{CompressionBuffer}]
jsl IncrementBuffer
inc {CompressedIndex}
and #$00FF
tay

lsr
lsr
lsr
lsr
lsr
clc

// Evaluate if long command
cmp #$0007
bne NotLongCommand

// Get Length
lda [{CompressionBuffer}]
and #$00FF
sta {CompressionLength}
jsl IncrementBuffer
inc {CompressedIndex}

tya
and #$0003
xba
and #$FF00 // essentially did a << 8 with fewer clock cyclesinc
ora {CompressionLength}
inc
sta {CompressionLength}

// Get command
tya
lsr
lsr
clc
and #$0007
bra DetermineCommand

NotLongCommand:
pha
tya
and #$001F
inc
sta {CompressionLength}
pla

DetermineCommand:
cmp #$0000
beq DirectCopy
cmp #$0001
beq ByteFill
cmp #$0002
beq WordFill
cmp #$0003
beq IncreaseFill
cmp #$0004
beq Repeat
InvalidCommand:
bra InvalidCommand

DirectCopy:
lda [{CompressionBuffer}]
and #$00FF
sta {DecompressionBuffer},x

inx
jsl IncrementBuffer
inc {CompressedIndex}
dec {CompressionLength}
lda {CompressionLength}
bne DirectCopy
bra CommandOver

ByteFill:
lda [{CompressionBuffer}]
and #$00FF
sta {DecompressionBuffer},x
inx
dec {CompressionLength}
lda {CompressionLength}
bne ByteFill
jsl IncrementBuffer
inc {CompressedIndex}
bra CommandOver

WordFill:
lda #$0000
tay

WordFillLoop:

and #$0001
cmp #$0001
beq WordFillLoopOdd

WordFillLoopEven:
lda [{CompressionBuffer}]
and #$00FF
bra WordFillLoopEvenOddEnd

WordFillLoopOdd:
lda [{CompressionBuffer}]
xba
and #$00FF

WordFillLoopEvenOddEnd:

sta {DecompressionBuffer},x
inx

iny

tya
cmp {CompressionLength}
bne WordFillLoop

jsl IncrementBuffer
jsl IncrementBuffer
inc {CompressedIndex}
inc {CompressedIndex}

bra CommandOver

IncreaseFill:

lda [{CompressionBuffer}]
and #$00FF
tay
jsl IncrementBuffer
inc {CompressedIndex}

IncreaseFillLoop:
tya
sta {DecompressionBuffer},x

inx
iny

dec {CompressionLength}
lda {CompressionLength}
bne IncreaseFillLoop
bra CommandOver

Repeat:
lda [{CompressionBuffer}]
sta {DecompressionBuffer},x

inx
inx

jsl IncrementBuffer
jsl IncrementBuffer
inc {CompressedIndex}
inc {CompressedIndex}

dec {CompressionLength}

lda {CompressionLength}
bne Repeat

CommandOver:

lda {CompressedIndex}
cmp {TotalCompressedSize}
beq DecompessEnd
DecompessTooMuch:
bpl DecompessTooMuch

jmp LoadCommand
DecompessEnd:
stz {CompressionLength}
tsc
clc
adc #$0006
tcs
pld
plb
rtl

IncrementBuffer:
pha
lda [{CompressionBuffer}]
inc {CompressionBuffer}

bne IncrementBufferSkipBankIncrement
inc {CompressionBufferBank}

IncrementBufferSkipBankIncrement:
pla
rtl

//==============================
// Wario 'W' sprite (Puzzle menu)
//==============================
org $11434; base $C11434; fill $0C, $FF

org $10168
db $00,$D4,$C1

org $1D400
db $f8,$02,$44,$12
db $08,$02,$46,$02
db $10,$02,$57,$02
db $08,$0A,$56,$02
db $10,$0A,$58,$02
db $10,$12,$59,$02
db $f8,$12,$47,$02
db $00,$12,$48,$02
db $08,$12,$49,$22

//==============================
// Wario 'W' sprite (Wario EX)
//==============================

org $11020; base $C11020; fill $0C, $FF

org $1009C
db $00,$D5,$C1

org $1D500
db $f2,$FB,$20,$13
db $f2,$0B,$23,$03
db $fa,$0B,$24,$03
db $fa,$0B,$24,$03
db $02,$FB,$22,$03
db $02,$03,$32,$03
db $02,$0B,$25,$03
db $0a,$FB,$33,$03
db $0a,$03,$34,$23


//==============================
// "File" in Select a file sprites
//==============================

org $11264
db $60,$FF,$AA,$02 //E
db $58,$FF,$AB,$02 //L
db $50,$FF,$1F,$02 //I
db $48,$FF,$AF,$02 //F

//==============================
// Puzzle hint sprites
//==============================
org $116F0
db $70,$FF,$0E,$00 // E
db $68,$FF,$0F,$00 // L
db $60,$FF,$B4,$01 // Z
db $58,$FF,$B4,$01 // Z
db $50,$FF,$B3,$01 // U
db $48,$FF,$B2,$01 // P
db $38,$FF,$19,$00 // A

//==============================
// Minor Font Ajustments
//==============================

// The font is stored like so:
// byte 00: width
// byte 01: height
// byte --: font data
// The format is 2BPP Gameboy
// Font reading starts @ c0:c214


// Make the bottom of 'w' lighter
org $991AC
db $09,$06,$04,$03

// Make the bottom of 'x' lighter
org $991DC
db $88,$70,$22,$1C

org $982a2
incbin "asm/bin/Text - Hyphen.bin"

org $97E80
incbin "asm/bin/Text - Comma.bin"
org $12F24
db $80,$7E,$C9

org $97EA0
incbin "asm/bin/Text - 'p'.bin"
org $13034
db $A0,$7E,$C9

org $097F20
incbin "asm/bin/Text - 'q'.bin"
org $13038
db $20,$7F,$C9

org $97EE0
incbin "asm/bin/Text - 'y'.bin"
org $13058
db $E0,$7E,$C9

// Repalce + with left quote
org $9824c
incbin "asm/bin/Text - Left Quote.bin"



//==============================
// Anti-piracy screen
//==============================

org $48000

db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$51,$00,$52,$00,$53,$00,$54,$00,$55,$00,$1D,$01,$1E,$01,$1F,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text
db $00,$00,$00,$00,$00,$00,$56,$00,$56,$00,$57,$00,$58,$00,$59,$00,$5A,$00,$00,$00,$5B,$00,$5C,$00,$5D,$00,$5E,$00,$5F,$00,$60,$00,$20,$01,$21,$01,$22,$01,$23,$01,$24,$01,$25,$01,$26,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text
db $00,$00,$00,$00,$00,$00,$61,$00,$62,$00,$63,$00,$64,$00,$65,$00,$66,$00,$67,$00,$68,$00,$69,$00,$6A,$00,$6B,$00,$6C,$00,$6D,$00,$27,$01,$28,$01,$29,$01,$2A,$01,$2B,$01,$2C,$01,$2D,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text

db $00,$00,$00,$00,$00,$00,$6E,$00,$6F,$00,$70,$00,$71,$00,$72,$00,$73,$00,$74,$00,$75,$00,$76,$00,$77,$00,$78,$00,$79,$00,$7A,$00,$2E,$01,$2F,$01,$30,$01,$31,$01,$32,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text
db $00,$00,$00,$00,$00,$00,$7B,$00,$7C,$00,$7D,$00,$7E,$00,$7F,$00,$80,$00,$81,$00,$82,$00,$83,$00,$84,$00,$85,$00,$86,$00,$87,$00,$33,$01,$34,$01,$35,$01,$36,$01,$37,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text

db $00,$00,$00,$00,$00,$00,$88,$00,$89,$00,$8A,$00,$8B,$00,$8C,$00,$8D,$00,$8E,$00,$8F,$00,$90,$00,$91,$00,$92,$00,$93,$00,$94,$00,$38,$01,$39,$01,$3A,$01,$3B,$01,$3C,$01,$3D,$01,$3E,$01,$3F,$01,$40,$01,$41,$01,$42,$01,$43,$01,$44,$01,$00,$00,$00,$00,$00,$00 // Text
db $00,$00,$00,$00,$00,$00,$95,$00,$96,$00,$97,$00,$98,$00,$99,$00,$9A,$00,$9B,$00,$9C,$00,$9D,$00,$9E,$00,$9F,$00,$A0,$00,$A1,$00,$45,$01,$46,$01,$47,$01,$48,$01,$49,$01,$4A,$01,$4B,$01,$4C,$01,$4D,$01,$4E,$01,$4F,$01,$50,$01,$51,$01,$00,$00,$00,$00,$00,$00 // Text

db $00,$00,$00,$00,$00,$00,$A2,$00,$A3,$00,$A4,$00,$A5,$00,$A6,$00,$A7,$00,$A8,$00,$A9,$00,$AA,$00,$AB,$00,$AA,$00,$AC,$00,$AD,$00,$52,$01,$53,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text
db $00,$00,$00,$00,$00,$00,$AE,$00,$AF,$00,$B0,$00,$B1,$00,$B2,$00,$B3,$00,$B4,$00,$B5,$00,$B6,$00,$B7,$00,$B8,$00,$B9,$00,$BA,$00,$54,$01,$55,$01,$56,$01,$57,$01,$58,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text

db $00,$00,$00,$00,$00,$00,$BB,$00,$BC,$00,$BD,$00,$BE,$00,$BF,$00,$C0,$00,$C1,$00,$C2,$00,$C3,$00,$C4,$00,$C5,$00,$C6,$00,$C7,$00,$59,$01,$5A,$01,$5B,$01,$5C,$01,$5D,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text
db $00,$00,$00,$00,$00,$00,$C8,$00,$C9,$00,$CA,$00,$CB,$00,$CC,$00,$CD,$00,$CE,$00,$CF,$00,$C8,$00,$D0,$00,$D1,$00,$D2,$00,$D3,$00,$5E,$01,$5F,$01,$60,$01,$61,$01,$62,$01,$63,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text

db $00,$00,$00,$00,$00,$00,$D4,$00,$D5,$00,$D6,$00,$D7,$00,$D8,$00,$D9,$00,$DA,$00,$DB,$00,$DC,$00,$DD,$00,$DE,$00,$DF,$00,$E0,$00,$64,$01,$65,$01,$66,$01,$67,$01,$68,$01,$69,$01,$6A,$01,$6B,$01,$6C,$01,$0D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text
db $00,$00,$00,$00,$00,$00,$E1,$00,$E2,$00,$E3,$00,$E4,$00,$E5,$00,$E6,$00,$E7,$00,$E8,$00,$E9,$00,$EA,$00,$EB,$00,$EC,$00,$ED,$00,$6D,$01,$6E,$01,$6F,$01,$70,$01,$71,$01,$72,$01,$73,$01,$74,$01,$75,$01,$76,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // Text

db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

// Titlescreen tilemap (Menu)

org $40C46 //VRAM: D046
incbin "asm/bin/Puzzle Menu.bin"

// Titlescreen tilemap

org $3e000
incbin "asm/bin/Titlescreen.bin"

//==============================
// Sprite Priority change
//==============================

// Default sprite priority throughout the game.
org $11A0; base $C011A0
//and #$3000

// Change priority for a specific graphics for the EX mode
// We expanded the tile to cover more length, therefore, the title overlaps
// with the picross tiles on the screen (and titlescreen)
// The game sets a priority of 3 for all sprites in the game.
// We only want to change the priority for these tiles.
// To identify the tiles, we check the locate of the sprites we're
// writing on screen.
org $11FB; base $C011FB; fill $05, $EA
org $11FB; base $C011FB
jsr ChangeSpritePriority

org $FC45
ChangeSpritePriority:
pha

lda $06
cmp #$C10F // C10FE2 (EX level) && C10FD2 (Titlescreen): Picross tile sprite data
bne NotPicrossTiles

lda $05
and #$00F0
cmp #$00E0
beq PicrossTiles

cmp #$00D0
beq PicrossTiles

NotPicrossTiles:
pla
and #$cfff
ora $0b
rts

PicrossTiles:
pla
and #$cfff
ora #$2000
rts

//==============================
// Text speed increase
//==============================

// Wario and Mario screen
org $A1A1; base $C0A1A1
and #$0001

// Mario Tutoria screen
org $C17D; base $C0C17D
// Already a speed of 1
//and #$0001

//==============================
// Puzzle name height expansion
//==============================
// The game switches modes by scanline for the puzzle name after you complete a puzzle
// (and other screens for that matter).
// The font gets partially truncated, so let's extend the region by two pixels.
// The game uses a loop with comparisons to set up a region to DMA later.
// Special thanks to blizzz and oziphanto for help with this.

org $836d; base $c0836d
cpy #$00ac // cpy #$00aa

//==============================
// Titlescreen blue palette adjust (Picross text)
//==============================

// dark blue
org $44444
db $A0,$28
db $00,$41
// Shade for light blue part
db $00,$7A


// Light blue
org $4444E
db $E2,$69


//==============================
// Titlescreen (menu)
//==============================

//-------------
// Wario (blue)
//-------------
org $400C0

db $00,$00
db $00,$00
db $A0,$28
db $00,$41
db $00,$7A
db $CA,$49
db $40,$5D
db $E2,$69
db $FF,$7F
db $43,$72
db $84,$76
db $C8,$7A
db $0C,$7B
db $50,$7F
db $94,$7F
db $00,$00

//-------------
// Mario (Yellow)
//-------------

org $400A0
db $00,$00
db $00,$00
db $67,$00
db $6E,$1C
db $0F,$01
db $FF,$FF
db $F6,$34
db $3C,$41

db $FF,$FF
db $9F,$4D
db $FF,$FF //
db $77,$01 //
db $FF,$FF
db $1C,$02
db $BF,$02
db $00,$00

//-------------
// Mario's (NEW)
//-------------

org $400E0
db $00,$38
db $00,$00
db $00,$00
db $00,$00
db $00,$00
db $00,$00
db $00,$00
db $0E,$08
db $00,$00
db $1B,$10
db $86,$32
db $FF,$03
db $10,$02
db $FB,$7D
db $E7,$1C
db $00,$00

org $400E0
db $00,$00
db $1B,$10
db $54,$14
db $09,$04
db $FB,$7D
db $52,$55
db $0F,$01
db $A9,$28
db $01,$15
db $C4,$25
db $86,$32
db $77,$01
db $BF,$02
db $1C,$02
db $DF,$1A
db $00,$00

//==============================
// Credits
//==============================

org $ffa80

db "------------------------------------------------------"
db "                        Credits                       "
db "------------------------------------------------------"
db "FCandChill: Hacking, translation, graphics            "
db "kumori#8931: Translation                              "
db "Senn: Kanji id                                        "
db "LuigiBlood#9296: Titlescreen feedback                 "
db "furrykef#4595: Onspot translation                     "
db "blizzz & oziphanto: Puzzle name bug fix               "
db "togemet2: Was there                                   "
db "Kajitani-Eizan#9804: Feedback                         "
db "kandowontu#2047: Feedback/beta tester                 "
db "blameitontherobot#7777: Original title screen gfx     "
db "------------------------------------------------------"
db "                                                      "
db "------------------------------------------------------"
db "                   Bug Reporters                      "
db "------------------------------------------------------"
db "supersonicjc: Wario's EX-K puzzle issue.              "
db "svenge: Puzzle picture disappearing issue.            "
db "Eldrethor: You have 'a 30 minutes' to complete each   "
db "           puzzle typo.                               "
db "VVV18: Music selection issue                          "