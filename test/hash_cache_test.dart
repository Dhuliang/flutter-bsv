import 'dart:convert';

import 'package:bsv/hash_cache.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  group('HashCache', () {
    var prevoutsHashBuf = hex.decode('01' * 32);
    var sequenceHashBuf = hex.decode('02' * 32);
    var outputsHashBuf = hex.decode('03' * 32);
    var hashCache = new HashCache(
      prevoutsHashBuf: prevoutsHashBuf,
      sequenceHashBuf: sequenceHashBuf,
      outputsHashBuf: outputsHashBuf,
    );

    test('should satisfy this basic API', () {
      expect(hashCache.prevoutsHashBuf.length, 32);
      expect(hashCache.sequenceHashBuf.length, 32);
      expect(hashCache.outputsHashBuf.length, 32);
    });

    group('#fromBuffer', () {
      test('should parse this known message', () {
        var hashCache1 = new HashCache().fromBuffer(hashCache.toBuffer());

        expect(
          hashCache1.toHex(),
          '7b22707265766f75747348617368427566223a2230313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031222c2273657175656e636548617368427566223a2230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032222c226f75747075747348617368427566223a2230333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033227d',
        );
      });
    });

    group('#toBuffer', () {
      test('should parse this known message', () {
        expect(
          hashCache.toBuffer().toHex(),
          '7b22707265766f75747348617368427566223a2230313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031222c2273657175656e636548617368427566223a2230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032222c226f75747075747348617368427566223a2230333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033227d',
        );
      });
    });

    group('#fromJSON', () {
      test('should parse this known json hashCache', () {
        expect(
          new HashCache()
              .fromJSON(
                json.decode(
                    '{"prevoutsHashBuf":"0101010101010101010101010101010101010101010101010101010101010101","sequenceHashBuf":"0202020202020202020202020202020202020202020202020202020202020202","outputsHashBuf":"0303030303030303030303030303030303030303030303030303030303030303"}'),
              )
              .toHex(),
          '7b22707265766f75747348617368427566223a2230313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031222c2273657175656e636548617368427566223a2230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032303230323032222c226f75747075747348617368427566223a2230333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033303330333033227d',
        );
      });
    });

    group('#toJSON', () {
      test('should create this known message', () {
        expect(
          json.encode(hashCache.toJSON()),
          '{"prevoutsHashBuf":"0101010101010101010101010101010101010101010101010101010101010101","sequenceHashBuf":"0202020202020202020202020202020202020202020202020202020202020202","outputsHashBuf":"0303030303030303030303030303030303030303030303030303030303030303"}',
        );
      });
    });
  });
}