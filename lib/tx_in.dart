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
import 'package:bsv/tx_out.dart';
import 'package:bsv/var_int.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:convert/convert.dart';

class TxIn {
  List<int> txHashBuf;
  int txOutNum;
  VarInt scriptVi;
  Script script;
  int nSequence = 0xffffffff;

  static const LOCKTIME_VERIFY_SEQUENCE = 1 << 0;

  static const SEQUENCE_FINAL = 0xffffffff;

  static const SEQUENCE_LOCKTIME_DISABLE_FLAG = 1 << 31;

  static const SEQUENCE_LOCKTIME_TYPE_FLAG = 1 << 22;

  static const SEQUENCE_LOCKTIME_MASK = 0x0000ffff;

  static const SEQUENCE_LOCKTIME_GRANULARITY = 9;

  TxIn({
    List<int> txHashBuf,
    int txOutNum,
    VarInt scriptVi,
    Script script,
    int nSequence,
  }) {
    this.txHashBuf = txHashBuf;
    this.txOutNum = txOutNum;
    this.scriptVi = scriptVi;
    this.script = script;
    this.nSequence = nSequence ?? 0xffffffff;
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

  TxIn fromJSON(Map json) {
    return TxIn(
      txHashBuf:
          json['txHashBuf'] != null ? hex.decode(json['txHashBuf']) : null,
      txOutNum: json['txOutNum'],
      scriptVi:
          json['scriptVi'] != null ? VarInt.fromJSON(json['scriptVi']) : null,
      script: json['script'] != null ? Script.fromJSON(json['script']) : null,
      nSequence: json['nSequence'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "txHashBuf": this.txHashBuf != null ? this.txHashBuf.toHex() : null,
      "txOutNum": this.txOutNum,
      "scriptVi": this.scriptVi != null ? this.scriptVi.toJSON() : null,
      "script": this.script != null ? this.script.toJSON() : null,
      "nSequence": this.nSequence
    };
  }

  TxIn setScript(Script s) {
    this.scriptVi = VarInt.fromNumber(s.toBuffer().length);
    this.script = s;
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

  Bw toBw([Bw bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.write(this.txHashBuf.asUint8List());
    bw.writeUInt32LE(this.txOutNum);
    bw.write(this.scriptVi.buf.asUint8List());
    bw.write(this.script.toBuffer().asUint8List());
    bw.writeUInt32LE(this.nSequence);
    return bw;
  }

  // ignore: slash_for_doc_comments
  /**
     * Generate txIn with blank signatures from a txOut and its
     * txHashBuf+txOutNum. A "blank" signature is just an OP_0. The pubKey also
     * defaults to blank but can be substituted with the real public key if you
     * know what it is.
     */
  TxIn fromPubKeyHashTxOut({
    List<int> txHashBuf,
    int txOutNum,
    TxOut txOut,
    PubKey pubKey,
  }) {
    var script = new Script();
    if (txOut.script.isPubKeyHashOut()) {
      script.writeOpCode(OpCode.OP_0); // blank signature
      if (pubKey != null) {
        script.writeBuffer(pubKey.toBuffer().asUint8List());
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

  bool hasNullInput() {
    var hexStr = this.txHashBuf.toHex();
    if (hexStr ==
            '0000000000000000000000000000000000000000000000000000000000000000' &&
        this.txOutNum == 0xffffffff) {
      return true;
    }
    return false;
  }

  void setNullInput() {
    this.txHashBuf = List<int>.generate(32, (index) => 0);
    this.txOutNum = 0xffffffff; // -1 cast to unsigned int
  }

  factory TxIn.fromHex(String str) {
    return TxIn().fromBr(Br(buf: hex.decode(str)));
  }

  TxIn fromHex(String str) {
    return this.fromBr(Br(buf: hex.decode(str)));
  }

  TxIn fromBuffer(List<int> buf) {
    return this.fromBr(Br(buf: buf.asUint8List()));
  }

  String toHex() {
    return this.toBw().toHex();
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }
}
