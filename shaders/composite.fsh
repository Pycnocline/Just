#version 460 compatibility

in vec4 texCoord;

uniform sampler2D gcolor;
uniform sampler2D gnormal;
uniform sampler2D gdepth;

// 实现阴影相关功能
uniform vec3 cameraPosition;
uniform sampler2D shadow;
uniform sampler2D gdepthtex;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

const int RGBA32F = 1;
const int gcolorFormat = RGBA32F;

layout(location = 0) out vec4 composite0;
layout(location = 1) out vec4 composite0Normal;
layout(location = 2) out vec4 composite0Depth;

float getDepth(in vec2 coord) {
    return texture2D(gdepthtex, coord).r;
}

vec4 getCameraSpacePosition(in vec2 coord) {
    float depth = getDepth(coord);
    vec4 positionNDcSpace = vec4(coord.s * 2.0 - 1.0, coord.t * 2.0 - 1.0, 2.0 * depth - 1.0, 1.0);
    vec4 positionCameraSpace = gbufferProjectionInverse * positionNDcSpace;

    return positionCameraSpace / positionCameraSpace.w;
}

vec4 getWorldSpacePosition(in vec2 coord) {
    vec4 positionCameraSpace = getCameraSpacePosition(coord);
    vec4 positionWorldSpace =  gbufferModelViewInverse * positionCameraSpace;
    positionWorldSpace.xyz += cameraPosition;

    return positionWorldSpace;
}

vec3 getShadowSpacePosition(in vec2 coord) {
    vec4 positionWorldSpace = getWorldSpacePosition(coord);

    positionWorldSpace.xyz -= cameraPosition;
    vec4 positionShadowSpace = shadowModelView * positionWorldSpace;
    positionShadowSpace = shadowProjection * positionShadowSpace;
    positionShadowSpace /= positionShadowSpace.w;

    return positionShadowSpace.xyz *0.5 + 0.5;
}

// 判断是是否在阴影中
float getSunVisibility(in vec2 coord) {
    vec3 shadowCoord = getShadowSpacePosition(coord);
    float shadowMapSample = texture2D(shadow, shadowCoord.st).r;

    return step(shadowCoord.z - shadowMapSample, 0.0);
}

void main() {
    vec4 composite00 = vec4(texture2D(gcolor, texCoord.st).rgb, 1.0f);
    composite0Normal = vec4(texture2D(gnormal, texCoord.st).rgb, 1.0f);
    composite0Depth = vec4(texture2D(gdepth, texCoord.st).rgb, 1.0f);

    composite0 = composite00 * getSunVisibility(texCoord.ts);
}