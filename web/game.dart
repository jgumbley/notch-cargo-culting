library game;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';

part 'shader.dart';
part 'quad.dart';
part 'texture.dart';

/* rendering context global */
WebGL.RenderingContext gl;

class Game {
  
  CanvasElement canvas;

  Math.Random random;
  Quad quad;
  Matrix4 viewMatrix, cameraMatrix;
  Texture sheetTexture = new Texture("tex/sheet.png");
  
  double fov = 90.0;
  
  void render(double time) {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(1, 0.816, 0.451, 255.0);
    gl.clear(WebGL.COLOR_BUFFER_BIT);
    
    viewMatrix = makePerspectiveMatrix(fov*Math.PI/180, canvas.width/canvas.height, 0.01, 100.0);
    
    double scale = 6.0 / canvas.height;
    cameraMatrix = new Matrix4.identity().scale(scale, scale, 1.0);
    quad.setCamera(viewMatrix, cameraMatrix);  
    
    quad.setTexture(sheetTexture);
    
    Vector4 whiteColour = new Vector4(1.0, 1.0, 1.0, 1.0);
    quad.render(0, 0, 24, 95, 0, 0, whiteColour);
    
    /* need to register call back to register next paint to paint */
    window.requestAnimationFrame(render);
  }
  
  void start() {
    canvas = querySelector("#game_canvas");
    random = new Math.Random();
    gl = canvas.getContext("webgl");
    if (gl==null) {
      gl = canvas.getContext("experimental-webgl");
    }
    
    quad = new Quad(quadShader);
    Texture.loadAll();
    
    if (gl!=null) {
      /* Register render function with browser for repaint */
      window.requestAnimationFrame(render);
    }
  }
}


void main() {
  new Game().start();
  
}