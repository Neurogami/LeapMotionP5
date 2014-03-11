class Target {

  PShape target;

  int relX, relY, relZ;

  float absX, absY, absZ;

  Target(String svgFile, int x, int y, int z ) {
    target = loadShape(svgFile);
    relX = x;
    relY = y;
    relZ = z;
  }

  void render() {
    pushMatrix();
    translate(relX, relY, relZ);

    shape(target, 0, 0);   
    absX = screenX(relX,relY, relZ);
    absY = screenY(relX,relY, relZ);
    absZ = screenZ(relX,relY, relZ);
    popMatrix();

  }

  float scrX() {
    return absX;
  }

  float scrY() {
    return absY;
  }

  float scrZ() {
    return absZ;
  }

  boolean haveIntersectXY(float x, float y) {
    if (dist(absX, absY, x, y) < 40.0 ) {
      return true;
    } 
    return false;
  }

}
