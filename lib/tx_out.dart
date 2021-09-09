/*
 * Transaction Input
 * =================
 *
 * An input to a transaction. The way you probably want to use this is through
 * the convenient method of new TxIn(txHashBuf, txOutNum, script, nSequence) (i.e., you
 * can leave out the scriptVi, which is computed automatically if you leave it
 * out.)
 */

import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/script.dart';
import 'package:bsv/var_int.dart';
import 'package:convert/convert.dart';
import 'package:bsv/extentsions/list.dart';

class TxOut {
  BigIntX? valueBn;
  VarInt? scriptVi;
  Script? script;

  TxOut({
    BigIntX? valueBn,
    VarInt? scriptVi,
    Script? script,
  }) {
    this.valueBn = valueBn;
    this.scriptVi = scriptVi;
    this.script = script;
  }

  factory TxOut.fromProperties({
    required BigIntX valueBn,
    Script? script,
  }) {
    return new TxOut().fromProperties(
      valueBn: valueBn,
      script: script,
    );
  }

  TxOut fromJSON(Map json) {
    return TxOut(
      valueBn: new BigIntX.fromString(json['valueBn']),
      scriptVi: new VarInt().fromJSON(json['scriptVi']),
      script: new Script().fromJSON(json['script']),
    );
  }

  Map<String, String> toJSON() {
    return {
      "valueBn": this.valueBn!.toJSON(),
      "scriptVi": this.scriptVi!.toJSON(),
      "script": this.script!.toJSON()
    };
  }

  TxOut setScript(Script? script) {
    this.scriptVi = VarInt.fromNumber(script!.toBuffer().length);
    this.script = script;
    return this;
  }

  TxOut fromProperties({
    required BigIntX valueBn,
    Script? script,
  }) {
    var txOut = TxOut(
      valueBn: valueBn,
    );
    txOut.setScript(script);
    return txOut;
  }

  TxOut fromBr(Br br) {
    this.valueBn = br.readUInt64LEBn();
    this.scriptVi = VarInt.fromNumber(br.readVarIntNum());
    this.script = new Script().fromBuffer(br.read(this.scriptVi!.toNumber()));
    return this;
  }

  TxOut fromHex(String str) {
    return this.fromBr(Br(buf: hex.decode(str) as Uint8List?));
  }

  factory TxOut.fromHex(String str) {
    return TxOut().fromBr(Br(buf: hex.decode(str) as Uint8List?));
  }

  TxOut fromBuffer(List<int> buf) {
    return this.fromBr(Br(buf: buf as Uint8List?));
  }

  Bw toBw([Bw? bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.writeUInt64LEBn(this.valueBn!);
    bw.write(this.scriptVi!.buf!.asUint8List());
    bw.write(this.script!.toBuffer().asUint8List());
    return bw;
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }

  String toHex() {
    return this.toBw().toHex();
  }
}
