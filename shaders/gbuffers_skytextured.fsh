#version 460 compatibility

in vec2 texCoord;
in vec2 lightCoord;
in vec4 vertexColor;
in float vertexDistance;
in vec3 normal;

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;
uniform vec3 shadowLightPosition;

const float	sunPathRotation	= -22.5;

layout(location = 0) out vec4 pixelColor;

void main() {
    // 定义纹理
    vec4 texColor = texture(gtexture, texCoord);
    // 停止绘制透明度小于0.01的纹理
    if (texColor.a < 0.01) discard;
    // 定义光照
    vec4 lightColor = texture(lightmap, lightCoord);
    // 计算边界雾
    float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
    // 生成纹理和亮度画面
    vec4 finalColor = texColor * lightColor * vertexColor;
    //生成最终画面
    pixelColor = finalColor;

    
}