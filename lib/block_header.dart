import 'dart:typed_data';

import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:convert/convert.dart';

// ignore: slash_for_doc_comments
/**
 * Block Header
 * ============
 *
 * Every block contains a blockHeader. This is probably not something you will
 * personally use, but it's here if you need it.
 */

class BlockHeader {
  int versionBytesNum;
  List<int> prevBlockHashBuf;
  List<int> merkleRootBuf;
  int time;
  int bits;
  int nonce;

  BlockHeader({
    required this.versionBytesNum,
    required this.prevBlockHashBuf,
    required this.merkleRootBuf,
    required this.time,
    required this.bits,
    required this.nonce,
  });

  factory BlockHeader.fromHex(String str) {
    return BlockHeader.fromBuffer(hex.decode(str));
  }

  // BlockHeader fromHex(String str) {
  //   return BlockHeader.fromHex(str);
  // }

  factory BlockHeader.fromBuffer(List<int> buf) {
    return BlockHeader.fromBr(Br(buf: buf.asUint8List()));
  }

  // BlockHeader fromBuffer(List<int> buf) {
  //   return BlockHeader.fromBr(Br(buf: buf.asUint8List()));
  // }

  factory BlockHeader.fromBr(Br br) {
    // this.versionBytesNum = br.readUInt32LE();
    // this.prevBlockHashBuf = br.read(32);
    // this.merkleRootBuf = br.read(32);
    // this.time = br.readUInt32LE();
    // this.bits = br.readUInt32LE();
    // this.nonce = br.readUInt32LE();
    // return this;
    return BlockHeader(
      versionBytesNum: br.readUInt32LE(),
      prevBlockHashBuf: br.read(32),
      merkleRootBuf: br.read(32),
      time: br.readUInt32LE(),
      bits: br.readUInt32LE(),
      nonce: br.readUInt32LE(),
    );
  }

  factory BlockHeader.fromJSON(Map json) {
    return BlockHeader(
      versionBytesNum: json['versionBytesNum'],
      prevBlockHashBuf: hex.decode(json['prevBlockHashBuf']),
      merkleRootBuf: hex.decode(json['merkleRootBuf']),
      time: json['time'],
      bits: json['bits'],
      nonce: json['nonce'],
    );
  }

  String toHex() {
    return this.toBuffer().toHex();
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }

  Map<String, dynamic> toJSON() {
    return {
      "versionBytesNum": this.versionBytesNum,
      "prevBlockHashBuf": this.prevBlockHashBuf.toHex(),
      "merkleRootBuf": this.merkleRootBuf.toHex(),
      "time": this.time,
      "bits": this.bits,
      "nonce": this.nonce
    };
  }

  Bw toBw([Bw? bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.writeUInt32LE(this.versionBytesNum);
    bw.write(this.prevBlockHashBuf as Uint8List);
    bw.write(this.merkleRootBuf as Uint8List);
    bw.writeUInt32LE(this.time);
    bw.writeUInt32LE(this.bits);
    bw.writeUInt32LE(this.nonce);
    return bw;
  }
}
