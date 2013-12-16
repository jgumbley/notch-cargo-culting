library game;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';

part 'shader.dart';

/* rendering context global */
WebGL.RenderingContext gl;

class Quad {
  Shader shader;
  
  Quad(this.shader){
    gl.getAttribLocation(shader.program, "a_pos");
    gl.getAttribLocation(shader.program, "a_texcoord");
  }
  
  void render(int x, int y, int w, int h, int uo, int va ) {
    
  }
}

class Game {
  
  CanvasElement canvas;

  Math.Random random;
  
  void render(double time) {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(random.nextDouble() , random.nextDouble(), random.nextDouble(), random.nextDouble());
    gl.clear(WebGL.COLOR_BUFFER_BIT);
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
    if (gl!=null) {
      /* Register render function with browser for repaint */
      window.requestAnimationFrame(render);
    }
  }
}

void main() {
  new Game().start();
  
}