class Token
{
  PVector pos;
  boolean touched = false;
  float size =60;
  Token()
  {
    pos = new PVector(140, 300);
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
}
