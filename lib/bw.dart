import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:convert/convert.dart';

// ignore: slash_for_doc_comments
/**
 * Buffer Writer
 * =============
 *
 * This is the writing complement of the Bw. You can easily write
 * VarInts and other basic number types. The way to use it is: buf =
 * new Bw().write(buf1).write(buf2).toBuffer()
 */

class Bw {
  late List<Uint8List?> bufs;

  Bw({List<Uint8List>? bufs}) {
    this.bufs = bufs ?? List<Uint8List?>.filled(0, null, growable: false);
  }

  // factory Bw.fromByteData(ByteData data) {
  //   return new Bw(bufs: data.buffer.asUint8List());
  // }

  int getLength() {
    var len = 0;
    for (var item in bufs) {
      var buf = item!;
      len = len + buf.length;
    }
    return len;
  }

  List<int> toBuffer() {
    return this.bufs.expand((element) => element!).toList();
  }

  String toHex() {
    return hex.encode(this.toBuffer());
  }

  Bw write(Uint8List? buf) {
    List<Uint8List?> temp = []..addAll(this.bufs)..addAll([buf]);
    this.bufs = temp;
    return this;
  }

  Bw writeReverse(Uint8List buf) {
    var buf2 = Uint8List(buf.length);
    for (var i = 0; i < buf2.length; i++) {
      buf2[i] = buf[buf.length - 1 - i];
    }
    List<Uint8List?> temp = []..addAll(this.bufs)..addAll([buf2]);
    this.bufs = temp;
    return this;
  }

  Bw writeUInt8(int n) {
    var buf = Uint8List(1);
    var view = ByteData.view(buf.buffer);
    view.setUint8(0, n);
    this.write(buf);
    return this;
  }

  Bw writeInt8(int n) {
    var buf = Uint8List(1);
    var view = ByteData.view(buf.buffer);
    view.setInt8(0, n);
    this.write(buf);
    return this;
  }

  Bw writeUInt16BE(int n) {
    var buf = Uint8List(2);
    var view = ByteData.view(buf.buffer);
    view.setUint16(0, n, Endian.big);
    this.write(buf);
    return this;
  }

  Bw writeInt16BE(int n) {
    var buf = Uint8List(2);
    var view = ByteData.view(buf.buffer);
    view.setInt16(0, n, Endian.big);
    this.write(buf);
    return this;
  }

  Bw writeUInt16LE(int n) {
    var buf = Uint8List(2);
    var view = ByteData.view(buf.buffer);
    view.setUint16(0, n, Endian.little);
    this.write(buf);
    return this;
  }

  Bw writeInt16LE(int n) {
    var buf = Uint8List(2);
    var view = ByteData.view(buf.buffer);
    view.setInt16(0, n, Endian.little);
    this.write(buf);
    return this;
  }

  Bw writeUInt32BE(int n) {
    var buf = Uint8List(4);
    var view = ByteData.view(buf.buffer);
    view.setUint32(0, n, Endian.big);
    this.write(buf);

    return this;
  }

  Bw writeInt32BE(int n) {
    var buf = Uint8List(4);

    var view = ByteData.view(buf.buffer);
    view.setInt32(0, n, Endian.big);
    this.write(buf);

    return this;
  }

  Bw writeUInt32LE(int n) {
    var buf = Uint8List(4);
    var view = ByteData.view(buf.buffer);
    view.setUint32(0, n, Endian.little);
    this.write(buf);
    return this;
  }

  Bw writeInt32LE(int n) {
    var buf = Uint8List(4);
    var view = ByteData.view(buf.buffer);
    view.setInt32(0, n, Endian.little);
    this.write(buf);
    return this;
  }

  Bw writeUInt64BEBn(BigIntX bn) {
    var buf = Uint8List.fromList(bn.toBuffer(size: 8));
    this.write(buf);
    return this;
  }

  Bw writeUInt64LEBn(BigIntX bn) {
    var buf = Uint8List.fromList(bn.toBuffer(size: 8));
    this.writeReverse(buf);
    return this;
  }

  Bw writeVarIntNum(int n) {
    var buf = Bw.varIntBufNum(n);
    this.write(buf);
    return this;
  }

  Bw writeVarIntBn(BigIntX bn) {
    var buf = Bw.varIntBufBn(bn);
    this.write(buf);
    return this;
  }

  static Uint8List varIntBufNum(int n) {
    Uint8List buf;
    ByteData view;
    if (n < 253) {
      buf = Uint8List(1);
      view = ByteData.view(buf.buffer);
      view.setUint8(0, n);
    } else if (n < 0x10000) {
      buf = Uint8List(1 + 2);
      view = ByteData.view(buf.buffer);
      view.setUint8(0, 253);
      view.setUint16(1, n, Endian.little);
    } else if (n < 0x100000000) {
      buf = Uint8List(1 + 4);
      view = ByteData.view(buf.buffer);
      view.setUint8(0, 254);
      view.setUint32(1, n, Endian.little);
    } else {
      buf = Uint8List(1 + 8);
      view = ByteData.view(buf.buffer);
      view.setUint8(0, 255);
      view.setUint32(1, n & -1, Endian.little);
      view.setUint32(5, (n / 0x100000000).floor(), Endian.little);
    }
    return buf;
  }

  static Uint8List varIntBufBn(BigIntX bn) {
    Uint8List buf;
    ByteData view;
    var n = bn.toNumber();
    if (n < 253) {
      buf = Uint8List(1);
      view = ByteData.view(buf.buffer);
      view.setUint8(0, n);
    } else if (n < 0x10000) {
      buf = Uint8List(1 + 2);
      view = ByteData.view(buf.buffer);
      view.setUint8(0, 253);
      view.setUint16(1, n, Endian.little);
    } else if (n < 0x100000000) {
      buf = Uint8List(1 + 4);
      view = ByteData.view(buf.buffer);
      view.setUint8(0, 254);
      view.setUint32(1, n, Endian.little);
    } else {
      buf = Uint8List(1 + 8);
      var bw = new Bw();
      bw.writeUInt8(255);
      bw.writeUInt64LEBn(bn);
      buf = Uint8List.fromList(bw.toBuffer());
    }
    return buf;
  }
}
