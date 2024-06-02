# -*- coding: UTF-8 -*-

import os
import sys

def ModifyFile(filePath):
    if not os.path.exists(filePath):
        return
    
    file = open(filePath, "r+")

    lines = file.readlines()
    file.seek(0)

    for line in lines:
        newLine = line.replace("<FlexLexer.h>", '''"FlexLexer.h"''')
        file.write(newLine)

    file.close()

if __name__ == "__main__":
    kBasePath = r"I:\Sources\ZEngineMaterialParser"
    if len(sys.argv) >= 2:
        kBasePath = sys.argv[1]
    kFileName = r"MaterialScanner"


    ModifyFile(kBasePath + os.path.sep + kFileName + ".h")
    ModifyFile(kBasePath + os.path.sep + kFileName + ".cpp")
