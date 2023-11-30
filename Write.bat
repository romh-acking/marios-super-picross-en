::Roms
set baseImage=roms\Mario no Super Picross (Japan).sfc
set newImage=roms\Mario no Super Picross (NEW).sfc

::Compression
set uncompressedOldPath=%cd%\compression\Original Uncompressed
set uncompressedNewPath=%cd%\compression\New Uncompressed
set compressedNewPath=%cd%\compression\New Compressed
set newOnly=%cd%\compression\New Only

::Folders
set projectFolder=%cd%

::Tools
set toolsFolder=%projectFolder%\tools
set xkasFolder=%toolsFolder%\xkas
set spiroFolder=%toolsFolder%\spiro
set compressionToolFolder=%toolsFolder%\compression
set checksumFolder=%toolsFolder%\superFamicheck

cd "%projectFolder%"

copy "%baseImage%" "%newImage%"

xcopy /s /y "%uncompressedOldPath%" "%uncompressedNewPath%"
xcopy /s /y "%newOnly%" "%uncompressedNewPath%"

::Write script
"%spiroFolder%\Spiro.exe" /ProjectDirectory "%projectFolder%" /Write
@pause

::Apply patches
"%xkasFolder%\xkas+.exe" -o "%newImage%" "asm\main.asm"
"%xkasFolder%\xkas+.exe" -o "%newImage%" "asm\menu.asm"

::Add compressed graphics
"%compressionToolFolder%\Mario Picross GFX.exe" Write "%newImage%" "%uncompressedNewPath%" "%compressedNewPath%"

:: Correct checksum (could have used SuperFamicheck.)
"%checksumFolder%\superfamicheck.exe" "%cd%\%newImage%" -f -o "%cd%\%newImage%"

"%newImage%"
::@pause