import 'Common.dart';

class Pixel {
  Color color;
  int counter;

  Pixel()
      : color = Color(255, 255, 255),
        counter = 0;

  Pixel.init(Pixel p)
      : color = Color.init(p.color),
        counter = p.counter;
}

class Pixels {
  final int width;
  final int height;
  final List<Pixel> _data;

  Pixels(this.width, this.height)
      : _data = List<Pixel>.generate(width * height, (index) => Pixel());

  int _xy2index(int x, int y) {
    int index = y * width + x;
    return index;
  }

  Pixel getPixel(int x, int y) {
    return Pixel.init(_data[_xy2index(x, y)]);
  }

  void setPixel(int x, int y, Pixel pixel) {
    _data[_xy2index(x, y)] = pixel;
  }

  bool inRange(int x, int y) {
    if (0 <= x && x < width && 0 <= y && y < height) {
      return true;
    } else {
      return false;
    }
  }
}
