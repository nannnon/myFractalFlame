import 'dart:math';

class Variation {
  static const int variationTypesNum = 49;
  static const int _seed = 42;
  static final Random _random = Random(_seed);

  final int _variationType;
  double _weight;
  final List<double> _ps;

  double get weight => _weight;
  set weight(double w) {
    if (w <= 0) {
      throw 'Invalid weight';
    }
    _weight = w;
  }

  Variation(this._variationType, this._weight, this._ps) {
    if (_variationType < 0) {
      throw 'Invalid variation type';
    }
    if (_weight <= 0) {
      throw 'weight must be larger than 0';
    }
    if (_ps.length > 4) {
      throw 'parameters length is too long';
    }
  }

  Point map(double x, double y, List<double> coefs) {
    double newx = 0, newy = 0;
    double a = coefs[0];
    double b = coefs[1];
    double c = coefs[2];
    double d = coefs[3];
    double e = coefs[4];
    double f = coefs[5];

    switch (_variationType) {
      case 0: // Linear:
        newx = x;
        newy = y;
        break;
      case 1: // Sinusoidal
        newx = sin(x);
        newy = sin(y);
        break;
      case 2: // Spherical
        double rpow = x * x + y * y;
        newx = x / rpow;
        newy = y / rpow;
        break;
      case 3: // Swirl
        double rpow = x * x + y * y;
        newx = x * sin(rpow) - y * cos(rpow);
        newy = x * cos(rpow) + y * sin(rpow);
        break;
      case 4: // Horseshoe
        double r = sqrt(x * x + y * y);
        newx = (x - y) * (x + y) / r;
        newy = 2 * x * y;
        break;
      case 5: // Polar
        newx = atan2(y, x) / pi;
        newy = sqrt(x * x + y * y) - 1;
        break;
      case 6: // Handkerchief
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        newx = r * sin(theta + r);
        newy = r * cos(theta - r);
        break;
      case 7: // Heart
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        newx = r * sin(theta * r);
        newy = r * -cos(theta * r);
        break;
      case 8: // Disc
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        newx = theta / pi * sin(pi * r);
        newy = theta / pi * cos(pi * r);
        break;
      case 9: // Spiral
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        newx = (cos(theta) + sin(r)) / r;
        newy = (sin(theta) - cos(r)) / r;
        break;
      case 10: // Hyperbolic
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        newx = sin(theta) / r;
        newy = r * cos(theta);
        break;
      case 11: // Diamond
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        newx = sin(theta) * cos(r);
        newy = cos(theta) * sin(r);
        break;
      case 12: // Ex
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        double p0 = sin(theta + r);
        double p1 = cos(theta - r);
        double p0_ = pow(p0, 3);
        double p1_ = pow(p1, 3);
        newx = r * (p0_ + p1_);
        newy = r * (p0_ - p1_);
        break;
      case 13: // Julia
        double r_ = sqrt(sqrt(x * x + y * y));
        double theta = atan2(y, x);
        double omega = _random.nextInt(2) * pi;
        newx = r_ * cos(theta / 2 + omega);
        newy = r_ * sin(theta / 2 + omega);
        break;
      case 14: // Bent
        if (x >= 0 && y >= 0) {
          newx = x;
          newy = y;
        } else if (x < 0 && y >= 0) {
          newx = 2 * x;
          newy = y;
        } else if (x >= 0 && y < 0) {
          newx = x;
          newy = y / 2;
        } else {
          newx = 2 * x;
          newy = y / 2;
        }
        break;
      case 15: // Waves
        newx = x + b * sin(y / (c * c));
        newy = y + e * sin(x / (f * f));
        break;
      case 16: // Fisheye
        double r = sqrt(x * x + y * y);
        newx = y * 2 / (r + 1);
        newy = x * 2 / (r + 1);
        break;
      case 17: // Popcorn
        newx = x + c * sin(tan(3 * y));
        newy = y + f * sin(tan(3 * x));
        break;
      case 18: // Exponential
        newx = exp(x - 1) * cos(pi * y);
        newy = exp(x - 1) * sin(pi * y);
        break;
      case 19: // Power
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        newx = pow(r, sin(theta)) * cos(theta);
        newy = pow(r, sin(theta)) * sin(theta);
        break;
      case 20: // Cosine
        double coshy = (exp(y) + exp(-y)) / 2;
        double sinhy = (exp(y) - exp(-y)) / 2;
        newx = cos(pi * x) * coshy;
        newy = -sin(pi * x) * sinhy;
        break;
      case 21: // Rings
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        double prefix = (r + c * c) % (2 * c * c) - c * c + r * (1 - c * c);
        newx = prefix * cos(theta);
        newy = prefix * sin(theta);
        break;
      case 22: // Fan
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        double t = pi * c * c;
        if (((theta + f) % t) > (t / 2)) {
          newx = r * cos(theta - t / 2);
          newy = r * sin(theta - t / 2);
        } else {
          newx = r * cos(theta + t / 2);
          newy = r * sin(theta + t / 2);
        }
        break;
      case 23: // Blob
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        double p1 = _ps[0];
        double p2 = _ps[1];
        double p3 = _ps[2];
        double prefix = r * (p2 + (p1 - p2) / 2 * (sin(p3 * theta) + 1));
        newx = prefix * cos(theta);
        newy = prefix * sin(theta);
        break;
      case 24: // PDJ
        double p1 = _ps[0];
        double p2 = _ps[1];
        double p3 = _ps[2];
        double p4 = _ps[3];
        newx = sin(p1 * y) - cos(p2 * x);
        newy = sin(p3 * x) - cos(p4 * y);
        break;
      case 25: // Fan2
        double p1 = pi * (_ps[0] * _ps[0]);
        double p2 = _ps[1];
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        double t = theta + p2 - p1 * (2 * theta * p2 / p1).truncate();
        if (t > p1 / 2) {
          newx = r * sin(theta - p1 / 2);
          newy = r * cos(theta - p1 / 2);
        } else {
          newx = r * sin(theta + p1 / 2);
          newy = r * cos(theta + p1 / 2);
        }
        break;
      case 26: // Rings2
        double r = sqrt(x * x + y * y);
        double theta = atan2(y, x);
        double p = _ps[0] * _ps[0];
        double t = r - 2 * p * ((r + p) / (2 * p)).truncate() + r * (1 - p);
        newx = t * sin(theta);
        newy = t * cos(theta);
        break;
      case 27: // Eyefish
        double r = sqrt(x * x + y * y);
        newx = 2 * x / (r + 1);
        newy = 2 * y / (r + 1);
        break;
      case 28: // Bubble
        double rpow = x * x + y * y;
        newx = 4 * x / (rpow + 4);
        newy = 4 * y / (rpow + 4);
        break;
      case 29: // Cylinder
        newx = sin(x);
        newy = y;
        break;
      case 30: // Perspective
        double p1 = _ps[0];
        double p2 = _ps[1];
        double prefix = p2 / (p2 - y * sin(p1));
        newx = prefix * x;
        newy = prefix * y * cos(p1);
        break;
      case 31: // Noise
        double psi1 = _random.nextDouble();
        double psi2 = _random.nextDouble();
        newx = psi1 * x * cos(2 * pi * psi2);
        newy = psi1 * y * sin(2 * pi * psi2);
        break;
      case 32: // JuliaN
        double p1 = _ps[0];
        double p2 = _ps[1];
        double psi = _random.nextDouble();
        int p3 = (p1.abs() * psi).truncate();
        double phi = atan2(x, y);
        double t = (phi + 2 * pi * p3) / p1;
        double r = sqrt(x * x + y * y);
        double prefix = pow(r, p2 / p1);
        newx = prefix * cos(t);
        newy = prefix * sin(t);
        break;
      case 33: // JuliaSccope
        double p1 = _ps[0];
        double p2 = _ps[1];
        double psi = _random.nextDouble();
        int p3 = (p1.abs() * psi).truncate();
        int lambda = _random.nextBool() ? -1 : 1;
        double phi = atan2(x, y);
        double t = (lambda * phi + 2 * pi * p3) / p1;
        double r = sqrt(x * x + y * y);
        double prefix = pow(r, p2 / p1);
        newx = prefix * cos(t);
        newy = prefix * sin(t);
        break;
      case 34: // Blur
        double psi1 = _random.nextDouble();
        double psi2 = _random.nextDouble();
        newx = psi1 * cos(2 * pi * psi2);
        newy = psi1 * sin(2 * pi * psi2);
        break;
      case 35: // Gaussian
        double psiSum = 0;
        for (int i = 0; i < 4; ++i) {
          psiSum += _random.nextDouble();
        }
        double psi5 = _random.nextDouble();
        newx = (psiSum - 2) * cos(2 * pi * psi5);
        newy = (psiSum - 2) * sin(2 * pi * psi5);
        break;
      case 36: // RadialBlur
        double p1 = _ps[0] * pi / 2;
        double v36 = _ps[1];
        double psiSum = 0;
        for (int i = 0; i < 4; ++i) {
          psiSum += _random.nextDouble();
        }
        double t1 = v36 * (psiSum - 2);
        double phi = atan2(x, y);
        double t2 = phi + t1 * sin(p1);
        double t3 = t1 * cos(p1) - 1;
        double r = sqrt(x * x + y * y);
        newx = (r * cos(t2) + t3 * x) / v36;
        newy = (r * sin(t2) + t3 * y) / v36;
        break;
      case 37: // Pie
        double p1 = _ps[0];
        double p2 = _ps[1];
        double p3 = _ps[2];
        double psi1 = _random.nextDouble();
        double psi2 = _random.nextDouble();
        double psi3 = _random.nextDouble();
        int t1 = (psi1 * p1 + 0.5).truncate();
        double t2 = p2 + (2 * pi / p1) * (t1 + psi2 * p3);
        newx = psi3 * cos(t2);
        newy = psi3 * sin(t2);
        break;
      case 38: // Ngon
        double p1 = _ps[0];
        double p2 = 2 * pi / _ps[1];
        double p3 = _ps[2];
        double p4 = _ps[3];
        double phi = atan2(x, y);
        double t3 = phi - p2 * (phi / p2).floor();
        double t4 = (t3 > p2 / 2) ? t3 : (t3 - p2);
        double r = sqrt(x * x + y * y);
        double k = (p3 * (1 / cos(t4) - 1) + p4) / pow(r, p1);
        newx = k * x;
        newy = k * y;
        break;
      case 39: // Curl
        double p1 = _ps[0];
        double p2 = _ps[1];
        double t1 = 1 + p1 * x + p2 * (x * x - y * y);
        double t2 = p1 * y + 2 * p2 * x * y;
        double prefix = 1 / (t1 * t1 + t2 * t2);
        newx = prefix * (x * t1 + y * t2);
        newy = prefix * (y * t1 - x * t2);
        break;
      case 40: // Rectangles
        double p1 = _ps[0];
        double p2 = _ps[1];
        newx = (2 * (x / p1).floor() + 1) * p1 - x;
        newy = (2 * (y / p2).floor() + 1) * p2 - y;
        break;
      case 41: // Arch
        double psi = _random.nextDouble();
        double v41 = _ps[0];
        newx = sin(psi * pi * v41);
        double s = sin(psi * pi * v41);
        newy = s * s / cos(psi * pi * v41);
        break;
      case 42: // Tangent
        newx = sin(x) / cos(y);
        newy = tan(y);
        break;
      case 43: // Square
        newx = _random.nextDouble() - 0.5;
        newy = _random.nextDouble() - 0.5;
        break;
      case 44: // Rays
        double v44 = _ps[0];
        double psi = _random.nextDouble();
        double rpow = x * x + y * y;
        double prefix = v44 * tan(psi * pi * v44) / rpow;
        newx = prefix * cos(x);
        newy = prefix * sin(y);
        break;
      case 45: // Blade
        double psi = _random.nextDouble();
        double r = sqrt(x * x + y * y);
        double v45 = _ps[0];
        newx = x * (cos(psi * r * v45) + sin(psi * r * v45));
        newy = x * (cos(psi * r * v45) - sin(psi * r * v45));
        break;
      case 46: // Secant
        double v46 = _ps[0];
        double r = sqrt(x * x + y * y);
        newx = x;
        newy = 1 / (v46 * cos(v46 * r));
        break;
      case 47: // Twintrian
        double psi = _random.nextDouble();
        double v47 = _ps[0];
        double r = sqrt(x * x + y * y);
        double s = sin(psi * r * v47);
        double t = log(s * 2) / log(10) + cos(psi * r * v47);
        newx = x * t;
        newy = x * (t - pi * sin(psi * r * v47));
        break;
      case 48: // Cross
        double prefix = sqrt(1 / ((x * x - y * y) * (x * x - y * y)));
        newx = prefix * x;
        newy = prefix * y;
        break;
      default:
        throw 'Invalid type';
    }

    return Point(newx, newy);
  }
}
