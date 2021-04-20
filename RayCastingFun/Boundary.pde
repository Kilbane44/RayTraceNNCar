class Boundary
{
  PVector a;
  PVector b;
  Boundary(float x, float y, float x2, float y2)
  {
    a = new PVector(x, y);
    b = new PVector(x2, y2);
  }

  Boundary(PVector _a, PVector _b)
  {
    a = _a.copy();
    b = _b.copy();
  }


  String toString()
  {
    return ""+ a.x+ " "+a.y+" "+b.x+" "+b.y;
  }



  void Draw()
  {
    stroke(255);
    line(a.x, a.y, b.x, b.y);
  }
}
