class Ray
{
  PVector pos;
  PVector dir;
  Ray(float x, float y)
  {
    pos = new PVector(x,y);
    dir = new PVector(1,0);
  }
  
  Ray(PVector position, float angle)
  {
    pos = position.copy();
    dir = PVector.fromAngle(angle);
  }
  
  
  void LookAt(float x, float y)
  {
    dir.x = x - pos.x;
    dir.y = y - pos.y;
    dir.normalize();
  }
  
  void Draw()
  {
    stroke(255);
    pushMatrix();
    translate(pos.x, pos.y);
    line(0,0,dir.x*20,dir.y*20);
    popMatrix();
  }
  
  PVector Cast(Boundary bound)
  {
    PVector pt = new PVector(0,0);
    //t    u     if 0<t<1
    //             u >0
    
    float x1 = bound.a.x;
    float y1 = bound.a.y;
    float x2 = bound.b.x;
    float y2 = bound.b.y;
    
    float x3 = pos.x;
    float y3 = pos.y;
    float x4 = pos.x + dir.x;
    float y4 = pos.y + dir.y; 
    
    float den = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
    if(den == 0)
    {
      return pt;
    }
    float t = ((x1-x3)*(y3-y4)-(y1-y3)*(x3-x4))/den;
    
    float u = -((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/den;
    
    
    if(t > 0 && t < 1 && u > 0)
    {
      
      
      pt.x = x1 + t * (x2-x1);
      pt.y = y1+t*(y2-y1);
      
      return pt;
    }
    
    
    return pt;
    
  }
  
  void SetPos(PVector p)
  {
    pos = p.copy();
  }
}
