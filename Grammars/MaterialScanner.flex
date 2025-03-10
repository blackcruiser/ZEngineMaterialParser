%{
#include "ZMaterialDefines.h"
#include "ZMaterialParser.h"

#define YY_DECL int yyFlexLexer::yylex(yy::ZMaterialParser::semantic_type *yylval)

using namespace yy;
%}

%option c++ interactive noyywrap noyylineno nodefault

DIGIT                       [0-9]
NEWLINE                     \r\n|\n\r|\n|\r

%s _ZTEST _STENCILSTATE _STENCILBLOCK _BLEND _CULLING


%%

Material                        { return ZMaterialParser::token::KEY_MATERIAL; }
Pass                            { return ZMaterialParser::token::KEY_PASS; }

VertexShader                    { return ZMaterialParser::token::KEY_VERTEX_SHADER; }
FragmentShader                  { return ZMaterialParser::token::KEY_FRAGMENT_SHADER; }

Blend                           { BEGIN (_BLEND); return ZMaterialParser::token::KEY_BLEND; }
<_BLEND>{
    Zero                        { yylval->build<EBlendFactor>(EBlendFactor::Zero); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    One                         { yylval->build<EBlendFactor>(EBlendFactor::One); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    SrcColor                    { yylval->build<EBlendFactor>(EBlendFactor::SrcColor); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    SrcAlpha                    { yylval->build<EBlendFactor>(EBlendFactor::SrcAlpha); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    DstColor                    { yylval->build<EBlendFactor>(EBlendFactor::DstColor); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    DstAlpha                    { yylval->build<EBlendFactor>(EBlendFactor::DstAlpha); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    OneMinusSrcColor            { yylval->build<EBlendFactor>(EBlendFactor::OneMinusSrcColor); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    OneMinusDstColor            { yylval->build<EBlendFactor>(EBlendFactor::OneMinusDstColor); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    OneMinusSrcAlpha            { yylval->build<EBlendFactor>(EBlendFactor::OneMinusSrcAlpha); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    OneMinusDstAlpha            { yylval->build<EBlendFactor>(EBlendFactor::OneMinusDstAlpha); return ZMaterialParser::token::VALUE_BLEND_FACTOR; }
    Add                         { yylval->build<EBlendOperation>(EBlendOperation::Add); return ZMaterialParser::token::VALUE_BLEND_OPERATION; }
    Sub                         { yylval->build<EBlendOperation>(EBlendOperation::Sub); return ZMaterialParser::token::VALUE_BLEND_OPERATION; }
    {NEWLINE}                   { BEGIN (INITIAL); }
}

ZWrite                          { return ZMaterialParser::token::KEY_ZWRITE; }
ZClip                           { return ZMaterialParser::token::KEY_ZCLIP; }
ZTest                           { BEGIN(_ZTEST); return ZMaterialParser::token::KEY_ZTEST; }
<_ZTEST>{
    Never                       { yylval->build<EZTestMode>(EZTestMode::Never);        BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
    Less                        { yylval->build<EZTestMode>(EZTestMode::Less);        BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
    LessEqual                   { yylval->build<EZTestMode>(EZTestMode::LessEqual);        BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
    Equal                       { yylval->build<EZTestMode>(EZTestMode::Equal);    BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
    GreaterEqual                { yylval->build<EZTestMode>(EZTestMode::GreaterEqual);    BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
    Greater                     { yylval->build<EZTestMode>(EZTestMode::Greater);    BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
    NotEqual                    { yylval->build<EZTestMode>(EZTestMode::NotEqual);    BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
    Always                      { yylval->build<EZTestMode>(EZTestMode::Always);    BEGIN (INITIAL); return ZMaterialParser::token::VALUE_ZTEST; }
}

CullingType                     { BEGIN (_CULLING); return ZMaterialParser::token::KEY_CULLING; }
<_CULLING>{
    Front                       { yylval->build<ECullingType>(ECullingType::Front); return ZMaterialParser::token::VALUE_CULLING_TYPE; }
    Back                        { yylval->build<ECullingType>(ECullingType::Back);  return ZMaterialParser::token::VALUE_CULLING_TYPE; }
    None                        { yylval->build<ECullingType>(ECullingType::None);  return ZMaterialParser::token::VALUE_CULLING_TYPE; }
    {NEWLINE}                   { BEGIN (INITIAL); }
}

Stencil                         { BEGIN (_STENCILSTATE); return ZMaterialParser::token::KEY_STENCIL; }
<_STENCILSTATE>{
    Front                       { BEGIN (_STENCILBLOCK); return ZMaterialParser::token::KEY_STENCIL_FRONT; }
    Back                        { BEGIN (_STENCILBLOCK); return ZMaterialParser::token::KEY_STENCIL_BACK; }
    \}                          { BEGIN (INITIAL); return '}'; }
}

<_STENCILBLOCK>{
    Ref                         { return ZMaterialParser::token::KEY_STENCIL_REF; }
    ReadMask                    { return ZMaterialParser::token::KEY_STENCIL_READMASK; }
    WriteMask                   { return ZMaterialParser::token::KEY_STENCIL_WRITEMASK; }
    CompareFunction             { return ZMaterialParser::token::KEY_STENCIL_COMPARE_FUNCTION; }
    PassOperation               { return ZMaterialParser::token::KEY_STENCIL_OPERATION_PASS; }
    FailOperation               { return ZMaterialParser::token::KEY_STENCIL_OPERATION_FAIL; }
    ZFailOperation              { return ZMaterialParser::token::KEY_STENCIL_OPERATION_ZFAIL; }

    Never                       { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Never);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }
    Less                        { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Less);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }
    Equal                       { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Equal);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }
    LessEqual                   { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::LEqual);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }
    Greater                     { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Greater);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }
    NotEqual                    { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::NotEqual);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }
    GreaterEqual                { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::GEqual);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }
    Always                      { yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Always);    return ZMaterialParser::token::VALUE_STENCIL_COMPARE_FUNCTION; }

    Keep                        { yylval->build<EStencilOperation>(EStencilOperation::Keep);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    Zero                        { yylval->build<EStencilOperation>(EStencilOperation::Zero);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    Replace                     { yylval->build<EStencilOperation>(EStencilOperation::Replace);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    IncreaseSaturate            { yylval->build<EStencilOperation>(EStencilOperation::IncreaseSaturate);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    DecreaseSaturate            { yylval->build<EStencilOperation>(EStencilOperation::DecreaseSaturate);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    Invert                      { yylval->build<EStencilOperation>(EStencilOperation::Invert);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    IncreaseWrap                { yylval->build<EStencilOperation>(EStencilOperation::IncreaseWrap);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    DecreaseWrap                { yylval->build<EStencilOperation>(EStencilOperation::DecreaseWrap);    return ZMaterialParser::token::VALUE_STENCIL_OPERATION; }
    \}                          { BEGIN (_STENCILSTATE); return '}'; }
}

True                            { yylval->build<bool>(true); return ZMaterialParser::token::VALUE_BOOL; }
False                           { yylval->build<bool>(false); return ZMaterialParser::token::VALUE_BOOL; }
Enable                          { yylval->build<bool>(true); return ZMaterialParser::token::VALUE_BOOL; }
Disable                         { yylval->build<bool>(false); return ZMaterialParser::token::VALUE_BOOL; }

-?{DIGIT}+("."({DIGIT}*))+      { yylval->build<float>(atof(yytext)); return ZMaterialParser::token::VALUE_FLOAT; }
-?"."{DIGIT}+                   { yylval->build<float>(atof(yytext)); return ZMaterialParser::token::VALUE_FLOAT; }
-?{DIGIT}+                      { yylval->build<float>(atof(yytext)); return ZMaterialParser::token::VALUE_INTEGER; }

\"[^\"]*\"                      {
        std::string text(yytext);
        yylval->build<std::string>(text.substr(1, text.size() - 2));
        return ZMaterialParser::token::VALUE_STRING;
    }

[ \t]*                          { /* whitespace */ }
"\/\/"[^\n\r]*
{NEWLINE}                       { yylineno++; }

.                               {return *yytext;}

%%