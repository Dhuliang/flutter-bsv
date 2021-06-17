import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:bsv/extentsions/string.dart';

/**
 * VarInt (a.k.a. Compact Size)
 * ============================
 *
 * A varInt is a varible sized integer, and it is a format that is unique to
 * bitcoin, and used throughout bitcoin to represent the length of binary data
 * in a compact format that can take up as little as 1 byte or as much as 9
 * bytes.
 */

class VarInt {
  List<int> buf;

  VarInt({List<int> buf}) {
    this.buf = buf;
  }

  factory VarInt.fromBn(BigIntX bn) {
    return new VarInt().fromBn(bn);
  }

  factory VarInt.fromNumber(int n) {
    return new VarInt().fromNumber(n);
  }

  factory VarInt.fromBuffer(List<int> buf) {
    return new VarInt().fromBuffer(buf);
  }

  String toJSON() {
    return this.buf.toHex();
  }

  VarInt fromJSON(String str) {
    this.buf = str.toBuffer();
    return this;
  }

  VarInt fromBuffer(List<int> buf) {
    this.buf = buf;
    return this;
  }

  VarInt fromBr(Br br) {
    this.buf = br.readVarIntBuf();
    return this;
  }

  VarInt fromBn(BigIntX bn) {
    this.buf = new Bw().writeVarIntBn(bn).toBuffer();
    return this;
  }

  VarInt fromNumber(int n) {
    this.buf = new Bw().writeVarIntNum(n).toBuffer();
    return this;
  }

  List<int> toBuffer() {
    return this.buf;
  }

  BigIntX toBn() {
    return new Br(buf: this.buf.toBuffer()).readVarIntBn();
  }

  int toNumber() {
    return new Br(buf: this.buf.toBuffer()).readVarIntNum();
  }
}
