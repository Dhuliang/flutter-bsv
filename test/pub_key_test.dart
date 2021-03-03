import 'package:bsv/bn.dart';
import 'package:bsv/point.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  group('PubKey', () {
    //   test('should create a blank public key', () {
    //   var pk = new PubKey()
    //   should.exist(pk)
    // });

    test('should create a public key with a point', () {
      var p = new PointWrapper();
      var pk = new PubKey(point: p);
      // should.exist(pk.point)
    });

    // test('should create a public key with a point with this convenient method', () {
    //   var p = new Point()
    //   var pk = new PubKey(p)
    //   should.exist(pk.point)
    //   pk.point.toString().should.equal(p.toString())
    // })

    // group('#fromObject', () {
    //   test('should make a public key from a point', () {
    //     should.exist(new PubKey().fromObject({ point: Point.getG() }).point)
    //   })
    // })

    // group('#fromJSON', () {
    //   test('should input this public key', () {
    //     var pk = new PubKey()
    //     pk.fromJSON(
    //       '00041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //     )
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
    //   })
    // })

    // group('#toJSON', () {
    //   test('should output this pubKey', () {
    //     var pk = new PubKey()
    //     var hex =
    //       '01041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //     pk
    //       .fromJSON(hex)
    //       .toJSON()
    //       .should.equal(hex)
    //   })

    //   test('should output this uncompressed pubKey', () {
    //     var pk = new PubKey()
    //     var hex =
    //       '00041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //     pk
    //       .fromJSON(hex)
    //       .toJSON()
    //       .should.equal(hex)
    //   })
    // })

    // group('#fromPrivKey', () {
    //   test('should make a public key from a privKey', () {
    //     should.exist(new PubKey().fromPrivKey(new PrivKey().fromRandom()))
    //   })
    // })

    // group('@fromPrivKey', () {
    //   test('should make a public key from a privKey', () {
    //     should.exist(PubKey.fromPrivKey(new PrivKey().fromRandom()))
    //   })
    // })

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
    //     var pk = new PubKey()
    //     pk.fromHex(
    //       '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //     )
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
    //   })
    // })

    // group('#fromBuffer', () {
    //   test('should parse this uncompressed public key', () {
    //     var pk = new PubKey()
    //     pk.fromBuffer(
    //       Buffer.from(
    //         '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
    //         'hex'
    //       )
    //     )
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
    //   })

    //   test('should parse this compressed public key', () {
    //     var pk = new PubKey()
    //     pk.fromBuffer(
    //       Buffer.from(
    //         '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
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
    //   })

    //   test('should throw an error on this invalid public key', () {
    //     var pk = new PubKey()
    //     ;(() {
    //       pk.fromBuffer(
    //         Buffer.from(
    //           '091ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //           'hex'
    //         )
    //       )
    //     }.should.throw())
    //   })
    // })

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

    // group('#fromFastBuffer', () {
    //   test('should convert from this known fast buffer', () {
    //     var pubKey = new PubKey().fromFastBuffer(
    //       Buffer.from(
    //         '01041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
    //         'hex'
    //       )
    //     )
    //     pubKey.point
    //       .getX()
    //       .toString(16)
    //       .should.equal(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //       )
    //   })
    // })

    // group('#fromDer', () {
    //   test('should parse this uncompressed public key', () {
    //     var pk = new PubKey()
    //     pk.fromDer(
    //       Buffer.from(
    //         '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
    //         'hex'
    //       )
    //     )
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
    //   })

    //   test('should parse this compressed public key', () {
    //     var pk = new PubKey()
    //     pk.fromDer(
    //       Buffer.from(
    //         '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
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
    //   })

    //   test('should throw an error on this invalid public key', () {
    //     var pk = new PubKey()
    //     ;(() {
    //       pk.fromDer(
    //         Buffer.from(
    //           '091ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //           'hex'
    //         )
    //       )
    //     }.should.throw())
    //   })
    // })

    // group('@fromDer', () {
    //   test('should parse this uncompressed public key', () {
    //     var pk = PubKey.fromDer(
    //       Buffer.from(
    //         '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
    //         'hex'
    //       )
    //     )
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
    //   })

    //   test('should parse this compressed public key', () {
    //     var pk = PubKey.fromDer(
    //       Buffer.from(
    //         '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
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
    //   })

    //   test('should throw an error on this invalid public key', () {
    //     ;(() {
    //       PubKey.fromDer(
    //         Buffer.from(
    //           '091ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //           'hex'
    //         )
    //       )
    //     }.should.throw())
    //   })
    // })

    // group('#fromString', () {
    //   test('should parse this known valid public key', () {
    //     var pk = new PubKey()
    //     pk.fromString(
    //       '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //     )
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
    //   })
    // })

    // group('#fromX', () {
    //   test('should create this known public key', () {
    //     var x = Bn.fromBuffer(
    //       Buffer.from(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
    //     var pk = new PubKey()
    //     pk.fromX(true, x)
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
    //   })
    // })

    // group('@fromX', () {
    //   test('should create this known public key', () {
    //     var x = Bn.fromBuffer(
    //       Buffer.from(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
    //     var pk = new PubKey()
    //     pk.fromX(true, x)
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
    //   })
    // })

    // group('#toHex', () {
    //   test('should return this compressed DER format', () {
    //     var x = new Bn().fromHex(
    //       '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //     )
    //     var pk = new PubKey()
    //     pk.fromX(true, x)
    //     pk
    //       .toHex()
    //       .should.equal(
    //         '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //       )
    //   })
    // })

    // group('#toBuffer', () {
    //   test('should return this compressed DER format', () {
    //     var x = Bn.fromBuffer(
    //       Buffer.from(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
    //     var pk = new PubKey()
    //     pk.fromX(true, x)
    //     pk
    //       .toBuffer()
    //       .toString('hex')
    //       .should.equal(
    //         '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //       )
    //   })
    // })

    // group('#toFastBuffer', () {
    //   test('should return fast buffer', () {
    //     var x = Bn.fromBuffer(
    //       Buffer.from(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
    //     var pk = new PubKey()
    //     pk.fromX(true, x)
    //     pk
    //       .toFastBuffer()
    //       .toString('hex')
    //       .should.equal(
    //         '01041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //       )
    //     pk.toFastBuffer().length.should.greaterThan(64)
    //   })
    // })

    // group('#toDer', () {
    //   test('should return this compressed DER format', () {
    //     var x = Bn.fromBuffer(
    //       Buffer.from(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
    //     var pk = new PubKey()
    //     pk.fromX(true, x)
    //     pk
    //       .toDer(true)
    //       .toString('hex')
    //       .should.equal(
    //         '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //       )
    //   })

    //   test('should return this uncompressed DER format', () {
    //     var x = Bn.fromBuffer(
    //       Buffer.from(
    //         '1ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a',
    //         'hex'
    //       )
    //     )
    //     var pk = new PubKey()
    //     pk.fromX(true, x)
    //     pk
    //       .toDer(false)
    //       .toString('hex')
    //       .should.equal(
    //         '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341'
    //       )
    //   })
    // })

    // group('#toString', () {
    //   test('should print this known public key', () {
    //     var hex =
    //       '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //     var pk = new PubKey()
    //     pk.fromString(hex)
    //     pk.toString().should.equal(hex)
    //   })
    // })

    // group('#validate', () {
    //   test('should not throw an error if pubKey is valid', () {
    //     var hex =
    //       '031ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a'
    //     var pk = new PubKey()
    //     pk.fromString(hex)
    //     should.exist(pk.validate())
    //   })

    //   test('should not throw an error if pubKey is invalid', () {
    //     var hex =
    //       '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a0000000000000000000000000000000000000000000000000000000000000000'
    //     var pk = new PubKey()
    //     pk.fromString(hex)
    //     ;(() {
    //       pk.validate()
    //     }.should.throw('Invalid y value of public key'))
    //   })

    //   test('should throw an error if pubKey is infinity', () {
    //     var pk = new PubKey()
    //     let errm = ''
    //     try {
    //       pk.point = Point.getG().mul(Point.getN())
    //     } catch (err) {
    //       errm = err.message
    //     }
    //     errm.should.equal('point mul out of range')
    //   })
    // })
  });
}
