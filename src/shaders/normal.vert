#version 300 es

// CSCI 4611 Assignment 5: Artistic Rendering
// Normal mapping is a complex effect that will involve changing
// both the vertex and fragment shader. This implementation is
// based on the approach described below, and you are encouraged
// to read this tutorial writeup for a deeper understanding.
// https://learnopengl.com/Advanced-Lighting/Normal-Mapping

// Most of the structure of this vertex shader has been implemented,
// but you will need to complete the code that computes the TBN matrix.

// You should complete this vertex shader first, and then move on to
// the fragment shader only after you have verified that is correct.

precision mediump int;
precision mediump float;

const int MAX_LIGHTS = 8;

uniform int numLights;
uniform vec3 lightPositionsWorld[MAX_LIGHTS];
uniform vec3 eyePositionWorld;

uniform mat4 modelMatrix;
uniform mat4 normalModelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

in vec3 position;
in vec3 normal;
in vec3 tangent;
in vec4 color;
in vec2 texCoord;

out vec4 vertColor;
out vec2 uv;
out vec3 vertPositionTangent;
out vec3 eyePositionTangent;
out vec3 lightPositionsTangent[MAX_LIGHTS];

void main() 
{
    // Assign the vertex color and uv
    vertColor = color;
    uv = texCoord.xy; 

    // Compute the world vertex position
    vec3 vertPositionWorld = (modelMatrix * vec4(position, 1)).xyz;   

    // TO BE ADDED
    // This line of code sets the TBN to an identity matrix.
    // You will need to replace it and compute the matrix that
    // converts vertices from world space to tangent space. 
    // When this part is completed correctly, it will produce
    // a result that looks identical to the Phong shader.
    // Then, you can move on to complete the fragment shader.
    mat3 tbn = mat3(1.0f);

    // Compute the tangent space vertex and view positions
    vertPositionTangent = tbn * vertPositionWorld;
    eyePositionTangent = tbn * eyePositionWorld;

    // Compute the tangent space light positions
    for(int i=0; i < numLights; i++)
    {
        lightPositionsTangent[i] = tbn * lightPositionsTangent[i];
    }
    
    // Compute the projected vertex position
    gl_Position = projectionMatrix * viewMatrix * vec4(vertPositionWorld, 1);
}