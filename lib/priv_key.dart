import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/constants.dart';
import 'package:bsv/point.dart';
import 'package:bsv/random.dart';

class PrivKey {
  BigIntX bn;
  bool compressed;
  int privKeyVersionByteNum = Constants.mainnet.privKeyVersionByteNum;

  PrivKey({
    this.bn,
    this.compressed,
    this.privKeyVersionByteNum,
  });

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

  PrivKey fromRandom() {
    List<int> privBuf;
    BigIntX bn;
    bool condition;

    do {
      privBuf = RandomBytes.getRandomBuffer(32);
      bn = BigIntX.fromBuffer(privBuf);
      condition = bn.lt(BigIntX(bn: Point.getN()));
    } while (!condition);

    return PrivKey(bn: bn, compressed: true);
  }

  toBuffer() {
    var compressed = this.compressed;

    if (compressed == null) {
      compressed = true;
    }
// Endian.big
    // var privBuf = this.bn.toBuffer({size: 32});
    // let buf
    // if (compressed) {
    //   buf = Buffer.concat([
    //     Buffer.from([this.privKeyVersionByteNum]),
    //     privBuf,
    //     Buffer.from([0x01])
    //   ])
    // } else {
    //   buf = Buffer.concat([Buffer.from([this.Constants.versionByteNum]), privBuf])
    // }

    // return buf
  }
}
