import 'package:bsv/point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Point', () {
    
  //   test('should create a point',  () {
  //   let p = new Point()
  //   should.exist(p)
  //   p = new Point()
  //   should.exist(p)
  //   ;(p instanceof Point).should.equal(true)
  // })

  // test('should have the standard properties for a point',  () {
  //   const p = new Point()
  //   const props = ['curve', 'type', 'precomputed', 'x', 'y', 'inf']

  //   // all enumerable, own properties should be in prop
  //   for (const k in p) {
  //     if (Object.prototype.hasOwnProperty.call(p, k)) {
  //       props.indexOf(k).should.not.equal(-1)
  //     }
  //   }

  //   // all props should be properties of a point
  //   props.forEach(function (k) {
  //     ;(p[k] === undefined).should.equal(false)
  //   })
  // })

  // group('#copyFrom',  () {
  //   test('should copy G',  () {
  //     const point = Point.getG()
  //     let point2
  //     ;( () {
  //       point.copyFrom(point2)
  //     }.should.throw()) // point2 is not a Point yet
  //     const point3 = new Point()
  //     point.copyFrom(point3)
  //     point.toString().should.equal(point3.toString())
  //   });
  // });

  group('#toJSON',  () {
    test('should print G to JSON',  () {
      const G = Point.getG();
      const json = G.toJSON();
      json.x.should.equal(G.x.toString())
      json.y.should.equal(G.y.toString())
    });
  });

  // group('#fromJSON',  () {
  //   test('should recover G',  () {
  //     new Point()
  //       .fromJSON(Point.getG().toJSON())
  //       .eq(Point.getG())
  //       .should.equal(true)
  //   })
  // })

  // group('#toString',  () {
  //   test('should convert G to a string',  () {
  //     const G = Point.getG()
  //     G.toString().should.equal(JSON.stringify(G.toJSON()))
  //   })
  // })

  // group('#fromString',  () {
  //   test('should convert a json string to G',  () {
  //     const G = Point.getG()
  //     new Point()
  //       .fromString(G.toString())
  //       .eq(G)
  //       .should.equal(true)
  //   })
  // })

  // group('#getX',  () {
  //   test('should return a Bn',  () {
  //     const p = new Point()
  //     ;(p.getX() instanceof Bn).should.equal(true)
  //   })

  //   test('should return 0',  () {
  //     const p = new Point()
  //     p
  //       .getX()
  //       .toString()
  //       .should.equal('0')
  //   })

  //   test('should be convertable to a buffer',  () {
  //     const p = new Point()
  //     p
  //       .getX()
  //       .toBuffer({ size: 32 })
  //       .length.should.equal(32)
  //   })
  // })

  // group('#getY',  () {
  //   test('should return a Bn',  () {
  //     const p = new Point()
  //     ;(p.getY() instanceof Bn).should.equal(true)
  //   })

  //   test('should return 0',  () {
  //     const p = new Point()
  //     p
  //       .getY()
  //       .toString()
  //       .should.equal('0')
  //   })

  //   test('should be convertable to a buffer',  () {
  //     const p = new Point()
  //     p
  //       .getY()
  //       .toBuffer({ size: 32 })
  //       .length.should.equal(32)
  //   })
  // })

  // group('#add',  () {
  //   test('should get back a point',  () {
  //     const p1 = Point.getG()
  //     const p2 = Point.getG()
  //     const p3 = p1.add(p2)
  //     ;(p3 instanceof Point).should.equal(true)
  //   })

  //   test('should accurately add g to itself',  () {
  //     const p1 = Point.getG()
  //     const p2 = Point.getG()
  //     const p3 = p1.add(p2)
  //     p3
  //       .getX()
  //       .toString()
  //       .should.equal(
  //         '89565891926547004231252920425935692360644145829622209833684329913297188986597'
  //       )
  //     p3
  //       .getY()
  //       .toString()
  //       .should.equal(
  //         '12158399299693830322967808612713398636155367887041628176798871954788371653930'
  //       )
  //   })
  // })

  // group('#mul',  () {
  //   test('should get back a point',  () {
  //     const g = Point.getG()
  //     const b = g.mul(new Bn(2))
  //     ;(b instanceof Point).should.equal(true)
  //   })

  //   test('should accurately multiply g by 2',  () {
  //     const g = Point.getG()
  //     const b = g.mul(new Bn(2))
  //     b
  //       .getX()
  //       .toString()
  //       .should.equal(
  //         '89565891926547004231252920425935692360644145829622209833684329913297188986597'
  //       )
  //     b
  //       .getY()
  //       .toString()
  //       .should.equal(
  //         '12158399299693830322967808612713398636155367887041628176798871954788371653930'
  //       )
  //   })

  //   test('should accurately multiply g by n-1',  () {
  //     const g = Point.getG()
  //     const n = Point.getN()
  //     const b = g.mul(n.sub(1))
  //     b
  //       .getX()
  //       .toString()
  //       .should.equal(
  //         '55066263022277343669578718895168534326250603453777594175500187360389116729240'
  //       )
  //     b
  //       .getY()
  //       .toString()
  //       .should.equal(
  //         '83121579216557378445487899878180864668798711284981320763518679672151497189239'
  //       )
  //   })

  //   test('should accurate multiply these problematic values related to a bug in bn.js',  () {
  //     // see these discussions:
  //     // https://github.com/bitpay/bitcore/pull/894
  //     // https://github.com/indutny/elliptic/issues/17
  //     // https://github.com/indutny/elliptic/pull/18
  //     // https://github.com/indutny/elliptic/pull/19
  //     // https://github.com/indutny/bn.js/commit/3557d780b07ed0ed301e128f326f83c2226fb679
  //     ;( () {
  //       const nhex =
  //         '6d1229a6b24c2e775c062870ad26bc261051e0198c67203167273c7c62538846'
  //       const n = new Bn(nhex, 16)
  //       const g1 = Point.getG() // precomputed g
  //       const g2 = new Point().fromX(
  //         false,
  //         new Bn(
  //           '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
  //           16
  //         )
  //       ) // non-precomputed g
  //       const p1 = g1.mul(n)
  //       const p2 = g2.mul(n)
  //       const pxhex =
  //         'd6106302d2698d6a41e9c9a114269e7be7c6a0081317de444bb2980bf9265a01'
  //       const pyhex =
  //         'e05fb262e64b108991a29979809fcef9d3e70cafceb3248c922c17d83d66bc9d'
  //       p1
  //         .getX()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pxhex)
  //       p1
  //         .getY()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pyhex)
  //       p2
  //         .getX()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pxhex)
  //       p2
  //         .getY()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pyhex)
  //     })()
  //     ;( () {
  //       const nhex =
  //         'f2cc9d2b008927db94b89e04e2f6e70c180e547b3e5e564b06b8215d1c264b53'
  //       const n = new Bn(nhex, 16)
  //       const g1 = Point.getG() // precomputed g
  //       const g2 = new Point().fromX(
  //         false,
  //         new Bn(
  //           '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
  //           16
  //         )
  //       ) // non-precomputed g
  //       const p1 = g1.mul(n)
  //       const p2 = g2.mul(n)
  //       const pxhex =
  //         'e275faa35bd1e88f5df6e8f9f6edb93bdf1d65f4915efc79fd7a726ec0c21700'
  //       const pyhex =
  //         '367216cb35b086e6686d69dddd822a8f4d52eb82ac5d9de18fdcd9bf44fa7df7'
  //       p1
  //         .getX()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pxhex)
  //       p1
  //         .getY()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pyhex)
  //       p2
  //         .getX()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pxhex)
  //       p2
  //         .getY()
  //         .toBuffer()
  //         .toString('hex')
  //         .should.equal(pyhex)
  //     })()
  //   })
  // })

  // group('#mulAdd',  () {
  //   test('should get back a point',  () {
  //     const p1 = Point.getG()
  //     const bn1 = new Bn(5)
  //     const p2 = Point.getG().add(p1)
  //     const bn2 = new Bn(6)
  //     p1
  //       .mulAdd(bn1, p2, bn2)
  //       .getX()
  //       .toString()
  //       .should.equal(
  //         p1
  //           .mul(bn1)
  //           .add(p2.mul(bn2))
  //           .getX()
  //           .toString()
  //       )
  //     p1
  //       .mulAdd(bn1, p2, bn2)
  //       .getY()
  //       .toString()
  //       .should.equal(
  //         p1
  //           .mul(bn1)
  //           .add(p2.mul(bn2))
  //           .getY()
  //           .toString()
  //       )
  //   })
  // })

  // group('@getN',  () {
  //   test('should return n',  () {
  //     const bn = Point.getN()
  //     ;(bn instanceof Bn).should.equal(true)
  //   })
  // })

  // group('@fromX',  () {
  //   test('should return g',  () {
  //     const g = Point.getG()
  //     const p = Point.fromX(false, g.getX())
  //     g.eq(p).should.equal(true)
  //   })
  // })

  // group('#fromX',  () {
  //   test('should return g',  () {
  //     const g = Point.getG()
  //     const p = new Point().fromX(false, g.getX())
  //     g.eq(p).should.equal(true)
  //   })
  // })

  // group('#validate',  () {
  //   test('should validate this valid point',  () {
  //     const x = new Bn().fromBuffer(
  //       Buffer.from(
  //         'ac242d242d23be966085a2b2b893d989f824e06c9ad0395a8a52f055ba39abb2',
  //         'hex'
  //       )
  //     )
  //     const y = new Bn().fromBuffer(
  //       Buffer.from(
  //         '4836ab292c105a711ed10fcfd30999c31ff7c02456147747e03e739ad527c380',
  //         'hex'
  //       )
  //     )
  //     const p = new Point(x, y)
  //     should.exist(p.validate())
  //   })

  //   test('should invalidate this invalid point',  () {
  //     const x = new Bn().fromBuffer(
  //       Buffer.from(
  //         'ac242d242d23be966085a2b2b893d989f824e06c9ad0395a8a52f055ba39abb2',
  //         'hex'
  //       )
  //     )
  //     const y = new Bn().fromBuffer(
  //       Buffer.from(
  //         '0000000000000000000000000000000000000000000000000000000000000000',
  //         'hex'
  //       )
  //     )
  //     const p = new Point(x, y)
  //     ;( () {
  //       p.validate()
  //     }.should.throw('Invalid y value of public key'))
  //   })
  // })
  });
}
