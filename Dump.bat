::Roms
set baseImage=roms\Mario no Super Picross (Japan).sfc

::Folders
set projectFolder=%cd%
set toolsFolder=%projectFolder%\tools
set spiroFolder=%toolsFolder%\spiro

cd "%projectFolder%"

::Dump script
"%spiroFolder%\Spiro.exe" /ProjectDirectory "%projectFolder%" /DumpScript
@pause