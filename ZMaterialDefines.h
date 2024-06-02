#pragma once

#include <vector>

enum class EStencilOperation
{
    Keep,
    Zero,
    Replace,
    IncreaseSaturate,
    DecreaseSaturate,
    Invert,
    IncreaseWrap,
    DecreaseWrap,
};

enum class EStencilCompareFunction
{
    Never,
    Less,
    Equal,
    LEqual,
    Greater,
    NotEqual,
    GEqual,
    Always
};

struct StencilOperationState
{
    EStencilOperation passOperation, failOperation, depthFailOperation;
    EStencilCompareFunction compareFunction;
    uint32_t readMask, writeMask, ref;
};

struct StencilState
{
    StencilOperationState front, back;
};

enum class EBlendOperation : uint8_t
{
    Add,
    Sub,
};

enum class EBlendFactor : uint8_t
{
    Zero,
    One,
    SrcColor,
    SrcAlpha,
    DstColor,
    DstAlpha,
    OneMinusSrcColor,
    OneMinusSrcAlpha,
    OneMinusDstColor,
    OneMinusDstAlpha,
};

struct BlendState
{
    EBlendFactor srcFactor, dstFactor, srcAlphaFactor, dstAlphaFactor;
    EBlendOperation operation;
};

enum class ECullingType : uint8_t
{
    Font,
    Back,
    None,
};

enum class EZTestMode : uint8_t
{
    Never,
    Less,
    LessEqual,
    Equal,
    GreaterEqual,
    Greater,
    NotEqual,
    Always,
};

enum class EZWriteMode : uint8_t
{
    Disable,
    Enable,
};

struct RenderState
{
    ECullingType cullingType;
    EZTestMode zTestMode;
    EZWriteMode zWriteMode;
    std::vector<BlendState> blendState;
    StencilState stencilState;
    bool zClipType;
};

struct Shader
{

};

struct Pass
{
    RenderState renderState;
    std::vector<Shader> shaders;
};

struct Material 
{
    RenderState renderState;
    std::vector<Pass> passes;
};