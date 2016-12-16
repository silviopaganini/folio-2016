varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;
varying vec3 vLight;
varying vec3 vNoise;

uniform vec3 color;
uniform vec3 ambient;
uniform vec3 lightDirection;
uniform vec3 specular;
uniform float shininess;
uniform float time;

float lambert(vec3 n, vec3 d)
{
    // n : surface view normalized
    // d : direction of the light normalized
    return dot(n, d);
}

float phong(vec3 light, vec3 normal, vec3 eyeDirection, float shininess)
{
    // light        : normalized light direction
    // normal       : surface view normal
    // eyeDirection : normalized vPosition
    // shininess    : self explanatory =)

    return pow(max(dot(reflect(light, normal), eyeDirection), 0.0), shininess);
}

vec3 faceNormals(vec3 pos) {
  vec3 fdx = dFdx(pos);
  vec3 fdy = dFdy(pos);
  return normalize(cross(fdx, fdy));
}

void main()
{
    vec3 normal = vNoise;
    // normal = faceNormals(vPosition);

    vec3 diffuse = color ;

    vec3 eyeDirection = normalize(vPosition);
    vec3 light = ambient +
      diffuse * lambert(normal, vLight) +
      specular * phong(
        vLight,
        normal,
        eyeDirection,
        shininess
      );

    light *= .35;
    gl_FragColor = vec4(light, 1.0);
    // gl_FragColor = vec4(light * .5, 1.0);
    // gl_FragColor = vec4(.5 - normalize(vNormal), 1.);
}
