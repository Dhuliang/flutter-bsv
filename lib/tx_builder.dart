// ignore: slash_for_doc_comments
import 'package:bsv/address.dart';
import 'package:bsv/constants.dart';
import 'package:bsv/bn.dart';
import 'package:bsv/hash_cache.dart';
import 'package:bsv/key_pair.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/script.dart';
import 'package:bsv/sig.dart';
import 'package:bsv/sig_operation.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_in.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/tx_out_map.dart';
import 'package:bsv/var_int.dart';
import 'package:bsv/extentsions/list.dart';

// ignore: slash_for_doc_comments
/**
 * Transaction Builder
 * ===================
 */
class TxBuilder {
  Tx tx = new Tx();
  List<TxIn> txIns = [];
  List<TxOut> txOuts = [];
  TxOutMap uTxOutMap = new TxOutMap();
  SigOperations sigOperations = new SigOperations();
  Script changeScript;
  BigIntX changeAmountBn;
  BigIntX feeAmountBn;
  num feePerKbNum = Constants.Mainnet.txBuilderFeePerKbNum;
  int nLockTime = 0;
  int versionBytesNum = 1;
  int sigsPerInput = 1;
  int dust = Constants.Mainnet.txBuilderDust;
  bool dustChangeToFees = false;
  HashCache hashCache = new HashCache();

  TxBuilder({
    this.tx,
    this.txIns,
    this.txOuts,
    this.uTxOutMap,
    this.sigOperations,
    this.feePerKbNum,
    this.nLockTime,
    this.versionBytesNum,
    this.sigsPerInput,
    this.dust,
    this.dustChangeToFees,
    this.hashCache,
  });

  Map toJSON() {
    var json = {};
    json['tx'] = this.tx.toHex();
    json['txIns'] = this.txIns.map((txIn) => txIn.toHex());
    json['txOuts'] = this.txOuts.map((txOut) => txOut.toHex());
    json['uTxOutMap'] = this.uTxOutMap.toJSON();
    json['sigOperations'] = this.sigOperations.toJSON();
    json['changeScript'] =
        this.changeScript != null ? this.changeScript.toHex() : null;
    json['changeAmountBn'] =
        this.changeAmountBn != null ? this.changeAmountBn.toNumber() : null;
    json['feeAmountBn'] =
        this.feeAmountBn != null ? this.feeAmountBn.toNumber() : null;
    json['feePerKbNum'] = this.feePerKbNum;
    json['sigsPerInput'] = this.sigsPerInput;
    json['dust'] = this.dust;
    json['dustChangeToFees'] = this.dustChangeToFees;
    json['hashCache'] = this.hashCache.toJSON();
    return json;
  }

  fromJSON(json) {
    this.tx = new Tx().fromHex(json['tx']);
    this.txIns = json['txIns'].map((txIn) => TxIn.fromHex(txIn));
    this.txOuts = json['txOuts'].map((txOut) => TxOut.fromHex(txOut));
    this.uTxOutMap = new TxOutMap().fromJSON(json['uTxOutMap']);
    this.sigOperations = new SigOperations().fromJSON(json['sigOperations']);
    this.changeScript = json['changeScript']
        ? new Script().fromHex(json['changeScript'])
        : null;
    this.changeAmountBn = json['changeAmountBn']
        ? new BigIntX.fromString(json['changeAmountBn'])
        : null;
    this.feeAmountBn = json['feeAmountBn']
        ? new BigIntX.fromString(json['feeAmountBn'])
        : null;
    this.feePerKbNum = json['feePerKbNum'] ?? this.feePerKbNum;
    this.sigsPerInput = json['sigsPerInput'] ?? this.sigsPerInput;
    this.dust = json['dust'] ?? this.dust;
    this.dustChangeToFees = json['dustChangeToFees'] ?? this.dustChangeToFees;
    this.hashCache = HashCache().fromJSON(json['hashCache']);
    return this;
  }

  TxBuilder setFeePerKbNum(num feePerKbNum) {
    if ((feePerKbNum is num) || feePerKbNum < 0) {
      throw ('cannot set a fee of zero or less');
    }
    this.feePerKbNum = feePerKbNum;
    return this;
  }

  TxBuilder setChangeAddress(Address changeAddress) {
    this.changeScript = changeAddress.toTxOutScript();
    return this;
  }

  TxBuilder setChangeScript(Script changeScript) {
    this.changeScript = changeScript;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
   * nLockTime is an unsigned integer.
   */
  TxBuilder setNLocktime(int nLockTime) {
    this.nLockTime = nLockTime;
    return this;
  }

  TxBuilder setVersion(int versionBytesNum) {
    this.versionBytesNum = versionBytesNum;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Sometimes one of your outputs or the change output will be less than
     * dust. Values less than dust cannot be broadcast. If you are OK with
     * sending dust amounts to fees, then set this value to true.
     */
  TxBuilder setDust([int dust]) {
    this.dust = dust ?? Constants.Mainnet.txBuilderDust;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Sometimes one of your outputs or the change output will be less than
     * dust. Values less than dust cannot be broadcast. If you are OK with
     * sending dust amounts to fees, then set this value to true. We
     * preferentially send all dust to the change if possible. However, that
     * might not be possible if the change itself is less than dust, in which
     * case all dust goes to fees.
     */
  TxBuilder sendDustChangeToFees([bool dustChangeToFees = false]) {
    this.dustChangeToFees = dustChangeToFees;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Import a transaction partially signed by someone else. The only thing you
     * can do after this is sign one or more inputs. Usually used for multisig
     * transactions. uTxOutMap is optional. It is not necessary so long as you
     * pass in the txOut when you sign. You need to know the output when signing
     * an input, including the script in the output, which is why this is
     * necessary when signing an input.
     */
  TxBuilder importPartiallySignedTx(
    Tx tx, [
    TxOutMap uTxOutMap,
    SigOperations sigOperations,
  ]) {
    this.tx = tx;
    this.uTxOutMap = uTxOutMap ?? this.uTxOutMap;
    this.sigOperations = sigOperations ?? this.sigOperations;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Pay "from" a script - in other words, add an input to the transaction.
     */
  inputFromScript({
    List<int> txHashBuf,
    int txOutNum,
    Script script,
    int nSequence,
    TxOut txOut,
  }) {
    if (!(txHashBuf is List<int>) ||
        !(txOutNum is int) ||
        !(txOut is TxOut) ||
        !(script is Script)) {
      throw ('invalid one of: txHashBuf, txOutNum, txOut, script');
    }
    this.txIns.add(TxIn.fromProperties(
        txHashBuf: txHashBuf,
        txOutNum: txOutNum,
        script: script,
        nSequence: nSequence));
    this.uTxOutMap.set(txHashBuf, txOutNum, txOut);
    return this;
  }

  TxBuilder addSigOperation({
    List<int> txHashBuf,
    int txOutNum,
    int nScriptChunk,
    String type,
    String addressStr,
    int nHashType,
  }) {
    this.sigOperations.addOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: type,
          addressStr: addressStr,
          nHashType: nHashType,
        );
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Pay "from" a pubKeyHash output - in other words, add an input to the
     * transaction.
     */
  TxBuilder inputFromPubKeyHash({
    List<int> txHashBuf,
    int txOutNum,
    TxOut txOut,
    PubKey pubKey,
    int nSequence,
    int nHashType,
  }) {
    if (!(txHashBuf is List<int>) || !(txOutNum is int) || !(txOut is TxOut)) {
      throw ('invalid one of: txHashBuf, txOutNum, txOut');
    }

    var txIn = new TxIn(nSequence: nSequence).fromPubKeyHashTxOut(
      txHashBuf: txHashBuf,
      txOutNum: txOutNum,
      txOut: txOut,
      pubKey: pubKey,
    );
    this.txIns.add(txIn);
    this.uTxOutMap.set(txHashBuf, txOutNum, txOut);
    var addressStr = Address.fromTxOutScript(txOut.script).toString();
    this.addSigOperation(
      txHashBuf: txHashBuf,
      txOutNum: txOutNum,
      nScriptChunk: 0,
      type: SigOperations.SigType,
      addressStr: addressStr,
      nHashType: nHashType,
    );

    this.addSigOperation(
      txHashBuf: txHashBuf,
      txOutNum: txOutNum,
      nScriptChunk: 1,
      type: SigOperations.PubKeyType,
      addressStr: addressStr,
      nHashType: nHashType,
    );

    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * An address to send funds to, along with the amount. The amount should be
     * denominated in satoshis, not bitcoins.
     */
  TxBuilder outputToAddress({BigIntX valueBn, Address addr}) {
    if (!(addr is Address) || !(valueBn is BigIntX)) {
      throw ('addr must be an Address, and valueBn must be a Bn');
    }
    var script = new Script().fromPubKeyHash(addr.hashBuf);
    this.outputToScript(valueBn: valueBn, script: script);
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * A script to send funds to, along with the amount. The amount should be
     * denominated in satoshis, not bitcoins.
     */
  TxBuilder outputToScript({BigIntX valueBn, Script script}) {
    if (!(script is Script) || !(valueBn is BigIntX)) {
      throw ('script must be a Script, and valueBn must be a Bn');
    }
    var txOut = TxOut.fromProperties(valueBn: valueBn, script: script);
    this.txOuts.add(txOut);
    return this;
  }

  BigIntX buildOutputs() {
    var outAmountBn = BigIntX.zero;
    this.txOuts.forEach((txOut) {
      if (txOut.valueBn.lt(this.dust) &&
          !txOut.script.isOpReturn() &&
          !txOut.script.isSafeDataOut()) {
        throw ('cannot create output lesser than dust');
      }
      outAmountBn = outAmountBn.add(txOut.valueBn);
      this.tx.addTxOut(data: txOut);
    });
    return outAmountBn;
  }

  BigIntX buildInputs({BigIntX outAmountBn, int extraInputsNum = 0}) {
    var inAmountBn = BigIntX.zero;

    for (var txIn in this.txIns) {
      var txOut = this.uTxOutMap.get(txIn.txHashBuf, txIn.txOutNum);
      inAmountBn = inAmountBn.add(txOut.valueBn);
      this.tx.addTxIn(data: txIn);
      if (inAmountBn.geq(outAmountBn)) {
        if (extraInputsNum <= 0) {
          break;
        }
        extraInputsNum--;
      }
    }
    if (inAmountBn.lt(outAmountBn)) {
      throw ('not enough funds for outputs: inAmountBn ${inAmountBn.toNumber()} outAmountBn ${outAmountBn.toNumber()}');
    }
    return inAmountBn;
  }

  // Thanks to SigOperations, if those are accurately used, then we can
  // accurately estimate what the size of the transaction is going to be once
  // all the signatures and public keys are inserted.
  int estimateSize() {
    // largest possible sig size. final 1 is for pushdata at start. second to
    // final is sighash byte. the rest are DER encoding.
    var sigSize = 1 + 1 + 1 + 1 + 32 + 1 + 1 + 32 + 1 + 1;
    // length of script, y odd, x value - assumes compressed public key
    var pubKeySize = 1 + 1 + 33;

    var size = this.tx.toBuffer().length;

    this.tx.txIns.forEach((txIn) {
      var txHashBuf = txIn.txHashBuf;
      var txOutNum = txIn.txOutNum;
      var sigOperations = this.sigOperations.get(txHashBuf, txOutNum);
      sigOperations.forEach((obj) {
        var nScriptChunk = obj['nScriptChunk'];
        var type = obj['type'];
        var script = new Script(chunks: [txIn.script.chunks[nScriptChunk]]);
        var scriptSize = script.toBuffer().length;
        size -= scriptSize;
        if (type == SigOperations.SigType) {
          size += sigSize;
        } else if (obj.type == SigOperations.PubKeyType) {
          size += pubKeySize;
        } else {
          throw ('unsupported sig operations type');
        }
      });
    });

    // size = size + sigSize * this.tx.txIns.length
    size = size + 1; // assume txInsVi increases by 1 byte
    return size.round();
  }

  BigIntX estimateFee([BigIntX extraFeeAmount]) {
    // old style rounding up per kb - pays too high fees:
    // var fee = Math.ceil(this.estimateSize() / 1000) * this.feePerKbNum

    // new style pays lower fees - rounds up to satoshi, not per kb:
    var fee = (this.estimateSize() / 1000 * this.feePerKbNum).ceil();

    return new BigIntX.fromNum(fee).add(extraFeeAmount ?? BigIntX.zero);
  }

  // ignore: slash_for_doc_comments
  /**
     * Builds the transaction and adds the appropriate fee by subtracting from
     * the change output. Note that by default the TxBuilder will use as many
     * inputs as necessary to pay the output amounts and the required fee. The
     * TxBuilder will not necessarily us all the inputs. To force the TxBuilder
     * to use all the inputs (such as if you wish to spend the entire balance
     * of a wallet), set the argument useAllInputs = true.
     */
  TxBuilder build({
    bool useAllInputs = false,
  }) {
    // build () {
    var minFeeAmountBn;
    if (this.txIns.length <= 0) {
      throw ('tx-builder number of inputs must be greater than 0');
    }
    if (this.changeScript == null) {
      throw ('must specify change script to use build method');
    }
    for (var extraInputsNum = useAllInputs ? this.txIns.length - 1 : 0;
        extraInputsNum < this.txIns.length;
        extraInputsNum++) {
      this.tx = new Tx();
      var outAmountBn = this.buildOutputs();
      var changeTxOut = TxOut.fromProperties(
          valueBn: BigIntX.zero, script: this.changeScript);
      this.tx.addTxOut(data: changeTxOut);

      var inAmountBn;
      try {
        inAmountBn = this.buildInputs(
            outAmountBn: outAmountBn, extraInputsNum: extraInputsNum);
      } catch (err) {
        if (err.message.includes('not enough funds for outputs')) {
          throw ('unable to gather enough inputs for outputs and fee');
        } else {
          throw err;
        }
      }

      // Set change amount from inAmountBn - outAmountBn
      this.changeAmountBn = inAmountBn.sub(outAmountBn);
      changeTxOut.valueBn = this.changeAmountBn;

      minFeeAmountBn = this.estimateFee();
      if (this.changeAmountBn.geq(minFeeAmountBn) &&
          this.changeAmountBn.sub(minFeeAmountBn).gt(this.dust)) {
        break;
      }
    }
    if (this.changeAmountBn.geq(minFeeAmountBn)) {
      // Subtract fee from change
      this.feeAmountBn = minFeeAmountBn;
      this.changeAmountBn = this.changeAmountBn.sub(this.feeAmountBn);
      this.tx.txOuts[this.tx.txOuts.length - 1].valueBn = this.changeAmountBn;

      if (this.changeAmountBn.lt(this.dust)) {
        if (this.dustChangeToFees) {
          // Remove the change amount since it is less than dust and the
          // builder has requested dust be sent to fees.
          this.tx.txOuts.removeLast();
          this.tx.txOutsVi = VarInt.fromNumber(this.tx.txOutsVi.toNumber() - 1);
          this.feeAmountBn = this.feeAmountBn.add(this.changeAmountBn);
          this.changeAmountBn = BigIntX.zero;
        } else {
          throw ('unable to create change amount greater than dust');
        }
      }

      this.tx.nLockTime = this.nLockTime;
      this.tx.versionBytesNum = this.versionBytesNum;
      if (this.tx.txOuts.length == 0) {
        throw ('outputs length is zero - unable to create any outputs greater than dust');
      }
      return this;
    } else {
      throw ('unable to gather enough inputs for outputs and fee');
    }
  }

  // BIP 69 sorting. call after build() but before sign()
  TxBuilder sort() {
    this.tx.sort();
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Check if all signatures are present in a multisig input script.
     */
  static bool allSigsPresent(int m, Script script) {
    // The first element is a Famous MultiSig Bug OP_0, and last element is the
    // redeemScript. The rest are signatures.
    var present = 0;
    for (var i = 1; i < script.chunks.length - 1; i++) {
      if (script.chunks[i].buf != null) {
        present++;
      }
    }
    return present == m;
  }

  // ignore: slash_for_doc_comments
  /**
     * Remove blank signatures in a multisig input script.
     */
  static dynamic removeBlankSigs(Script script) {
    // The first element is a Famous MultiSig Bug OP_0, and last element is the
    // redeemScript. The rest are signatures.
    script = new Script(chunks: script.chunks.slice()); // copy the script
    for (var i = 1; i < script.chunks.length - 1; i++) {
      if (script.chunks[i].buf == null) {
        script.chunks.splice(i, 1); // remove ith element
      }
    }
    return script;
  }

  TxBuilder fillSig({int nIn, int nScriptChunk, Sig sig}) {
    var txIn = this.tx.txIns[nIn];
    txIn.script.chunks[nScriptChunk] =
        new Script().writeBuffer(sig.toTxFormat()).chunks[0];
    txIn.scriptVi = VarInt.fromNumber(txIn.script.toBuffer().length);
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Sign an input, but do not fill the signature into the transaction. Return
     * the signature.
     *
     * For a normal transaction, subScript is usually the scriptPubKey. If
     * you're not normal because you're using OP_CODESEPARATORs, you know what
     * to do.
     */
  Sig getSig({
    KeyPair keyPair,
    int nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID,
    int nIn,
    Script subScript,
    int flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID,
  }) {
    BigIntX valueBn;
    if ((nHashType & Sig.SIGHASH_FORKID != 0) &&
        (flags & Tx.SCRIPT_ENABLE_SIGHASH_FORKID != 0)) {
      var txHashBuf = this.tx.txIns[nIn].txHashBuf;
      var txOutNum = this.tx.txIns[nIn].txOutNum;
      var txOut = this.uTxOutMap.get(txHashBuf, txOutNum);
      if (!txOut) {
        throw ('for SIGHASH_FORKID must provide UTXOs');
      }
      valueBn = txOut.valueBn;
    }
    var sig = this.tx.sign(
          keyPair: keyPair,
          nHashType: nHashType,
          nIn: nIn,
          subScript: subScript,
          valueBn: valueBn,
          flags: flags,
          hashCache: this.hashCache,
        );
    return sig;
  }

  // /**
  //    * Asynchronously sign an input in a worker, but do not fill the signature
  //    * into the transaction. Return the signature.
  //    */
  // asyncGetSig (keyPair, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, nIn, subScript, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID) {
  //   var valueBn
  //   if (
  //     nHashType & Sig.SIGHASH_FORKID &&
  //       flags & Tx.SCRIPT_ENABLE_SIGHASH_FORKID
  //   ) {
  //     var txHashBuf = this.tx.txIns[nIn].txHashBuf
  //     var txOutNum = this.tx.txIns[nIn].txOutNum
  //     var txOut = this.uTxOutMap.get(txHashBuf, txOutNum)
  //     if (!txOut) {
  //       throw  ('for SIGHASH_FORKID must provide UTXOs');
  //     }
  //     valueBn = txOut.valueBn
  //   }
  //   return this.tx.asyncSign(
  //     keyPair,
  //     nHashType,
  //     nIn,
  //     subScript,
  //     valueBn,
  //     flags,
  //     this.hashCache
  //   )
  // }

  // ignore: slash_for_doc_comments
  /**
     * Sign ith input with keyPair and insert the signature into the transaction.
     * This method only works for some standard transaction types. For
     * non-standard transaction types, use getSig.
     */
  TxBuilder signTxIn({
    int nIn,
    KeyPair keyPair,
    TxOut txOut,
    int nScriptChunk,
    int nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID,
    int flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID,
  }) {
    var txIn = this.tx.txIns[nIn];
    var script = txIn.script;
    if (nScriptChunk == null && script.isPubKeyHashIn()) {
      nScriptChunk = 0;
    }
    if (nScriptChunk == null) {
      throw ('cannot sign unknown script type for input $nIn');
    }
    var txHashBuf = txIn.txHashBuf;
    var txOutNum = txIn.txOutNum;
    if (txOut == null) {
      txOut = this.uTxOutMap.get(txHashBuf, txOutNum);
    }
    var outScript = txOut.script;
    var subScript = outScript; // true for standard script types
    var sig = this.getSig(
      keyPair: keyPair,
      nHashType: nHashType,
      nIn: nIn,
      subScript: subScript,
      flags: flags,
    );

    this.fillSig(nIn: nIn, nScriptChunk: nScriptChunk, sig: sig);
    return this;
  }

  // /**
  //    * Asynchronously sign ith input with keyPair in a worker and insert the
  //    * signature into the transaction.  This method only works for some standard
  //    * transaction types. For non-standard transaction types, use asyncGetSig.
  //    */
  // async asyncSignTxIn (nIn, keyPair, txOut, nScriptChunk, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID) {
  //   var txIn = this.tx.txIns[nIn]
  //   var script = txIn.script
  //   if (nScriptChunk == null && script.isPubKeyHashIn()) {
  //     nScriptChunk = 0
  //   }
  //   if (nScriptChunk == null) {
  //     throw  ('cannot sign unknown script type for input ' + nIn);
  //   }
  //   var txHashBuf = txIn.txHashBuf
  //   var txOutNum = txIn.txOutNum
  //   if (!txOut) {
  //     txOut = this.uTxOutMap.get(txHashBuf, txOutNum)
  //   }
  //   var outScript = txOut.script
  //   var subScript = outScript // true for standard script types
  //   var sig = await this.asyncGetSig(keyPair, nHashType, nIn, subScript, flags, this.hashCache)
  //   this.fillSig(nIn, nScriptChunk, sig)
  //   return this
  // }

  TxBuilder signWithKeyPairs(List<KeyPair> keyPairs) {
    // produce map of addresses to private keys
    var addressStrMap = {};
    for (var keyPair in keyPairs) {
      var addressStr = Address.fromPubKey(keyPair.pubKey).toString();
      addressStrMap[addressStr] = keyPair;
    }

    // loop through all inputs

    for (var nIn = 0; nIn < this.tx.txIns.length; nIn++) {
      var txIn = this.tx.txIns[nIn];
      // for each input, use sigOperations to get list of signatures and pubkeys
      // to be produced and inserted
      var arr = this.sigOperations.get(txIn.txHashBuf, txIn.txOutNum);
      for (var obj in arr) {
        // for each pubkey, get the privkey from the privkey map and sign the input
        var nScriptChunk = obj['nScriptChunk'];
        var type = obj['type'];
        var addressStr = obj['addressStr'];
        var nHashType = obj['nHashType'];
        var keyPair = addressStrMap[addressStr];
        if (!keyPair) {
          obj.log = 'cannot find keyPair for addressStr $addressStr';
          continue;
        }
        var txOut = this.uTxOutMap.get(txIn.txHashBuf, txIn.txOutNum);
        if (type == SigOperations.SigType) {
          this.signTxIn(
            nIn: nIn,
            keyPair: keyPair,
            txOut: txOut,
            nScriptChunk: nScriptChunk,
            nHashType: nHashType,
          );
          obj.log = 'successfully inserted signature';
        } else if (type == 'pubKey') {
          txIn.script.chunks[nScriptChunk] =
              new Script().writeBuffer(keyPair.pubKey.toBuffer()).chunks[0];
          txIn.setScript(txIn.script);
          obj.log = 'successfully inserted public key';
        } else {
          obj.log = 'cannot perform operation of type $type';
          continue;
        }
      }
    }

    // // loop through all inputs
    // for (var nIn in this.tx.txIns) {
    //   // var txIn = this.tx.txIns[nIn];
    //   var txIn = this.tx.txIns[1];
    //   // for each input, use sigOperations to get list of signatures and pubkeys
    //   // to be produced and inserted
    //   var arr = this.sigOperations.get(txIn.txHashBuf, txIn.txOutNum);
    //   for (var obj in arr) {
    //     // for each pubkey, get the privkey from the privkey map and sign the input
    //     // var { nScriptChunk, type, addressStr, nHashType } = obj
    //     // var { nScriptChunk, type, addressStr, nHashType } = obj;
    //     var nScriptChunk = obj['nScriptChunk'];
    //     var type = obj['type'];
    //     var addressStr = obj['addressStr'];
    //     var nHashType = obj['nHashType'];
    //     var keyPair = addressStrMap[addressStr];
    //     if (!keyPair) {
    //       obj.log = 'cannot find keyPair for addressStr $addressStr';
    //       continue;
    //     }
    //     var txOut = this.uTxOutMap.get(txIn.txHashBuf, txIn.txOutNum);
    //     if (type == 'sig') {
    //       this.signTxIn(
    //         nIn: 1,
    //         keyPair: keyPair,
    //         txOut: txOut,
    //         nScriptChunk: nScriptChunk,
    //         nHashType: nHashType,
    //       );
    //       obj.log = 'successfully inserted signature';
    //     } else if (type == 'pubKey') {
    //       txIn.script.chunks[nScriptChunk] =
    //           new Script().writeBuffer(keyPair.pubKey.toBuffer()).chunks[0];
    //       txIn.setScript(txIn.script);
    //       obj.log = 'successfully inserted public key';
    //     } else {
    //       obj.log = 'cannot perform operation of type $type';
    //       continue;
    //     }
    //   }
    // }
    return this;
  }
}
