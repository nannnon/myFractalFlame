import 'dart:math';
import 'Common.dart';

enum VariationType { Linear, Sinusoidal, Spherical }

Vector linear(double x, double y) {
  return Vector(x, y);
}

Vector sinusoidal(double x, double y) {
  double nx = sin(x);
  double ny = sin(y);
  return Vector(nx, ny);
}

Vector spherical(double x, double y) {
  double rPow = x * x + y * y;
  double nx = x / rPow;
  double ny = y / rPow;
  return Vector(nx, ny);
}
