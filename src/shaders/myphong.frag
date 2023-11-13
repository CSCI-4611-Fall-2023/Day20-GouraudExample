#version 300 es

precision mediump float;

#define POINT_LIGHT 0
#define DIRECTIONAL_LIGHT 1

const int MAX_LIGHTS = 8;

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

uniform int useTexture;
uniform sampler2D textureImage;

in vec3 positionWorld;
in vec3 normalWorld;
in vec4 baseColor;
in vec2 uv;

out vec4 fragColor;

void main() 
{
    vec3 fragNormalWorld = normalize(normalWorld.xyz);

    fragColor = vec4(0,0,0,1);
    for (int i=0; i<numLights; i++) {
        vec3 ambientComponent = ambientIntensities[i] * kAmbient;

        vec3 lWorld;
        if (lightTypes[i] == POINT_LIGHT) {
            lWorld = normalize(lightPositionsWorld[i] - positionWorld.xyz);
        } else {
            lWorld = normalize(lightPositionsWorld[i]);
        }
        vec3 diffuseComponent = diffuseIntensities[i] * kDiffuse * max(0.0, dot(fragNormalWorld, lWorld));

        vec3 eWorld = normalize(eyePositionWorld - positionWorld.xyz);
        vec3 rWorld = reflect(-lWorld, fragNormalWorld);
        vec3 specularComponent = specularIntensities[i] * kSpecular * pow(max(0.0, dot(eWorld, rWorld)), shininess);

        vec3 totalIlluminationForLightI = ambientComponent + diffuseComponent + specularComponent;

        fragColor.rgb += totalIlluminationForLightI;
    }

    // modulate with the per-vertex color from the raw mesh data
    // (defaults to white if the mesh does not have per-vertex colors)
    fragColor *= baseColor;

    if (useTexture == 1) {
        fragColor *= texture(textureImage, uv);
    }
}