#include <fstream>
#include <iostream>

#include "ZMaterialScanner.h"
#include "ZMaterialParser.h"

int main() {
    std::fstream fs{"TestCases/SampleMaterial.Material"}; 
    if (!fs.is_open())
    {
        std::cout << "File not found!" << std::endl;
        return 0;
    }

    yyFlexLexer scanner;
    scanner.set_debug(1);
    scanner.switch_streams(&fs, nullptr);

    Material* material = new Material();;
    yy::ZMaterialParser parser{ scanner, material };
    parser.set_debug_level(1);
    parser.parse();

    fs.close();

    return 0;
}