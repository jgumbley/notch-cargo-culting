part of game;

class Quad {
  Shader shader;
  int posLocation;
  WebGL.UniformLocation objectTransformLocation, cameraTransformLocation, viewTransformLocation, textureTransformLocation;
  WebGL.UniformLocation colorLocation;
  
  Quad(this.shader){
    posLocation = gl.getAttribLocation(shader.program, "a_pos");
    
    objectTransformLocation = gl.getUniformLocation(shader.program, "u_objectTransform");
    cameraTransformLocation = gl.getUniformLocation(shader.program, "u_cameraTransform");
    viewTransformLocation = gl.getUniformLocation(shader.program, "u_viewTransform");
    textureTransformLocation = gl.getUniformLocation(shader.program, "u_textureTransform");
    colorLocation = gl.getUniformLocation(shader.program, "u_color");
    
    Float32List vertexArray = new Float32List(4*3);
    vertexArray.setAll(0*3, [0.0, 0.0, 0.0]);
    vertexArray.setAll(1*3, [0.0, 1.0, 0.0]);
    vertexArray.setAll(2*3, [1.0, 1.0, 0.0]);
    vertexArray.setAll(3*3, [1.0, 0.0, 0.0]);
    
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
  Matrix4 textureMatrix = new Matrix4.identity();
  /* location, dimensions, texture offset */
  void render(int x, int y, int w, int h, int uo, int va, Vector4 color) {
    objectMatrix.setIdentity();
    objectMatrix.translate(x*1.0, y*1.0, -1.0);
    objectMatrix.scale(w*1.0, h*-1.0, 0.0);
    gl.uniformMatrix4fv(objectTransformLocation, false, objectMatrix.storage);
    
    double texHeight = 256.0;
    double texWidth = 256.0;
    
    textureMatrix.setIdentity();
    textureMatrix.scale(1.0/texWidth, 1.0/texHeight, -1.0);
    textureMatrix.translate(uo*1.0, va*1.0, 0.0);
    textureMatrix.scale(w*1.0, h*1.0, 0.0);
    gl.uniformMatrix4fv(textureTransformLocation, false, textureMatrix.storage);   
    
    gl.uniform4fv(colorLocation, color.storage);
    
    gl.drawElements(WebGL.TRIANGLES, 6, WebGL.UNSIGNED_SHORT, 0);
  }
}