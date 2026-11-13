del autorun.exe
del TestAll.exe
del AutorunCD_log.txt
del autorun_*.rar
cd src
dcc32 autorun.dpr -E..\
cd ..
del LuaDelphi\*.dcu
del src\*.~*
del src\*.dcu
del src\*.ddp
rar a -r -ag -xmsi -xSetup -xsrc\__history -xCVS autorun_ -x.svn -xLuaDelphi -xSrc -ximg-src -xDelphiXML