import 'dart:math';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'Common.dart';
import 'MyFunction.dart';
import 'Variation.dart';
import 'Pixels.dart';

class MyFractalFlame {
  static const int _seed = 42;
  static const int _samplesNum = 100;
  static const double _minInitialCoord = -2;
  static const double _maxInitialCoord = 2;
  static const int _stepsNum = 5000;
  static const int _width = 1024;
  static const int _height = 768;
  static const double _scale = 100;
  static const double _gamma = 1.5;

  Random _random;
  List<MyFunction> _functions;
  List<double> _finalTCoefs;
  Pixels _pixels;

  MyFractalFlame() {
    _random = Random(_seed);

    _functions = [];
    int functionsNum = _random.nextInt(5) + 1;
    const double maxCoef = 1.5;
    for (int i = 0; i < functionsNum; ++i) {
      double p = _getRandom(0.01, 1);

      double ca = _getRandom(-maxCoef, maxCoef);
      double cb = _getRandom(-maxCoef, maxCoef);
      double cc = _getRandom(-maxCoef, maxCoef);
      double cd = _getRandom(-maxCoef, maxCoef);
      double ce = _getRandom(-maxCoef, maxCoef);
      double cf = _getRandom(-maxCoef, maxCoef);

      List<Variation> vars = [];
      int varsNum = _random.nextInt(5) + 1;
      for (int j = 0; j < varsNum; ++j) {
        int type = _random.nextInt(Variation.variationTypesNum);
        double w = _getRandom(0.01, 1);

        const double maxParam = 2;
        double p0 = _getRandom(-maxParam, maxParam);
        double p1 = _getRandom(-maxParam, maxParam);
        double p2 = _getRandom(-maxParam, maxParam);
        double p3 = _getRandom(-maxParam, maxParam);

        vars.add(Variation(type, w, [p0, p1, p2, p3]));
      }

      double pta = _getRandom(-maxCoef, maxCoef);
      double ptb = _getRandom(-maxCoef, maxCoef);
      double ptc = _getRandom(-maxCoef, maxCoef);
      double ptd = _getRandom(-maxCoef, maxCoef);
      double pte = _getRandom(-maxCoef, maxCoef);
      double ptf = _getRandom(-maxCoef, maxCoef);

      double r = _getRandom(0, 255);
      double g = _getRandom(0, 255);
      double b = _getRandom(0, 255);

      _functions.add(MyFunction(p, [ca, cb, cc, cd, ce, cf], vars,
          [pta, ptb, ptc, ptd, pte, ptf], Color(r, g, b)));
    }

    double fa = _getRandom(-maxCoef, maxCoef);
    double fb = _getRandom(-maxCoef, maxCoef);
    double fc = _getRandom(-maxCoef, maxCoef);
    double fd = _getRandom(-maxCoef, maxCoef);
    double fe = _getRandom(-maxCoef, maxCoef);
    double ff = _getRandom(-maxCoef, maxCoef);
    _finalTCoefs = [fa, fb, fc, fd, fe, ff];

    _pixels = Pixels(_width, _height);
  }

  List<double> _normalizePs() {
    // 写像の確率を最後に1になるよう計算する
    List<double> normalizedPs = [];

    for (MyFunction function in _functions) {
      normalizedPs.add(function.probability);
    }

    double sum = normalizedPs.reduce((value, element) => value + element);
    for (int i = 0; i < normalizedPs.length; ++i) {
      normalizedPs[i] /= sum;
    }

    for (int i = 1; i < normalizedPs.length; ++i) {
      normalizedPs[i] += normalizedPs[i - 1];
    }

    return normalizedPs;
  }

  double _getRandom(double min, double max) {
    double value = (max - min) * _random.nextDouble() + min;
    return value;
  }

  void iterate() {
    List<double> normalizedPs = _normalizePs();

    for (int sample = 0; sample < _samplesNum; ++sample) {
      print('sample:${sample}/${_samplesNum - 1}');
      // 初期位置
      double x = _getRandom(_minInitialCoord, _maxInitialCoord);
      double y = _getRandom(_minInitialCoord, _maxInitialCoord);

      for (int step = 0; step < _stepsNum; ++step) {
        // Functionを選択
        int fi = -1;
        {
          double value = _random.nextDouble();
          for (int i = 0; i < normalizedPs.length; ++i) {
            if (value <= normalizedPs[i]) {
              fi = i;
              break;
            }
          }
        }

        // 写像
        Point point = _functions[fi].map(x, y);

        // Final transformation
        Point afterFT = mapByCoefs(point.x, point.y, _finalTCoefs);

        x = afterFT.x;
        y = afterFT.y;

        // x, yが大きい値になったら中断
        if (x.isNaN || y.isNaN || x.abs() >= 10e100 || y.abs() >= 10e100) {
          break;
        }

        // プロットする
        if (step >= 20) {
          // 画像上の座標に変換
          int imgX = (_scale * x + _width / 2).round();
          int imgY = (_scale * y + _height / 2).round();

          if (_pixels.inRange(imgX, imgY)) {
            Pixel p = _pixels.getPixel(imgX, imgY);
            Color fColor = _functions[fi].color;

            Pixel p2 = Pixel();
            p2.color.r = (p.color.r + fColor.r) / 2.0;
            p2.color.g = (p.color.g + fColor.g) / 2.0;
            p2.color.b = (p.color.b + fColor.b) / 2.0;
            p2.counter = p.counter + 1;

            _pixels.setPixel(imgX, imgY, p2);
          }
        }
      }
    }
  }

  void reduce() {
    int maxCount = 0;
    for (int x = 0; x < _width; ++x) {
      for (int y = 0; y < _height; ++y) {
        int count = _pixels.getPixel(x, y).counter;
        maxCount = max(maxCount, count);
      }
    }

    if (maxCount <= 1) {
      return;
    }

    for (int x = 0; x < _width; ++x) {
      for (int y = 0; y < _height; ++y) {
        Pixel pixel = _pixels.getPixel(x, y);

        if (pixel.counter > 0) {
          double afterLog = log(pixel.counter) / log(maxCount);
          double afterGamma = pow(afterLog, 1 / _gamma);

          Pixel after = Pixel();
          after.color.r = pixel.color.r * afterGamma;
          after.color.g = pixel.color.g * afterGamma;
          after.color.b = pixel.color.b * afterGamma;

          _pixels.setPixel(x, y, after);
        }
      }
    }
  }

  void encode(String outputImageFileName) {
    final image = img.Image(_width, _height);
    img.fill(image, img.getColor(0, 0, 0));

    for (int x = 0; x < _width; ++x) {
      for (int y = 0; y < _height; ++y) {
        Color color = _pixels.getPixel(x, y).color;
        int r = color.r.round();
        int g = color.g.round();
        int b = color.b.round();
        image.setPixel(x, y, img.getColor(r, g, b));
      }
    }

    File(outputImageFileName).writeAsBytesSync(img.encodePng(image));
  }

  void generate(String outputImageFileName) {
    iterate();
    reduce();
    encode(outputImageFileName);
  }
}
