#pragma glslify: fxaa = require('./fxaa.glsl')

varying vec2 vUv;
uniform sampler2D tDiffuse;
uniform vec2 resolution;
uniform float time;

float random(vec2 n, float offset ){
    //return fract(sin(dot(gl_FragCoord.xyz+seed,scale))*43758.5453);
  return .5 - fract(sin(dot(n.xy + vec2( offset, 0. ), vec2(12.9898, 78.233)))* 43758.5453);
}

float pattern() {

  float angle = random(vUv, sin(time) * cos(time));
  vec2 tSize = vec2(256.);
  vec2 center = vec2(0.5);
  float scale = 10.0;

	float s = sin( angle ), c = cos( angle );

	vec2 tex = vUv * tSize - center;
	vec2 point = vec2( c * tex.x - s * tex.y, s * tex.x + c * tex.y ) * scale;

	return ( sin( point.x ) * sin( point.y ) ) * 4.0;

}

void main() {

    vec2 fragCoord = vUv * resolution;
    // vec4 texel = fxaa(tDiffuse, fragCoord, resolution);

    // float amount = 20.;
    // float speed = 1.5;
    //
    // vec4 noise = vec4( vec3( amount * random( vUv, .005 * speed * time ) ), 1. );
    //
    // texel = mix(texel, noise, .0125);
    //
    // vec2 res = (gl_FragCoord.xy / resolution.xy) - vec2(0.2);
    // res.x *= resolution.x / resolution.y;

    // vec4 texel = texture2D( tDiffuse, vUv );

    // vignette
    // float len = length(res);
    // float vignette = smoothstep(.85, .5, len);
    // texel = pow(texel, vec4(3.)) * vignette;
    // //
    float angle = 0.;
    float amount = 0.005;
    //
    vec2 offset = amount * vec2( cos(angle), sin(angle));
		vec4 cr = texture2D(tDiffuse, vUv + offset);
		vec4 cga = texture2D(tDiffuse, vUv);
		vec4 cb = texture2D(tDiffuse, vUv - offset);
    //
    vec3 texel = vec3(cr.r, cga.g, cb.b);
    //
    float average = ( texel.r + texel.g + texel.b ) / 3.0;
    //
    vec3 colorFinal = texel + (average* pattern());

		gl_FragColor = vec4(colorFinal, 1.0);

    // gl_FragColor = texture2D(tDiffuse, vUv);
    // gl_FragColor = texel;

}
