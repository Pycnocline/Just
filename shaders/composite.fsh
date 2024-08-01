#version 460 compatibility

in vec4 texCoord;

uniform sampler2D gcolor;
uniform sampler2D gnormal;
uniform sampler2D gdepth;

const int RGBA32F = 1;
const int gcolorFormat = RGBA32F;

layout(location = 0) out vec4 composite0;
layout(location = 1) out vec4 composite0Normal;
layout(location = 2) out vec4 composite0Depth;

void main() {
    composite0 = vec4(texture2D(gcolor, texCoord.st).rgb, 1.0f);
    composite0Normal = vec4(texture2D(gnormal, texCoord.st).rgb, 1.0f);
    composite0Depth = vec4(texture2D(gdepth, texCoord.st).rgb, 1.0f);

}