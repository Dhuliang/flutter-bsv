import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/src/cmp.dart';

void main() {
  group("cmp", () {
    test("should know if these buffers are equal", () {
      var buf1, buf2;

      buf1 = Uint8List.fromList([]);
      buf2 = Uint8List.fromList([]);
      expect(cmp(buf1, buf2), true);

      buf1 = Uint8List.fromList([1]);
      buf2 = Uint8List.fromList([]);
      expect(cmp(buf1, buf2), false);

      buf1 = Uint8List.fromList([]);
      buf2 = Uint8List.fromList([1]);
      expect(cmp(buf1, buf2), false);

      buf1 = Uint8List.fromList([1]);
      buf2 = Uint8List.fromList([1]);
      expect(cmp(buf1, buf2), true);

      buf1 = Uint8List.fromList([1, 1]);
      buf2 = Uint8List.fromList([1]);
      expect(cmp(buf1, buf2), false);

      buf1 = Uint8List.fromList([1]);
      buf2 = Uint8List.fromList([1, 1]);
      expect(cmp(buf1, buf2), false);

      buf1 = Uint8List.fromList([1, 1]);
      buf2 = Uint8List.fromList([1, 1]);
      expect(cmp(buf1, buf2), true);

      buf1 = Uint8List.fromList([1, 0]);
      buf2 = Uint8List.fromList([1, 1]);
      expect(cmp(buf1, buf2), false);

      buf1 = Uint8List.fromList([1]);
      buf2 = Uint8List.fromList([1, 0]);
      expect(cmp(buf1, buf2), false);
    });
  });
}
