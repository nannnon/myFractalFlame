import 'dart:math';
import 'Common.dart';
import 'Variation.dart';

class MyFunction {
  final double _probability;
  final List<double> _coefs;
  final List<Variation> _variations;
  final List<double> _postTransformCoefs;
  final Color _color;

  double get probability => _probability;
  Color get color => _color;

  MyFunction(this._probability, this._coefs, this._variations,
      this._postTransformCoefs, this._color) {
    if (_probability <= 0) {
      throw '_probability must be larger than 0';
    }
    if (_coefs.length != 6) {
      throw '_coefs length is not 6';
    }
    if (_variations.length == 0) {
      throw '_variations length is zero';
    }
    if (_postTransformCoefs.length != 6) {
      throw '_postTransformCoefs length is not 6';
    }

    // Varitionの重みの和が1になるようにする
    List<double> weights = [];
    for (Variation variation in _variations) {
      weights.add(variation.weight);
    }
    double sum = weights.reduce((value, element) => value + element);
    for (int i = 0; i < _variations.length; ++i) {
      _variations[i].weight /= sum;
    }
  }

  Point map(double x, double y) {
    // アフィン変換
    Point point = mapByCoefs(x, y, _coefs);

    // 非線形写像
    Point afterVar = Point(0, 0);
    for (Variation variation in _variations) {
      afterVar += variation.map(point.x, point.y) * variation.weight;
    }

    // Post transformation
    Point afterPT = mapByCoefs(afterVar.x, afterVar.y, _postTransformCoefs);

    return afterPT;
  }
}
