import 'Common.dart';
import 'Variations.dart';

class Variation {
  final VariationType _varitionType;
  double _weight;
  final List<double> _parameters;

  double get weight => _weight;
  set weight(double w) {
    if (w <= 0) {
      throw 'Invalid weight';
    }
    _weight = w;
  }

  Variation(this._varitionType, this._weight, this._parameters) {
    if (_weight <= 0) {
      throw 'weight must be larger than 0';
    }
    if (_parameters.length > 4) {
      throw 'parameters length is too long';
    }
  }

  Vector map(double x, double y) {
    switch (_varitionType) {
      case VariationType.Linear:
        return linear(x, y);
      case VariationType.Sinusoidal:
        return sinusoidal(x, y);
      case VariationType.Spherical:
        return spherical(x, y);
    }

    return null;
  }
}
