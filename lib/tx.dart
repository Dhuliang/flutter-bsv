import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:bsv/hash.dart';
import 'package:bsv/hash_cache.dart';
import 'package:bsv/sig.dart';
import 'package:bsv/tx_in.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/var_int.dart';

class Tx {
  static const int MAX_MONEY = 2100000000000000;

  // This is defined on Interp, but Tx cannot depend on Interp - must redefine here
  static const int SCRIPT_ENABLE_SIGHASH_FORKID = 1 << 16;

  int versionBytesNum;
  VarInt txInsVi;
  List<TxIn> txIns;
  VarInt txOutsVi;
  List<TxOut> txOuts;
  int nLockTime;

  Tx({
    int versionBytesNum,
    VarInt txInsVi,
    List<TxIn> txIns,
    VarInt txOutsVi,
    List<TxOut> txOuts,
    int nLockTime,
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

  Map<String, Object> toJSON() {
    var txIns = [];
    this.txIns.forEach((txIn) {
      txIns.add(txIn.toJSON());
    });
    var txOuts = [];
    this.txOuts.forEach((txOut) {
      txOuts.add(txOut.toJSON());
    });
    return {
      "versionBytesNum": this.versionBytesNum,
      "txInsVi": this.txInsVi.toJSON(),
      "txIns": txIns,
      "txOutsVi": this.txOutsVi.toJSON(),
      "txOuts": txOuts,
      "nLockTime": this.nLockTime
    };
  }

  Tx fromBr(Br br) {
    this.versionBytesNum = br.readUInt32LE();
    this.txInsVi = new VarInt(buf: br.readVarIntBuf());
    var txInsNum = this.txInsVi.toNumber();
    this.txIns = [];
    for (var i = 0; i < txInsNum; i++) {
      this.txIns.add(new TxIn().fromBr(br));
    }
    this.txOutsVi = new VarInt(buf: br.readVarIntBuf());
    var txOutsNum = this.txOutsVi.toNumber();
    this.txOuts = [];
    for (var i = 0; i < txOutsNum; i++) {
      this.txOuts.add(new TxOut().fromBr(br));
    }
    this.nLockTime = br.readUInt32LE();
    return this;
  }

  Bw toBw(Bw bw) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.writeUInt32LE(this.versionBytesNum);
    bw.write(this.txInsVi.buf);
    for (var i = 0; i < this.txIns.length; i++) {
      this.txIns[i].toBw(bw);
    }
    bw.write(this.txOutsVi.buf);
    for (var i = 0; i < this.txOuts.length; i++) {
      this.txOuts[i].toBw(bw);
    }
    bw.writeUInt32LE(this.nLockTime);
    return bw;
  }

  // // https://github.com/Bitcoin-UAHF/spec/blob/master/replay-protected-sighash.md
  Hash hashPrevouts() {
    var bw = new Bw();
    for (var txIn in this.txIns) {
      // var txIn = this.txIns[i];
      bw.write(txIn.txHashBuf); // outpoint (1/2)
      bw.writeUInt32LE(txIn.txOutNum); // outpoint (2/2)
    }
    return Hash.sha256Sha256(bw.toBuffer());
  }

  Hash hashSequence() {
    var bw = new Bw();
    for (var txIn in this.txIns) {
      // var txIn = this.txIns[i]
      bw.writeUInt32LE(txIn.nSequence);
    }
    return Hash.sha256Sha256(bw.toBuffer());
  }

  Hash hashOutputs() {
    var bw = new Bw();
    for (var txOut in this.txOuts) {
      // var txOut = this.txOuts[i]
      bw.write(txOut.toBuffer());
    }
    return Hash.sha256Sha256(bw.toBuffer());
  }

  // ignore: slash_for_doc_comments
  /**
   * For a normal transaction, subScript is usually the scriptPubKey. For a
   * p2sh transaction, subScript is usually the redeemScript. If you're not
   * normal because you're using OP_CODESEPARATORs, you know what to do.
   */
  // sighash ({nHashType, nIn, subScript, valueBn, flags = 0, hashCache = new HashCache()}) {
  //   var buf = this.sighashPreimage(nHashType, nIn, subScript, valueBn, flags, hashCache)
  //   if (buf.compare(Buffer.from('0000000000000000000000000000000000000000000000000000000000000001', 'hex')) == 0) {
  //     return buf
  //   }
  //   return new Br(Hash.sha256Sha256(buf)).readReverse()
  // }

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

  // TODO NEXT
  sighashPreimage({nHashType, nIn, subScript, valueBn, flags = 0, hashCache}) {
    // start with UAHF part (Bitcoin SV)
    // https://github.com/Bitcoin-UAHF/spec/blob/master/replay-protected-sighash.md
    hashCache = hashCache ?? new HashCache();
    if (nHashType & Sig.SIGHASH_FORKID &&
        flags & Tx.SCRIPT_ENABLE_SIGHASH_FORKID) {
      var hashPrevouts = List.generate(32, (index) => 0);
      var hashSequence = List.generate(32, (index) => 0);
      var hashOutputs = List.generate(32, (index) => 0);

      if (!(nHashType & Sig.SIGHASH_ANYONECANPAY)) {
        hashPrevouts = hashCache.prevoutsHashBuf
            ? hashCache.prevoutsHashBuf
            : hashCache.prevoutsHashBuf = this.hashPrevouts();
      }

      if (!(nHashType & Sig.SIGHASH_ANYONECANPAY) &&
          (nHashType & 0x1f) != Sig.SIGHASH_SINGLE &&
          (nHashType & 0x1f) != Sig.SIGHASH_NONE) {
        hashSequence = hashCache.sequenceHashBuf
            ? hashCache.sequenceHashBuf
            : hashCache.sequenceHashBuf = this.hashSequence();
      }

      if ((nHashType & 0x1f) != Sig.SIGHASH_SINGLE &&
          (nHashType & 0x1f) != Sig.SIGHASH_NONE) {
        hashOutputs = hashCache.outputsHashBuf
            ? hashCache.outputsHashBuf
            : hashCache.outputsHashBuf = this.hashOutputs();
      } else if ((nHashType & 0x1f) == Sig.SIGHASH_SINGLE &&
          nIn < this.txOuts.length) {
        hashOutputs = Hash.sha256Sha256(this.txOuts[nIn].toBuffer()).data;
      }

      var bw = new Bw();
      bw.writeUInt32LE(this.versionBytesNum);
      bw.write(hashPrevouts.asUint8List());
      bw.write(hashSequence.asUint8List());
      bw.write(this.txIns[nIn].txHashBuf.asUint8List()); // outpoint (1/2);
      bw.writeUInt32LE(this.txIns[nIn].txOutNum); // outpoint (2/2);
      bw.writeVarIntNum(subScript.toBuffer().length);
      bw.write(subScript.toBuffer());
      bw.writeUInt64LEBn(valueBn);
      bw.writeUInt32LE(this.txIns[nIn].nSequence);
      bw.write(hashOutputs);
      bw.writeUInt32LE(this.nLockTime);
      bw.writeUInt32LE(nHashType >> 0);

      return bw.toBuffer();
    }
  }

  //   // original bitcoin code follows - not related to UAHF (Bitcoin SV)
  //   var txcopy = this.cloneByBuffer()

  //   subScript = new Script().fromBuffer(subScript.toBuffer())
  //   subScript.removeCodeseparators()

  //   for (var i = 0; i < txcopy.txIns.length; i++) {
  //     txcopy.txIns[i] = TxIn.fromBuffer(txcopy.txIns[i].toBuffer()).setScript(
  //       new Script()
  //     )
  //   }

  //   txcopy.txIns[nIn] = TxIn.fromBuffer(
  //     txcopy.txIns[nIn].toBuffer()
  //   ).setScript(subScript)

  //   if ((nHashType & 31) == Sig.SIGHASH_NONE) {
  //     txcopy.txOuts.length = 0
  //     txcopy.txOutsVi = VarInt.fromNumber(0)

  //     for (var i = 0; i < txcopy.txIns.length; i++) {
  //       if (i != nIn) {
  //         txcopy.txIns[i].nSequence = 0
  //       }
  //     }
  //   } else if ((nHashType & 31) == Sig.SIGHASH_SINGLE) {
  //     // The SIGHASH_SINGLE bug.
  //     // https://bitcointalk.org/index.php?topic=260595.0
  //     if (nIn > txcopy.txOuts.length - 1) {
  //       return Buffer.from(
  //         '0000000000000000000000000000000000000000000000000000000000000001',
  //         'hex'
  //       )
  //     }

  //     txcopy.txOuts.length = nIn + 1
  //     txcopy.txOutsVi = VarInt.fromNumber(nIn + 1)

  //     for (var i = 0; i < txcopy.txOuts.length; i++) {
  //       if (i < nIn) {
  //         txcopy.txOuts[i] = TxOut.fromProperties(
  //           new Bn().fromBuffer(Buffer.from('ffffffffffffffff', 'hex')),
  //           new Script()
  //         )
  //       }
  //     }

  //     for (var i = 0; i < txcopy.txIns.length; i++) {
  //       if (i != nIn) {
  //         txcopy.txIns[i].nSequence = 0
  //       }
  //     }
  //   }
  //   // else, SIGHASH_ALL

  //   if (nHashType & Sig.SIGHASH_ANYONECANPAY) {
  //     txcopy.txIns[0] = txcopy.txIns[nIn]
  //     txcopy.txIns.length = 1
  //     txcopy.txInsVi = VarInt.fromNumber(1)
  //   }

  //   var buf = new Bw()
  //     .write(txcopy.toBuffer())
  //     .writeInt32LE(nHashType)
  //     .toBuffer()
  //   return buf
  // }

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

  // // This  returns a signature but does not update any inputs
  // sign (keyPair, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, nIn, subScript, valueBn, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID, hashCache = {}) {
  //   var hashBuf = this.sighash(nHashType, nIn, subScript, valueBn, flags, hashCache)
  //   var sig = Ecdsa.sign(hashBuf, keyPair, 'little').fromObject({
  //     nHashType: nHashType
  //   })
  //   return sig
  // }

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

  // // This  takes a signature as input and does not parse any inputs
  // verify (
  //   sig,
  //   pubKey,
  //   nIn,
  //   subScript,
  //   enforceLowS = false,
  //   valueBn,
  //   flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID,
  //   hashCache = {}
  // ) {
  //   var hashBuf = this.sighash(sig.nHashType, nIn, subScript, valueBn, flags, hashCache)
  //   return Ecdsa.verify(hashBuf, sig, pubKey, 'little', enforceLowS)
  // }

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

  // hash () {
  //   return Hash.sha256Sha256(this.toBuffer())
  // }

  // async asyncHash () {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'hash', [])
  //   return workersResult.resbuf
  // }

  // id () {
  //   return new Br(this.hash()).readReverse().toString('hex')
  // }

  // async asyncId () {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'id', [])
  //   return JSON.parse(workersResult.resbuf.toString())
  // }

  // addTxIn (txHashBuf, txOutNum, script, nSequence) {
  //   var txIn
  //   if (txHashBuf instanceof TxIn) {
  //     txIn = txHashBuf
  //   } else {
  //     txIn = new TxIn()
  //       .fromObject({ txHashBuf, txOutNum, nSequence })
  //       .setScript(script)
  //   }
  //   this.txIns.push(txIn)
  //   this.txInsVi = VarInt.fromNumber(this.txInsVi.toNumber() + 1)
  //   return this
  // }

  // addTxOut (valueBn, script) {
  //   var txOut
  //   if (valueBn instanceof TxOut) {
  //     txOut = valueBn
  //   } else {
  //     txOut = new TxOut().fromObject({ valueBn }).setScript(script)
  //   }
  //   this.txOuts.push(txOut)
  //   this.txOutsVi = VarInt.fromNumber(this.txOutsVi.toNumber() + 1)
  //   return this
  // }

  // /**
  //  * Analagous to bitcoind's IsCoinBase  in transaction.h
  //  */
  // isCoinbase () {
  //   return this.txIns.length == 1 && this.txIns[0].hasNullInput()
  // }

  // /**
  //  * BIP 69 sorting. Be sure to sign after sorting.
  //  */
  // sort () {
  //   this.txIns.sort((first, second) => {
  //     return new Br(first.txHashBuf).readReverse().compare(new Br(second.txHashBuf).readReverse()) ||
  //       first.txOutNum - second.txOutNum
  //   })

  //   this.txOuts.sort((first, second) => {
  //     return first.valueBn.sub(second.valueBn).toNumber() ||
  //       first.script.toBuffer().compare(second.script.toBuffer())
  //   })

  //   return this
  // }
}
