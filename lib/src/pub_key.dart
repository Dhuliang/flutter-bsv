import 'package:bsv/src/bn.dart';
import 'package:bsv/src/point.dart';
import 'package:bsv/src/priv_key.dart';
// import 'package:bs58check/bs58check.dart' as Base58Check;
import 'package:convert/convert.dart';

class PubKey {
  PointWrapper? point;
  bool? compressed;

  static const INVALID_BUF_LENGTH = "Length of x and y must be 32 bytes";

  static const INVALID_DER_FORMAT = "Invalid DER format pubKey";

  static const INVALID_ODD =
      "Must specify whether y is odd or not (true or false)";

  static const INVALID_COMPRESSED =
      "Must specify whether the public key is compressed or not (true or false)";

  static const INVALID_POINT_INFINITY =
      "point: Point cannot be equal to Infinity";

  static const INVALID_POINT_ZERO = "point: Point cannot be equal to 0, 0";

  PubKey({
    PointWrapper? point,
    bool? compressed,
  }) {
    this.point = point;
    this.compressed = compressed;
  }

  factory PubKey.fromPrivKey(PrivKey privKey) {
    return PubKey().fromPrivKey(privKey);
  }

  factory PubKey.fromDer(List<int> buf, [bool strict = false]) {
    return PubKey().fromDer(buf, strict);
  }

  factory PubKey.fromHex(String str) {
    return PubKey().fromBuffer(hex.decode(str));
  }

  factory PubKey.fromJSON(String str) {
    return PubKey().fromJSON(str);
  }

  PubKey fromJSON(String json) {
    this.fromFastBuffer(hex.decode(json));
    return this;
  }

  PubKey fromString(String str) {
    this.fromDer(BigIntX.fromHex(str).toBuffer(), false);
    return this;
  }

  PubKey fromFastBuffer(List<int> buf) {
    if (buf.isEmpty) {
      return this;
    }

    var compressed = buf[0] == 1;
    buf = buf.sublist(1);
    this.fromDer(buf);
    this.compressed = compressed;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * In order to mimic the non-strict style of OpenSSL, set strict = false. For
     * information and what prefixes 0x06 and 0x07 mean, in addition to the normal
     * compressed and uncompressed public keys, see the message by Peter Wuille
     * where he discovered these "hybrid pubKeys" on the mailing list:
     * http://sourceforge.net/p/bitcoin/mailman/message/29416133/
     */
  PubKey fromDer(List<int> buf, [bool? strict]) {
    if (strict == null) {
      strict = true;
    } else {
      strict = false;
    }

    if (buf[0] == 0x04 || (!strict && (buf[0] == 0x06 || buf[0] == 0x07))) {
      var xbuf = buf.sublist(1, 33);
      var ybuf = buf.sublist(33, 65);
      if (xbuf.length != 32 || ybuf.length != 32 || buf.length != 65) {
        throw INVALID_BUF_LENGTH;
      }
      var x = BigIntX.fromBuffer(xbuf).bn;
      var y = BigIntX.fromBuffer(ybuf).bn;

      this.point = new PointWrapper(x: x, y: y);
      this.compressed = false;
    } else if (buf[0] == 0x03) {
      var xbuf = buf.sublist(1);
      var x = new BigIntX.fromBuffer(xbuf).bn;
      this.fromX(isOdd: true, x: x);
      this.compressed = true;
    } else if (buf[0] == 0x02) {
      var xbuf = buf.sublist(1);
      var x = new BigIntX.fromBuffer(xbuf).bn;
      this.fromX(isOdd: false, x: x);
      this.compressed = true;
    } else {
      throw INVALID_DER_FORMAT;
    }
    return this;
  }

  PubKey fromX({bool? isOdd, BigInt? x}) {
    if (isOdd == null) {
      throw INVALID_ODD;
    }

    this.point = PointWrapper.fromX(isOdd: isOdd, x: x);
    return this;
  }

  PubKey fromBuffer(List<int> buf, [bool? strict]) {
    return this.fromDer(buf, strict);
  }

  List<int> toBuffer() {
    var compressed = this.compressed;

    if (compressed == null) {
      compressed = true;
    }

    return this.toDer(compressed);
  }

  List<int> toDer(bool compressed) {
    // compressed = compressed == null ? this.compressed : compressed;
    // ignore: unnecessary_null_comparison
    if (compressed == null) {
      throw INVALID_COMPRESSED;
    }

    var x = this.point!.getX();
    var y = this.point!.getY();

    var xbuf = x.toBuffer(size: 32);
    var ybuf = y.toBuffer(size: 32);

    List<int> prefix;

    if (!compressed) {
      prefix = List<int>.from([0x04]);
      // return List<int>.from([prefix, xbuf, ybuf]);
      return prefix + xbuf + ybuf;
    } else {
      var odd = ybuf[ybuf.length - 1] % 2;
      if (odd != 0) {
        prefix = List<int>.from([0x03]);
      } else {
        prefix = List<int>.from([0x02]);
      }
      // return List<int>.from([prefix, xbuf]);
      return prefix + xbuf;
    }
  }

  // String toWif() {
  //   return Base58Check.encode(Uint8List.fromList(this.toBuffer()));
  // }

  String toJSON() {
    return hex.encode(this.toFastBuffer());
  }

  List<int> toFastBuffer() {
    if (this.point == null) {
      return [0];
    }

    List<int> buffer = [];
    buffer.add((this.compressed ?? true) ? 1 : 0);
    buffer.addAll(this.toDer(false));
    // var bw = WriteBuffer();
    // Buffer
    // const bw = new Bw()

    // bw.putUint8(this.compressed ? 1 : 0);
    // bw.putInt64List(this.toDer(false));
    // return bw.toBuffer()
    // return bw.done().buffer.asInt8List();
    return buffer;
  }

  String toHex() {
    return hex.encode(this.toBuffer());
  }

  String toString() {
    var compressed = this.compressed == null ? true : this.compressed;
    return hex.encode(this.toDer(compressed!));
  }

  static bool isCompressedOrUncompressed(List<int> buf) {
    if (buf.length < 33) {
      //  Non-canonical public key: too short
      return false;
    }
    if (buf[0] == 0x04) {
      if (buf.length != 65) {
        //  Non-canonical public key: invalid length for uncompressed key
        return false;
      }
    } else if (buf[0] == 0x02 || buf[0] == 0x03) {
      if (buf.length != 33) {
        //  Non-canonical public key: invalid length for compressed key
        return false;
      }
    } else {
      //  Non-canonical public key: neither compressed nor uncompressed
      return false;
    }
    return true;
  }

  PubKey validate() {
    if (this.point!.isInfinity) {
      throw INVALID_POINT_INFINITY;
    }
    var other = PointWrapper(x: BigInt.zero, y: BigInt.zero);
    if (this.point == other) {
      throw INVALID_POINT_ZERO;
    }
    this.point!.validate();
    return this;
  }

  PubKey fromPrivKey(PrivKey privKey) {
    this.point = PointWrapper.getG().mul(privKey.bn!);
    this.compressed = privKey.compressed;
    return this;
  }
}
