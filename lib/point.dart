import 'dart:convert';

import "package:pointycastle/pointycastle.dart";

var ec = new ECDomainParameters("secp256k1");

class Point {
  final BigInt x;
  final BigInt y;

  Point({this.x, this.y});

  factory Point.fromX({bool isOdd, BigInt x}) {
    // const _point = ec.curve.pointFromX(x, isOdd)
    // const point = Object.create(Point.prototype)
    // return point.copyFrom(_point)
    return Point(x: x);
  }

  static ECPoint getG() {
    ec.G.x.toBigInteger();
    print(ec);
    // ec.curve.
    // ec.seed()
    // BigInt.from(value)
    // return new Bn(ec.curve.n.toArray())
    print(ec.G * BigInt.two);
    return ec.G;
  }

  static BigInt getN() {
    return ec.n;
  }

  Map<String, String> toJson() {
    return {
      "x": this.x.toString(),
      "y": this.x.toString(),
    };
  }

  String toString() {
    return json.encode(this.toJson());
  }
}
