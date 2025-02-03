
// Variables
PShader raymarching;
PGraphics shaderGraphics;

//////////////////

// Setup
void setup() {
  
  // Size 1024x1024 and set title
  size(1024, 1024, P2D);
  surface.setTitle("Kishimisu #2 : Raymarching shader");

  // Setup screen display and shader
  shaderGraphics = createGraphics(width, height, P2D);
  shaderGraphics.loadPixels();
  raymarching = loadShader("raymarching_shader.glsl");
  
  // Give the resolution and time to the shader
  raymarching.set("resolution", float(width), float(height));
  raymarching.set("time", float(millis()) / 1000.0);
  
  // Display the shader
  shaderGraphics.shader(raymarching);
  shaderGraphics.rect(0, 0, width , height);
  image(shaderGraphics, 0, 0, width, height);
}

// Draw everything
void draw() {
  
    // Give the time, mouse position and mouse pressed to the shader
    raymarching.set("time", float(millis()) / 1000.0);
    float mouseZ = -1.;
    if (mousePressed) {
      mouseZ = 1.;
    }
    raymarching.set("mouse", float(mouseX), float(mouseY), mouseZ);
    
    // Display the shader
    shaderGraphics.shader(raymarching);
    shaderGraphics.rect(0, 0, width, height);
    image(shaderGraphics, 0, 0, width, height);
}
