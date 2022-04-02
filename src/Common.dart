import 'dart:math';

class Color {
  double r;
  double g;
  double b;

  Color(this.r, this.g, this.b);
  Color.init(Color color)
      : r = color.r,
        g = color.g,
        b = color.b;
}

Point mapByCoefs(double x, double y, List<double> coefs) {
  double nx = coefs[0] * x + coefs[1] * y + coefs[2];
  double ny = coefs[3] * x + coefs[4] * y + coefs[5];
  return Point(nx, ny);
}
