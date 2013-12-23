library game;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';

part 'shader.dart';
part 'quad.dart';

/* rendering context global */
WebGL.RenderingContext gl;

class Game {
  
  CanvasElement canvas;

  Math.Random random;
  Quad quad;
  Matrix4 viewMatrix, cameraMatrix;
  Texture sheetTexture;
  
  double fov = 20.0;
  
  void render(double time) {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(random.nextDouble() , random.nextDouble(), random.nextDouble(), random.nextDouble());
    gl.clear(WebGL.COLOR_BUFFER_BIT);
    
    viewMatrix = makePerspectiveMatrix(fov*Math.PI/180, canvas.width/canvas.height, 0.01, 100.0);
    
    double scale = 0.5 / canvas.height;
    cameraMatrix = new Matrix4.identity().scale(scale, scale, 1.0);
    quad.setCamera(viewMatrix, cameraMatrix);  
    Vector4 whiteColour = new Vector4(1.0, 1.0, 1.0, 1.0);
    quad.render(0, 0, 95, 95, 0, 0, whiteColour);
    
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
    sheetTexture = new Texture("tex/sheet.png");
    
    if (gl!=null) {
      /* Register render function with browser for repaint */
      window.requestAnimationFrame(render);
    }
  }
}

class Texture {
  static List<Texture> _pendingTextures = new List<Texture>();
  
  String url;
  WebGL.Texture texture;
  int width, height;
  bool loaded = false;
  
  Texture(this.url) {
    if (gl==null) {
      _pendingTextures.add(this);
    } else {
      _load();
    }
  }
  
  static void loadAll() {
    _pendingTextures.forEach((e)=>e._load());
    _pendingTextures.clear();
  }
  
  void _load() {
    ImageElement img = new ImageElement();
    texture = gl.createTexture();
    img.onLoad.listen((e) {
      gl.bindTexture(WebGL.TEXTURE_2D, texture);
      gl.texImage2DImage(WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA, WebGL.UNSIGNED_BYTE, img);
      gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.NEAREST);
      gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.NEAREST);
      width = img.width;
      height = img.height;
      loaded = true;
    });
    img.src = url;
  }
}

void main() {
  new Game().start();
  
}