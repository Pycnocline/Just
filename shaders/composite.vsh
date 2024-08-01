#version 460 compatibility

out vec4 texCoord;

void main() {
    gl_Position = ftransform();

    texCoord = gl_MultiTexCoord0;
}