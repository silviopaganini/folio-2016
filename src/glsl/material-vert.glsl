#pragma glslify: curlNoise = require(glsl-curl-noise)

#define PI 3.14159265359
varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;
varying vec3 vLight;

uniform vec3 lightDirection;
uniform float time;

void main() {
    vUv = uv;
    vec4 mvPosition = modelViewMatrix * vec4(position , 1.0 );

    float aaTime = time * 1.95;
    aaTime = 0.5 + 0.5 * ((2.0 * PI) * time);
    aaTime *= 0.25;

    float power = 15.5;
    vec3 noise = curlNoise(normal);
    vec3 dist = noise * normal * power;

    // mvPosition.x += cos(aaTime * 2.) * (5.5 * dist.x) * normal.z ;
    // mvPosition.y += sin(aaTime * 2.) * (5.5 * dist.y) * normal.x ;
    // mvPosition.z += sin(aaTime * 2.) * (5.5 * dist.z) * normal.z ;

    mvPosition.x += (cos(aaTime) * (dist.x) );
    mvPosition.y += (sin(aaTime) * (dist.y) );
    mvPosition.z += (sin(aaTime) * (dist.z) );

    vNormal = normal * normalMatrix;
    vPosition = mvPosition.xyz;
    vLight = normalize(lightDirection - vPosition);

    gl_Position = projectionMatrix * mvPosition;
}
