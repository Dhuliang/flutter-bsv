import 'dart:typed_data';

import 'package:bsv/aescbc.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

import './vectors/aescbc.dart';

void main() {
  group("Aescbc", () {
    group('vectors', () {
      for (var i = 0; i < aescbcJson.length; i++) {
        var vector = aescbcJson[i];
        test('should pass sjcl test vector $i', () {
          final key = hex.decode(vector['key']!);
          final iv = hex.decode(vector['iv']!);
          final data = hex.decode(vector['pt']!);

          final ctBuf = hex.decode(vector['ct']!);

          final encHex = hex.encode(Aescbc.encrypt(
              data as Uint8List, key as Uint8List, iv as Uint8List));

          expect(encHex.substring(0), vector['ct']);

          final decHex =
              hex.encode(Aescbc.decrypt(ctBuf as Uint8List, key, iv));

          expect(decHex, vector['pt']);
        });
      }
    });
  });
}
