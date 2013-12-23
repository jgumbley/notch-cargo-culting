part of game;

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