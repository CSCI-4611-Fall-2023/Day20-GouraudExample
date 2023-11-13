#version 300 es

precision mediump float;

uniform mat4 modelMatrix;
uniform mat4 normalModelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

in vec3 position;
in vec3 normal;
in vec4 color;
in vec2 texCoord;

out vec3 vertPosition;
out vec3 vertNormal;
out vec4 vertColor;
out vec2 uv;

void main() 
{
    
    // Required: compute the vertex position in clip coordinates
    gl_Position = vec4(0,0,0,1);
}
