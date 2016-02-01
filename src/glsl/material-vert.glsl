#pragma glslify: snoise3 = require(glsl-noise/simplex/3d) 
#pragma glslify: snoise3 = require(glsl-noise/simplex/2d) 

varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;
// varying vec3 vLight;

uniform vec3 lightDirection;
uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vUv = uv;
    vec4 mvPosition = modelViewMatrix * vec4(position , 1.0 );

    float power = 7.5;
    vec3 nTime = normalize(vec3(time)) * 5.5;
    vec3 noise = vec3(snoise3(normal)); 
    vec3 dist = noise * (normal * power) * nTime;

    // mvPosition.x += cos(time * 2.) * (5.5 * dist.x) * normal.x ;
    // mvPosition.y += sin(time * 2.) * (5.5 * dist.y) * normal.y ;
    // mvPosition.z += sin(time * 2.) * (5.5 * dist.z) * normal.z ;

    mvPosition.x += (cos(time) * (dist.x) );
    mvPosition.y += (sin(time) * (dist.y) );
    mvPosition.z += (cos(time * 10.) * dist.z * 2.);

    // mvPosition.y += dist * (sin(time * 5. * normal.y) ) ;

    vNormal = normal * normalMatrix;
    vPosition = mvPosition.xyz;
    // vLight = normalize(lightDirection - vPosition);

    gl_Position =  projectionMatrix * mvPosition;
}