#version 300 es

precision mediump float;

#define POINT_LIGHT 0
#define DIRECTIONAL_LIGHT 1

const int MAX_LIGHTS = 8;

uniform mat4 modelMatrix;
uniform mat4 normalModelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

uniform vec3 eyePositionWorld;

uniform int numLights;
uniform int lightTypes[MAX_LIGHTS];
uniform vec3 lightPositionsWorld[MAX_LIGHTS];
uniform vec3 ambientIntensities[MAX_LIGHTS];
uniform vec3 diffuseIntensities[MAX_LIGHTS];
uniform vec3 specularIntensities[MAX_LIGHTS];

uniform vec3 kAmbient;
uniform vec3 kDiffuse;
uniform vec3 kSpecular;
uniform float shininess;

// per-vertex data
in vec3 position;
in vec3 normal;
in vec4 color;
in vec2 texCoord;

// data we want to send to the rasterizer and eventually the fragment shader
out vec4 totalIllumination;
out vec2 uv;

void main() 
{
    vec4 positionWorld = modelMatrix * vec4(position, 1);
    vec4 normalWorld = normalize(normalModelMatrix * vec4(normal, 0));

    totalIllumination = vec4(0,0,0,1);
    for (int i=0; i<numLights; i++) {
        vec3 ambientComponent = ambientIntensities[i] * kAmbient;

        vec3 lWorld;
        if (lightTypes[i] == POINT_LIGHT) {
            lWorld = normalize(lightPositionsWorld[i] - positionWorld.xyz);
        } else {
            lWorld = normalize(lightPositionsWorld[i]);
        }
        vec3 diffuseComponent = diffuseIntensities[i] * kDiffuse * max(0.0, dot(normalWorld.xyz, lWorld));

        vec3 eWorld = normalize(eyePositionWorld - positionWorld.xyz);
        vec3 rWorld = reflect(-lWorld, normalWorld.xyz);
        vec3 specularComponent = specularIntensities[i] * kSpecular * pow(max(0.0, dot(eWorld, rWorld)), shininess);

        vec3 totalIlluminationForLightI = ambientComponent + diffuseComponent + specularComponent;

        totalIllumination.rgb += totalIlluminationForLightI;
    }

    // modulate with the per-vertex color from the raw mesh data
    // (defaults to white if the mesh does not have per-vertex colors)
    totalIllumination *= color;

    // just pass these along to the rasterizer to get interpolated
    uv = texCoord;

    vec4 positionEye = viewMatrix * positionWorld;
    vec4 positionScreen = projectionMatrix * positionEye;
    //vec4 positionScreen = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1);

    // Required: compute the vertex position in clip coordinates
    gl_Position = positionScreen;
}
