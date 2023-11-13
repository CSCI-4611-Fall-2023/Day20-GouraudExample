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

out vec3 positionWorld;
out vec3 normalWorld;
out vec4 baseColor;
out vec2 uv;

void main() 
{
    positionWorld = (modelMatrix * vec4(position, 1)).xyz;
    normalWorld = (normalModelMatrix * vec4(normal, 0)).xyz;
    baseColor = color;
    uv = texCoord;
    
    // Required: compute the vertex position in clip coordinates
    gl_Position = projectionMatrix * viewMatrix * vec4(positionWorld, 1);
}
