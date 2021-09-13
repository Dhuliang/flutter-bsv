import 'dart:convert';
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/constants.dart';
import 'package:bsv/hash.dart';
import 'package:bsv/point.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/random.dart';
import 'package:convert/convert.dart';
import 'package:bs58check/bs58check.dart' as Base58Check;
import 'package:bsv/extentsions/list.dart';

class Bip32 {
  int? versionBytesNum;
  int? depth;
  Uint8List? parentFingerPrint;
  int? childIndex;
  Uint8List? chainCode;
  PrivKey? privKey;
  PubKey? pubKey;

  int? bip32PrivKey;
  int? bip32PubKey;

  Bip32({
    int? versionBytesNum,
    int? depth,
    Uint8List? parentFingerPrint,
    int? childIndex,
    Uint8List? chainCode,
    PrivKey? privKey,
    PubKey? pubKey,
    int? bip32PrivKey,
    int? bip32PubKey,
  }) {
    this.versionBytesNum = versionBytesNum;
    this.depth = depth;
    this.parentFingerPrint = parentFingerPrint;
    this.childIndex = childIndex;
    this.chainCode = chainCode;
    this.privKey = privKey;
    this.pubKey = pubKey;
    this.bip32PrivKey = bip32PrivKey ?? Globals.network.bip32PrivKey;
    this.bip32PubKey = bip32PubKey ?? Globals.network.bip32PubKey;
  }

  // ignore: non_constant_identifier_names
  factory Bip32.Testnet({
    int? versionBytesNum,
    int? depth,
    Uint8List? parentFingerPrint,
    int? childIndex,
    Uint8List? chainCode,
    PrivKey? privKey,
    PubKey? pubKey,
  }) {
    return Bip32(
      versionBytesNum: versionBytesNum,
      depth: depth,
      parentFingerPrint: parentFingerPrint,
      childIndex: childIndex,
      chainCode: chainCode,
      privKey: privKey,
      pubKey: pubKey,
      bip32PrivKey: Constants.Testnet.bip32PrivKey,
      bip32PubKey: Constants.Testnet.bip32PubKey,
    );
  }

  // ignore: non_constant_identifier_names
  factory Bip32.Regtest({
    int? versionBytesNum,
    int? depth,
    Uint8List? parentFingerPrint,
    int? childIndex,
    Uint8List? chainCode,
    PrivKey? privKey,
    PubKey? pubKey,
  }) {
    return Bip32(
      versionBytesNum: versionBytesNum,
      depth: depth,
      parentFingerPrint: parentFingerPrint,
      childIndex: childIndex,
      chainCode: chainCode,
      privKey: privKey,
      pubKey: pubKey,
      bip32PrivKey: Constants.Regtest.bip32PrivKey,
      bip32PubKey: Constants.Regtest.bip32PubKey,
    );
  }

  // ignore: non_constant_identifier_names
  factory Bip32.Mainnet({
    int? versionBytesNum,
    int? depth,
    Uint8List? parentFingerPrint,
    int? childIndex,
    Uint8List? chainCode,
    PrivKey? privKey,
    PubKey? pubKey,
  }) {
    return Bip32(
      versionBytesNum: versionBytesNum,
      depth: depth,
      parentFingerPrint: parentFingerPrint,
      childIndex: childIndex,
      chainCode: chainCode,
      privKey: privKey,
      pubKey: pubKey,
      bip32PrivKey: Globals.network.bip32PrivKey,
      bip32PubKey: Globals.network.bip32PubKey,
    );
  }

  Bip32 fromRandom() {
    this.versionBytesNum = this.bip32PrivKey ?? Globals.network.bip32PrivKey;
    this.depth = 0x00;
    this.parentFingerPrint = Uint8List.fromList([0, 0, 0, 0]);
    this.childIndex = 0;
    this.chainCode = RandomBytes.getRandomBuffer(32);
    this.privKey = new PrivKey.fromRandom();
    this.pubKey = new PubKey().fromPrivKey(this.privKey!);
    return this;
  }

  factory Bip32.fromRandom() {
    return new Bip32().fromRandom();
  }

  Bip32 fromString(String str) {
    return this.fromBuffer(Base58Check.decode(str));
  }

  Bip32 fromSeed(List<int>? bytes) {
    if (!(bytes is List<int>)) {
      throw ('bytes must be a buffer');
    }
    if (bytes.length < 128 / 8) {
      throw ('Need more than 128 bits of entropy');
    }
    if (bytes.length > 512 / 8) {
      throw ('More than 512 bits of entropy is nonstandard');
    }
    var hash = Hash.sha512Hmac(
            bytes as Uint8List, Uint8List.fromList(utf8.encode('Bitcoin seed')))
        .data!;

    this.depth = 0x00;
    this.parentFingerPrint = Uint8List.fromList([0, 0, 0, 0]);
    this.childIndex = 0;
    this.chainCode = hash.slice(32, 64).asUint8List();
    this.versionBytesNum = this.bip32PrivKey;
    this.privKey = PrivKey.fromBn(BigIntX.fromBuffer(hash.slice(0, 32)));
    this.pubKey = PubKey().fromPrivKey(this.privKey!);

    return this;
  }

  factory Bip32.fromSeed(List<int> bytes) {
    return new Bip32().fromSeed(bytes);
  }

  Bip32 fromBuffer(List<int> list) {
    // Both pub and private extended keys are 78 buf
    if (list.length != 78) {
      throw ('incorrect bip32 data length');
    }

    // Uint8List.fromList([]).buffer).getUint16(byteOffset)
    var buf = Uint8List.fromList(list);

    this.versionBytesNum =
        ByteData.view(Uint8List.fromList(buf.slice(0, 4)).buffer).getUint32(0);
    this.depth =
        ByteData.view(Uint8List.fromList(buf.slice(4, 5)).buffer).getUint8(0);

    this.parentFingerPrint = buf.slice(5, 9).asUint8List();
    this.childIndex =
        ByteData.view(Uint8List.fromList(buf.slice(9, 13)).buffer).getUint32(0);

    this.chainCode = buf.slice(13, 45).asUint8List();
    var keyBytes = buf.slice(45, 78);

    var isPrivate = this.versionBytesNum == this.bip32PrivKey;
    var isPublic = this.versionBytesNum == this.bip32PubKey;

    if (isPrivate && keyBytes[0] == 0) {
      this.privKey = PrivKey.fromBn(BigIntX.fromBuffer(keyBytes.slice(1, 33)));
      this.pubKey = new PubKey().fromPrivKey(this.privKey!);
    } else if (isPublic && (keyBytes[0] == 0x02 || keyBytes[0] == 0x03)) {
      this.pubKey = new PubKey().fromDer(keyBytes);
    } else {
      throw ('Invalid key');
    }

    return this;
  }

  Bip32 derive(String path) {
    var e = path.split('/');

    if (path == 'm') {
      return this;
    }

    Bip32 bip32 = this;

    for (var i = 0; i < e.length; i++) {
      var c = e[i];

      if (i == 0) {
        if (c != 'm') throw ('invalid path');
        continue;
      }

      var isNum = int.tryParse(c.replaceAll("'", '')).toString() !=
          c.replaceAll("'", '');
      // if (parseInt(c.replace("'", ''), 10).toString() != c.replace("'", '')) {
      if (isNum) {
        throw ('invalid path');
      }

      var usePrivate = c.length > 1 && c[c.length - 1] == "'";
      var childIndex =
          int.tryParse(usePrivate ? c.substring(0, c.length - 1) : c)! &
              0x7fffffff;

      if (usePrivate) {
        childIndex += 0x80000000;
      }

      bip32 = bip32.deriveChild(childIndex);
    }

    return bip32;
  }

  Bip32 deriveChild(int i) {
    if (!(i is int)) {
      throw ('i must be a number');
    }

    List<int> ib = [];
    ib.add((i >> 24) & 0xff);
    ib.add((i >> 16) & 0xff);
    ib.add((i >> 8) & 0xff);
    ib.add(i & 0xff);
    ib = List<int>.from(ib);

    var usePrivate = (i & 0x80000000) != 0;

    var isPrivate = this.versionBytesNum == this.bip32PrivKey;

    if (usePrivate && ((this.privKey == null) || !isPrivate)) {
      throw ('Cannot do private key derivation without private key');
    }

    Bip32 ret;
    if (this.privKey != null) {
      Uint8List data;

      if (usePrivate) {
        data = Uint8List.fromList([
          ...[0],
          ...this.privKey!.bn!.toBuffer(size: 32),
          ...ib,
        ]);
      } else {
        // data =  List<int>.from([this.pubKey.toBuffer( size: 32 ), ib]);
        data = Uint8List.fromList([
          ...this.pubKey!.toBuffer(),
          ...ib,
        ]);
      }

      var hash =
          Hash.sha512Hmac(Uint8List.fromList(data), this.chainCode!).data!;
      // var il = BigIntX.fromBuffer(hash.slice(0, 32), { size: 32 })
      var il = BigIntX.fromBuffer(hash.slice(0, 32));
      var ir = hash.slice(32, 64).asUint8List();

      // ki = IL + kpar (mod n).
      var k = il.add(this.privKey!.bn!).mod(PointWrapper.getN());

      ret = new Bip32();
      ret.chainCode = ir;

      ret.privKey = PrivKey.fromBn(k);
      ret.pubKey = new PubKey().fromPrivKey(ret.privKey!);
    } else {
      var data = Uint8List.fromList([...this.pubKey!.toBuffer(), ...ib]);
      var hash = Hash.sha512Hmac(data, this.chainCode!).data!;
      var il = BigIntX.fromBuffer(hash.slice(0, 32));
      var ir = hash.slice(32, 64).asUint8List();

      // Ki = (IL + kpar)*G = IL*G + Kpar
      var ilG = PointWrapper.getG().mul(il);
      // ignore: non_constant_identifier_names
      var Kpar = this.pubKey!.point!;
      // ignore: non_constant_identifier_names
      var Ki = ilG.add(Kpar);
      var newpub = new PubKey();
      newpub.point = Ki;

      ret = new Bip32();
      ret.chainCode = ir;

      ret.pubKey = newpub;
    }

    ret.childIndex = i;
    var pubKeyhash =
        Hash.sha256Ripemd160(this.pubKey!.toBuffer().asUint8List()).data!;
    ret.parentFingerPrint = pubKeyhash.slice(0, 4).asUint8List();
    ret.versionBytesNum = this.versionBytesNum;
    ret.depth = this.depth! + 1;
    ret.bip32PrivKey = this.bip32PrivKey;
    ret.bip32PubKey = this.bip32PubKey;

    return ret;
  }

  Bip32 toPublic() {
    var bip32 = new Bip32(
      versionBytesNum: this.versionBytesNum,
      depth: this.depth,
      parentFingerPrint: this.parentFingerPrint,
      childIndex: this.childIndex,
      chainCode: this.chainCode,
      privKey: this.privKey,
      pubKey: this.pubKey,
      bip32PrivKey: this.bip32PrivKey,
      bip32PubKey: this.bip32PubKey,
    );
    bip32.versionBytesNum = this.bip32PubKey;
    bip32.privKey = null;
    return bip32;
  }

  List<int> toBuffer() {
    var isPrivate = this.versionBytesNum == this.bip32PrivKey;
    var isPublic = this.versionBytesNum == this.bip32PubKey;
    if (isPrivate) {
      return new Bw()
          .writeUInt32BE(this.versionBytesNum!)
          .writeUInt8(this.depth!)
          .write(this.parentFingerPrint)
          .writeUInt32BE(this.childIndex!)
          .write(this.chainCode)
          .writeUInt8(0)
          .write(this.privKey!.bn!.toBuffer(size: 32).asUint8List())
          .toBuffer();
    } else if (isPublic) {
      if (this.pubKey!.compressed == false) {
        throw ('cannot convert bip32 to buffer if pubKey is not compressed');
      }
      return new Bw()
          .writeUInt32BE(this.versionBytesNum!)
          .writeUInt8(this.depth!)
          .write(this.parentFingerPrint)
          .writeUInt32BE(this.childIndex!)
          .write(this.chainCode)
          .write(this.pubKey!.toBuffer().asUint8List())
          .toBuffer();
    } else {
      throw ('bip32: invalid versionBytesNum byte');
    }
  }

  String toString() {
    return Base58Check.encode(this.toBuffer().asUint8List());
  }

  // toJSON() {
  //   return this.toFastHex();
  // }

  // fromJSON(json) {
  //   return this.fromFastHex(json);
  // }

  Bip32 fromHex(String str) {
    return this.fromBuffer(hex.decode(str));
  }

  String toHex() {
    return this.toBuffer().toHex();
  }

  bool isPrivate() {
    return this.versionBytesNum == this.bip32PrivKey;
  }
}
