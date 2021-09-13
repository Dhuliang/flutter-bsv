import 'package:bsv/src/bn.dart';
import 'package:bsv/src/point.dart';
import 'package:bsv/src/priv_key.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/src/extentsions/list.dart';

void main() {
  group('PrivKey', () {
    var hexStr =
        '96c132224121b509b7d0a16245e957d9192609c5637c6228311287b1be21627a';
    var buf = hex.decode(hexStr);
    var enctestnet = 'cSdkPxkAjA4HDr5VHgsebAPDEh9Gyub4HK8UJr2DFGGqKKy4K5sG';
    var enctu = '92jJzK4tbURm1C7udQXxeCBvXHoHJstDXRxAMouPG1k1XUaXdsu';
    var encmainnet = 'L2Gkw3kKJ6N24QcDuH4XDqt9cTqsKTVNDGz1CRZhk9cq4auDUbJy';
    var encmu = '5JxgQaFM1FMd38cd14e3mbdxsdSa9iM2BV6DHBYsvGzxkTNQ7Un';

    var testnetPriv = PrivKey.Testnet(bn: BigIntX.zero, compressed: true);

    test('should satisfy these basic API features', () {
      // let privKey = new PrivKey()
      // should.exist(privKey)
      // privKey = new PrivKey()
      // should.exist(privKey)

      // new PrivKey().constructor.should.equal(new PrivKey().constructor)
      // new PrivKey.Testnet().constructor.should.equal(
      //   new PrivKey.Testnet().constructor
      // )

      print(testnetPriv.privKeyVersionByteNum);
      expect(testnetPriv.fromRandom().toString()[0], 'c');
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
          PrivKey.Testnet(bn: BigIntX.fromBuffer(buf), compressed: false);
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
        expect(
          privKey.toHex(),
          '8096c132224121b509b7d0a16245e957d9192609c5637c6228311287b1be21627a',
        );
        var privKey2 = PrivKey.fromJSON(privKey.toHex());
        expect(privKey2.toWif(), encmu);
      });
    });

    group('#toString', () {
      test('should output this address correctly', () {
        var privKey = new PrivKey.fromString(encmu);
        expect(privKey.toString(), encmu);
      });
    });

    group('#fromRandom', () {
      test('should set bn gt 0 and lt n, and should be compressed', () {
        var privKey = PrivKey().fromRandom();
        expect(privKey.bn!.gt(0), true);
        expect(privKey.bn!.lt(PointWrapper.getN()), true);
        expect(privKey.compressed, true);
      });
    });

    group('@fromRandom', () {
      test('should set bn gt 0 and lt n, and should be compressed', () {
        var privKey = PrivKey.fromRandom();
        expect(privKey.bn!.gt(0), true);
        expect(privKey.bn!.lt(PointWrapper.getN()), true);
        expect(privKey.compressed, true);
      });
    });

    group('#toHex', () {
      test('should return a hex string', () {
        var privKey = PrivKey.fromBn((BigIntX.fromNum(5)));
        expect(
          privKey.toHex(),
          '80000000000000000000000000000000000000000000000000000000000000000501',
        );
      });
    });

    group('#toBuffer', () {
      test('should return a buffer', () {
        var privKey = PrivKey.fromBn((BigIntX.fromNum(5)));
        expect(
          privKey.toBuffer().toHex(),
          '80000000000000000000000000000000000000000000000000000000000000000501',
        );
      });
    });

    group('#fromHex', () {
      test('should return a hex string', () {
        var privKey = new PrivKey.fromHex(
            '80000000000000000000000000000000000000000000000000000000000000000501');
        expect(
          privKey.toHex(),
          '80000000000000000000000000000000000000000000000000000000000000000501',
        );
      });
    });

    group('#fromBuffer', () {
      test('should return a buffer', () {
        var privKey = PrivKey.fromBuffer(
          hex.decode(
              '80000000000000000000000000000000000000000000000000000000000000000501'),
        );

        expect(
          privKey.toHex(),
          '80000000000000000000000000000000000000000000000000000000000000000501',
        );
      });

      test('should throw an error if buffer is wrong length', () {
        expect(
          () => PrivKey().fromBuffer(
            hex.decode(
              '8000000000000000000000000000000000000000000000000000000000000000050100',
            ),
          ),
          throwsA(PrivKey.INVALID_PRIV_KEY_LENGTH),
        );

        expect(
          () => PrivKey().fromBuffer(
            hex.decode(
              '8000000000000000000000000000000000000000000000000000000000000005',
            ),
          ),
          throwsA(PrivKey.INVALID_PRIV_KEY_LENGTH),
        );
      });

      test('should throw an error if buffer has wrong versionByteNum byte', () {
        expect(
          () => PrivKey().fromBuffer(
            hex.decode(
              '90000000000000000000000000000000000000000000000000000000000000000501',
            ),
          ),
          throwsA(PrivKey.INVALID_VERSION_BYTE_NUM_BYTE),
        );
      });
    });

    group('#toBn', () {
      test('should return a bn', () {
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(5));
        expect(privKey.toBn()!.eq(5), true);
      });
    });

    group('#fromBn', () {
      test('should create a privKey from a bignum', () {
        var privKey = new PrivKey.fromBn(BigIntX.fromNum(5));
        expect(privKey.toBn()!.eq(5), true);
      });
    });

    group('@fromBn', () {
      test('should create a privKey from a bignum', () {
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(5));
        expect(privKey.toBn()!.eq(5), true);
      });
    });

    group('#validate', () {
      test('should unvalidate these privKeys', () {
        var privKey = new PrivKey();
        privKey.compressed = true;
        privKey.bn = PointWrapper.getN();

        expect(
          () => privKey.validate(),
          throwsA(PrivKey.INVALID_NUMBER_N),
        );

        privKey.bn = privKey.bn!.sub(BigIntX.one);
        privKey.compressed = null;

        expect(
          () => privKey.validate(),
          throwsA(PrivKey.INVALID_COMPRESSED),
        );

        privKey.compressed = true;
        expect(privKey.validate(), privKey);
      });
    });

    group('#fromWif', () {
      test('should parse this compressed testnet address correctly', () {
        var privKey = new PrivKey().fromWif(encmainnet);
        expect(privKey.toWif(), encmainnet);
      });
    });

    group('@fromWif', () {
      test('should parse this compressed testnet address correctly', () {
        var privKey = new PrivKey.fromWif(encmainnet);
        expect(privKey.toWif(), encmainnet);
      });
    });

    group('#toWif', () {
      test('should parse this compressed testnet address correctly', () {
        var privKey = new PrivKey.Testnet(bn: BigIntX.zero, compressed: true);
        privKey.fromWif(enctestnet);
        expect(privKey.toWif(), enctestnet);
      });
    });

    group('#fromString', () {
      test('should parse this uncompressed testnet address correctly', () {
        var privKey = new PrivKey.Testnet(bn: BigIntX.zero, compressed: true);
        privKey.fromString(enctu);
        expect(privKey.toWif(), enctu);
      });
    });

    group('#toString', () {
      test('should parse this uncompressed mainnet address correctly', () {
        var privKey = new PrivKey();
        privKey.fromString(encmu);
        expect(privKey.toString(), encmu);
      });
    });
  });
}
