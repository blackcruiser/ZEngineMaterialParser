%require "3.2"
%language "C++"

%define api.parser.class {ZMaterialParser}
%define api.value.type variant
%param { yyFlexLexer& scanner_ }
%parse-param { Material* Material_ }

%code top
{
#include "ZMaterialScanner.h"

static int yylex(yy::ZMaterialParser::value_type* value, yyFlexLexer& scanner)
{
    return scanner.yylex(value);
}
}

%code requires
{
#include "ZMaterialDefines.h"

class yyFlexLexer;
}

%token KEY_MATERIAL KEY_PASS
%token KEY_BLEND VALUE_BLEND_FACTOR VALUE_BLEND_OPERATION
%token KEY_ZWRITE
%token KEY_ZCLIP
%token KEY_ZTEST VALUE_ZTEST
%token KEY_CULLING VALUE_CULLING_TYPE
%token KEY_STENCIL KEY_STENCIL_FRONT KEY_STENCIL_BACK
%token VALUE_STENCIL_COMPARE_FUNCTION KEY_STENCIL_COMPARE_FUNCTION
%token KEY_STENCIL_OPERATION_PASS KEY_STENCIL_OPERATION_FAIL KEY_STENCIL_OPERATION_ZFAIL VALUE_STENCIL_OPERATION
%token KEY_STENCIL_REF KEY_STENCIL_READMASK KEY_STENCIL_WRITEMASK 

%token VALUE_BOOL
%token VALUE_FLOAT VALUE_INTEGER
%token VALUE_STRING


%type <Material*> Material
%type <Pass*> Pass
%type <RenderState*> RenderState
%type <EBlendOperation> VALUE_BLEND_OPERATION
%type <EBlendFactor> VALUE_BLEND_FACTOR
%type <ECullingType> VALUE_CULLING_TYPE
%type <EZTestMode> VALUE_ZTEST
%type <StencilState*> StencilState
%type <StencilOperationState*> StencilBlock
%type <EStencilCompareFunction> VALUE_STENCIL_COMPARE_FUNCTION
%type <EStencilOperation> VALUE_STENCIL_OPERATION

%type <bool> VALUE_BOOL
%type <float> VALUE_FLOAT NumberValue
%type <int32_t> VALUE_INTEGER
%type <std::string> VALUE_STRING


%start Material


%%

Material: KEY_MATERIAL VALUE_STRING '{' Passes '}'        { $$ = Material_; Material_->name = $2; }

Passes: /* empty */    { }
    | Passes Pass                                         { Material_->passes.push_back($2); }

Pass: KEY_PASS VALUE_STRING '{' RenderState '}'           { $$ = new Pass(); $$->name = $2; $$->renderState = $4; }

RenderState: /* empty */                                  { $$ = new RenderState(); }
    | RenderState KEY_ZTEST VALUE_ZTEST                   { $$ = $1; $1->zTestMode = $3; }
    | RenderState KEY_ZWRITE VALUE_BOOL                   { $$ = $1; $1->zWriteMode = static_cast<EZWriteMode>($3); }
    | RenderState KEY_ZCLIP VALUE_BOOL                    { $$ = $1; $1->zClipType = $3; }
    | RenderState KEY_CULLING VALUE_CULLING_TYPE          { $$ = $1; $1->cullingType = static_cast<ECullingType>($3); }

    | RenderState KEY_STENCIL '{' StencilState '}'        { $$ = $1; $1->stencilState = $4; }

    | RenderState KEY_BLEND VALUE_INTEGER VALUE_BLEND_OPERATION VALUE_BLEND_FACTOR VALUE_BLEND_FACTOR ',' VALUE_BLEND_FACTOR VALUE_BLEND_FACTOR { 
        BlendState* blendState = new BlendState();
        blendState->operation = $4;
        blendState->srcFactor = $5;
        blendState->dstFactor = $6;
        blendState->srcFactor = $8;
        blendState->dstFactor = $9;
        $1->blendState.push_back(blendState);
        $$ = $1;
    }

StencilState: /* empty */                                       { $$ = new StencilState(); }
    | StencilState KEY_STENCIL_FRONT '{' StencilBlock '}'       { $$ = $1; $1->front = $4; }
    | StencilState KEY_STENCIL_BACK '{' StencilBlock '}'        { $$ = $1; $1->back = $4; }

StencilBlock: /* empty */                       { $$ = new StencilOperationState(); }
    | StencilBlock KEY_STENCIL_REF VALUE_INTEGER                                { $$ = $1; $$->ref = $3; }
    | StencilBlock KEY_STENCIL_READMASK VALUE_INTEGER                           { $$ = $1; $$->readMask = $3; }
    | StencilBlock KEY_STENCIL_WRITEMASK VALUE_INTEGER                          { $$ = $1; $$->writeMask = $3; }
    | StencilBlock KEY_STENCIL_COMPARE_FUNCTION VALUE_STENCIL_COMPARE_FUNCTION  { $$ = $1; $$->compareFunction = static_cast<EStencilCompareFunction>($3); }
    | StencilBlock KEY_STENCIL_OPERATION_PASS VALUE_STENCIL_OPERATION           { $$ = $1; $$->passOperation = static_cast<EStencilOperation>($3); }
    | StencilBlock KEY_STENCIL_OPERATION_FAIL VALUE_STENCIL_OPERATION           { $$ = $1; $$->failOperation = static_cast<EStencilOperation>($3); }
    | StencilBlock KEY_STENCIL_OPERATION_ZFAIL VALUE_STENCIL_OPERATION          { $$ = $1; $$->depthFailOperation = static_cast<EStencilOperation>($3); }


/* property references
 * ------------------------- */

NumberValue: VALUE_INTEGER      { $$ = static_cast<float>($1); }
    | VALUE_FLOAT               { $$ = $1; }

%%


void yy::ZMaterialParser::error(const std::string& msg) {
    std::cerr << msg << '\n';
}
