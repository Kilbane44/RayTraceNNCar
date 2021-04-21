class Token
{
  PVector pos;
  boolean touched = false;
  float size =20;
  Token()
  {
    pos = new PVector(140, 340);
  }
  Token(Token t)
  {
    pos = new PVector(t.pos.x, t.pos.y);
  }

  Token(float _x, float _y)
  {
    pos = new PVector(_x, _y);
  }

  void Draw()
  {


    if (touched)
    {
      fill(255, 255, 0, 100);
    } else
    {
      fill(255, 255, 0, 255);
    }
    ellipse(pos.x, pos.y, size, size);
  }


  String toString()
  {
    return ""+pos.x+" "+pos.y;
  }
}
