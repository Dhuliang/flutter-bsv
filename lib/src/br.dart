import 'dart:math';
import 'dart:typed_data';

import 'package:bsv/src/bn.dart';
import 'package:bsv/src/extentsions/list.dart';

// ignore: slash_for_doc_comments
/**
 * Buffer Reader
 * =============
 *
 * This is a convenience class for reading VarInts and other basic types from a
 * buffer. This class is most useful for reading VarInts, and also for signed
 * or unsigned integers of various types. It can also read a buffer in reverse
 * order, which is useful in bitcoin which uses little endian numbers a lot so
 * you find that you must reverse things. You probably want to use it like:
 * varInt = new Br(buf).readnew VarInt()
 */

class Br {
  Uint8List? buf;
  int? pos;

  static const ERROR_NUMBER_TOO_LARGE =
      'number too large to retain precision - use readVarIntBn';

  Br({Uint8List? buf, int? pos}) {
    this.buf = buf ?? Uint8List(0);
    this.pos = pos ?? 0;
  }

  factory Br.fromByteData(ByteData data) {
    return new Br(buf: data.buffer.asUint8List());
  }

  bool eof() {
    return this.pos! >= this.buf!.length;
  }

  Uint8List read([int? len]) {
    len = len ?? this.buf!.length;
    var start = this.pos;
    var end = this.pos! + len;

    var newBuf = Uint8List.fromList(this.buf!.slice(start, end));
    this.pos = end;
    return newBuf;
  }

  List<int> readReverse([int? len]) {
    len = len ?? this.buf!.length;
    var buf = this.buf!.sublist(this.pos!, this.pos! + len);
    this.pos = this.pos! + len;
    var buf2 = List<int>.filled(buf.length, 0, growable: false);
    for (var i = 0; i < buf2.length; i++) {
      buf2[i] = buf[buf.length - 1 - i];
    }
    return buf2;
  }

  int readUInt8() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Uint8List.fromList(this.buf).buffer);
    var value = view.getUint8(this.pos!);
    this.pos = this.pos! + 1;
    return value;
  }

  int readInt8() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Int8List.fromList(this.buf).buffer);
    var value = view.getInt8(this.pos!);
    this.pos = this.pos! + 1;
    return value;
  }

  int readUInt16BE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Uint16List.fromList(this.buf).buffer);
    var value = view.getUint16(this.pos!, Endian.big);
    this.pos = this.pos! + 2;
    return value;
  }

  int readInt16BE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Int8List.fromList(this.buf).buffer);
    var value = view.getInt16(this.pos!, Endian.big);
    this.pos = this.pos! + 2;
    return value;
  }

  int readUInt16LE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Uint16List.fromList(this.buf).buffer);
    var value = view.getUint16(this.pos!, Endian.little);
    this.pos = this.pos! + 2;
    return value;
  }

  int readInt16LE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Int8List.fromList(this.buf).buffer);
    var value = view.getInt16(this.pos!, Endian.little);
    this.pos = this.pos! + 2;
    return value;
  }

  int readUInt32BE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Uint32List.fromList(this.buf).buffer);
    var value = view.getUint32(this.pos!, Endian.big);
    this.pos = this.pos! + 4;
    return value;
  }

  int readInt32BE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Int32List.fromList(this.buf).buffer);
    var value = view.getInt32(this.pos!, Endian.big);
    this.pos = this.pos! + 4;
    return value;
  }

  int readUInt32LE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Uint32List.fromList(this.buf).buffer);
    var value = view.getUint32(this.pos!, Endian.little);
    this.pos = this.pos! + 4;
    return value;
  }

  int readInt32LE() {
    var view = ByteData.view(this.buf!.buffer);
    // var view = ByteData.view(Int32List.fromList(this.buf).buffer);
    var value = view.getInt32(this.pos!, Endian.little);
    this.pos = this.pos! + 4;
    return value;
  }

  BigIntX readUInt64BEBn() {
    var buf = this.buf!.sublist(this.pos!, this.pos! + 8);
    var bn = BigIntX.fromBuffer(buf);
    this.pos = this.pos! + 8;
    return bn;
  }

  BigIntX readUInt64LEBn() {
    var buf = this.readReverse(8);
    var bn = BigIntX.fromBuffer(buf);
    return bn;
  }

  int readVarIntNum() {
    var first = this.readUInt8();
    var bn, n;
    switch (first) {
      case 0xfd:
        return this.readUInt16LE();
      case 0xfe:
        return this.readUInt32LE();
      case 0xff:
        bn = this.readUInt64LEBn();
        n = bn.toNumber();
        if (n <= pow(2, 53)) {
          return n;
        } else {
          throw ERROR_NUMBER_TOO_LARGE;
        }
      // break;
      default:
        return first;
    }
  }

  List<int> readVarIntBuf() {
    var temp = Br(buf: this.buf, pos: this.pos);
    var first = temp.readUInt8();
    switch (first) {
      case 0xfd:
        return this.read(1 + 2);
      case 0xfe:
        return this.read(1 + 4);
      case 0xff:
        return this.read(1 + 8);
      default:
        return this.read(1);
    }
  }

  BigIntX readVarIntBn() {
    var first = this.readUInt8();
    switch (first) {
      case 0xfd:
        return new BigIntX.fromNum(this.readUInt16LE());
      case 0xfe:
        return new BigIntX.fromNum(this.readUInt32LE());
      case 0xff:
        return this.readUInt64LEBn();
      default:
        return new BigIntX.fromNum(first);
    }
  }
}
