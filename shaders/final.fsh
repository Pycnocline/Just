#version 460 compatibility

in vec4 texCoord;

uniform sampler2D gcolor;

// 暗角滤镜
void Vignette(inout vec3 color) {
    float dist = distance(texCoord.st, vec2(0.5)) * 2.0;

    // 调节范围
    dist /= 2.5f;

    dist = pow(dist, 1.1f);
    // 调节强度
    color.rgb *= 1.0f -dist;
}

void main() {
    vec3 color = texture2D(gcolor, texCoord.st).rgb;

    // 添加暗角滤镜
    Vignette(color);

    // 输出最终颜色
    gl_FragColor = vec4(color.rgb, 1.0f);
}