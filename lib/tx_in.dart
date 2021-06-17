/*
 * Transaction Input
 * =================
 *
 * An input to a transaction. The way you probably want to use this is through
 * the convenient method of new TxIn(txHashBuf, txOutNum, script, nSequence) (i.e., you
 * can leave out the scriptVi, which is computed automatically if you leave it
 * out.)
 */

import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/op_code.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/script.dart';
import 'package:bsv/var_int.dart';

class TxIn {
  List<int> txHashBuf;
  int txOutNum;
  VarInt scriptVi;
  Script script;
  int nSequence = 0xffffffff;

  TxIn({
    List<int> txHashBuf,
    int txOutNum,
    VarInt scriptVi,
    Script script,
    int nSequence = 0xffffffff,
  }) {
    this.txHashBuf = txHashBuf;
    this.txOutNum = txOutNum;
    this.scriptVi = scriptVi;
    this.script = script;
    this.nSequence = nSequence;
  }

  factory TxIn.fromProperties({
    List<int> txHashBuf,
    int txOutNum,
    Script script,
    int nSequence,
  }) {
    return new TxIn().fromProperties(
      txHashBuf: txHashBuf,
      script: script,
      txOutNum: txOutNum,
      nSequence: nSequence,
    );
  }

  TxIn setScript(Script script) {
    this.scriptVi = VarInt.fromNumber(script.toBuffer().length);
    this.script = script;
    return this;
  }

  TxIn fromProperties({
    List<int> txHashBuf,
    int txOutNum,
    Script script,
    int nSequence,
  }) {
    var txIn = TxIn(
      txHashBuf: txHashBuf,
      txOutNum: txOutNum,
      nSequence: nSequence,
    );
    txIn.setScript(script);
    return txIn;
  }

  TxIn fromBr(Br br) {
    this.txHashBuf = br.read(32);
    this.txOutNum = br.readUInt32LE();
    this.scriptVi = VarInt.fromBuffer(br.readVarIntBuf());
    this.script = Script.fromBuffer(br.read(this.scriptVi.toNumber()));
    this.nSequence = br.readUInt32LE();
    return this;
  }

  Bw toBw(Bw bw) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.write(this.txHashBuf);
    bw.writeUInt32LE(this.txOutNum);
    bw.write(this.scriptVi.buf);
    bw.write(this.script.toBuffer());
    bw.writeUInt32LE(this.nSequence);
    return bw;
  }

  /**
     * Generate txIn with blank signatures from a txOut and its
     * txHashBuf+txOutNum. A "blank" signature is just an OP_0. The pubKey also
     * defaults to blank but can be substituted with the real public key if you
     * know what it is.
     */
  TxIn fromPubKeyHashTxOut(
      {List<int> txHashBuf, int txOutNum, txOut, PubKey pubKey}) {
    var script = new Script();
    if (txOut.script.isPubKeyHashOut()) {
      script.writeOpCode(OpCode.OP_0); // blank signature
      if (pubKey != null) {
        script.writeBuffer(pubKey.toBuffer());
      } else {
        script.writeOpCode(OpCode.OP_0);
      }
    } else {
      throw ('txOut must be of type pubKeyHash');
    }
    this.txHashBuf = txHashBuf;
    this.txOutNum = txOutNum;
    this.setScript(script);
    return this;
  }
}
