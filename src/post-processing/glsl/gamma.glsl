#pragma glslify: fxaa = require('./fxaa.glsl')

varying vec2 vUv;
uniform sampler2D tDiffuse;
uniform vec2 resolution;
uniform float time;

float random(vec2 n, float offset ){
    //return fract(sin(dot(gl_FragCoord.xyz+seed,scale))*43758.5453);
    return .5 - fract(sin(dot(n.xy + vec2( offset, 0. ), vec2(12.9898, 78.233)))* 43758.5453);
}

void main() {

    vec2 fragCoord = vUv * resolution;
    vec4 texel = fxaa(tDiffuse, fragCoord, resolution);

    float amount = 20.;
    float speed = 1.5;

    vec4 noise = vec4( vec3( amount * random( vUv, .005 * speed * time ) ), 1. );

    texel = mix(texel, noise, .0125);

    vec2 res = (gl_FragCoord.xy / resolution.xy) - vec2(0.2);
    res.x *= resolution.x / resolution.y;

    // vec4 texel = texture2D( tDiffuse, vUv );

    // vignette
    // float len = length(res);
    // float vignette = smoothstep(.85, .5, len);
    // texel = pow(texel, vec4(3.)) * vignette;

    gl_FragColor = texel;

}
