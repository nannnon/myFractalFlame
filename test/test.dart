import 'package:test/test.dart';
import '../src/Common.dart';
import '../src/MyFractalFlame.dart';
import '../src/Pixels.dart';

void main() {
  test('mapByCoefs', () {
    double x = 15, y = 800;
    double a = 1.5, b = 1.2, c = -0.1;
    double d = 0.8, e = -0.5, f = -1;
    var result = mapByCoefs(x, y, [a, b, c, d, e, f]);
    expect(result.x, a * x + b * y + c);
    expect(result.y, d * x + e * y + f);
  });

  test('Pixels', () {
    Pixels pixels = Pixels(128, 64);

    {
      Pixel p = pixels.getPixel(0, 0);
      expect(p.color.r, 0);
      expect(p.color.g, 0);
      expect(p.color.b, 0);
      expect(p.counter, 0);
    }
    {
      const int x = 1;
      const int y = 1;
      const double r = 255;
      const int c = 5;

      Pixel p = Pixel();
      p.color.r = r;
      p.counter = c;
      pixels.setPixel(x, y, p);

      Pixel p2 = pixels.getPixel(x, y);
      expect(p2.color.r, r);
      expect(p2.color.g, 0);
      expect(p2.color.b, 0);
      expect(p2.counter, c);
    }
    {
      const int x = 2;
      const int y = 5;
      const double g = 128;
      const int c = 7;

      Pixel p = pixels.getPixel(x, y);
      p.color.g = g;
      p.counter = c;
      pixels.setPixel(x, y, p);

      Pixel p2 = pixels.getPixel(x, y);
      expect(p2.color.r, 0);
      expect(p2.color.g, g);
      expect(p2.color.b, 0);
      expect(p2.counter, c);
    }
    {
      Pixel p = pixels.getPixel(0, 0);
      expect(p.color.r, 0);
      expect(p.color.g, 0);
      expect(p.color.b, 0);
      expect(p.counter, 0);
    }
  });

  test('MyFractalFlame', () {
    final mff = MyFractalFlame();
    mff.generate('output.png');
  });
}
