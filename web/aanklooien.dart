

void main()
{
  Function f = () => print("danny");

  f?.call();

  int a;

  a ??= 5;

  print(a);
}