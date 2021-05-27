import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:convert/convert.dart';

// ignore: slash_for_doc_comments
/**
 * Signature
 * ======
 *
 * A signature is the thing you make when you want to sign a transaction, or
 * the thing you want to verify if you want to ensure that someone signed a
 * transaction. It has an r and s value, which are the cryptographic big
 * numbers that define a signature. And since this is a bitcoin library, it
 * also has nHashType, which is the way to hash a transaction and is used in
 * the binary format of a signature when it is in a transaction. We also
 * support a public key recover value, recovery, allowing one to compute the
 * public key from a signature. The "compressed" value is also necessary to
 * accurately compute the public key from a signature.
 *
 * There are a few different formats of a signature in bitcoin. One is DER, the
 * other is the TxFormat which is the same as DER but with the nHashType byte
 * appended, and the final one is Compact, which is used by Bitcoin Signed
 * Message (Bsm).
 */

class Sig {
  static const SIGHASH_ALL = 0x00000001;
  static const SIGHASH_NONE = 0x00000002;
  static const SIGHASH_SINGLE = 0x00000003;
  static const SIGHASH_FORKID = 0x00000040;
  static const SIGHASH_ANYONECANPAY = 0x00000080;

  BigIntX r;
  BigIntX s;
  int nHashType;
  int recovery;
  bool compressed;

  Sig({
    BigIntX r,
    BigIntX s,
    int nHashType,
    int recovery,
    bool compressed,
  }) {
    this.r = r ?? BigIntX.zero;
    this.s = s ?? BigIntX.zero;
    this.nHashType = nHashType;
    this.recovery = recovery;
    this.compressed = compressed;
  }

  factory Sig.fromCompact(List<int> buf) {
    return new Sig().fromCompact(buf);
  }

  factory Sig.fromRS(List<int> rsbuf) {
    return new Sig().fromRS(rsbuf);
  }

  factory Sig.fromDer(List<int> buf, [bool strict]) {
    return new Sig().fromDer(buf, strict);
  }

  factory Sig.fromTxFormat(List<int> buf) {
    return new Sig().fromTxFormat(buf);
  }

  factory Sig.fromHex(List<int> buf) {
    return new Sig().fromBuffer(buf);
  }

  Sig fromHex(String str) {
    return this.fromBuffer(hex.decode(str));
  }

  Sig fromBuffer(List<int> buf) {
    try {
      return this.fromDer(buf, true);
    } catch (e) {}
    try {
      return this.fromCompact(buf);
    } catch (e) {}
    return this.fromTxFormat(buf);
  }

  List<int> toBuffer() {
    if (this.nHashType != null) {
      return this.toTxFormat();
    } else if (this.recovery != null) {
      return this.toCompact();
    }
    return this.toDer();
  }

  // The format used by "message"
  Sig fromCompact(List<int> buf) {
    var compressed = true;
    var recovery = buf.slice(0, 1)[0] - 27 - 4;
    if (recovery < 0) {
      compressed = false;
      recovery = recovery + 4;
    }

    if (!(recovery == 0 || recovery == 1 || recovery == 2 || recovery == 3)) {
      throw ('i must be 0, 1, 2, or 3');
    }

    this.compressed = compressed;
    this.recovery = recovery;

    var rsbuf = buf.slice(1);
    this.fromRS(rsbuf);

    return this;
  }

  fromRS(List<int> rsbuf) {
    var b2 = rsbuf.slice(0, 32);
    var b3 = rsbuf.slice(32, 64);
    if (b2.length != 32) {
      throw ('r must be 32 bytes');
    }
    if (b3.length != 32 || rsbuf.length > 64) {
      throw ('s must be 32 bytes');
    }
    this.r = new BigIntX.fromBuffer(b2);
    this.s = new BigIntX.fromBuffer(b3);
    return this;
  }

  // The format used in a tx, except without the nHashType at the end
  Sig fromDer(List<int> buf, [bool strict]) {
    var obj = Sig.parseDer(buf, strict);
    this.r = obj['r'];
    this.s = obj['s'];

    return this;
  }

  // The format used in a tx
  Sig fromTxFormat(List<int> buf) {
    if (buf.length == 0) {
      // allow setting a "blank" signature
      this.r = BigIntX.one;
      this.s = BigIntX.one;
      this.nHashType = 1;
      return this;
    }

    // var nHashType = buf.readUInt8(buf.length - 1);
    var nHashType =
        ByteData.view(buf.toBuffer().buffer).getUint8(buf.length - 1);
    var derbuf = buf.slice(0, buf.length - 1);
    this.fromDer(derbuf, false);
    this.nHashType = nHashType;
    return this;
  }

  dynamic fromString(str) {
    return this.fromHex(str);
  }

  // ignore: slash_for_doc_comments
  /**
     * In order to mimic the non-strict DER encoding of OpenSSL, set strict = false.
     */
  static Map<String, dynamic> parseDer(List<int> buf, [bool strict]) {
    if (strict == null) {
      strict = true;
    }

    // if (!Buffer.isBuffer(buf)) {
    //   throw ('DER formatted signature should be a buffer');
    // }

    var header = buf[0];

    if (header != 0x30) {
      throw ('Header byte should be 0x30');
    }

    var length = buf[1];
    var buflength = buf.slice(2).length;
    if (strict && length != buflength) {
      throw ('LEngth byte should length of what follows');
    } else {
      length = length < buflength ? length : buflength;
    }

    var rheader = buf[2 + 0];
    if (rheader != 0x02) {
      throw ('Integer byte for r should be 0x02');
    }

    var rlength = buf[2 + 1];
    var rbuf = buf.slice(2 + 2, 2 + 2 + rlength);
    var r = new BigIntX.fromBuffer(rbuf);
    var rneg = buf[2 + 1 + 1] == 0x00;
    if (rlength != rbuf.length) {
      throw ('LEngth of r incorrect');
    }

    var sheader = buf[2 + 2 + rlength + 0];
    if (sheader != 0x02) {
      throw ('Integer byte for s should be 0x02');
    }

    var slength = buf[2 + 2 + rlength + 1];
    var sbuf = buf.slice(2 + 2 + rlength + 2, 2 + 2 + rlength + 2 + slength);
    var s = new BigIntX.fromBuffer(sbuf);
    var sneg = buf[2 + 2 + rlength + 2 + 2] == 0x00;
    if (slength != sbuf.length) {
      throw ('LEngth of s incorrect');
    }

    var sumlength = 2 + 2 + rlength + 2 + slength;
    if (length != sumlength - 2) {
      throw ('LEngth of signature incorrect');
    }

    var obj = {
      "header": header,
      "length": length,
      "rheader": rheader,
      "rlength": rlength,
      "rneg": rneg,
      "rbuf": rbuf,
      "r": r,
      "sheader": sheader,
      "slength": slength,
      "sneg": sneg,
      "sbuf": sbuf,
      "s": s
    };

    return obj;
  }

  // ignore: slash_for_doc_comments
  /**
     * This function is translated from bitcoind's IsDERSignature and is used in
     * the script interpreter.  This "DER" format actually includes an extra byte,
     * the nHashType, at the end. It is really the tx format, not DER format.
     *
     * A canonical signature exists of: [30] [total len] [02] [len R] [R] [02] [len S] [S] [hashtype]
     * Where R and S are not negative (their first byte has its highest bit not set), and not
     * excessively padded (do not start with a 0 byte, unless an otherwise negative number follows,
     * in which case a single 0 byte is necessary and even required).
     *
     * See https://bitcointalk.org/index.php?topic=8392.msg127623#msg127623
     */
  // ignore: non_constant_identifier_names
  static bool IsTxDer(List<int> buf) {
    if (buf.length < 9) {
      //  Non-canonical signature: too short
      return false;
    }
    if (buf.length > 73) {
      // Non-canonical signature: too long
      return false;
    }
    if (buf[0] != 0x30) {
      //  Non-canonical signature: wrong type
      return false;
    }
    if (buf[1] != buf.length - 3) {
      //  Non-canonical signature: wrong length marker
      return false;
    }
    var nLEnR = buf[3];
    if (5 + nLEnR >= buf.length) {
      //  Non-canonical signature: S length misplaced
      return false;
    }
    var nLEnS = buf[5 + nLEnR];
    if (nLEnR + nLEnS + 7 != buf.length) {
      //  Non-canonical signature: R+S length mismatch
      return false;
    }

    var R = buf.slice(4);
    if (buf[4 - 2] != 0x02) {
      //  Non-canonical signature: R value type mismatch
      return false;
    }
    if (nLEnR == 0) {
      //  Non-canonical signature: R length is zero
      return false;
    }
    if (R[0] & 0x80 == 1) {
      //  Non-canonical signature: R value negative
      return false;
    }
    if (nLEnR > 1 && R[0] == 0x00 && !(R[1] & 0x80 == 1)) {
      //  Non-canonical signature: R value excessively padded
      return false;
    }

    var S = buf.slice(6 + nLEnR);
    if (buf[6 + nLEnR - 2] != 0x02) {
      //  Non-canonical signature: S value type mismatch
      return false;
    }
    if (nLEnS == 0) {
      //  Non-canonical signature: S length is zero
      return false;
    }
    if (S[0] & 0x80 == 1) {
      //  Non-canonical signature: S value negative
      return false;
    }
    if (nLEnS > 1 && S[0] == 0x00 && !(S[1] & 0x80 == 1)) {
      //  Non-canonical signature: S value excessively padded
      return false;
    }
    return true;
  }

  // ignore: slash_for_doc_comments
  /**
     * Compares to bitcoind's IsLowDERSignature
     * See also Ecdsa signature algorithm which enforces this.
     * See also Bip 62, "low S values in signatures"
     */
  bool hasLowS() {
    if (this.s.lt(1) ||
        this.s.gt(BigIntX.fromBuffer(hex.decode(
                '7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0')
            // Buffer.from(
            //   '7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0',
            //   'hex'
            // )
            ))) {
      return false;
    }
    return true;
  }

  // ignore: slash_for_doc_comments
  /**
     * Ensures the nHashType is exactly equal to one of the standard options or combinations thereof.
     * Translated from bitcoind's IsDefinedHashtypeSignature
     */
  bool hasDefinedHashType() {
    if (this.nHashType < Sig.SIGHASH_ALL ||
        this.nHashType > Sig.SIGHASH_SINGLE) {
      return false;
    }
    return true;
  }

  List<int> toCompact({recovery, compressed}) {
    recovery = recovery == 'number' ? recovery : this.recovery;
    compressed = compressed == 'boolean' ? compressed : this.compressed;

    if (!(recovery == 0 || recovery == 1 || recovery == 2 || recovery == 3)) {
      throw ('recovery must be equal to 0, 1, 2, or 3');
    }

    var val = recovery + 27 + 4;
    if (compressed == false) {
      val = val - 4;
    }
    var b1 = List<int>.from([val]);
    var b2 = this.r.toBuffer(size: 32);
    var b3 = this.s.toBuffer(size: 32);
    return List<int>.from([
      ...b1,
      ...b2,
      ...b3,
    ]);
  }

  List<int> toRS() {
    return List<int>.from(
        [...this.r.toBuffer(size: 32), ...this.s.toBuffer(size: 32)]);
  }

  List<int> toDer() {
    var rnbuf = this.r.toBuffer();
    var snbuf = this.s.toBuffer();

    var rneg = rnbuf[0] & 0x80;
    var sneg = snbuf[0] & 0x80;

    var rbuf = rneg != 0
        ? List<int>.from([
            ...List<int>.from([0x00]),
            ...rnbuf
          ])
        : rnbuf;
    var sbuf = sneg != 0
        ? List<int>.from([
            ...List<int>.from([0x00]),
            ...snbuf
          ])
        : snbuf;

    var length = 2 + rbuf.length + 2 + sbuf.length;
    var rlength = rbuf.length;
    var slength = sbuf.length;
    var rheader = 0x02;
    var sheader = 0x02;
    var header = 0x30;

    var der = List<int>.from([
      ...List<int>.from([header, length, rheader, rlength]),
      ...rbuf,
      ...List<int>.from([sheader, slength]),
      ...sbuf,
    ]);
    return der;
  }

  List<int> toTxFormat() {
    var derbuf = this.toDer();
    var buf = Uint8List(1);
    ByteData.view(buf.buffer).setUint8(0, this.nHashType);
    return List<int>.from([
      ...derbuf,
      ...buf,
    ]);
  }

  String toString() {
    return hex.encode(this.toDer());
  }

  String toHex() {
    return this.toBuffer().toHex();
  }
}
