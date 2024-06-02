set BISON_PATH=E:\Softwares\Dev\win_flex_bison-2.5.25\win_bison.exe
set FLEX_PATH=E:\Softwares\Dev\win_flex_bison-2.5.25\win_flex.exe

set GRAMMAR_PATH=%~dp0..\Grammar\
set OUTPUT_PATH=%~dp0..\

%FLEX_PATH% -o%OUTPUT_PATH%MaterialScanner.cpp --header-file=%OUTPUT_PATH%MaterialScanner.h --wincompat --nounistd --noline -d %GRAMMAR_PATH%MaterialScanner.flex
%BISON_PATH% -o %OUTPUT_PATH%MaterialParser.cpp --header=%OUTPUT_PATH%MaterialParser.h -l -v -t %GRAMMAR_PATH%MaterialParser.bison

python %~dp0ModifyParser.py %OUTPUT_PATH%

pause