class Vector {
  double x;
  double y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) {
    return Vector(x + v.x, y + v.y);
  }

  Vector operator *(double value) {
    return Vector(value * x, value * y);
  }
}

class Color {
  double r;
  double g;
  double b;

  Color(this.r, this.g, this.b);
}

Vector mapByCoefs(double x, double y, List<double> coefs) {
  double nx = coefs[0] * x + coefs[1] * y + coefs[2];
  double ny = coefs[3] * x + coefs[4] * y + coefs[5];
  return Vector(nx, ny);
}
