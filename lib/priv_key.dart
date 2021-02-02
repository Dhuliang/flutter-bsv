import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/constants.dart';
import 'package:bsv/point.dart';
import 'package:bsv/random.dart';
import 'package:bs58check/bs58check.dart' as Base58Check;

class PrivKey {
  BigIntX bn;
  bool compressed;
  int privKeyVersionByteNum;

  PrivKey({
    BigIntX bn,
    bool compressed,
    int privKeyVersionByteNum,
  }) {
    this.bn = bn;
    this.compressed = compressed;
    this.privKeyVersionByteNum =
        privKeyVersionByteNum ?? Constants.mainnet.privKeyVersionByteNum;
  }

  factory PrivKey.testnet({BigIntX bn, bool compressed}) {
    return PrivKey(
      bn: bn,
      compressed: compressed,
      privKeyVersionByteNum: Constants.testnet.privKeyVersionByteNum,
    );
  }

  factory PrivKey.mainnet({BigIntX bn, bool compressed}) {
    return PrivKey(
      bn: bn,
      compressed: compressed,
      privKeyVersionByteNum: Constants.mainnet.privKeyVersionByteNum,
    );
  }

  factory PrivKey.fromRandom() {
    return PrivKey().fromRandom();
  }

  factory PrivKey.fromBuffer(buf) {
    return PrivKey().fromBuffer(buf);
  }

  factory PrivKey.fromBn(BigIntX bn) {
    return PrivKey(bn: bn);
  }

  factory PrivKey.fromWif(String str) {
    return PrivKey.fromBuffer(Base58Check.decode(str));
  }

  factory PrivKey.fromString(String str) {
    return PrivKey.fromWif(str);
  }

  factory PrivKey.fromHex(String str) {
    return PrivKey.fromBn(BigIntX.fromHex(str));
  }

  factory PrivKey.fromJSON(String str) {
    return PrivKey.fromHex(str);
  }

  PrivKey fromBuffer(List<int> buf) {
    if (buf.length == 1 + 32 + 1 && buf[1 + 32 + 1 - 1] == 1) {
      this.compressed = true;
    } else if (buf.length == 1 + 32) {
      this.compressed = false;
    } else {
      throw new Exception(
          'Length of privKey buffer must be 33 (uncompressed pubKey) or 34 (compressed pubKey)');
    }

    if (buf[0] != this.privKeyVersionByteNum) {
      throw new Exception('Invalid versionByteNum byte');
    }

    return PrivKey.fromBn(BigIntX.fromBuffer(buf.sublist(1, 1 + 32)));
  }

  PrivKey fromRandom() {
    List<int> privBuf;
    BigIntX bn;
    bool condition;

    do {
      privBuf = RandomBytes.getRandomBuffer(32);
      bn = BigIntX.fromBuffer(privBuf);
      condition = bn.lt(Point.getN());
    } while (!condition);

    // return PrivKey(bn: bn, compressed: true);
    this.bn = bn;
    this.compressed = true;
    return this;
  }

  List<int> toBuffer() {
    var compressed = this.compressed;

    if (compressed == null) {
      compressed = true;
    }

    var privBuf = this.bn.toBuffer(size: 32);
    List<int> buf;
    if (compressed) {
      buf = [
        this.privKeyVersionByteNum,
        ...privBuf,
        0x01,
      ];
    } else {
      buf = [this.privKeyVersionByteNum, ...privBuf];
    }

    return buf;
  }

  String toWif() {
    return Base58Check.encode(Uint8List.fromList(this.toBuffer()));
  }

  String toJSON() {
    return this.toHex();
  }

  String toHex() {
    return this.bn.toHex();
  }

  @override
  String toString() {
    return this.toWif();
  }
}
