[//]: <> (This readme is in the markdown format. Please preview in a markdown parser.)

# Mario's Super Picross: English Translation

## About
This repository contains source code for patches and tools to compile an English translation of Mario's Super Picross for the Super Famicom.

## Support the Creators
If you like this game, consider supporting Nintendo by subscribing to Nintendo Switch Online (or the modern equivalent this game is available on) or buying games from [Jupiter's Picross e series.](https://en.wikipedia.org/wiki/Picross_e) Roms are not (and will not be) provided in this repository, and building the translated rom will require a legally acquired rom image.

## Folders
* `asm`
	* Contains the asm files which are to be compiled with xkas
* `roms`
	* Use this to store your roms
* `script`
	* Contains the dumped script in `Script.json` and `Script VC.json`. They contain the Japanese script and the English translation.
        * The former contains a translated script for the Super Famicom release and the latter contains a translated script for the Virtual Console release.
        * If your source rom is based off the Virtual Console release, delete `Script.json` and rename `Script VC.json` to `Script.json`.
* `tables`
	* Contains table files
* `tools`
	* `cyproAce`
		* A script editor 
	* `spiro`
		* Script dumper and inserter
	* `xkas`
		* Applies the assembly patches
    * `superFamicheck`
        * Contains a tool to correct the rom's checksum
    * `compression`
        * A tool to insert the compressed graphics
* `compression`
    * Folders to manage the compressed assets

## Manual
One of the few projects of my to not have a manual translation. If you find a high quality manual scan, let me know.

## Instructions
The tools are coded in C#. You'll have to mess with Wine if you want them to run in Linux. You'll also have to rewrite the bat files, which aren't complicated at all.

* If you want to dump the script (the Japanese and English script are already included in this repository), you can dump it by executing the bat file `Dump.bat` by double clicking it.
    * Keep in mind this overwrites the existing `script.json`.
* To generate a SNES rom file with the translation and execute the bat file `Write.bat` by double clicking it.
    * Keep in mind, you will need to run `Dump.bat` first to retrieve the decompressed assets.

## Changelog
* 2021 November 15th: 1.5
	* There's now a Nintendo Switch Online translation patch. Now you can enjoy puzzles that don't follow the difficulty curve... English!
	* An issue regarding the music selection menu was resolved. Later in the game, the amount of songs expands from 3 to 4. When adjusting the menu sprites, I didn't realize this, so the graphics didn't display the extra option.
	* Adjusted the logo graphics and tutorial graphic... again. I don't usually like improving games, but the the logo on the menu screen was improved by expanding the palettes to better match the ones on the title screen.
	* The SNES header adjusted by updating the version number and region. I was considering disabling the game's save file sanity check to modify the header's game code, but it would mess with save file cross compatibility between the original version and this fan translation.
	* Fixed a bug where the font was getting cut off after you solve a puzzle. This is because I extended some of the characters (`p` and `q` for example) in the font by a pixel. After corrupting the VRAM, it appeared the game was changing the tileset after a scanline. After discussing with people, some people thought the game was running on either Mode 5 or 6 and is switching modes mid-scanline. It didn't look like it was. As far as I could tell it was running on Mode 1. Some people thought it was writing to either BG12NBA or BG34NBA registers. As far as I could tell it was not. Some people thought it had something to do with IRQs. Again, as far as I could tell it was not. So what *was* the game doing and why? I honestly had no idea. After banging my head for hours setting breakpoints at registers, two generous people (oziphanto and blizzz) stepped up to the plate, downloaded the hack, and got their hands dirty. Turns out that because the BGMode was being modified by indirect DMA transfers, I wasn't seeing it changed via standard breakpoints. This can be observed by inspecting DMAs in the event viewer in MESEN-S. Once located, each value indicated in the event viewer can be searched in the memory viewer. What we find in the memory viewer would be data that would later be read by a DMA. From there, a breakpoint can be set to see how this data is being written. The logic to write to this area has been adjusted to display two extra scanlines of the font, just to be safe. For what it's worth, nobody but me noticed this. It was a great learning opportunity, so again, big thanks to oziphanto and blizzz.
* 2021 October 10th: 1.4
	* A handful of puzzle names were adjusted to fix the title casing, to make the puzzle names more accurate to the picture, and to use terminology more commonly used in English vernacular.
	* Start quote graphic in font adjusted.
	* There's some lines from Mario and Wario that I thought were unused / didn't know how to trigger. If you skip some puzzles, they give a message encouraging you to go back and complete them. The lines were cleaned up given this context.
	* You have "a 30 minutes" to complete each puzzle typo was fixed.
* 2021 October 8th: 1.3
	* Minor tweak to the text centering for puzzle names after a puzzle is completed.
* 2021 October 7th: 1.2
	* Fixed an issue where Wario's EX-K puzzle's name was not showing up. The text centering code was adjusted to allow for longer names.
	* Fixed an issue where the "の (No)" puzzle's picture was disappearing and some other puzzle animations weren't playing.
* 2021 October 6th: 1.1
	* Cleaned up the tutorial menu graphic.
* 2021 October 6th: 1.0
	* Initial release

## Credits

### Main Team
* FCandChill
    * Hacking, puzzle translations, graphics, script revision
* kumori#8931
    * Text translation 
* Senn
    * Kanji identification
* LuigiBlood#9296:
    * Title screen feedback
* furrykef#4595
    * Spot translation
* blizzz & oziphanto:
    * Puzzle name bug fix
* togemet2
    * Was there
* Kajitani-Eizan#9804
    * Feedback
* kandowontu#2047
    * Feedback/beta tester
* blameitontherobot#7777
    * Original title screen gfx

### Bug Reporters
* supersonicjc
	* Wario's EX-K puzzle issue.
* svenge
	* Puzzle picture disappearing issue.
* Eldrethor
	* You have "a 30 minutes" to complete each puzzle typo.
* VVV18
	* Music menu selection issue
    * Was there
