import 'dart:convert';

import 'package:bsv/bn.dart';
import 'package:bsv/point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Point', () {
    //   test('should create a point',  () {
    //   let p = new PointWrapper
    //   should.exist(p)
    //   p = new PointWrapper
    //   should.exist(p)
    //   ;(p instanceof Point).should.equal(true)
    // })

    // test('should have the standard properties for a point',  () {
    //   var p = new PointWrapper
    //   var props = ['curve', 'type', 'precomputed', 'x', 'y', 'inf']

    //   // all enumerable, own properties should be in prop
    //   for (var k in p) {
    //     if (Object.prototype.hasOwnProperty.call(p, k)) {
    //       props.indexOf(k).should.not.equal(-1)
    //     }
    //   }

    //   // all props should be properties of a point
    //   props.forEach(function (k) {
    //     ;(p[k] === undefined).should.equal(false)
    //   })
    // })

    group('#copyFrom', () {
      test('should copy G', () {
        var point = PointWrapper.getG();
        var point2;

        expect(
          () => point.copyFrom(point2),
          throwsA(PointWrapper.INVALID_POINT_CONSTRUCTOR),
        );
        var point3 = new PointWrapper();
        point.copyFrom(point3);
        expect(point.toString(), point3.toString());
      });
    });

    group('#toJSON', () {
      test('should print G to JSON', () {
        var G = PointWrapper.getG();
        var json = G.toJson();

        expect(json['x'], G.point!.x.toString());
        expect(json['y'], G.point!.y.toString());
      });
    });

    // group('#fromJSON', () {
    //   test('should recover G', () {
    //     // new PointWrapper
    //     //   .fromJSON(PointWrapper.getG().toJSON())
    //     //   .eq(PointWrapper.getG())
    //     //   .should.equal(true)
    //   });
    // });

    group('#toString', () {
      test('should convert G to a string', () {
        var G = PointWrapper.getG();
        expect(G.toString(), json.encode(G.toJson()));
      });
    });

    // group('#fromString',  () {
    //   test('should convert a json string to G',  () {
    //     var G = PointWrapper.getG()
    //     new PointWrapper
    //       .fromString(G.toString())
    //       .eq(G)
    //       .should.equal(true)
    //   })
    // })

    group('#getX', () {
      test('should return a Bn', () {
        var p = new PointWrapper();
        expect(p.getX() is BigIntX, true);
      });

      test('should return 0', () {
        var p = new PointWrapper();
        expect(p.getX().toString(), '0');
      });

      test('should be convertable to a buffer', () {
        var p = new PointWrapper();
        expect(p.getX().toBuffer(size: 32).length, 32);
      });
    });

    group('#getY', () {
      test('should return a Bn', () {
        var p = new PointWrapper();
        expect(p.getY() is BigIntX, true);
      });

      test('should return 0', () {
        var p = new PointWrapper();
        expect(p.getY().toString(), '0');
      });

      test('should be convertable to a buffer', () {
        var p = new PointWrapper();
        expect(p.getY().toBuffer(size: 32).length, 32);
      });
    });

    group('#add', () {
      test('should get back a point', () {
        var p1 = PointWrapper.getG();
        var p2 = PointWrapper.getG();
        var p3 = p1.add(p2);

        expect(p3 is PointWrapper, true);
      });

      test('should accurately add g to itself', () {
        var p1 = PointWrapper.getG();
        var p2 = PointWrapper.getG();
        var p3 = p1.add(p2);
        expect(
          p3.getX().toString(),
          '89565891926547004231252920425935692360644145829622209833684329913297188986597',
        );

        expect(
          p3.getY().toString(),
          '12158399299693830322967808612713398636155367887041628176798871954788371653930',
        );
      });
    });

    group('#mul', () {
      test('should get back a point', () {
        var g = PointWrapper.getG();
        var b = g.mul(BigIntX.fromNum(2));

        expect(b is PointWrapper, true);
      });

      test('should accurately multiply g by 2', () {
        var g = PointWrapper.getG();
        var b = g.mul(BigIntX.fromNum(2));

        expect(
          b.getX().toString(),
          '89565891926547004231252920425935692360644145829622209833684329913297188986597',
        );

        expect(
          b.getY().toString(),
          '12158399299693830322967808612713398636155367887041628176798871954788371653930',
        );
      });

      test('should accurately multiply g by n-1', () {
        var g = PointWrapper.getG();
        var n = PointWrapper.getN();
        var b = g.mul(n.sub(BigIntX.one));

        expect(
          b.getX().toString(),
          '55066263022277343669578718895168534326250603453777594175500187360389116729240',
        );

        expect(
          b.getY().toString(),
          '83121579216557378445487899878180864668798711284981320763518679672151497189239',
        );
      });

      test(
          'should accurate multiply these problematic values related to a bug in bn.js',
          () {
        // see these discussions:
        // https://github.com/bitpay/bitcore/pull/894
        // https://github.com/indutny/elliptic/issues/17
        // https://github.com/indutny/elliptic/pull/18
        // https://github.com/indutny/elliptic/pull/19
        // https://github.com/indutny/bn.js/commit/3557d780b07ed0ed301e128f326f83c2226fb679
        {
          var nhex =
              '6d1229a6b24c2e775c062870ad26bc261051e0198c67203167273c7c62538846';

          var n = BigIntX.fromString(nhex, radix: 16);
          var g1 = PointWrapper.getG(); // precomputed g
          var g2 = PointWrapper.fromX(
            isOdd: false,
            x: BigIntX.fromString(
              "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
              radix: 16,
            ).bn,
          ); // non-precomputed g
          var p1 = g1.mul(n);
          var p2 = g2.mul(n);
          var pxhex =
              'd6106302d2698d6a41e9c9a114269e7be7c6a0081317de444bb2980bf9265a01';
          var pyhex =
              'e05fb262e64b108991a29979809fcef9d3e70cafceb3248c922c17d83d66bc9d';
          expect(p1.getX().toHex(), pxhex);

          expect(p1.getY().toHex(), pyhex);

          expect(p2.getX().toHex(), pxhex);

          expect(p2.getY().toHex(), pyhex);
        }
        {
          var nhex =
              'f2cc9d2b008927db94b89e04e2f6e70c180e547b3e5e564b06b8215d1c264b53';
          var n = BigIntX.fromString(nhex, radix: 16);
          var g1 = PointWrapper.getG(); // precomputed g
          var g2 = new PointWrapper.fromX(
            isOdd: false,
            x: BigIntX.fromString(
              '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
              radix: 16,
            ).bn,
          ); // non-precomputed g
          var p1 = g1.mul(n);
          var p2 = g2.mul(n);
          var pxhex =
              'e275faa35bd1e88f5df6e8f9f6edb93bdf1d65f4915efc79fd7a726ec0c21700';
          var pyhex =
              '367216cb35b086e6686d69dddd822a8f4d52eb82ac5d9de18fdcd9bf44fa7df7';

          expect(p1.getX().toHex(), pxhex);

          expect(p1.getY().toHex(), pyhex);

          expect(p2.getX().toHex(), pxhex);

          expect(p2.getY().toHex(), pyhex);
        }
      });

      group('#mulAdd', () {
        test('should get back a point', () {
          var p1 = PointWrapper.getG();
          var bn1 = BigIntX.fromNum(5);
          var p2 = PointWrapper.getG().add(p1);
          var bn2 = BigIntX.fromNum(6);

          expect(
            p1.mulAdd(bn1, p2, bn2).getX().toString(),
            p1.mul(bn1).add(p2.mul(bn2)).getX().toString(),
          );

          expect(
            p1.mulAdd(bn1, p2, bn2).getY().toString(),
            p1.mul(bn1).add(p2.mul(bn2)).getY().toString(),
          );
        });
      });

      group('@getN', () {
        test('should return n', () {
          var bn = PointWrapper.getN();
          expect(bn is BigIntX, true);
        });
      });

      group('@fromX', () {
        test('should return g', () {
          var g = PointWrapper.getG();
          var p = PointWrapper.fromX(isOdd: false, x: g.getX().bn);
          expect(g.point == p.point, true);
        });
      });

      group('#fromX', () {
        test('should return g', () {
          var g = PointWrapper.getG();
          var p = new PointWrapper.fromX(isOdd: false, x: g.getX().bn);
          expect(g.point == p.point, true);
        });
      });

      group('#validate', () {
        test('should validate this valid point', () {
          var x = BigIntX.fromHex(
            'ac242d242d23be966085a2b2b893d989f824e06c9ad0395a8a52f055ba39abb2',
          );

          var y = BigIntX.fromHex(
            '4836ab292c105a711ed10fcfd30999c31ff7c02456147747e03e739ad527c380',
          );

          var p = new PointWrapper(x: x.bn, y: y.bn);
          expect(p.validate() is PointWrapper, true);
        });

        test('should invalidate this invalid point', () {
          var x = BigIntX.fromHex(
            'ac242d242d23be966085a2b2b893d989f824e06c9ad0395a8a52f055ba39abb2',
          );
          var y = BigIntX.fromHex(
            '0000000000000000000000000000000000000000000000000000000000000000',
          );

          var p = new PointWrapper(x: x.bn, y: y.bn);

          expect(
            () => p.validate(),
            throwsA(PointWrapper.INVALID_Y_VALUE_OF_PUBLIC_KEY),
          );
        });
      });
    });
  });
}
