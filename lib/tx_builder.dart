// ignore: slash_for_doc_comments
import 'package:bsv/address.dart';
import 'package:bsv/constants.dart';
import 'package:bsv/bn.dart';
import 'package:bsv/hash_cache.dart';
import 'package:bsv/script.dart';
import 'package:bsv/sig_operation.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_in.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/tx_out_map.dart';

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
  // inputFromScript (
  //   List<int> txHashBuf,
  //   int txOutNum,
  //   Script script,
  //   int nSequence,

  //   txHashBuf, txOutNum, txOut, script, nSequence) {
  //   if (
  //     !Buffer.isBuffer(txHashBuf) ||
  //       !(typeof txOutNum === 'number') ||
  //       !(txOut instanceof TxOut) ||
  //       !(script instanceof Script)
  //   ) {
  //     throw ('invalid one of: txHashBuf, txOutNum, txOut, script');
  //   }
  //   this.txIns.add(
  //     TxIn.fromProperties(txHashBuf : txHashBuf, txOutNum, script, nSequence)
  //   );
  //   this.uTxOutMap.set(txHashBuf, txOutNum, txOut)
  //   return this
  // }

  // addSigOperation (txHashBuf, txOutNum, nScriptChunk, type, addressStr, nHashType) {
  //   this.sigOperations.addOne(txHashBuf, txOutNum, nScriptChunk, type, addressStr, nHashType)
  //   return this
  // }

  // /**
  //    * Pay "from" a pubKeyHash output - in other words, add an input to the
  //    * transaction.
  //    */
  // inputFromPubKeyHash (txHashBuf, txOutNum, txOut, pubKey, nSequence, nHashType) {
  //   if (
  //     !Buffer.isBuffer(txHashBuf) ||
  //       typeof txOutNum !== 'number' ||
  //       !(txOut instanceof TxOut)
  //   ) {
  //     throw new Error('invalid one of: txHashBuf, txOutNum, txOut')
  //   }
  //   this.txIns.push(
  //     new TxIn()
  //       .fromObject({ nSequence })
  //       .fromPubKeyHashTxOut(txHashBuf, txOutNum, txOut, pubKey)
  //   )
  //   this.uTxOutMap.set(txHashBuf, txOutNum, txOut)
  //   var addressStr = Address.fromTxOutScript(txOut.script).toString()
  //   this.addSigOperation(txHashBuf, txOutNum, 0, 'sig', addressStr, nHashType)
  //   this.addSigOperation(txHashBuf, txOutNum, 1, 'pubKey', addressStr)
  //   return this
  // }

  // /**
  //    * An address to send funds to, along with the amount. The amount should be
  //    * denominated in satoshis, not bitcoins.
  //    */
  // outputToAddress (valueBn, addr) {
  //   if (!(addr instanceof Address) || !(valueBn instanceof Bn)) {
  //     throw new Error('addr must be an Address, and valueBn must be a Bn')
  //   }
  //   var script = new Script().fromPubKeyHash(addr.hashBuf)
  //   this.outputToScript(valueBn, script)
  //   return this
  // }

  // /**
  //    * A script to send funds to, along with the amount. The amount should be
  //    * denominated in satoshis, not bitcoins.
  //    */
  // outputToScript (valueBn, script) {
  //   if (!(script instanceof Script) || !(valueBn instanceof Bn)) {
  //     throw new Error('script must be a Script, and valueBn must be a Bn')
  //   }
  //   var txOut = TxOut.fromProperties(valueBn, script)
  //   this.txOuts.push(txOut)
  //   return this
  // }

  // buildOutputs () {
  //   let outAmountBn = new Bn(0)
  //   this.txOuts.forEach(txOut => {
  //     if (txOut.valueBn.lt(this.dust) && !txOut.script.isOpReturn() && !txOut.script.isSafeDataOut()) {
  //       throw new Error('cannot create output lesser than dust')
  //     }
  //     outAmountBn = outAmountBn.add(txOut.valueBn)
  //     this.tx.addTxOut(txOut)
  //   })
  //   return outAmountBn
  // }

  // buildInputs (outAmountBn, extraInputsNum = 0) {
  //   let inAmountBn = new Bn(0)
  //   for (var txIn of this.txIns) {
  //     var txOut = this.uTxOutMap.get(txIn.txHashBuf, txIn.txOutNum)
  //     inAmountBn = inAmountBn.add(txOut.valueBn)
  //     this.tx.addTxIn(txIn)
  //     if (inAmountBn.geq(outAmountBn)) {
  //       if (extraInputsNum <= 0) {
  //         break
  //       }
  //       extraInputsNum--
  //     }
  //   }
  //   if (inAmountBn.lt(outAmountBn)) {
  //     throw new Error(
  //       'not enough funds for outputs: inAmountBn ' +
  //           inAmountBn.toNumber() +
  //           ' outAmountBn ' +
  //           outAmountBn.toNumber()
  //     )
  //   }
  //   return inAmountBn
  // }

  // // Thanks to SigOperations, if those are accurately used, then we can
  // // accurately estimate what the size of the transaction is going to be once
  // // all the signatures and public keys are inserted.
  // estimateSize () {
  //   // largest possible sig size. final 1 is for pushdata at start. second to
  //   // final is sighash byte. the rest are DER encoding.
  //   var sigSize = 1 + 1 + 1 + 1 + 32 + 1 + 1 + 32 + 1 + 1
  //   // length of script, y odd, x value - assumes compressed public key
  //   var pubKeySize = 1 + 1 + 33

  //   let size = this.tx.toBuffer().length

  //   this.tx.txIns.forEach((txIn) => {
  //     var { txHashBuf, txOutNum } = txIn
  //     var sigOperations = this.sigOperations.get(txHashBuf, txOutNum)
  //     sigOperations.forEach((obj) => {
  //       var { nScriptChunk, type } = obj
  //       var script = new Script([txIn.script.chunks[nScriptChunk]])
  //       var scriptSize = script.toBuffer().length
  //       size -= scriptSize
  //       if (type === 'sig') {
  //         size += sigSize
  //       } else if (obj.type === 'pubKey') {
  //         size += pubKeySize
  //       } else {
  //         throw new Error('unsupported sig operations type')
  //       }
  //     })
  //   })

  //   // size = size + sigSize * this.tx.txIns.length
  //   size = size + 1 // assume txInsVi increases by 1 byte
  //   return Math.round(size)
  // }

  // estimateFee (extraFeeAmount = new Bn(0)) {
  //   // old style rounding up per kb - pays too high fees:
  //   // var fee = Math.ceil(this.estimateSize() / 1000) * this.feePerKbNum

  //   // new style pays lower fees - rounds up to satoshi, not per kb:
  //   var fee = Math.ceil(this.estimateSize() / 1000 * this.feePerKbNum)

  //   return new Bn(fee).add(extraFeeAmount)
  // }

  // /**
  //    * Builds the transaction and adds the appropriate fee by subtracting from
  //    * the change output. Note that by default the TxBuilder will use as many
  //    * inputs as necessary to pay the output amounts and the required fee. The
  //    * TxBuilder will not necessarily us all the inputs. To force the TxBuilder
  //    * to use all the inputs (such as if you wish to spend the entire balance
  //    * of a wallet), set the argument useAllInputs = true.
  //    */
  // build (opts = { useAllInputs: false }) {
  //   let minFeeAmountBn
  //   if (this.txIns.length <= 0) {
  //     throw Error('tx-builder number of inputs must be greater than 0')
  //   }
  //   if (!this.changeScript) {
  //     throw new Error('must specify change script to use build method')
  //   }
  //   for (
  //     let extraInputsNum = opts.useAllInputs ? this.txIns.length - 1 : 0;
  //     extraInputsNum < this.txIns.length;
  //     extraInputsNum++
  //   ) {
  //     this.tx = new Tx()
  //     var outAmountBn = this.buildOutputs()
  //     var changeTxOut = TxOut.fromProperties(new Bn(0), this.changeScript)
  //     this.tx.addTxOut(changeTxOut)

  //     let inAmountBn
  //     try {
  //       inAmountBn = this.buildInputs(outAmountBn, extraInputsNum)
  //     } catch (err) {
  //       if (err.message.includes('not enough funds for outputs')) {
  //         throw new Error('unable to gather enough inputs for outputs and fee')
  //       } else {
  //         throw err
  //       }
  //     }

  //     // Set change amount from inAmountBn - outAmountBn
  //     this.changeAmountBn = inAmountBn.sub(outAmountBn)
  //     changeTxOut.valueBn = this.changeAmountBn

  //     minFeeAmountBn = this.estimateFee()
  //     if (
  //       this.changeAmountBn.geq(minFeeAmountBn) &&
  //         this.changeAmountBn.sub(minFeeAmountBn).gt(this.dust)
  //     ) {
  //       break
  //     }
  //   }
  //   if (this.changeAmountBn.geq(minFeeAmountBn)) {
  //     // Subtract fee from change
  //     this.feeAmountBn = minFeeAmountBn
  //     this.changeAmountBn = this.changeAmountBn.sub(this.feeAmountBn)
  //     this.tx.txOuts[this.tx.txOuts.length - 1].valueBn = this.changeAmountBn

  //     if (this.changeAmountBn.lt(this.dust)) {
  //       if (this.dustChangeToFees) {
  //         // Remove the change amount since it is less than dust and the
  //         // builder has requested dust be sent to fees.
  //         this.tx.txOuts.pop()
  //         this.tx.txOutsVi = VarInt.fromNumber(this.tx.txOutsVi.toNumber() - 1)
  //         this.feeAmountBn = this.feeAmountBn.add(this.changeAmountBn)
  //         this.changeAmountBn = new Bn(0)
  //       } else {
  //         throw new Error('unable to create change amount greater than dust')
  //       }
  //     }

  //     this.tx.nLockTime = this.nLockTime
  //     this.tx.versionBytesNum = this.versionBytesNum
  //     if (this.tx.txOuts.length === 0) {
  //       throw new Error(
  //         'outputs length is zero - unable to create any outputs greater than dust'
  //       )
  //     }
  //     return this
  //   } else {
  //     throw new Error('unable to gather enough inputs for outputs and fee')
  //   }
  // }

  // // BIP 69 sorting. call after build() but before sign()
  // sort () {
  //   this.tx.sort()
  //   return this
  // }

  // /**
  //    * Check if all signatures are present in a multisig input script.
  //    */
  // static allSigsPresent (m, script) {
  //   // The first element is a Famous MultiSig Bug OP_0, and last element is the
  //   // redeemScript. The rest are signatures.
  //   let present = 0
  //   for (let i = 1; i < script.chunks.length - 1; i++) {
  //     if (script.chunks[i].buf) {
  //       present++
  //     }
  //   }
  //   return present === m
  // }

  // /**
  //    * Remove blank signatures in a multisig input script.
  //    */
  // static removeBlankSigs (script) {
  //   // The first element is a Famous MultiSig Bug OP_0, and last element is the
  //   // redeemScript. The rest are signatures.
  //   script = new Script(script.chunks.slice()) // copy the script
  //   for (let i = 1; i < script.chunks.length - 1; i++) {
  //     if (!script.chunks[i].buf) {
  //       script.chunks.splice(i, 1) // remove ith element
  //     }
  //   }
  //   return script
  // }

  // fillSig (nIn, nScriptChunk, sig) {
  //   var txIn = this.tx.txIns[nIn]
  //   txIn.script.chunks[nScriptChunk] = new Script().writeBuffer(
  //     sig.toTxFormat()
  //   ).chunks[0]
  //   txIn.scriptVi = VarInt.fromNumber(txIn.script.toBuffer().length)
  //   return this
  // }

  // /**
  //    * Sign an input, but do not fill the signature into the transaction. Return
  //    * the signature.
  //    *
  //    * For a normal transaction, subScript is usually the scriptPubKey. If
  //    * you're not normal because you're using OP_CODESEPARATORs, you know what
  //    * to do.
  //    */
  // getSig (keyPair, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, nIn, subScript, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID) {
  //   let valueBn
  //   if (
  //     nHashType & Sig.SIGHASH_FORKID &&
  //       flags & Tx.SCRIPT_ENABLE_SIGHASH_FORKID
  //   ) {
  //     var txHashBuf = this.tx.txIns[nIn].txHashBuf
  //     var txOutNum = this.tx.txIns[nIn].txOutNum
  //     var txOut = this.uTxOutMap.get(txHashBuf, txOutNum)
  //     if (!txOut) {
  //       throw new Error('for SIGHASH_FORKID must provide UTXOs')
  //     }
  //     valueBn = txOut.valueBn
  //   }
  //   return this.tx.sign(keyPair, nHashType, nIn, subScript, valueBn, flags, this.hashCache)
  // }

  // /**
  //    * Asynchronously sign an input in a worker, but do not fill the signature
  //    * into the transaction. Return the signature.
  //    */
  // asyncGetSig (keyPair, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, nIn, subScript, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID) {
  //   let valueBn
  //   if (
  //     nHashType & Sig.SIGHASH_FORKID &&
  //       flags & Tx.SCRIPT_ENABLE_SIGHASH_FORKID
  //   ) {
  //     var txHashBuf = this.tx.txIns[nIn].txHashBuf
  //     var txOutNum = this.tx.txIns[nIn].txOutNum
  //     var txOut = this.uTxOutMap.get(txHashBuf, txOutNum)
  //     if (!txOut) {
  //       throw new Error('for SIGHASH_FORKID must provide UTXOs')
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

  // /**
  //    * Sign ith input with keyPair and insert the signature into the transaction.
  //    * This method only works for some standard transaction types. For
  //    * non-standard transaction types, use getSig.
  //    */
  // signTxIn (nIn, keyPair, txOut, nScriptChunk, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID) {
  //   var txIn = this.tx.txIns[nIn]
  //   var script = txIn.script
  //   if (nScriptChunk === null && script.isPubKeyHashIn()) {
  //     nScriptChunk = 0
  //   }
  //   if (nScriptChunk === null) {
  //     throw new Error('cannot sign unknown script type for input ' + nIn)
  //   }
  //   var txHashBuf = txIn.txHashBuf
  //   var txOutNum = txIn.txOutNum
  //   if (!txOut) {
  //     txOut = this.uTxOutMap.get(txHashBuf, txOutNum)
  //   }
  //   var outScript = txOut.script
  //   var subScript = outScript // true for standard script types
  //   var sig = this.getSig(keyPair, nHashType, nIn, subScript, flags, this.hashCache)
  //   this.fillSig(nIn, nScriptChunk, sig)
  //   return this
  // }

  // /**
  //    * Asynchronously sign ith input with keyPair in a worker and insert the
  //    * signature into the transaction.  This method only works for some standard
  //    * transaction types. For non-standard transaction types, use asyncGetSig.
  //    */
  // async asyncSignTxIn (nIn, keyPair, txOut, nScriptChunk, nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, flags = Tx.SCRIPT_ENABLE_SIGHASH_FORKID) {
  //   var txIn = this.tx.txIns[nIn]
  //   var script = txIn.script
  //   if (nScriptChunk === null && script.isPubKeyHashIn()) {
  //     nScriptChunk = 0
  //   }
  //   if (nScriptChunk === null) {
  //     throw new Error('cannot sign unknown script type for input ' + nIn)
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

  // signWithKeyPairs (keyPairs) {
  //   // produce map of addresses to private keys
  //   var addressStrMap = {}
  //   for (var keyPair of keyPairs) {
  //     var addressStr = Address.fromPubKey(keyPair.pubKey).toString()
  //     addressStrMap[addressStr] = keyPair
  //   }
  //   // loop through all inputs
  //   for (var nIn in this.tx.txIns) {
  //     var txIn = this.tx.txIns[nIn]
  //     // for each input, use sigOperations to get list of signatures and pubkeys
  //     // to be produced and inserted
  //     var arr = this.sigOperations.get(txIn.txHashBuf, txIn.txOutNum)
  //     for (var obj of arr) {
  //       // for each pubkey, get the privkey from the privkey map and sign the input
  //       var { nScriptChunk, type, addressStr, nHashType } = obj
  //       var keyPair = addressStrMap[addressStr]
  //       if (!keyPair) {
  //         obj.log = `cannot find keyPair for addressStr ${addressStr}`
  //         continue
  //       }
  //       var txOut = this.uTxOutMap.get(txIn.txHashBuf, txIn.txOutNum)
  //       if (type === 'sig') {
  //         this.signTxIn(nIn, keyPair, txOut, nScriptChunk, nHashType)
  //         obj.log = 'successfully inserted signature'
  //       } else if (type === 'pubKey') {
  //         txIn.script.chunks[nScriptChunk] = new Script().writeBuffer(
  //           keyPair.pubKey.toBuffer()
  //         ).chunks[0]
  //         txIn.setScript(txIn.script)
  //         obj.log = 'successfully inserted public key'
  //       } else {
  //         obj.log = `cannot perform operation of type ${type}`
  //         continue
  //       }
  //     }
  //   }
  //   return this
  // }
}
