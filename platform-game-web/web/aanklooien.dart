import "dart:html";
import "dart:async";

abstract class A
{
  A.withSize(int x, int y);
}

class B extends A
{
  B.withSize(int x, int y) : super.withSize(x, y);
}

void main()
{
  B b = new B.withSize(10, 10);
}
