import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/random.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  group("RandomBytes", () {
    group("@getRandomBuffer", () {
      test('should return a buffer', () {
        var bytes = RandomBytes.getRandomBuffer(8);

        expect(bytes.length, 8);
        expect(bytes is Uint8List, true);
      });

      test('should not equate two 256 bit random buffers', () {
        var bytes1 = RandomBytes.getRandomBuffer(32);
        var bytes2 = RandomBytes.getRandomBuffer(32);

        var hex1 = bytes1.toHex();
        var hex2 = bytes2.toHex();

        expect(hex1 == hex2, false);
        expect(hex1.length, 64);
      });

      test('should generate 100 8 byte buffers in a row that are not equal',
          () {
        List<String> hexs = [];

        for (var i = 0; i < 100; i++) {
          var bytes = RandomBytes.getRandomBuffer(8);
          hexs.add(bytes.toHex());
        }

        for (var i = 0; i < 100; i++) {
          for (var j = i + 1; j < 100; j++) {
            expect(hexs[i] == hexs[j], false);
          }
        }
      });
    });
  });
}
