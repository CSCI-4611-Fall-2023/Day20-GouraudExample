#version 300 es

precision mediump float;

uniform int useTexture;
uniform sampler2D textureImage;

in vec4 vertColor;
in vec2 uv;

out vec4 fragColor;

void main() 
{
    fragColor = vec4(0,0,0,1);
}
