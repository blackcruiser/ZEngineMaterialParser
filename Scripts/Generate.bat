set BISON_PATH=E:\Softwares\Devs\win_flex_bison-2.5.25\win_bison.exe
set FLEX_PATH=E:\Softwares\Devs\win_flex_bison-2.5.25\win_flex.exe

set GRAMMAR_PATH=%~dp0..\Grammars\
set OUTPUT_PATH=%~dp0..\Sources\

%FLEX_PATH% --outfile=%OUTPUT_PATH%ZMaterialScanner.cpp --header-file=%OUTPUT_PATH%ZMaterialScanner.h --wincompat --noline --debug --verbose %GRAMMAR_PATH%MaterialScanner.flex
%BISON_PATH% --output=%OUTPUT_PATH%ZMaterialParser.cpp --header=%OUTPUT_PATH%ZMaterialParser.h --no-lines --debug --verbose %GRAMMAR_PATH%MaterialParser.bison

python %~dp0ModifyParser.py %OUTPUT_PATH%
pause