import 'package:convert/convert.dart';
import "package:pointycastle/pointycastle.dart";

var ec = new ECDomainParameters("secp256k1");

/// Big number extension
class BigIntX {
  BigInt bn;

  BigIntX({this.bn});

  factory BigIntX.fromNum(num n) {
    return BigIntX(bn: BigInt.from(n));
  }

  factory BigIntX.fromString(String source, {int radix = 10}) {
    return BigIntX(bn: BigInt.parse(source, radix: radix));
  }

  static BigIntX fromBuffer(List<int> list) {
    var str = hex.encode(list);
    return BigIntX(bn: BigInt.tryParse(str, radix: 16));
  }

  BigIntX neg() => BigIntX(bn: bn * BigInt.from(-1));

  BigIntX add(BigIntX other) => BigIntX(bn: bn + other.bn);

  BigIntX sub(BigIntX other) => BigIntX(bn: bn - other.bn);

  BigIntX mul(BigIntX other) => BigIntX(bn: bn * other.bn);

  /// in dart -50%47=44 , in nodejs -50%47=3 , use remainder fix it
  BigIntX mod(BigIntX other) {
    // var a = 10;
    // a.remainder(other)
    // if (bn.isNegative) {
    //   return BigIntX(bn: (bn % other.bn));
    // }
    // return BigIntX(bn: bn % other.bn);
    return BigIntX(bn: bn.remainder(other.bn));
  }

  BigIntX div(BigIntX other) => BigIntX(bn: bn ~/ other.bn);

  int cmp(BigIntX other) => this.bn.compareTo(other.bn);

  bool eq(BigIntX other) {
    return this.cmp(other) == 0;
  }

  bool neq(BigIntX other) {
    return this.cmp(other) != 0;
  }

  bool gt(BigIntX other) {
    return this.cmp(other) > 0;
  }

  bool geq(BigIntX other) {
    return this.cmp(other) >= 0;
  }

  bool lt(BigIntX other) {
    return this.cmp(other) < 0;
  }

  bool leq(BigIntX other) {
    return this.cmp(other) <= 0;
  }

  String toString({int radix = 10}) {
    return this.bn.toRadixString(radix);
  }
}
