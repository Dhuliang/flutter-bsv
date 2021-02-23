import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/constants.dart';
import 'package:bsv/point.dart';
import 'package:bsv/random.dart';
import 'package:bs58check/bs58check.dart' as Base58Check;
import 'package:convert/convert.dart';

class PubKey {
  Point point;
  bool compressed;

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
    Point point,
    bool compressed,
  }) {
    this.point = point;
    this.compressed = compressed;
  }

  // factory PrivKey.testnet({BigIntX bn, bool compressed}) {
  //   return PrivKey(
  //     bn: bn,
  //     compressed: compressed,
  //     privKeyVersionByteNum: Constants.testnet.privKeyVersionByteNum,
  //   );
  // }

  // factory PrivKey.mainnet({BigIntX bn, bool compressed}) {
  //   return PrivKey(
  //     bn: bn,
  //     compressed: compressed,
  //     privKeyVersionByteNum: Constants.mainnet.privKeyVersionByteNum,
  //   );
  // }

  // factory PrivKey.fromRandom() {
  //   return PrivKey().fromRandom();
  // }

  // factory PrivKey.fromBuffer(List<int> buf) {
  //   return PrivKey().fromBuffer(buf);
  // }

  // factory PrivKey.fromBn(BigIntX bn) {
  //   return PrivKey(bn: bn);
  // }

  // factory PrivKey.fromWif(String str) {
  //   return PrivKey.fromBuffer(Base58Check.decode(str));
  // }

  // factory PrivKey.fromString(String str) {
  //   return PrivKey.fromWif(str);
  // }

  // factory PrivKey.fromHex(String str) {
  //   return PrivKey.fromBuffer(hex.decode(str));
  // }

  // factory PrivKey.fromJSON(String str) {
  //   return PrivKey.fromHex(str);
  // }

  // PrivKey fromBuffer(List<int> buf) {
  //   // bool compressed;
  //   if (buf.length == 1 + 32 + 1 && buf[1 + 32 + 1 - 1] == 1) {
  //     this.compressed = true;
  //   } else if (buf.length == 1 + 32) {
  //     this.compressed = false;
  //   } else {
  //     throw INVALID_PRIV_KEY_LENGTH;
  //     // throw new Exception(
  //     //     'Length of privKey buffer must be 33 (uncompressed pubKey) or 34 (compressed pubKey)');
  //     // throw ('Length of privKey buffer must be 33 (uncompressed pubKey) or 34 (compressed pubKey)');
  //   }

  //   if (buf[0] != this.privKeyVersionByteNum) {
  //     // throw new Exception('Invalid versionByteNum byte');
  //     throw INVALID_VERSION_BYTE_NUM_BYTE;
  //   }

  //   // return PrivKey(
  //   //   bn: BigIntX.fromBuffer(buf.sublist(1, 1 + 32)),
  //   //   compressed: compressed,
  //   // );

  //   return this.fromBn(BigIntX.fromBuffer(buf.sublist(1, 1 + 32)));
  // }

  // PrivKey fromBn(BigIntX bn) {
  //   this.bn = bn;
  //   return this;
  // }

  // PrivKey fromString(String str) {
  //   this.bn = bn;
  //   return this.fromWif(str);
  // }

  // PrivKey fromWif(String str) {
  //   return this.fromBuffer(Base58Check.decode(str));
  // }

  // PrivKey fromRandom() {
  //   List<int> privBuf;
  //   BigIntX bn;
  //   bool condition;

  //   do {
  //     privBuf = RandomBytes.getRandomBuffer(32);
  //     bn = BigIntX.fromBuffer(privBuf);
  //     condition = bn.lt(Point.getN());
  //   } while (!condition);

  //   // return PrivKey(bn: bn, compressed: true);
  //   this.bn = bn;
  //   this.compressed = true;
  //   return this;
  // }

  // List<int> toBuffer() {
  //   var compressed = this.compressed;

  //   if (compressed == null) {
  //     compressed = true;
  //   }

  //   var privBuf = this.bn.toBuffer(size: 32);
  //   List<int> buf;
  //   if (compressed) {
  //     buf = [
  //       this.privKeyVersionByteNum,
  //       ...privBuf,
  //       0x01,
  //     ];
  //   } else {
  //     buf = [this.privKeyVersionByteNum, ...privBuf];
  //   }

  //   return buf;
  // }

  // String toWif() {
  //   return Base58Check.encode(Uint8List.fromList(this.toBuffer()));
  // }

  // String toJSON() {
  //   return this.toHex();
  // }

  // String toHex() {
  //   return hex.encode(this.toBuffer());
  // }

  // BigIntX toBn() {
  //   return this.bn;
  // }

  // PrivKey validate() {
  //   if (!this.bn.lt(Point.getN())) {
  //     throw INVALID_NUMBER_N;
  //   }
  //   if (this.compressed == null) {
  //     throw INVALID_COMPRESSED;
  //   }
  //   return this;
  // }

  // @override
  // String toString() {
  //   return this.toWif();
  // }
}
