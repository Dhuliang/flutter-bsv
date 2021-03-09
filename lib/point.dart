import 'dart:convert';
import 'dart:math';

import 'package:bsv/bn.dart';
import 'package:convert/convert.dart';
import "package:pointycastle/pointycastle.dart";

var ec = new ECDomainParameters("secp256k1");

BigInt sqrt(BigInt val) {
  BigInt half = BigInt.from(val.bitLength / 2);
  BigInt cur = half;

  while (true) {
    BigInt tmp = half + BigInt.from(val / half) >> (1);

    if (tmp == half || tmp == cur) return tmp;

    cur = half;
    half = tmp;
  }
}

class PointWrapper {
  ECPoint point;

  PointWrapper({BigInt x, BigInt y}) {
    this.point = ec.curve.createPoint(x ?? BigInt.zero, y ?? BigInt.zero);
  }

  static const INVALID_Y_VALUE_OF_PUBLIC_KEY = "Invalid y value of public key";

  static const INVALID_POINT_ON_CURVE = "Point does not lie on the curve";

  static const INVALID_POINT_CONSTRUCTOR = "Point should be an external point";

//  ShortCurve.prototype.pointFromX = function pointFromX(x, odd) {
//   x = new BN(x, 16);
//   if (!x.red)
//     x = x.toRed(this.red);

//   var y2 = x.redSqr().redMul(x).redIAdd(x.redMul(this.a)).redIAdd(this.b);
//   var y = y2.redSqrt();
//   if (y.redSqr().redSub(y2).cmp(this.zero) !== 0)
//     throw new Error('invalid point');

//   // XXX Is there any way to tell if the number is odd without converting it
//   // to non-red form?
//   var isOdd = y.fromRed().isOdd();
//   if (odd && !isOdd || !odd && isOdd)
//     y = y.redNeg();

//   return this.point(x, y);
// };

  factory PointWrapper.fromX({bool isOdd, BigInt x}) {
    var prefixByte;
    if (isOdd) {
      prefixByte = 0x03;
    } else {
      prefixByte = 0x02;
    }

    var encoded = BigIntX(bn: x).toBuffer();

    var addressBytes = List<int>(1 + encoded.length);
    addressBytes[0] = prefixByte;
    addressBytes.setRange(1, addressBytes.length, encoded);

    var point = ec.curve.decodePoint(addressBytes);

    PointWrapper.checkIfOnCurve(point);

    return PointWrapper.fromECPoint(point);
    // var t = ec.curve.fromBigInteger(x);
    // var alpha = (t * ((t * t) + ec.curve.a)) + ec.curve.b;
    // ECFieldElement beta = alpha.sqrt();

    // ec.curve.decodePoint(x)
    // x = BigInt.from(16);
    // var ecf = ec.curve.fromBigInteger(x);
    // ecf.sqrt();
    // ec.curve.fromBigInteger(x);
    // // x.modPow(exponent, modulus)
    // var n = BigInt.from(10);
    // var exp = BigInt.from(3);
    // var mod = BigInt.from(30);
    // var t = n.modPow(exp, mod);

    // var field = ec.curve.fromBigInteger(x);

    // var a = ec.curve.fromBigInteger(BigInt.zero);
    // var b = ec.curve.fromBigInteger(BigInt.from(7));

    // var y2 = (field * field) * (field) + (field * a) + b;
    // var tmp = sqrt(y2);
    // x.
    // sqrt(y2);
    // x.
    // x.modPow(exponent, modulus)

    // return PointWrapper(x: x);
  }

  factory PointWrapper.fromECPoint(ECPoint point) {
    var wrapper = PointWrapper();
    wrapper.point = point;
    return wrapper;
  }

  static PointWrapper getG() {
    return PointWrapper.fromECPoint(ec.G);
  }

  static BigIntX getN() {
    return BigIntX(bn: ec.n);
  }

  PointWrapper copyFrom(PointWrapper other) {
    if (!(other is PointWrapper)) {
      throw INVALID_POINT_CONSTRUCTOR;
    }
    this.point.x;
    this.point = other.point;
    return this;
  }

  PointWrapper add(PointWrapper other) {
    var result = PointWrapper.fromECPoint(this.point + other.point);
    return result;
  }

  PointWrapper mul(BigIntX other) {
    var result = PointWrapper.fromECPoint(this.point * other.bn);
    return result;
  }

  // mulAdd (bn1, point, bn2) {
  //   var p = _Point.prototype.mulAdd.call(this, bn1, point, bn2)
  //   point = Object.create(Point.prototype)
  //   return point.copyFrom(p)
  // }

  BigIntX getX() {
    return BigIntX(bn: this.point.x.toBigInteger());
  }

  BigIntX getY() {
    return BigIntX(bn: this.point.y.toBigInteger());
  }

  PointWrapper fromX({bool isOdd, BigInt x}) {
    return PointWrapper(x: x);
  }

  Map<String, String> toJson() {
    return {
      "x": this.point.x.toString(),
      "y": this.point.y.toString(),
    };
  }

  PointWrapper fromJSON(Map<String, String> json) {
    var x = BigInt.parse(json['x']);
    var y = BigInt.parse(json['y']);

    var point = new PointWrapper(x: x, y: y);
    return point;
  }

  String toString() {
    return json.encode(this.toJson());
  }

  // fromString (str) {
  //   var json = JSON.parse(str)
  //   var p = new Point().fromJSON(json)
  //   return this.copyFrom(p)
  // }

  PointWrapper validate() {
    var p2 = PointWrapper.fromX(x: this.getX().bn);

    if (!(p2.getY().cmp(this.getY()) == 0)) {
      throw INVALID_Y_VALUE_OF_PUBLIC_KEY;
    }

    if (!(this.getX().gt(-1) && this.getX().lt(PointWrapper.getN())) ||
        !(this.getY().gt(-1) && this.getY().lt(PointWrapper.getN()))) {
      throw INVALID_POINT_ON_CURVE;
    }
    return this;
  }

  static String compressPoint(ECPoint point) {
    return hex.encode(point.getEncoded(true));
  }

  static checkIfOnCurve(ECPoint point) {
    //a bit of math copied from PointyCastle. ecc/ecc_fp.dart -> decompressPoint()
    var x = ec.curve.fromBigInteger(point.x.toBigInteger());
    var alpha = (x * ((x * x) + ec.curve.a)) + ec.curve.b;
    ECFieldElement beta = alpha.sqrt();

    if (beta == null) {
      throw ('This point is not on the curve');
    }

    //slight-of-hand. Create compressed point, reconstruct and check Y value.
    var compressedPoint = compressPoint(point);
    var checkPoint = ec.curve.decodePoint(hex.decode(compressedPoint));

    if (checkPoint.y.toBigInteger() != point.y.toBigInteger()) {
      throw ('This point is not on the curve');
    }

    var isOnCurve = (point.x.toBigInteger() == BigInt.zero) &&
        (point.y.toBigInteger() == BigInt.zero);

    return isOnCurve;
  }
}
