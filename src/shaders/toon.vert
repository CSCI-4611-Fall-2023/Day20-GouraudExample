#version 300 es

// CSCI 4611 Assignment 5: Artistic Rendering
// This vertex shader is identical to the one used
// for Phong shading. You do not need to modify it.

precision mediump float;

uniform mat4 modelMatrix;
uniform mat4 normalModelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

in vec3 position;
in vec3 normal;
in vec4 color;
in vec2 texCoord;

out vec3 vertPositionWorld;
out vec3 vertNormalWorld;
out vec4 vertColor;
out vec2 uv;

void main() 
{
    // Compute the world space vertex position and normal so we can use them in the fragement shader
    vertPositionWorld = (modelMatrix * vec4(position, 1)).xyz;
    vertNormalWorld = normalize((normalModelMatrix * vec4(normal, 0)).xyz);

    // Also pass the vertex color and texture coordinates along to the fragment shader
    vertColor = color;
    uv = texCoord.xy; 

    // Required: compute the vertex position in clip coordinates
    gl_Position = projectionMatrix * viewMatrix * vec4(vertPositionWorld, 1);
}