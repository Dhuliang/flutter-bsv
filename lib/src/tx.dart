import 'dart:typed_data';

import 'package:bsv/src/bn.dart';
import 'package:bsv/src/br.dart';
import 'package:bsv/src/bw.dart';
import 'package:bsv/src/ecdsa.dart';
import 'package:bsv/src/extentsions/list.dart';
import 'package:bsv/src/hash.dart';
import 'package:bsv/src/hash_cache.dart';
import 'package:bsv/src/key_pair.dart';
import 'package:bsv/src/pub_key.dart';
import 'package:bsv/src/script.dart';
import 'package:bsv/src/sig.dart';
import 'package:bsv/src/tx_in.dart';
import 'package:bsv/src/tx_out.dart';
import 'package:bsv/src/var_int.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';

class Tx {
  static const int MAX_MONEY = 2100000000000000;

  // This is defined on Interp, but Tx cannot depend on Interp - must redefine here
  static const int SCRIPT_ENABLE_SIGHASH_FORKID = 1 << 16;

  int? versionBytesNum;
  VarInt? txInsVi;
  List<TxIn>? txIns;
  VarInt? txOutsVi;
  List<TxOut>? txOuts;
  int? nLockTime;

  Tx({
    int? versionBytesNum,
    VarInt? txInsVi,
    List<TxIn>? txIns,
    VarInt? txOutsVi,
    List<TxOut>? txOuts,
    int? nLockTime,
  }) {
    this.versionBytesNum = versionBytesNum ?? 1;
    this.txInsVi = txInsVi ?? VarInt.fromNumber(0);
    this.txIns = txIns ?? [];
    this.txOutsVi = txOutsVi ?? VarInt.fromNumber(0);
    this.txOuts = txOuts ?? [];
    this.nLockTime = nLockTime ?? 0;
  }

  Tx fromJSON(Map json) {
    List<TxIn> txIns = [];
    json['txIns'].forEach((txIn) {
      txIns.add(new TxIn().fromJSON(txIn));
    });
    List<TxOut> txOuts = [];
    json['txOuts'].forEach((txOut) {
      txOuts.add(new TxOut().fromJSON(txOut));
    });
    return Tx(
      versionBytesNum: json['versionBytesNum'],
      txInsVi: new VarInt().fromJSON(json['txInsVi']),
      txIns: txIns,
      txOutsVi: new VarInt().fromJSON(json['txOutsVi']),
      txOuts: txOuts,
      nLockTime: json['nLockTime'],
    );
  }

  Map<String, Object?> toJSON() {
    var txIns = [];
    this.txIns!.forEach((txIn) {
      txIns.add(txIn.toJSON());
    });
    var txOuts = [];
    this.txOuts!.forEach((txOut) {
      txOuts.add(txOut.toJSON());
    });
    return {
      "versionBytesNum": this.versionBytesNum,
      "txInsVi": this.txInsVi!.toJSON(),
      "txIns": txIns,
      "txOutsVi": this.txOutsVi!.toJSON(),
      "txOuts": txOuts,
      "nLockTime": this.nLockTime
    };
  }

  Tx fromBr(Br br) {
    this.versionBytesNum = br.readUInt32LE();
    this.txInsVi = VarInt(buf: br.readVarIntBuf());
    var txInsNum = this.txInsVi!.toNumber()!;
    this.txIns = [];
    for (var i = 0; i < txInsNum; i++) {
      var txIn = TxIn().fromBr(br);
      this.txIns!.add(txIn);
    }
    this.txOutsVi = VarInt(buf: br.readVarIntBuf());
    var txOutsNum = this.txOutsVi!.toNumber()!;
    this.txOuts = [];
    for (var i = 0; i < txOutsNum; i++) {
      this.txOuts!.add(TxOut().fromBr(br));
    }
    this.nLockTime = br.readUInt32LE();
    return this;
  }

  factory Tx.fromBuffer(List<int> buf) {
    return Tx().fromBr(Br(buf: buf as Uint8List?));
  }

  factory Tx.fromHex(String str) {
    return Tx().fromHex(str);
  }

  Bw toBw([Bw? bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.writeUInt32LE(this.versionBytesNum!);
    bw.write(this.txInsVi!.buf!.asUint8List());
    for (var i = 0; i < this.txIns!.length; i++) {
      this.txIns![i].toBw(bw);
    }
    bw.write(this.txOutsVi!.buf!.asUint8List());
    for (var i = 0; i < this.txOuts!.length; i++) {
      this.txOuts![i].toBw(bw);
    }
    bw.writeUInt32LE(this.nLockTime!);
    return bw;
  }

  // // https://github.com/Bitcoin-UAHF/spec/blob/master/replay-protected-sighash.md
  Hash hashPrevouts() {
    var bw = new Bw();
    for (var txIn in this.txIns!) {
      // var txIn = this.txIns[i];
      bw.write(txIn.txHashBuf!.asUint8List()); // outpoint (1/2)
      bw.writeUInt32LE(txIn.txOutNum!); // outpoint (2/2)
    }
    return Hash.sha256Sha256(bw.toBuffer().asUint8List());
  }

  Hash hashSequence() {
    var bw = new Bw();
    for (var txIn in this.txIns!) {
      // var txIn = this.txIns[i]
      bw.writeUInt32LE(txIn.nSequence);
    }
    return Hash.sha256Sha256(bw.toBuffer().asUint8List());
  }

  Hash hashOutputs() {
    var bw = new Bw();
    for (var txOut in this.txOuts!) {
      // var txOut = this.txOuts[i]
      bw.write(txOut.toBuffer().asUint8List());
    }
    return Hash.sha256Sha256(bw.toBuffer().asUint8List());
  }

  // ignore: slash_for_doc_comments
  /**
   * For a normal transaction, subScript is usually the scriptPubKey. For a
   * p2sh transaction, subScript is usually the redeemScript. If you're not
   * normal because you're using OP_CODESEPARATORs, you know what to do.
   */
  List<int> sighash({
    required int nHashType,
    int? nIn,
    Script? subScript,
    BigIntX? valueBn,
    int? flags = 0,
    HashCache? hashCache,
  }) {
    hashCache = hashCache ?? HashCache();
    var buf = this.sighashPreimage(
      nHashType: nHashType,
      nIn: nIn,
      subScript: subScript,
      valueBn: valueBn,
      flags: flags,
      hashCache: hashCache,
    );
    var result = listEquals(
      buf,
      hex.decode(
        '0000000000000000000000000000000000000000000000000000000000000001',
      ),
    );
    if (result) {
      return buf;
    }
    return new Br(buf: Hash.sha256Sha256(buf.asUint8List()).data).readReverse();
  }

  // async asyncSighash (nHashType, nIn, subScript, valueBn, flags = 0, hashCache = {}) {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'sighash', [
  //     nHashType,
  //     nIn,
  //     subScript,
  //     valueBn,
  //     flags,
  //     hashCache
  //   ])
  //   return workersResult.resbuf
  // }

  List<int> sighashPreimage({
    required int nHashType,
    int? nIn,
    Script? subScript,
    BigIntX? valueBn,
    int? flags = 0,
    HashCache? hashCache,
  }) {
    // start with UAHF part (Bitcoin SV)
    // https://github.com/Bitcoin-UAHF/spec/blob/master/replay-protected-sighash.md
    hashCache = hashCache ?? new HashCache();
    if ((nHashType & Sig.SIGHASH_FORKID != 0) &&
        (flags! & Tx.SCRIPT_ENABLE_SIGHASH_FORKID != 0)) {
      List<int>? hashPrevouts = List.generate(32, (index) => 0);
      List<int>? hashSequence = List.generate(32, (index) => 0);
      List<int>? hashOutputs = List.generate(32, (index) => 0);

      if (!(nHashType & Sig.SIGHASH_ANYONECANPAY != 0)) {
        hashPrevouts = hashCache.prevoutsHashBuf != null
            ? hashCache.prevoutsHashBuf
            : hashCache.prevoutsHashBuf = this.hashPrevouts().data.toList();
      }

      if (!(nHashType & Sig.SIGHASH_ANYONECANPAY != 0) &&
          (nHashType & 0x1f) != Sig.SIGHASH_SINGLE &&
          (nHashType & 0x1f) != Sig.SIGHASH_NONE) {
        hashSequence = hashCache.sequenceHashBuf != null
            ? hashCache.sequenceHashBuf
            : hashCache.sequenceHashBuf = this.hashSequence().data.toList();
      }

      if ((nHashType & 0x1f) != Sig.SIGHASH_SINGLE &&
          (nHashType & 0x1f) != Sig.SIGHASH_NONE) {
        hashOutputs = hashCache.outputsHashBuf != null
            ? hashCache.outputsHashBuf
            : hashCache.outputsHashBuf = this.hashOutputs().data.toList();
      } else if ((nHashType & 0x1f) == Sig.SIGHASH_SINGLE &&
          nIn! < this.txOuts!.length) {
        hashOutputs =
            Hash.sha256Sha256(this.txOuts![nIn].toBuffer().asUint8List()).data;
      }

      var bw = new Bw();
      bw.writeUInt32LE(this.versionBytesNum!);
      bw.write(hashPrevouts!.asUint8List());
      bw.write(hashSequence!.asUint8List());
      bw.write(this.txIns![nIn!].txHashBuf!.asUint8List()); // outpoint (1/2);
      bw.writeUInt32LE(this.txIns![nIn].txOutNum!); // outpoint (2/2);
      bw.writeVarIntNum(subScript!.toBuffer().length);
      bw.write(subScript.toBuffer().asUint8List());
      bw.writeUInt64LEBn(valueBn!);
      bw.writeUInt32LE(this.txIns![nIn].nSequence);
      bw.write(hashOutputs!.asUint8List());
      bw.writeUInt32LE(this.nLockTime!);
      bw.writeUInt32LE(nHashType >> 0);

      return bw.toBuffer();
    }

    // original bitcoin code follows - not related to UAHF (Bitcoin SV)
    var txcopy = this.cloneByBuffer();

    subScript = new Script().fromBuffer(subScript!.toBuffer().asUint8List());
    subScript.removeCodeseparators();

    for (var i = 0; i < txcopy.txIns!.length; i++) {
      txcopy.txIns![i] = TxIn()
          .fromBuffer(txcopy.txIns![i].toBuffer())
          .setScript(new Script());
    }

    txcopy.txIns![nIn!] =
        TxIn().fromBuffer(txcopy.txIns![nIn].toBuffer()).setScript(subScript);

    if ((nHashType & 31) == Sig.SIGHASH_NONE) {
      txcopy.txOuts!.length = 0;
      txcopy.txOutsVi = VarInt.fromNumber(0);

      for (var i = 0; i < txcopy.txIns!.length; i++) {
        if (i != nIn) {
          txcopy.txIns![i].nSequence = 0;
        }
      }
    } else if ((nHashType & 31) == Sig.SIGHASH_SINGLE) {
      // The SIGHASH_SINGLE bug.
      // https://bitcointalk.org/index.php?topic=260595.0
      if (nIn > txcopy.txOuts!.length - 1) {
        return hex.decode(
          '0000000000000000000000000000000000000000000000000000000000000001',
        );
      }

      txcopy.txOuts!.length = nIn + 1;
      txcopy.txOutsVi = VarInt.fromNumber(nIn + 1);

      for (var i = 0; i < txcopy.txOuts!.length; i++) {
        if (i < nIn) {
          txcopy.txOuts![i] = TxOut.fromProperties(
            valueBn: new BigIntX.fromBuffer(hex.decode('ffffffffffffffff')),
            script: new Script(),
          );
        }
      }

      for (var i = 0; i < txcopy.txIns!.length; i++) {
        if (i != nIn) {
          txcopy.txIns![i].nSequence = 0;
        }
      }
    }
    // else, SIGHASH_ALL

    if (nHashType & Sig.SIGHASH_ANYONECANPAY != 0) {
      txcopy.txIns![0] = txcopy.txIns![nIn];
      txcopy.txIns!.length = 1;
      txcopy.txInsVi = VarInt.fromNumber(1);
    }

    var buf = new Bw()
        .write(txcopy.toBuffer().asUint8List())
        .writeInt32LE(nHashType)
        .toBuffer();
    // print(buf.toHex());
    return buf;
  }

  Tx cloneByBuffer() {
    return new Tx().fromBuffer(this.toBuffer());
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }

  Tx fromBuffer(List<int> buf) {
    return this.fromBr(Br(buf: buf.asUint8List()));
  }

  Tx fromHex(String str) {
    return this.fromBuffer(hex.decode(str));
  }

  String toHex() {
    return this.toBuffer().toHex();
  }

  // async asyncSighashPreimage (nHashType, nIn, subScript, valueBn, flags = 0, hashCache = {}) {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'sighashPreimage', [
  //     nHashType,
  //     nIn,
  //     subScript,
  //     valueBn,
  //     flags,
  //     hashCache
  //   ])
  //   return workersResult.resbuf
  // }

  // This  returns a signature but does not update any inputs
  Sig sign({
    KeyPair? keyPair,
    int nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID,
    int? nIn,
    Script? subScript,
    BigIntX? valueBn,
    int flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID,
    HashCache? hashCache,
  }) {
    var hashBuf = this.sighash(
      nHashType: nHashType,
      nIn: nIn,
      subScript: subScript,
      valueBn: valueBn,
      flags: flags,
      hashCache: hashCache,
    );

    // var hashStr = hashBuf.toHex();
    // print(hashStr);

    // var reversedHash = hex.encode(hashBuf.reversed.toList());
    // print(reversedHash);

    var sig = Ecdsa.staticSign(
      hashBuf: hashBuf,
      keyPair: keyPair,
      endian: Endian.little,
    )!;
    sig.nHashType = nHashType;
    return sig;
  }

  // async asyncSign (keyPair, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, nIn, subScript, valueBn, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID, hashCache = {}) {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'sign', [
  //     keyPair,
  //     nHashType,
  //     nIn,
  //     subScript,
  //     valueBn,
  //     flags,
  //     hashCache
  //   ])
  //   return new Sig().fromFastBuffer(workersResult.resbuf)
  // }

  // This  takes a signature as input and does not parse any inputs
  bool? verify({
    required Sig sig,
    PubKey? pubKey,
    int? nIn,
    Script? subScript,
    bool enforceLowS = false,
    BigIntX? valueBn,
    int? flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID,
    HashCache? hashCache,
  }) {
    var hashBuf = this.sighash(
      nHashType: sig.nHashType!,
      nIn: nIn,
      subScript: subScript,
      valueBn: valueBn,
      flags: flags,
      hashCache: hashCache,
    );

    return Ecdsa.staticVerify(
      hashBuf: hashBuf,
      sig: sig,
      pubKey: pubKey,
      endian: Endian.little,
      enforceLowS: enforceLowS,
    );
  }

  // async asyncVerify (
  //   sig,
  //   pubKey,
  //   nIn,
  //   subScript,
  //   enforceLowS = false,
  //   valueBn,
  //   flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID,
  //   hashCache = {}
  // ) {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'verify', [
  //     sig,
  //     pubKey,
  //     nIn,
  //     subScript,
  //     enforceLowS,
  //     valueBn,
  //     flags,
  //     hashCache
  //   ])
  //   return JSON.parse(workersResult.resbuf.toString())
  // }

  Hash hash() {
    return Hash.sha256Sha256(this.toBuffer().asUint8List());
  }

  // async asyncHash () {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'hash', [])
  //   return workersResult.resbuf
  // }

  String id() {
    return new Br(buf: this.hash().data).readReverse().toHex();
  }

  // async asyncId () {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'id', [])
  //   return JSON.parse(workersResult.resbuf.toString())
  // }

  Tx addTxIn({
    dynamic data,
    int? txOutNum,
    Script? script,
    int? nSequence,
  }) {
    var txIn;
    if (data is TxIn) {
      txIn = data;
    } else {
      txIn = TxIn.fromProperties(
        txHashBuf: data,
        txOutNum: txOutNum,
        nSequence: nSequence,
        script: script,
      ).setScript(script);
    }
    this.txIns!.add(txIn);
    this.txInsVi = VarInt.fromNumber(this.txInsVi!.toNumber()! + 1);
    return this;
  }

  Tx addTxOut({dynamic data, Script? script}) {
    var txOut;
    if (data is TxOut) {
      txOut = data;
    } else {
      txOut = new TxOut(valueBn: data).setScript(script!);
    }
    this.txOuts!.add(txOut);
    this.txOutsVi = VarInt.fromNumber(this.txOutsVi!.toNumber()! + 1);
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
   * Analagous to bitcoind's IsCoinBase  in transaction.h
   */
  bool isCoinbase() {
    return this.txIns!.length == 1 && this.txIns![0].hasNullInput();
  }

  // ignore: slash_for_doc_comments
  /**
   * BIP 69 sorting. Be sure to sign after sorting.
   */
  Tx sort() {
    this.txIns!.sort((first, second) {
      // return new Br(buf: first.txHashBuf)
      //         .readReverse()
      //         .compare(new Br(buf: second.txHashBuf).readReverse()) ??
      //     first.txOutNum - second.txOutNum;
      var a = new Br(buf: first.txHashBuf!.asUint8List()).readReverse();
      var b = new Br(buf: second.txHashBuf!.asUint8List()).readReverse();

      var result = a.compareTo(b);
      // 如果是0, 则返回first.txOutNum - second.txOutNum;
      // 否则返回相对应的排序
      if (result == 0) return first.txOutNum! - second.txOutNum!;
      return result;
    });

    this.txOuts!.sort((first, second) {
      var result = first.valueBn!.sub(second.valueBn!).toNumber();
      if (result != 0) return result;

      var a = first.script!.toBuffer();
      var b = second.script!.toBuffer();
      return a.compareTo(b);
    });

    return this;
  }

  @override
  String toString() {
    return this.toHex();
  }
}
