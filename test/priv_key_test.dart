import 'package:bsv/bn.dart';
import 'package:bsv/priv_key.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrivKey', () {
    var hexStr =
        '96c132224121b509b7d0a16245e957d9192609c5637c6228311287b1be21627a';
    var buf = hex.decode(hexStr);
    var enctestnet = 'cSdkPxkAjA4HDr5VHgsebAPDEh9Gyub4HK8UJr2DFGGqKKy4K5sG';
    var enctu = '92jJzK4tbURm1C7udQXxeCBvXHoHJstDXRxAMouPG1k1XUaXdsu';
    var encmainnet = 'L2Gkw3kKJ6N24QcDuH4XDqt9cTqsKTVNDGz1CRZhk9cq4auDUbJy';
    var encmu = '5JxgQaFM1FMd38cd14e3mbdxsdSa9iM2BV6DHBYsvGzxkTNQ7Un';

    test('should satisfy these basic API features', () {
      // let privKey = new PrivKey()
      // should.exist(privKey)
      // privKey = new PrivKey()
      // should.exist(privKey)

      // new PrivKey().constructor.should.equal(new PrivKey().constructor)
      // new PrivKey.Testnet().constructor.should.equal(
      //   new PrivKey.Testnet().constructor
      // )

      print(PrivKey.testnet().privKeyVersionByteNum);
      expect(PrivKey.testnet().fromRandom().toString()[0], 'c');
    });

    test('should create a 0 private key with this convenience method', () {
      var bn = BigIntX.zero;
      var privKey = new PrivKey(bn: bn);
      expect(privKey.bn.toString(), bn.toString());
    });

    test('should create a mainnet private key', () {
      var privKey = PrivKey(bn: BigIntX.fromBuffer(buf), compressed: true);
      expect(privKey.toString(), encmainnet);
    });

    test('should create an uncompressed testnet private key', () {
      var privKey =
          PrivKey.testnet(bn: BigIntX.fromBuffer(buf), compressed: false);
      expect(privKey.toString(), enctu);
    });

    test('should create an uncompressed mainnet private key', () {
      var privKey = PrivKey(bn: BigIntX.fromBuffer(buf), compressed: false);
      expect(privKey.toString(), encmu);
    });

    group('#fromObject', () {
      test('should set bn', () {
        // should.exist(new PrivKey().fromObject({ bn: Bn.fromBuffer(buf) }).bn)
      });
    });

    group('#fromJSON', () {
      test('should input this address correctly', () {
        var privKey = PrivKey.fromString(encmu);
        var privKey2 = PrivKey.fromJSON(privKey.toHex());
        expect(privKey2.toWif(), encmu);
      });
    });
  });
}
