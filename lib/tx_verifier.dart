// ignore: slash_for_doc_comments
/*s*
 * Transaction Verifier
 * ====================
 */

import 'dart:convert';

import 'package:bsv/block.dart';
import 'package:bsv/bn.dart';
import 'package:bsv/interp.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/tx_out_map.dart';
import 'package:bsv/extentsions/list.dart';

class TxVerifier {
  Tx? tx;
  TxOutMap? txOutMap;
  String errStr;
  Interp? interp;

  TxVerifier({
    this.tx,
    this.txOutMap,
    this.errStr = '',
  });

  // ignore: slash_for_doc_comments
  /**
     * Verifies that the transaction is valid both by performing basic checks, such
     * as ensuring that no two inputs are the same, as well as by verifying every
     * script. The two checks are checkStr, which is analagous to bitcoind's
     * CheckTransaction, and verifyStr, which runs the script interpreter.
     *
     * This does NOT check that any possible claimed fees are accurate; checking
     * that the fees are accurate requires checking that the input transactions are
     * valid, which is not performed by this test. That check is done with the
     * normal verify function.
     */
  Future<bool> verify([int? flags]) async {
    var result1 = this.checkStr();
    if (result1 is String) {
      return false;
    }
    flags = flags ?? Interp.SCRIPT_ENABLE_SIGHASH_FORKID;
    var result2 = await this.verifyStr(flags);
    if (result2 is String) {
      return false;
    }

    // return !this.checkStr() && !this.verifyStr(flags);
    // return true;
    return !result1 && !result2;
  }

  // /*
  //    * Returns true if the transaction was verified successfully (that is no
  //    * error was found), and false otherwise. In case an error was found the
  //    * error message can be accessed by calling this.getDebugString().
  //    */
  // async asyncVerify (flags) {
  //   var verifyStr = await this.asyncVerifyStr(flags)
  //   return !this.checkStr() && !verifyStr
  // }

  // ignore: slash_for_doc_comments
  /**
     * Convenience method to verify a transaction.
     */
  static Future<bool> staticVerify({Tx? tx, TxOutMap? txOutMap, int? flags}) {
    return new TxVerifier(tx: tx, txOutMap: txOutMap).verify(flags);
  }

  // static asyncVerify (tx, txOutMap, flags) {
  //   return new TxVerifier(tx, txOutMap).asyncVerify(flags)
  // }

  // ignore: slash_for_doc_comments
  /**
     * Check that a transaction passes basic sanity tests. If not, return a string
     * describing the error. This function contains the same logic as
     * CheckTransaction in bitcoin core.
     */
  dynamic checkStr() {
    // Basic checks that don't depend on any context
    if (this.tx!.txIns!.length == 0 || this.tx!.txInsVi!.toNumber() == 0) {
      this.errStr = 'transaction txIns empty';
      return this.errStr;
    }
    if (this.tx!.txOuts!.length == 0 || this.tx!.txOutsVi!.toNumber() == 0) {
      this.errStr = 'transaction txOuts empty';
      return this.errStr;
    }

    // Size limits
    if (this.tx!.toBuffer().length > Block.MAX_BLOCK_SIZE) {
      this.errStr = 'transaction over the maximum block size';
      return this.errStr;
    }

    // Check for negative or overflow output values
    var valueoutbn = BigIntX.zero;
    for (var i = 0; i < this.tx!.txOuts!.length; i++) {
      var txOut = this.tx!.txOuts![i];
      if (txOut.valueBn!.lt(0)) {
        this.errStr = 'transaction txOut $i negative';
        return this.errStr;
      }
      if (txOut.valueBn!.gt(Tx.MAX_MONEY)) {
        this.errStr = 'transaction txOut $i greater than MAX_MONEY';
        return this.errStr;
      }
      valueoutbn = valueoutbn.add(txOut.valueBn!);
      if (valueoutbn.gt(Tx.MAX_MONEY)) {
        this.errStr =
            'transaction txOut $i total output greater than MAX_MONEY';
        return this.errStr;
      }
    }

    // Check for duplicate inputs
    var txInmap = {};
    for (var i = 0; i < this.tx!.txIns!.length; i++) {
      var txIn = this.tx!.txIns![i];
      var inputid = '${txIn.txHashBuf!.toHex()}:${txIn.txOutNum}';
      if (txInmap[inputid] != null) {
        this.errStr = 'transaction input $i duplicate input';
        return this.errStr;
      }
      txInmap[inputid] = true;
    }

    if (this.tx!.isCoinbase()) {
      var buf = this.tx!.txIns![0].script!.toBuffer();
      if (buf.length < 2 || buf.length > 100) {
        this.errStr = 'coinbase trasaction script size invalid';
        return this.errStr;
      }
    } else {
      for (var i = 0; i < this.tx!.txIns!.length; i++) {
        if (this.tx!.txIns![i].hasNullInput()) {
          this.errStr = 'transaction input $i has null input';
          return this.errStr;
        }
      }
    }
    return false;
  }

  // ignore: slash_for_doc_comments
  /**
     * verify the transaction inputs by running the script interpreter. Returns a
     * string of the script interpreter is invalid, otherwise returns false.
     */
  dynamic verifyStr(int flags) async {
    for (var i = 0; i < this.tx!.txIns!.length; i++) {
      if (!await this.verifyNIn(i, flags)) {
        this.errStr = 'input $i failed script verify';
        return this.errStr;
      }
    }
    return false;
  }

  // async asyncVerifyStr (flags) {
  //   for (var i = 0; i < this.tx.txIns.length; i++) {
  //     var verifyNIn = await this.asyncVerifyNIn(i, flags)
  //     if (!verifyNIn) {
  //       this.errStr = 'input ' + i + ' failed script verify'
  //       return this.errStr
  //     }
  //   }
  //   return false
  // }

  // ignore: slash_for_doc_comments
  /**
     * Verify a particular input by running the script interpreter. Returns true if
     * the input is valid, false otherwise.
     */
  Future<bool> verifyNIn(int nIn, int flags) async {
    var txIn = this.tx!.txIns![nIn];
    var scriptSig = txIn.script;
    TxOut? txOut = this.txOutMap!.get(txIn.txHashBuf!, txIn.txOutNum);
    if (txOut == null) {
      print('output ${txIn.txOutNum} not found');
      return false;
    }
    var scriptPubKey = txOut.script;
    var valueBn = txOut.valueBn;
    this.interp = new Interp();
    var verified = await this.interp!.verify(
          scriptSig: scriptSig,
          scriptPubKey: scriptPubKey,
          tx: this.tx,
          nIn: nIn,
          flags: flags,
          valueBn: valueBn,
        );
    return verified;
  }

  // async asyncVerifyNIn (nIn, flags) {
  //   var txIn = this.tx.txIns[nIn]
  //   var scriptSig = txIn.script
  //   var txOut = this.txOutMap.get(txIn.txHashBuf, txIn.txOutNum)
  //   if (!txOut) {
  //     console.log('output ' + txIn.txOutNum + ' not found')
  //     return false
  //   }
  //   var scriptPubKey = txOut.script
  //   var valueBn = txOut.valueBn
  //   this.interp = new Interp()
  //   var workersResult = await Workers.asyncObjectMethod(
  //     this.interp,
  //     'verify',
  //     [scriptSig, scriptPubKey, this.tx, nIn, flags, valueBn]
  //   )
  //   var verified = JSON.parse(workersResult.resbuf.toString())
  //   return verified
  // }

  Map<String, dynamic> getDebugObject() {
    return {
      "errStr": this.errStr,
      "interpFailure": this.interp != null ? this.interp!.getDebugObject() : null
    };
  }

  String getDebugString() {
    return jsonEncode(this.getDebugObject());
  }
}
