import 'dart:math';

class Variation {
  final int _variationType;
  double _weight;
  final List<double> _parameters;

  double get weight => _weight;
  set weight(double w) {
    if (w <= 0) {
      throw 'Invalid weight';
    }
    _weight = w;
  }

  Variation(this._variationType, this._weight, this._parameters) {
    if (_variationType < 0) {
      throw 'Invalid variation type';
    }
    if (_weight <= 0) {
      throw 'weight must be larger than 0';
    }
    if (_parameters.length > 4) {
      throw 'parameters length is too long';
    }
  }

  Point map(double x, double y) {
    double newx = 0, newy = 0;

    switch (_variationType) {
      case 0: // Linear:
        newx = x;
        newy = y;
        break;
      case 1: // Sinusoidal:
        newx = sin(x);
        newy = sin(y);
        break;
      case 2: // Spherical:
        double rPow = x * x + y * y;
        newx = x / rPow;
        newy = y / rPow;
        break;
    }

    return Point(newx, newy);
  }
}
