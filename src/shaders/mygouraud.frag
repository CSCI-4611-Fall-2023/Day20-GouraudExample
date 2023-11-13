#version 300 es

precision mediump float;

uniform int useTexture;
uniform sampler2D textureImage;

in vec4 totalIllumination;
in vec2 uv;

out vec4 fragColor;

void main() 
{
    fragColor = totalIllumination;

    if (useTexture == 1) {
        fragColor *= texture(textureImage, uv);
    }
}
