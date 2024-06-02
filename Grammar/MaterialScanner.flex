%{
#include "ZMaterialDefines.h"
#include "MaterialParser.h"

#define YY_DECL int yyFlexLexer::yylex(yy::MaterialParser::semantic_type *yylval)

using namespace yy;
%}

%option c++ interactive noyywrap noyylineno nodefault

DIGIT		[0-9]

%s _ZTEST _STENCIL _STENCIL_INNER

%%
Material					{ return MaterialParser::token::TOK_MATERIAL; }
Pass						{ return MaterialParser::token::TOK_PASS; }


True						{ return MaterialParser::token::TOK_TRUE; }
False						{ return MaterialParser::token::TOK_FALSE; }

ZWrite						{ return MaterialParser::token::TOK_ZWRITE; }
ZClip						{ return MaterialParser::token::TOK_ZCLIP; }
ZTest						{ BEGIN(_ZTEST); return MaterialParser::token::TOK_ZTEST; }
<_ZTEST>{
	Never					{ yylval->build<EZTestMode>(EZTestMode::Never);		BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
	Less					{ yylval->build<EZTestMode>(EZTestMode::Less);		BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
	LEqual					{ yylval->build<EZTestMode>(EZTestMode::LessEqual);		BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
	Equal					{ yylval->build<EZTestMode>(EZTestMode::Equal);	BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
	GEqual					{ yylval->build<EZTestMode>(EZTestMode::GreaterEqual);	BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
	Ereater					{ yylval->build<EZTestMode>(EZTestMode::Greater);	BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
	NEqual					{ yylval->build<EZTestMode>(EZTestMode::NotEqual);	BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
	Always					{ yylval->build<EZTestMode>(EZTestMode::Always);	BEGIN (INITIAL); return MaterialParser::token::TVAL_ZTEST;}
}

Stencil						{ BEGIN (_STENCIL); return MaterialParser::token::TOK_STENCIL; }
<_STENCIL>{
	Front					{ BEGIN (_STENCIL_INNER); return MaterialParser::token::TOK_STENCIL_FRONT;}
	Back					{ BEGIN (_STENCIL_INNER); return MaterialParser::token::TOK_STENCIL_BACK;}
	\}						{ BEGIN (INITIAL); return MaterialParser::token::TOK_RIGHT_BRACE; }
}

<_STENCIL_INNER>{
	Ref						{ return MaterialParser::token::TOK_REF;}
	ReadMask				{ return MaterialParser::token::TOK_READMASK;}
	WriteMask				{ return MaterialParser::token::TOK_WRITEMASK;}
	CompareFunction			{ return MaterialParser::token::TOK_COMP;}
	PassOperation			{ return MaterialParser::token::TOK_OPPASS;}
	FailOperation			{ return MaterialParser::token::TOK_OPFAIL;}
	ZFailOperation			{ return MaterialParser::token::TOK_OPZFAIL;}

	Never					{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Never);			return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}
	Less					{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Less);			return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}
	Equal					{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Equal);			return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}
	LEqual					{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::LEqual);		return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}
	Greater					{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Greater);		return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}
	NEqual				{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::NotEqual);		return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}
	GEqual					{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::GEqual);		return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}
	Always					{ yylval->build<EStencilCompareFunction>(EStencilCompareFunction::Always);		return MaterialParser::token::TVAL_STENCIL_COMPARE_FUNCTION;}

	Keep					{ yylval->build<EStencilOperation>(EStencilOperation::Keep);		return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	Zero					{ yylval->build<EStencilOperation>(EStencilOperation::Zero);		return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	Replace					{ yylval->build<EStencilOperation>(EStencilOperation::Replace);	return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	IncrSat					{ yylval->build<EStencilOperation>(EStencilOperation::IncreaseSaturate);	return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	DecrSat					{ yylval->build<EStencilOperation>(EStencilOperation::DecreaseSaturate);	return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	Invert					{ yylval->build<EStencilOperation>(EStencilOperation::Invert);	return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	IncrWrap				{ yylval->build<EStencilOperation>(EStencilOperation::IncreaseWrap);	return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	DecrWrap				{ yylval->build<EStencilOperation>(EStencilOperation::DecreaseWrap);	return MaterialParser::token::TVAL_STENCIL_OPERATION;}
	\}						{ BEGIN (_STENCIL); return MaterialParser::token::TOK_RIGHT_BRACE; }
}

cull						{ return MaterialParser::token::TOK_CULL;}
front						{ yylval->build<ECullingType>(ECullingType::Font); return MaterialParser::token::TVAL_CULLORIENT;}
back						{ yylval->build<ECullingType>(ECullingType::Back);  return MaterialParser::token::TVAL_CULLORIENT;}

Blend							{ BEGIN (INITIAL); return MaterialParser::token::TOK_BLEND; }
	Zero						{ yylval->build<EBlendFactor>(EBlendFactor::Zero); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	One							{ yylval->build<EBlendFactor>(EBlendFactor::One); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	SrcColor					{ yylval->build<EBlendFactor>(EBlendFactor::SrcColor); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	SrcAlpha					{ yylval->build<EBlendFactor>(EBlendFactor::SrcAlpha); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	DstColor					{ yylval->build<EBlendFactor>(EBlendFactor::DstColor); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	DstAlpha					{ yylval->build<EBlendFactor>(EBlendFactor::DstAlpha); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	OneMinusSrcColor			{ yylval->build<EBlendFactor>(EBlendFactor::OneMinusSrcColor); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	OneMinusDstColor			{ yylval->build<EBlendFactor>(EBlendFactor::OneMinusDstColor); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	OneMinusSrcAlpha			{ yylval->build<EBlendFactor>(EBlendFactor::OneMinusSrcAlpha); return MaterialParser::token::TVAL_BLEND_FACTOR;}
	OneMinusDstAlpha			{ yylval->build<EBlendFactor>(EBlendFactor::OneMinusDstAlpha); return MaterialParser::token::TVAL_BLEND_FACTOR;}

	Add							{ yylval->build<EBlendOperation>(EBlendOperation::Add); return MaterialParser::token::TVAL_BLEND_OPERATION; }
	Sub							{ yylval->build<EBlendOperation>(EBlendOperation::Sub); return MaterialParser::token::TVAL_BLEND_OPERATION; }


VertexShader				{ return MaterialParser::token::TOK_VERTEXSHADER; }
FragmentShader				{ return MaterialParser::token::TOK_FRAGMENTSHADER; }

-?{DIGIT}+("."({DIGIT}*))+ 	{ yylval->build<float>(atof(yytext)); return MaterialParser::token::TVAL_FLOAT; }
-?"."{DIGIT}+ 				{ yylval->build<float>(atof(yytext)); return MaterialParser::token::TVAL_FLOAT; }
-?{DIGIT}+ 	{ yylval->build<float>(atoi(yytext)); return MaterialParser::token::TVAL_INTEGER; }

\"[^\"]*\"					{
		yylval->build<std::string>(yytext); return MaterialParser::token::TVAL_STRING;
	}

[ \t]*						{ /* whitespace */ }

\{ 							{ return MaterialParser::token::TOK_LEFT_BRACE; }
\} 							{ return MaterialParser::token::TOK_RIGHT_BRACE; }

;							{ return MaterialParser::token::TOK_SEMICOLON; }

\r\n						{yylineno++;}
\n\r						{yylineno++;}
\r							{yylineno++;}
\n							{yylineno++;}

.							{return *yytext;}
%%