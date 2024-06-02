%require "3.2"
%language "C++"

%define api.parser.class {MaterialParser}
%define api.value.type variant
%param { yyFlexLexer& scanner_ }
%parse-param { Material& Material_ }

%code requires
{
#include "ZMaterialDefines.h"

class yyFlexLexer;
}

%code
{
#include "MaterialScanner.h"

static int yylex(yy::MaterialParser::value_type* value, yyFlexLexer& scanner)
{
    return scanner.yylex(value);
}
}

%token TOK_MATERIAL TOK_SHADER TOK_PASS
%token TOK_ZTEST TOK_CULL TOK_BLEND 
%token TOK_FLOAT TOK_DOUBLE
%token TOK_ZCLIP
%token TOK_ZWRITE 
%token TOK_TRUE TOK_FALSE
%token TOK_STENCIL TOK_REF TOK_READMASK TOK_WRITEMASK TOK_STENCIL_FRONT TOK_STENCIL_BACK
%token TOK_COMP TOK_OPPASS TOK_OPFAIL TOK_OPZFAIL

%token TVAL_BLEND_FACTOR TVAL_BLEND_OPERATION
%token TVAL_STENCIL_OPERATION TVAL_STENCIL_COMPARE_FUNCTION 
%token TVAL_INTEGER TVAL_FLOAT TVAL_ZTEST TVAL_CULLORIENT TVAL_ZWRITE

%token <std::string> TVAL_ID TVAL_STRING TVAL_VARREF
%token TOK_LEFT_BRACE TOK_RIGHT_BRACE TOK_SEMICOLON
%token TOK_VERTEXSHADER TOK_FRAGMENTSHADER

%type <Material> Material
%type <std::vector<Pass>> Passes
%type <Pass> Pass PassBlock
%type <StencilOperationState> StencilBlock
%type <StencilState> StencilState
%type <EStencilCompareFunction> StencilCompareFunction TVAL_STENCIL_COMPARE_FUNCTION
%type <EStencilOperation> StencilOperation TVAL_STENCIL_OPERATION
%type <EBlendFactor> BlendFactor TVAL_BLEND_FACTOR
%type <EBlendOperation> BlendOperation TVAL_BLEND_OPERATION
%type <ECullingType> CullValue TVAL_CULLORIENT
%type <EZTestMode> ZTestValue TVAL_ZTEST
%type <EZWriteMode> ZWriteValue TVAL_ZWRITE
%type <int> TVAL_INTEGER 
%type <float> NumberValue TVAL_FLOAT 
%type <RenderState> RenderState 
%type <bool> BoolValue TOK_TRUE TOK_FALSE
%type <Shader> VertexShader FragmentShader


%%

Material: TOK_MATERIAL TVAL_STRING TOK_LEFT_BRACE Passes TOK_RIGHT_BRACE
                                    {
                                        $$.passes = $4;
                                        Material_ = $$;
                                    }

Passes: Pass          { $$.emplace_back($1); }
    | Passes Pass   { $$.emplace_back($2); }

Pass: TOK_PASS TVAL_STRING TOK_LEFT_BRACE PassBlock TOK_RIGHT_BRACE
                            {
                                $$ = $4;
                            }

PassBlock: {}
    | PassBlock RenderState  {$$ = $1; $$.renderState = $2;}
    | PassBlock VertexShader {$$ = $1; $$.shaders.push_back(Shader());}
    | PassBlock FragmentShader {$$ = $1; $$.shaders.push_back(Shader());}

RenderState:                                             {}
    | RenderState TOK_ZTEST ZTestValue TOK_SEMICOLON                   { $$ = $1; $$.zTestMode = $3; }
    | RenderState TOK_ZWRITE ZWriteValue TOK_SEMICOLON                  { $$ = $1; $$.zWriteMode = $3; }
    | RenderState TOK_ZCLIP BoolValue TOK_SEMICOLON                    { $$ = $1; $$.zClipType = $3; }
    | RenderState TOK_CULL CullValue TOK_SEMICOLON                    { $$ = $1; $$.cullingType = $3; }

    | RenderState TOK_STENCIL TOK_LEFT_BRACE StencilState TOK_RIGHT_BRACE       { $$ = $1; $$.stencilState = $4; }

    | RenderState TOK_BLEND TVAL_INTEGER BlendOperation BlendFactor BlendFactor BlendFactor BlendFactor { $$ = $1; BlendState blendState; blendState.operation = $4; blendState.srcFactor = $5; blendState.dstFactor = $6; blendState.srcFactor = $7; blendState.dstFactor = $8;  }

StencilState: /* empty */               {}
    | StencilState TOK_STENCIL_FRONT TOK_LEFT_BRACE StencilBlock TOK_RIGHT_BRACE      { $$.front = $4; }
    | StencilState TOK_STENCIL_BACK TOK_LEFT_BRACE StencilBlock TOK_RIGHT_BRACE      { $$.back = $4; }

StencilBlock: /* empty */                       {}
    | StencilBlock TOK_REF TVAL_INTEGER TOK_SEMICOLON              { $$ = $1; $$.ref = $3; }
    | StencilBlock TOK_READMASK TVAL_INTEGER TOK_SEMICOLON          { $$ = $1; $$.readMask = $3; }
    | StencilBlock TOK_WRITEMASK TVAL_INTEGER TOK_SEMICOLON        { $$ = $1; $$.writeMask = $3; }
    | StencilBlock TOK_COMP StencilCompareFunction TOK_SEMICOLON             { $$ = $1; $$.compareFunction = $3; }
    | StencilBlock TOK_OPPASS StencilOperation TOK_SEMICOLON       { $$ = $1; $$.passOperation = $3; }
    | StencilBlock TOK_OPFAIL StencilOperation TOK_SEMICOLON       { $$ = $1; $$.failOperation = $3; }
    | StencilBlock TOK_OPZFAIL StencilOperation TOK_SEMICOLON      { $$ = $1; $$.depthFailOperation = $3; }

VertexShader: TOK_VERTEXSHADER TOK_LEFT_BRACE TOK_RIGHT_BRACE {}

FragmentShader: TOK_FRAGMENTSHADER TOK_LEFT_BRACE TOK_RIGHT_BRACE {}


/* property references
 * ------------------------- */
NumberValue: TVAL_INTEGER  { $$ = $1; }

BlendFactor: TVAL_BLEND_FACTOR        { $$ = $1; }

BlendOperation: TVAL_BLEND_OPERATION  { $$ = $1; }

ZTestValue : TVAL_ZTEST    { $$ = $1; }

ZWriteValue : TVAL_ZWRITE    { $$ = $1; }

StencilOperation: TVAL_STENCIL_OPERATION    { $$ = $1; }

StencilCompareFunction: TVAL_STENCIL_COMPARE_FUNCTION    { $$ = $1; }

CullValue: TVAL_CULLORIENT   { $$ = $1; }

BoolValue: TOK_TRUE                              { $$ = true; }
    | TOK_FALSE                             { $$ = false;}

%%

void yy::MaterialParser::error(const std::string& msg) {
    std::cerr << msg << '\n';
}