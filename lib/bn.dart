import 'dart:typed_data';

import 'package:convert/convert.dart';
import "package:pointycastle/pointycastle.dart";

var ec = new ECDomainParameters("secp256k1");

List<int> reverseBuf(List<int> buf) {
  var buf2 = List<int>(buf.length);
  for (var i = 0; i < buf.length; i++) {
    buf2[i] = buf[buf.length - 1 - i];
  }
  return buf2;
}

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

  static BigIntX fromBuffer(
    List<int> list, {
    Endian endian = Endian.big,
  }) {
    if (endian == Endian.little) {
      list = reverseBuf(list);
    }
    var str = hex.encode(list);
    return BigIntX(bn: BigInt.tryParse(str, radix: 16));
  }

  static BigIntX fromHex(String hexStr, {Endian endian = Endian.big}) {
    return BigIntX.fromBuffer(hex.decode(hexStr), endian: endian);
  }

  String toHex({int size, Endian endian = Endian.big}) {
    return hex.encode(this.toBuffer(size: size, endian: endian));
  }

  List<int> toBuffer({int size, Endian endian = Endian.big}) {
    // List<int> buf = hex.decode(hexStr);
    List<int> buf;

    if (size != null) {
      var hexStr = this.bn.toRadixString(16).padLeft(2, '0');
      var natlen = hexStr.length ~/ 2;
      buf = hex.decode(hexStr);

      if (natlen == size) {
        //pass
      } else if (natlen > size) {
        buf = buf.getRange(natlen - buf.length, buf.length).toList();
      } else if (natlen < size) {
        var rbuf = List<int>(size);
        for (var i = 0; i < buf.length; i++) {
          rbuf[rbuf.length - 1 - i] = buf[buf.length - 1 - i];
        }
        for (var i = 0; i < size - natlen; i++) {
          rbuf[i] = 0;
        }
        buf = rbuf;
      }
      // buf = hex.decode(this.bn.toRadixString(16).padLeft(size, '0'));
      // return this.bn.toRadixString(16).padLeft(size);
    } else {
      var hexStr = this.bn.toRadixString(16).padLeft(2, '0');
      buf = hex.decode(hexStr);
    }

    if (endian == Endian.little) {
      buf = reverseBuf(buf);
    }
    // Uint8List a;
    //    const longzero = Buffer.from([0])
    // if (Buffer.compare(buf, longzero) === 0) {
    //   return Buffer.from([])
    // }
    // return hex.decode(this.bn.toRadixString(16));
    return buf;
  }

  /// not implement
  // int toBits() {
  //   return this.bn.bitLength;
  // }

  /// not implement
  /// fromBits(){}

  /// not implement
  /// toSm(){}

  /// Signed magnitude buffer. Most significant bit represents sign (0 = positive,
  /// 1 = negative).
  BigIntX fromSm(List<int> buf, {Endian endian = Endian.big}) {
    if (buf.isEmpty) {
      BigIntX.fromBuffer([0]);
    }

    if (endian == Endian.little) {
      buf = reverseBuf(buf);
    }

    if (buf[0] & 0x80 == 1) {
      buf[0] = buf[0] & 0x7f;
      var tmp = BigIntX.fromBuffer(buf);
      return tmp.neg();
    } else {
      return BigIntX.fromBuffer(buf);
    }
    // return BigIntX.fromBuffer(buf);
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
