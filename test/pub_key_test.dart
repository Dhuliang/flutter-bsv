import 'package:bsv/bn.dart';
import 'package:bsv/point.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PubKey', () {
    // test('should create a blank public key', () {
    //   var pk = new PubKey();
    //   expect(pk != null, true);
    // });

    test('should create a public key with a point', () {
      var p = new PointWrapper();
      var pk = new PubKey(point: p);
      expect(pk.point != null, true);
    });

    test('should create a public key with a point with this convenient method',
        () {
      var p = new PointWrapper();
      var pk = new PubKey(point: p);
      expect(pk.point.toString(), p.toString());
    });

    // group('#fromObject', () {
    //   test('should make a public key from a point', () {
    //     should.exist(new PubKey().fromObject({ point: Point.getG() }).point)
    //   })
    // })

    group('#fromJSON', () {
      test('should input this public key', () {
        var pk = new PubKey();
        pk.fromJSON(
          '00041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });
    });

    group('#toJSON', () {
      test('should output this pubKey', () {
        var pk = new PubKey();
        var hex =
            '01041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341';

        expect(
          pk.fromJSON(hex).toJSON(),
          hex,
        );
      });

      test('should output this uncompressed pubKey', () {
        var pk = new PubKey();
        var hex =
            '00041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341';

        expect(
          pk.fromJSON(hex).toJSON(),
          hex,
        );
      });
    });

    group('#fromPrivKey', () {
      test('should make a public key from a privKey', () {
        expect(
            new PubKey().fromPrivKey(new PrivKey().fromRandom()).point != null,
            true);
      });
    });

    group('@fromPrivKey', () {
      test('should make a public key from a privKey', () {
        expect(
            PubKey.fromPrivKey(new PrivKey().fromRandom()).point != null, true);
      });
    });

    // group('#asyncFromPrivKey', () {
    //   test('should result the same as fromPrivKey', async () {
    //     var privKey = new PrivKey().fromRandom()
    //     var pubKey1 = new PubKey().fromPrivKey(privKey)
    //     var pubKey2 = await new PubKey().asyncFromPrivKey(privKey)
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })

    //   test('should result the same as fromPrivKey', async () {
    //     var privKey = new PrivKey().fromBn(new Bn(5))
    //     var pubKey1 = new PubKey().fromPrivKey(privKey)
    //     var pubKey2 = await new PubKey().asyncFromPrivKey(privKey)
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })
    // })

    // group('@asyncFromPrivKey', () {
    //   test('should result the same as fromPrivKey', async () {
    //     var privKey = new PrivKey().fromRandom()
    //     var pubKey1 = PubKey.fromPrivKey(privKey)
    //     var pubKey2 = await PubKey.asyncFromPrivKey(privKey)
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })

    //   test('should result the same as fromPrivKey', async () {
    //     var privKey = new PrivKey().fromBn(new Bn(5))
    //     var pubKey1 = PubKey.fromPrivKey(privKey)
    //     var pubKey2 = await PubKey.asyncFromPrivKey(privKey)
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })
    // })

    // group('#fromHex', () {
    //   test('should parse this uncompressed public key', () {
    //     var pk = new PubKey();
    //     pk.fromHex(
    //         '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341');
    //     pk.point
    //       .getX()
    //       .toString(16)
    //       .should.equal(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //       )
    //     pk.point
    //       .getY()
    //       .toString(16)
    //       .should.equal(
    //         '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //       )
    //   });
    // });

    group('#fromBuffer', () {
      test('should parse this uncompressed public key', () {
        var pk = new PubKey();
        pk.fromBuffer(hex.decode(
            '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'));

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });

      test('should parse this compressed public key', () {
        var pk = new PubKey();
        pk.fromBuffer(hex.decode(
            '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'));

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });

      test('should throw an error on this invalid public key', () {
        var pk = new PubKey();

        expect(
          () => pk.fromBuffer(hex.decode(
              '091ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a')),
          throwsA(PubKey.INVALID_DER_FORMAT),
        );
      });
    });

    // group('#asyncFromBuffer', () {
    //   test('should derive the same as fromBuffer', async () {
    //     var pubKey = new PubKey().fromPrivKey(new PrivKey().fromRandom())
    //     var pubKey1 = new PubKey().fromBuffer(pubKey.toBuffer())
    //     var pubKey2 = await new PubKey().asyncFromBuffer(pubKey.toBuffer())
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })
    // })

    // group('@asyncFromBuffer', () {
    //   test('should derive the same as fromBuffer', async () {
    //     var pubKey = PubKey.fromPrivKey(new PrivKey().fromRandom())
    //     var pubKey1 = PubKey.fromBuffer(pubKey.toBuffer())
    //     var pubKey2 = await PubKey.asyncFromBuffer(pubKey.toBuffer())
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })
    // })

    group('#fromFastBuffer', () {
      test('should convert from this known fast buffer', () {
        var pubKey = new PubKey().fromFastBuffer(hex.decode(
            '01041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'));

        expect(
          pubKey.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );
      });
    });

    group('#fromDer', () {
      test('should parse this uncompressed public key', () {
        var pk = new PubKey();
        pk.fromDer(hex.decode(
          '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        ));

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });

      test('should parse this compressed public key', () {
        var pk = new PubKey();
        pk.fromDer(hex.decode(
          '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        ));

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });

      test('should throw an error on this invalid public key', () {
        var pk = new PubKey();

        expect(
          () => pk.fromBuffer(hex.decode(
              '091ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a')),
          throwsA(PubKey.INVALID_DER_FORMAT),
        );
      });
    });

    group('@fromDer', () {
      test('should parse this uncompressed public key', () {
        var pk = PubKey.fromDer(hex.decode(
            '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'));

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });

      test('should parse this compressed public key', () {
        var pk = PubKey.fromDer(hex.decode(
          '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        ));

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });

      test('should throw an error on this invalid public key', () {
        expect(
          () => PubKey.fromDer(hex.decode(
              '091ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a')),
          throwsA(PubKey.INVALID_DER_FORMAT),
        );
      });
    });

    group('#fromString', () {
      test('should parse this known valid public key', () {
        var pk = new PubKey();
        pk.fromString(
            '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341');

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });
    });

    group('#fromX', () {
      test('should create this known public key', () {
        var x = BigIntX.fromHex(
            '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a');

        var pk = new PubKey();
        pk.fromX(isOdd: true, x: x.bn);

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });
    });

    group('@fromX', () {
      test('should create this known public key', () {
        var x = BigIntX.fromHex(
            '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a');

        var pk = new PubKey();
        pk.fromX(isOdd: true, x: x.bn);

        expect(
          pk.point!.getX().toString(radix: 16),
          '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );

        expect(
          pk.point!.getY().toString(radix: 16),
          '7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });
    });

    group('#toHex', () {
      test('should return this compressed DER format', () {
        var x = BigIntX.fromHex(
            '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a');
        var pk = new PubKey();
        pk.fromX(isOdd: true, x: x.bn);

        expect(
          pk.toHex(),
          '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );
      });
    });

    group('#toBuffer', () {
      test('should return this compressed DER format', () {
        var x = BigIntX.fromHex(
            '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a');
        var pk = new PubKey();
        pk.fromX(isOdd: true, x: x.bn);
        expect(
          hex.encode(pk.toBuffer()),
          '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );
      });
    });

    group('#toFastBuffer', () {
      test('should return fast buffer', () {
        var x = BigIntX.fromHex(
            '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a');

        var pk = new PubKey();
        pk.fromX(isOdd: true, x: x.bn);
        expect(
          hex.encode(pk.toFastBuffer()),
          '01041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );

        expect(pk.toFastBuffer().length > 64, true);
      });
    });

    group('#toDer', () {
      test('should return this compressed DER format', () {
        var x = BigIntX.fromHex(
            '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a');

        var pk = new PubKey();
        pk.fromX(isOdd: true, x: x.bn);

        expect(
          hex.encode(pk.toDer(true)),
          '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
        );
      });

      test('should return this uncompressed DER format', () {
        var x = BigIntX.fromHex(
            '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a');

        var pk = new PubKey();
        pk.fromX(isOdd: true, x: x.bn);

        expect(
          hex.encode(pk.toDer(false)),
          '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        );
      });
    });

    group('#toString', () {
      test('should print this known public key', () {
        var hex =
            '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a';
        var pk = new PubKey();
        pk.fromString(hex);
        expect(pk.toString(), hex);
      });
    });

    group('#validate', () {
      test('should not throw an error if pubKey is valid', () {
        var hex =
            '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a';
        var pk = new PubKey();
        pk.fromString(hex);
        expect(pk.validate().point != null, true);
      });

      test('should not throw an error if pubKey is invalid', () {
        var hex =
            '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a0000000000000000000000000000000000000000000000000000000000000000';
        var pk = new PubKey();
        pk.fromString(hex);

        expect(
          () => pk.validate(),
          throwsA(PointWrapper.INVALID_Y_VALUE_OF_PUBLIC_KEY),
        );
      });

      test('should throw an error if pubKey is infinity', () {
        var pk = new PubKey();
        String errm = '';
        try {
          pk.point = PointWrapper.getG().mul(PointWrapper.getN());
        } catch (err) {
          print(errm);
        }
        expect(pk.point!.isInfinity, true);
        // errm.should.equal('point mul out of range');
      });
    });
  });
}
