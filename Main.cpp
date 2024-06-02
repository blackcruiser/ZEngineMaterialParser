#include <fstream>

#include "MaterialScanner.h"
#include "MaterialParser.h"

int main() {
    std::fstream fs{"TestCases/SampleMaterial.Material"}; 
    if (!fs.is_open())
        return 0;

    yyFlexLexer scanner;
    //scanner.set_debug(1);
    scanner.switch_streams(&fs, nullptr);

    Material material;
    yy::MaterialParser parser{ scanner, material };
    //parser.set_debug_level(1);
    parser.parse();

    fs.close();

    return 0;
}