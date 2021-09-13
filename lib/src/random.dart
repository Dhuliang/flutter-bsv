import 'dart:math';
import 'dart:typed_data';

class RandomBytes {
  static Uint8List getRandomBuffer(int length) {
    assert(length > 0);

    var random = Random.secure();
    var list = Uint8List(length);

    for (var i = 0; i < length; i++) {
      list[i] = random.nextInt(256);
    }

    return list;
  }
}
