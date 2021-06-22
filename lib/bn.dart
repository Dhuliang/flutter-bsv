import 'dart:typed_data';

import 'package:bsv/extentsions/string.dart';
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

  static BigIntX get zero => BigIntX(bn: BigInt.zero);
  static BigIntX get one => BigIntX(bn: BigInt.one);
  static BigIntX get two => BigIntX(bn: BigInt.two);

  factory BigIntX.fromNum(num n) {
    return BigIntX(bn: BigInt.from(n));
  }

  factory BigIntX.fromString(String source, {int radix = 10}) {
    return BigIntX(bn: BigInt.parse(source, radix: radix));
  }

  /// Signed magnitude buffer. Most significant bit represents sign (0 = positive,
  /// 1 = negative).
  factory BigIntX.fromSm(List<int> buf, {Endian endian = Endian.big}) {
    if (buf.isEmpty) {
      return BigIntX.fromBuffer([0]);
    }

    if (endian == Endian.little) {
      buf = reverseBuf(buf);
    }

    if (buf[0] & 0x80 > 0) {
      buf[0] = buf[0] & 0x7f;
      var tmp = BigIntX.fromBuffer(buf);
      return tmp.neg();
    }

    return BigIntX.fromBuffer(buf);
  }

  factory BigIntX.fromBuffer(
    List<int> list, {
    Endian endian = Endian.big,
  }) {
    if (endian == Endian.little) {
      list = reverseBuf(list);
    }
    var str = hex.encode(list);
    return BigIntX(bn: BigInt.tryParse(str, radix: 16));
  }

  factory BigIntX.fromHex(String hexStr, {Endian endian = Endian.big}) {
    return BigIntX.fromBuffer(hex.decode(hexStr), endian: endian);
  }

  // This is analogous to the constructor for CScriptNum in bitcoind. Many ops
  // in bitcoind's script interpreter use CScriptNum, which is not really a
  // proper bignum. Instead, an error is thrown if trying to input a number
  // bigger than 4 bytes. We copy that behavior here. There is one exception -
  // in CHECKLOCKTIMEVERIFY, the numbers are allowed to be up to 5 bytes long.
  // We allow for setting that variable here for use in CHECKLOCKTIMEVERIFY.
  //这类似于bitcoind中CScriptNum的构造函数。 许多行动
  //在bitcoind的脚本解释器中使用CScriptNum，这实际上不是
  //正确的bignum。 相反，如果尝试输入数字，则会引发错误
  //大于4个字节。 我们在此复制该行为。 有一个例外-
  //在CHECKLOCKTIMEVERIFY中，数字的最大长度为5个字节。
  //我们允许在此处设置该变量以用于CHECKLOCKTIMEVERIFY。
  factory BigIntX.fromScriptNumBuffer({
    List<int> buf,
    bool fRequireMinimal = false,
    int nMaxNumSize,
  }) {
    if (nMaxNumSize == null) {
      nMaxNumSize = 4;
    }
    if (buf.length > nMaxNumSize) {
      throw Exception('script number overflow');
    }
    if (fRequireMinimal && buf.length > 0) {
      // Check that the number is encoded with the minimum possible
      // number of bytes.
      //
      // If the most-significant-byte - excluding the sign bit - is zero
      // then we're not minimal. Note how this test also rejects the
      // negative-zero encoding, 0x80.
      if ((buf[buf.length - 1] & 0x7f) == 0) {
        // One exception: if there's more than one byte and the most
        // significant bit of the second-most-significant-byte is set
        // it would conflict with the sign bit. An example of this case
        // is +-255, which encode to 0xff00 and 0xff80 respectively.
        // (big-endian).
        if (buf.length <= 1 || (buf[buf.length - 2] & 0x80) == 0) {
          throw Exception('non-minimally encoded script number');
        }
      }
    }

    return BigIntX.fromSm(buf, endian: Endian.little);
  }

  String toHex({int size, Endian endian = Endian.big}) {
    return hex.encode(this.toBuffer(size: size, endian: endian));
  }

  List<int> toBuffer({int size, Endian endian = Endian.big}) {
    // List<int> buf = hex.decode(hexStr);
    List<int> buf;

    if (size != null) {
      var hexStr = this.bn.toRadixString(16).padLeft0();
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
      // var hexStr = this.bn.toRadixString(16).padLeft(2, '0');
      var hexStr = this.bn.toRadixString(16).padLeft0();
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

  List<int> toSm({Endian endian = Endian.big}) {
    List<int> buf;
    if (this?.cmp(0) == -1) {
      buf = this.neg().toBuffer();
      if (buf[0] & 0x80 > 0) {
        // buf = Buffer.concat([Buffer.from([0x80]), buf])
        buf = [0x80, ...buf];
      } else {
        buf[0] = buf[0] | 0x80;
      }
    } else {
      buf = this.toBuffer();
      if (buf[0] & 0x80 > 0) {
        // buf = Buffer.concat([Buffer.from([0x00]), buf])
        buf = [0x00, ...buf];
      }
    }

    if ((buf.length == 1) & (buf[0] == 0)) {
      buf = [];
    }

    if (endian == Endian.little) {
      buf = reverseBuf(buf);
    }

    return buf;
  }

  int toInt() {
    return this.bn.toInt();
  }

  BigIntX umod(BigIntX other) => BigIntX(bn: bn % other.bn);

  BigIntX invm(BigIntX other) => BigIntX(bn: bn.modInverse(other.bn));

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

  // int cmp(BigIntX other) => this.bn.compareTo(other.bn);
  int cmp(dynamic other) {
    if (other is BigIntX) {
      return this.bn.compareTo(other.bn);
    }
    if (other is num) {
      return this.bn.compareTo(BigInt.from(other));
    }
    if (other is BigInt) {
      return this.bn.compareTo(other);
    }
    throw Exception("not support yet");
  }

  bool eq(dynamic other) {
    return this.cmp(other) == 0;
  }

  bool neq(dynamic other) {
    return this.cmp(other) != 0;
  }

  bool gt(dynamic other) {
    return this.cmp(other) > 0;
  }

  bool geq(dynamic other) {
    return this.cmp(other) >= 0;
  }

  bool lt(dynamic other) {
    return this.cmp(other) < 0;
  }

  bool leq(dynamic other) {
    return this.cmp(other) <= 0;
  }

  String toString({int radix = 10}) {
    return this.bn.toRadixString(radix);
  }

  //上面的推论，除了我们不抛出的明显例外
  //如果输出大于四个字节，则返回错误。 （如果
  //执行数值运算，导致溢出超过4
  //字节）。
  List<int> toScriptNumBuffer() {
    return this.toSm(endian: Endian.little);
  }

  int toNumber() {
    return this.bn.toInt();
  }
}
