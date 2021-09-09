import 'dart:math' as Math;

import 'package:bsv/hash.dart';
import 'package:bsv/extentsions/list.dart';

// ignore: slash_for_doc_comments
/**
 * Merkle
 * ======
 *
 * A node in a Merkle tree (possibly the root node, in which case it is the
 * Merkle root). A node either contains a buffer or links to two other nodes.
 */

class Merkle {
  List<int>? hashBuf;
  List<int>? buf;
  Merkle? merkle1;
  Merkle? merkle2;

  Merkle({
    this.hashBuf,
    this.buf,
    this.merkle1,
    this.merkle2,
  });

  List<int>? hash() {
    if (this.hashBuf != null) {
      return this.hashBuf;
    }
    if (this.buf != null) {
      return Hash.sha256Sha256(this.buf!.asUint8List()).data!.toList();
    }
    var hashBuf1 = this.merkle1!.hash()!;
    var hashBuf2 = this.merkle2!.hash()!;
    this.buf = List<int>.from([...hashBuf1, ...hashBuf2]);
    return Hash.sha256Sha256(this.buf!.asUint8List()).data!.toList();
  }

  double logBase(num x, num base) => Math.log(x) / Math.log(base);
  double log10(num x) => Math.log(x) / Math.ln10;
  double log2(num x) => Math.log(x) / Math.ln2;
  bool isInteger(num x) => x.toInt() == x;

  Merkle fromBuffers(List<List<int>> bufs) {
    if (bufs.length < 1) {
      throw ('buffers must have a length');
    }
    bufs = bufs.slice(0);
    var log = log2(bufs.length);

    if (!isInteger(log)) {
      // If a merkle tree does not have a number of ends that is a power of 2,
      // then we have to copy the last value until it is a power of 2. Note
      // that we copy *the actual object* over and over again, which ensures
      // that when we finds its hash, the hash is cached.
      var lastval = bufs[bufs.length - 1];
      var len = Math.pow(2, log.ceil());
      for (var i = bufs.length; i < len; i++) {
        // bufs.add(lastval);
        bufs = [...bufs, lastval];
      }
    }
    var bufs1 = bufs.slice(0, bufs.length ~/ 2);
    var bufs2 = bufs.slice(bufs.length ~/ 2);
    this.fromBufferArrays(bufs1, bufs2);
    return this;
  }

  factory Merkle.fromBuffers(List<List<int>> bufs) {
    return new Merkle().fromBuffers(bufs);
  }

  // ignore: slash_for_doc_comments
  /**
   * Takes two arrays, both of which *must* be of a length that is a power of
   * two.
   */
  Merkle fromBufferArrays(List<List<int>> bufs1, List<List<int>> bufs2) {
    if (bufs1.length == 1) {
      this.merkle1 = new Merkle(hashBuf: null, buf: bufs1[0]);
      this.merkle2 = new Merkle(hashBuf: null, buf: bufs2[0]);
      return this;
    }
    List<List<int>> bufs11 = bufs1.slice(0, bufs1.length ~/ 2);
    List<List<int>> bufs12 = bufs1.slice(bufs1.length ~/ 2);
    this.merkle1 = new Merkle().fromBufferArrays(bufs11, bufs12);
    List<List<int>> bufs21 = bufs2.slice(0, bufs2.length ~/ 2);
    List<List<int>> bufs22 = bufs2.slice(bufs2.length ~/ 2);
    this.merkle2 = new Merkle().fromBufferArrays(bufs21, bufs22);
    return this;
  }

  factory Merkle.fromBufferArrays(
      List<List<int>> bufs1, List<List<int>> bufs2) {
    return new Merkle().fromBufferArrays(bufs1, bufs2);
  }

  int leavesNum() {
    if (this.merkle1 != null) {
      return this.merkle1!.leavesNum() + this.merkle2!.leavesNum();
    }
    if (this.buf != null) {
      return 1;
    }
    throw ('invalid number of leaves');
  }
}
