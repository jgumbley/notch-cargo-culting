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
  int posLocation;
  WebGL.UniformLocation objectTransformLocation, cameraTransformLocation, viewTransformLocation;
  WebGL.UniformLocation colorLocation;
  
  Quad(this.shader){
    posLocation = gl.getAttribLocation(shader.program, "a_pos");
    
    objectTransformLocation = gl.getUniformLocation(shader.program, "u_objectTransform");
    cameraTransformLocation = gl.getUniformLocation(shader.program, "u_cameraTransform");
    viewTransformLocation = gl.getUniformLocation(shader.program, "u_viewTransform");
    colorLocation = gl.getUniformLocation(shader.program, "u_color");
    
    Float32List vertexArray = new Float32List(4*3);
    vertexArray.setAll(0*3, [0.0, 0.0, 0.0]);
    vertexArray.setAll(1*3, [0.0, 1.0, 0.0]);
    vertexArray.setAll(2*3, [1.0, 1.0, 0.0]);
    vertexArray.setAll(3*3, [0.0, 0.0, 0.0]);
    
    Int16List indexArray = new Int16List(6);
    indexArray.setAll(0, [0, 1, 2, 0, 2, 3]);
    
    gl.useProgram(shader.program);
    gl.enableVertexAttribArray(posLocation);
    
    WebGL.Buffer vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferDataTyped(WebGL.ARRAY_BUFFER, vertexArray, WebGL.STATIC_DRAW);
    gl.vertexAttribPointer(posLocation, 3, WebGL.FLOAT, false, 0, 0);
    
    WebGL.Buffer indexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferDataTyped(WebGL.ELEMENT_ARRAY_BUFFER, indexArray, WebGL.STATIC_DRAW);
    gl.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
  }
  
  void setCamera (Matrix4 viewMatrix, Matrix4 cameraMatrix) {
    gl.uniformMatrix4fv(viewTransformLocation, false, viewMatrix.storage);
    gl.uniformMatrix4fv(cameraTransformLocation, false, cameraMatrix.storage);
  }
  
  Matrix4 objectMatrix = new Matrix4.identity();
  /* location, dimensions, texture offset */
  void render(int x, int y, int w, int h, int uo, int va, Vector4 colour) {
    objectMatrix.setIdentity();
    //objectMatrix.scale(w*1.0, h*1.0, 0.0);
    objectMatrix.translate(x*1.0, y*1.0, 0.0);
    objectMatrix.translate(0.0, 0.0, -0.5);
    gl.uniformMatrix4fv(objectTransformLocation, false, objectMatrix.storage);
    
    gl.drawElements(WebGL.TRIANGLES, 6, WebGL.UNSIGNED_SHORT, 0);
  }
}

class Game {
  
  CanvasElement canvas;

  Math.Random random;
  Quad quad;
  Matrix4 viewMatrix, cameraMatrix;
  double fov = 90.0;
  
  void render(double time) {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(random.nextDouble() , random.nextDouble(), random.nextDouble(), random.nextDouble());
    gl.clear(WebGL.COLOR_BUFFER_BIT);
    
    viewMatrix = makePerspectiveMatrix(fov*Math.PI/180, canvas.width/canvas.height, 0.01, 100.0);
    cameraMatrix = new Matrix4.identity();
    
    quad.setCamera(viewMatrix, cameraMatrix);
    
    Vector4 whiteColour = new Vector4(1.0, 1.0, 1.0, 1.0);
    quad.render(0, 0, 16, 16, 0, 0, whiteColour);
    
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
    
    if (gl!=null) {
      /* Register render function with browser for repaint */
      window.requestAnimationFrame(render);
    }
  }
}

void main() {
  new Game().start();
  
}