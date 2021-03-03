import 'dart:convert';

import 'package:bsv/bn.dart';
import "package:pointycastle/pointycastle.dart";

var ec = new ECDomainParameters("secp256k1");

class PointWrapper {
  ECPoint point;

  PointWrapper({BigInt x, BigInt y}) {
    this.point = ec.curve.createPoint(x ?? BigInt.zero, y ?? BigInt.zero);
  }

  static const INVALID_Y_VALUE_OF_PUBLIC_KEY = "Invalid y value of public key";

  static const INVALID_POINT_ON_CURVE = "Point does not lie on the curve";

  static const INVALID_POINT_CONSTRUCTOR = "Point should be an external point";

  factory PointWrapper.fromX({bool isOdd, BigInt x}) {
    ec.curve.fromBigInteger(x);
    ec.curve.fromBigInteger(x);
    return PointWrapper(x: x);
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
}
