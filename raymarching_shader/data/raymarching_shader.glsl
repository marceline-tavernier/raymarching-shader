#ifdef GL_ES
precision highp float;
#endif

// Variables

uniform vec2 resolution;
uniform float time;
uniform vec3 mouse;

//////////////////

// Smooth minimum
float smin(float a, float b, float k) {
  float h = max(k - abs(a - b), 0.) / k;
  return min(a, b) - h * h * h * k * (1. / 6.);
}

// 2D rotation
mat2 rot2D(float a) {
  float s = sin(a);
  float c = cos(a);
  return mat2(c, -s, s, c);
}

// Octahedron distance function
float sdOctahedron(vec3 p, float s) {
  p = abs(p);
  return (p.x + p.y + p.z - s) * .57735027;
}

// Distance to the scene
float map(vec3 p) {
  // Forward movement
  p.z += time * .4;

  // Space repetition
  p.xy = fract(p.xy) -.5 ;
  p.z = mod(p.z, .25) - .125;

  // Octahedron SDF
  float octahedron = sdOctahedron(p, .15);

  // Closest distance to the scene
  return octahedron;
}

// Palette
vec3 palette(float t) {
  vec3 a = vec3 (0.5, 0.5, 0.5);
  vec3 b = vec3 (0.5, 0.5, 0.5);
  vec3 c = vec3 (1.0, 1.0, 1.0);
  vec3 d = vec3 (0.263, 0.416, 0.557);

  return a + b * cos(6.28318 * (c * t + d));
}

void main() {

  // Initialize uv and mouse
  vec2 uv = (gl_FragCoord.xy * 2. - resolution) / resolution.y;
  vec2 m = (mouse.xy * 2. - resolution) / resolution.y;
  m.y = -m.y;
  
  // Ray origin, ray direction and color
  vec3 ro = vec3(0, 0, -3);
  vec3 rd = normalize(vec3(uv, 1));
  vec3 col = vec3(0);

  // Distance traveled
  float t = 0.;

  // If the mouse is not pressed, simulate a circling with the mouse
  if (mouse.z < 0.) {
    m = vec2(cos(time * .2), sin(time * .2));
  }

  // Raymarching
  int i;
  for (i = 0; i < 80; i++) {
    // Postion of the ray
    vec3 p = ro + rd * t;
    
    // Rotate and wiggle the ray
    p.xy *= rot2D(t * .2 * m.x);
    p.y += sin(t * (m.y + 1.) * .5) * .35;

    // Current distance to the scene
    float d = map(p);

    // March the ray
    t += d;

    // Break if too close or too far
    if (d < 0.001 || t > 100.) break;
    
  }

  // Coloring
  col = palette(t * .04 + float(i) * .005);
  
  gl_FragColor = vec4(col, 1);
}
