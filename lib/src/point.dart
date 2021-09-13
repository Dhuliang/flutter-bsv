import 'dart:convert';

import 'package:bsv/src/bn.dart';
import 'package:convert/convert.dart';
import "package:pointycastle/pointycastle.dart";

var ec = new ECDomainParameters("secp256k1");

class PointWrapper {
  ECPoint? point;

  PointWrapper({BigInt? x, BigInt? y}) {
    super.toString();
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

  factory PointWrapper.fromX({required bool isOdd, BigInt? x}) {
    var prefixByte;
    if (isOdd) {
      prefixByte = 0x03;
    } else {
      prefixByte = 0x02;
    }

    var encoded = BigIntX(bn: x).toBuffer(size: 32);

    var addressBytes = List<int>.filled(1 + encoded.length, 0, growable: false);
    addressBytes[0] = prefixByte;
    addressBytes.setRange(1, addressBytes.length, encoded);

    var point = ec.curve.decodePoint(addressBytes)!;

    PointWrapper.checkIfOnCurve(point);

    return PointWrapper.fromECPoint(point);
  }

  factory PointWrapper.fromECPoint(ECPoint? point) {
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

  bool get isCompressed => this.point!.isCompressed;

  bool get isInfinity => this.point!.isInfinity;

  PointWrapper copyFrom(PointWrapper? other) {
    if (!(other is PointWrapper)) {
      throw INVALID_POINT_CONSTRUCTOR;
    }
    this.point!.x;
    this.point = other.point;
    return this;
  }

  PointWrapper add(PointWrapper other) {
    var result = PointWrapper.fromECPoint(this.point! + other.point);
    return result;
  }

  PointWrapper mul(BigIntX other) {
    var result = PointWrapper.fromECPoint(this.point! * other.bn);
    return result;
  }

  PointWrapper mulAdd(BigIntX b1, PointWrapper p, BigIntX b2) {
    // var result = PointWrapper.fromECPoint(this.point * other.bn);
    // return result;
    return this.mul(b1).add(p.mul(b2));
  }

  // mulAdd (bn1, point, bn2) {
  //   var p = _Point.prototype.mulAdd.call(this, bn1, point, bn2)
  //   point = Object.create(Point.prototype)
  //   return point.copyFrom(p)
  // }

  BigIntX getX() {
    return BigIntX(bn: this.point!.x!.toBigInteger());
  }

  BigIntX getY() {
    return BigIntX(bn: this.point!.y!.toBigInteger());
  }

  PointWrapper fromX({required bool isOdd, BigInt? x}) {
    return PointWrapper(x: x);
  }

  Map<String, String> toJson() {
    return {
      "x": this.point!.x.toString(),
      "y": this.point!.y.toString(),
    };
  }

  PointWrapper fromJSON(Map<String, String> json) {
    var x = BigInt.parse(json['x']!);
    var y = BigInt.parse(json['y']!);

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
    var p2 = PointWrapper.fromX(
      isOdd: this.point!.y!.toBigInteger()!.isOdd,
      x: this.getX().bn,
    );

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

  static bool checkIfOnCurve(ECPoint point) {
    //a bit of math copied from PointyCastle. ecc/ecc_fp.dart -> decompressPoint()
    var x = ec.curve.fromBigInteger(point.x!.toBigInteger()!);
    var alpha = (x * ((x * x) + ec.curve.a!)) + ec.curve.b!;
    ECFieldElement? beta = alpha.sqrt();

    if (beta == null) {
      throw ('This point is not on the curve');
    }

    //slight-of-hand. Create compressed point, reconstruct and check Y value.
    var compressedPoint = compressPoint(point);
    var checkPoint = ec.curve.decodePoint(hex.decode(compressedPoint))!;

    if (checkPoint.y!.toBigInteger() != point.y!.toBigInteger()) {
      throw ('This point is not on the curve');
    }

    var isOnCurve = (point.x!.toBigInteger() == BigInt.zero) &&
        (point.y!.toBigInteger() == BigInt.zero);

    return isOnCurve;
  }

  @override
  bool operator ==(other) {
    if (other is PointWrapper) {
      return this.point == other.point;
    }
    return this == other;
  }

  @override
  int get hashCode => super.hashCode;
}
