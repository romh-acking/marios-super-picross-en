::Roms
set baseImage=roms\Mario no Super Picross (Japan).sfc

::Folders
set projectFolder=%cd%
set toolsFolder=%projectFolder%\tools
set spiroFolder=%toolsFolder%\spiro
set compressionToolFolder=%toolsFolder%\compression
set compressionOutputFolder=%projectFolder%\compression\Original Uncompressed

cd "%projectFolder%"

::Dump script
"%spiroFolder%\Spiro.exe" /ProjectDirectory "%projectFolder%" /DumpScript

::Add compressed graphics
"%compressionToolFolder%\Mario Picross GFX.exe" Dump "%baseImage%" "%compressionOutputFolder%"

@pause