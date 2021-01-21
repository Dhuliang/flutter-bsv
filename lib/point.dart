import "package:pointycastle/pointycastle.dart";

var ec = new ECDomainParameters("secp256k1");

class Point {
  final BigInt x;
  final BigInt y;

  Point({this.x, this.y});

  static ECPoint getG() {
    ec.G.x.toBigInteger();
    print(ec);
    // ec.curve.
    // ec.seed()
    // BigInt.from(value)
    // return new Bn(ec.curve.n.toArray())
    return ec.G;
  }

  static BigInt getN() {
    return ec.n;
  }
}
