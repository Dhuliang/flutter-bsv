import 'dart:math' as math;
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bn', () {
    test('should create a bn', () {
      var bn = BigIntX.fromNum(50);
      expect(bn.toString(), '50');

      bn = BigIntX.fromString("ff00", radix: 16);
      expect(bn.toString(radix: 16), 'ff00');
    });

    test('should parse this number', () {
      var bn = BigIntX.fromNum(999970000);
      expect(bn.toString(), '999970000');
    });

    test('should parse numbers below and at bn.js internal word size', () {
      var bn = BigIntX.fromNum(math.pow(2, 26) - 1);
      expect(bn.toString(), (math.pow(2, 26) - 1).toString());
      bn = BigIntX.fromNum(math.pow(2, 26));
      expect(bn.toString(), (math.pow(2, 26)).toString());
    });

    //it('should correctly square the number related to a bug in bn.js', function () {
    //   const p = Bn._prime('k256').p
    //   const red = Bn.red('k256')

    //   const n = new Bn(
    //     '9cd8cb48c3281596139f147c1364a3ede88d3f310fdb0eb98c924e599ca1b3c9',
    //     16
    //   )
    //   const expected = n.sqr().mod(p)
    //   const actual = n
    //     .toRed(red)
    //     .redSqr()
    //     .fromRed()

    //   assert.strict.equal(actual.toString(16), expected.toString(16))
    // });

    //   it('should correctly square these numbers related to a bug in OpenSSL - CVE-2014-3570', function () {
    //   /**
    //    * Bitcoin developer Peter Wuile discovered a bug in OpenSSL in the course
    //    * of developing libsecp256k. The OpenSSL security advisory is here:
    //    *
    //    * https://www.openssl.org/news/secadv_20150108.txt
    //    *
    //    * Greg Maxwell has a description of the bug and how it was found here:
    //    *
    //    * https://www.reddit.com/r/Bitcoin/comments/2rrxq7/on_why_010s_release_notes_say_we_have_reason_to/
    //    * https://www.reddit.com/r/programming/comments/2rrc64/openssl_security_advisory_new_openssl_releases/
    //    *
    //    * The OpenSSL fix is here:
    //    *
    //    * https://github.com/openssl/openssl/commit/a7a44ba55cb4f884c6bc9ceac90072dea38e66d0
    //    *
    //    * This test uses the same big numbers that were problematic in OpenSSL.
    //    * The check is to ensure that squaring a number and multiplying it by
    //    * itself result in the same number. As an additional precaution, we check
    //    * this multiplication normally as well as mod(p).
    //    */
    //   const p = Bn._prime('k256').p

    //   let n = new Bn(
    //     '80000000000000008000000000000001FFFFFFFFFFFFFFFE0000000000000000',
    //     16
    //   )
    //   let sqr = n.sqr()
    //   let nn = n.mul(n)
    //   nn.toString().should.equal(sqr.toString())
    //   sqr = n.sqr().mod(p)
    //   nn = n.mul(n).mod(p)
    //   nn.toString().should.equal(sqr.toString())

    //   n = new Bn(
    //     '80000000000000000000000080000001FFFFFFFE000000000000000000000000',
    //     16
    //   )
    //   sqr = n.sqr()
    //   nn = n.mul(n)
    //   nn.toString().should.equal(sqr.toString())
    //   sqr = n.sqr().mod(p)
    //   nn = n.mul(n).mod(p)
    //   nn.toString().should.equal(sqr.toString())
    // })

    // describe('#copy', function () {
    //   it('should copy 5', function () {
    //     const bn = new Bn('5')
    //     let bn2
    //     ;(function () {
    //       bn.copy(bn2)
    //     }.should.throw()) // bn2 is not a Bn yet
    //     const bn3 = new Bn()
    //     bn.copy(bn3)
    //     bn3.toString().should.equal('5')
    //   })
    // })
  });

  group('#neg', () {
    test('should produce a negative', () {
      var bn = BigIntX.fromNum(1).neg();
      expect(bn.toString(), '-1');
    });
  });

  group('#add', () {
    test('should add two small numbers together', () {
      var bn1 = BigIntX.fromNum(50);
      var bn2 = BigIntX.fromNum(75);
      var bn3 = bn1.add(bn2);
      expect(bn3.toString(), '125');
    });
  });

  group('#sub', () {
    test('should subtract a small number', () {
      var bn1 = BigIntX.fromNum(50);
      var bn2 = BigIntX.fromNum(25);
      var bn3 = bn1.sub(bn2);
      expect(bn3.toString(), '25');
    });
  });

  group('#mul', () {
    test('should mul a small number', () {
      var bn1 = BigIntX.fromNum(50);
      var bn2 = BigIntX.fromNum(25);
      var bn3 = bn1.mul(bn2);
      expect(bn3.toString(), '1250');
    });
  });

  group('#mod', () {
    test('should mod a small number', () {
      var bn1 = BigIntX.fromNum(50);
      var bn2 = BigIntX.fromNum(25);
      var bn3 = bn1.mod(bn2);
      expect(bn3.toString(), '0');
    });

    test('should mod a small number', () {
      var bn1 = BigIntX.fromNum(-50);
      var bn2 = BigIntX.fromNum(25);
      var bn3 = bn1.mod(bn2);
      expect(bn3.toString(), '0');
    });

    test('should mod a small number', () {
      var bn1 = BigIntX.fromNum(50);
      var bn2 = BigIntX.fromNum(47);
      var bn3 = bn1.mod(bn2);
      expect(bn3.toString(), '3');
    });

    test('should mod a small number', () {
      var bn1 = BigIntX.fromNum(-50);
      var bn2 = BigIntX.fromNum(47);
      var bn3 = bn1.mod(bn2);
      expect(bn3.toString(), '-3');
    });
  });

  //  describe('#umod', function () {
  //   it('should mod a small number', function () {
  //     const bn1 = new Bn(50)
  //     const bn2 = new Bn(25)
  //     const bn3 = bn1.umod(bn2)
  //     bn3.toString().should.equal('0')
  //   })

  //   it('should mod a small number', function () {
  //     const bn1 = new Bn(50)
  //     const bn2 = new Bn(47)
  //     const bn3 = bn1.umod(bn2)
  //     bn3.toString().should.equal('3')
  //   })
  // })

  // describe('#invm', function () {
  //   it('should invm a small number', function () {
  //     const bn1 = new Bn(50)
  //     const bn2 = new Bn(25)
  //     const bn3 = bn1.invm(bn2)
  //     bn3.toString().should.equal('0')
  //   })

  //   it('should invm a small number', function () {
  //     const bn1 = new Bn(50)
  //     const bn2 = new Bn(47)
  //     const bn3 = bn1.invm(bn2)
  //     bn3.toString().should.equal('16')
  //   })
  // })

  group('#div', () {
    test('should div a small number', () {
      var bn1 = BigIntX.fromNum(50);
      var bn2 = BigIntX.fromNum(25);
      var bn3 = bn1.div(bn2);
      expect(bn3.toString(), '2');
    });

    test('should div a small number', () {
      var bn1 = BigIntX.fromNum(50);
      var bn2 = BigIntX.fromNum(47);
      var bn3 = bn1.div(bn2);
      expect(bn3.toString(), '1');
    });
  });

  group('#cmp', () {
    test('should know A=B', () {
      expect(BigIntX.fromNum(5).cmp(BigIntX.fromNum(5)), 0);
      expect(BigIntX.fromNum(5).cmp(BigIntX.fromNum(4)), 1);
      expect(BigIntX.fromNum(5).cmp(BigIntX.fromNum(6)), -1);
    });
  });

  group('#eq', () {
    test('should know A=B', () {
      expect(BigIntX.fromNum(5).eq(BigIntX.fromNum(5)), true);
      expect(BigIntX.fromNum(5).eq(BigIntX.fromNum(4)), false);
    });
  });

  group('#neq', () {
    test('should know A!=B', () {
      expect(BigIntX.fromNum(5).neq(BigIntX.fromNum(5)), false);
      expect(BigIntX.fromNum(5).neq(BigIntX.fromNum(4)), true);
    });
  });

  group('#gt', () {
    test('should say 1 is greater than 0', () {
      var bn1 = BigIntX.fromNum(1);
      var bn0 = BigIntX.fromNum(0);
      expect(bn1.gt(bn0), true);
    });

    test('should say a big number is greater than a small big number', () {
      var bn1 = BigIntX.fromString('24023452345398529485723980457');
      var bn0 = BigIntX.fromString('34098234283412341234049357');
      expect(bn1.gt(bn0), true);
    });

    test('should say a big number is great than a standard number', () {
      var bn1 = BigIntX.fromString('24023452345398529485723980457');
      var bn0 = BigIntX.fromNum(5);
      expect(bn1.gt(bn0), true);
    });
  });

  group('#geq', () {
    test('should know that A >= B', () {
      expect(BigIntX.fromNum(6).geq(BigIntX.fromNum(5)), true);
      expect(BigIntX.fromNum(5).geq(BigIntX.fromNum(5)), true);
      expect(BigIntX.fromNum(4).geq(BigIntX.fromNum(5)), false);
    });
  });

  group('#lt', () {
    test('should know A < B', () {
      expect(BigIntX.fromNum(5).lt(BigIntX.fromNum(6)), true);
      expect(BigIntX.fromNum(5).lt(BigIntX.fromNum(4)), false);
    });
  });

  group('#leq', () {
    test('should know A <= B', () {
      expect(BigIntX.fromNum(5).leq(BigIntX.fromNum(6)), true);
      expect(BigIntX.fromNum(5).leq(BigIntX.fromNum(5)), true);
      expect(BigIntX.fromNum(5).leq(BigIntX.fromNum(4)), false);
    });
  });

  // describe('#fromJSON', function () {
  //   it('should make Bn from a string', function () {
  //     new Bn()
  //       .fromJSON('5')
  //       .toString()
  //       .should.equal('5')
  //   })
  // })

  // describe('#toJSON', function () {
  //   it('should make string from a Bn', function () {
  //     new Bn(5).toJSON().should.equal('5')
  //     new Bn()
  //       .fromJSON('5')
  //       .toJSON()
  //       .should.equal('5')
  //   })
  // })

  group('#fromString', () {
    test('should make Bn from a string', () {
      expect(BigIntX.fromString('5').toString(), '5');
    });
  });

  group('#toString', () {
    test('should make Bn from a string', () {
      expect(BigIntX(bn: BigInt.from(5)).toString(), '5');
    });
  });

  group('@fromBuffer', () {
    test('should work with big endian', () {
      var bn = BigIntX.fromBuffer(hex.decode('0001'));
      expect(bn.toString(), '1');
    });

    test('should work with big endian 256', () {
      var bn = BigIntX.fromBuffer(hex.decode('0100'));
      expect(bn.toString(), '256');
    });

    test('should work with little endian if we specify the size', () {
      var bn = BigIntX.fromBuffer(hex.decode('0100'), endian: Endian.little);
      expect(bn.toString(), '1');
    });
  });

  group('#fromHex', () {
    test('should create bn from known hex', () {
      var bn = BigIntX.fromHex('0100', endian: Endian.little);
      expect(bn.toString(), '1');
    });
  });

  group('#fromBuffer', () {
    test('should work as a prototype method', () {
      var bn = BigIntX.fromBuffer(hex.decode('0100'), endian: Endian.little);
      expect(bn.toString(), '1');
    });
  });

  group('#toHex', () {
    test('should create a hex string of 4 byte buffer', () {
      var bn = BigIntX.fromNum(1);
      expect(bn.toHex(size: 4), '00000001');
    });
  });

  group('#toBuffer', () {
    test('should convert zero to empty buffer', () {
      expect(listEquals(BigIntX.fromNum(0).toBuffer(), [0]), true);
    });

    test('should create a 4 byte buffer', () {
      var bn = BigIntX.fromNum(1);

      expect(bn.toBuffer(size: 4).toHex(), '00000001');
    });

    test('should create a 4 byte buffer in little endian', () {
      var bn = BigIntX.fromNum(1);

      expect(bn.toBuffer(size: 4, endian: Endian.little).toHex(), '01000000');
    });

    test('should create a 2 byte buffer even if you ask for a 1 byte', () {
      var bn = BigIntX.fromString("ff00", radix: 16);
      expect(bn.toBuffer(size: 1).toHex(), 'ff00');
    });

    test('should create a 4 byte buffer even if you ask for a 1 byte', () {
      var bn = BigIntX.fromString("ffffff00", radix: 16);
      expect(bn.toBuffer(size: 4).toHex(), 'ffffff00');
    });
  });

  // group('#toBits', () {
  //   test('should convert these known Bns to bits', () {
  //     expect(BigIntX.fromHex('00').toBits(), 0x00000000);

  //     expect(BigIntX.fromHex('01').toBits(), 0x01000001);

  //     expect(BigIntX.fromHex('0101').toBits(), 0x02000101);

  //     expect(BigIntX.fromHex('010101').toBits(), 0x03010101);

  //     expect(BigIntX.fromHex('01010101').toBits(), 0x04010101);

  //     expect(BigIntX.fromHex('0101010101').toBits(), 0x04010101);

  //     expect(BigIntX.fromHex('0101010101').toBits(), 0x05010101);

  //     expect(BigIntX.fromHex('010101010101').toBits(), 0x06010101);

  //     expect(BigIntX.fromNum(-1).toBits(), 0x01800001);
  //   });
  // });

  // describe('#fromBits', function () {
  //   it('should convert these known bits to Bns', function () {
  //     new Bn()
  //       .fromBits(0x01003456)
  //       .toHex()
  //       .should.equal('')
  //     new Bn()
  //       .fromBits(0x02003456)
  //       .toHex()
  //       .should.equal('34')
  //     new Bn()
  //       .fromBits(0x03003456)
  //       .toHex()
  //       .should.equal('3456')
  //     new Bn()
  //       .fromBits(0x04003456)
  //       .toHex()
  //       .should.equal('345600')
  //     new Bn()
  //       .fromBits(0x05003456)
  //       .toHex()
  //       .should.equal('34560000')
  //     new Bn()
  //       .fromBits(0x05f03456)
  //       .lt(0)
  //       .should.equal(true) // sign bit set
  //     ;(function () {
  //       new Bn().fromBits(0x05f03456, { strict: true }) // sign bit set
  //     }.should.throw('negative bit set'))
  //     new Bn()
  //       .fromBits(0x04923456)
  //       .lt(0)
  //       .should.equal(true)
  //   })
  // })
}
