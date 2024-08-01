#version 460 compatibility

out vec2 texCoord;
out vec2 lightCoord;
out vec4 vertexColor;
out float vertexDistance;
out vec3 normal;

void main() {
    // 改变地形相对于屏幕的位置,通过将模型视图和投影矩阵与世界空间位置相乘来实现
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    
    texCoord = gl_MultiTexCoord0.xy;
    lightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    vertexColor = gl_Color;

    // 计算边界雾位置
    vertexDistance = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    
    // 对象空间中的法线向量乘以法线矩阵，得到在视图空间中的法线向量
    normal = gl_NormalMatrix * gl_Normal;
}