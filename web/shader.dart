part of game;

class Shader {
  String vertexShaderCode,fragmentShaderCode;
  WebGL.Shader vertexShader, fragmentShader;
  WebGL.Program program;
  
  Shader(this.vertexShaderCode, this.fragmentShaderCode) {
    compile();
  }
  
  void compile() {
    vertexShader = gl.createShader(WebGL.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderCode);
    gl.compileShader(vertexShader);
    
    if (!gl.getShaderParameter(vertexShader, WebGL.COMPILE_STATUS)) {
      throw gl.getShaderInfoLog(vertexShader);
    }
    
    fragmentShader = gl.createShader(WebGL.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderCode);
    gl.compileShader(fragmentShader);
    
    if (!gl.getShaderParameter(fragmentShader, WebGL.COMPILE_STATUS)) {
      throw gl.getShaderInfoLog(fragmentShader);
    }
    
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, WebGL.LINK_STATUS )) {
      throw gl.getProgramInfoLog(program);
    }
  }
}

Shader quadShader = new Shader("""
  precision highp float;
  
  attribute vec3 a_pos;
  attribute vec3 a_normal;
  attribute vec2 a_texcoord;
  qttribute vec3 a_color;
  
  uniform mat4 u_objectTransform;
  uniform mat4 u_cameraTransform;
  uniform mat4 u_viewTransform;
  
  varying vec2 v_texcoord;
  
  void main() {
    v_texcoord = a_texcoord;
    gl_Position = u_viewTransform*u_cameraTransform*u_objectTransform*vec4(a_pos, 1.0);
  }
""",/*=============================================================*/"""
  precision highp float;
  
  varying vec2 v_texcoord;
  
  uniform sampler2D u_tex;
  uniform vec3 u_color;
  
  void main() {
    vec4 col = texture2D(u_tex, v_texcoord);
    if (col.a>0.0){
      gl_FragColor = col*u_color;
    } else {
      discard;
    }
  }
""");