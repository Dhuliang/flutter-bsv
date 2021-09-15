import 'dart:convert';
import 'dart:typed_data';

import 'package:bsv/src/bn.dart';
import 'package:bsv/src/br.dart';
import 'package:bsv/src/hash.dart';
import 'package:bsv/src/key_pair.dart';
import 'package:bsv/src/point.dart';
import 'package:bsv/src/pub_key.dart';
import 'package:bsv/src/random.dart';
import 'package:bsv/src/sig.dart';

import 'package:bsv/src/extentsions/list.dart';
import 'package:convert/convert.dart';

// ignore: slash_for_doc_comments
/**
 * Ecdsa
 * ====
 *
 * Ecdsa is the signature algorithm used by bitcoin. The way you probably want
 * to use this is with the static Ecdsa.sign( ... ) and Ecdsa.verify( ... )
 * functions. Note that in bitcoin, the hashBuf is little endian, so if you are
 * signing or verifying something that has to do with a transaction, you should
 * explicitly plug in that it is little endian as an option to the sign and
 * verify functions.
 *
 * This implementation of Ecdsa uses deterministic signatures as defined in RFC
 * 6979 as the default, which has become a defacto standard in bitcoin wallets
 * due to recurring security issues around using a value of k pulled from a
 * possibly faulty entropy pool. If you use the same value of k twice, someone
 * can derive your private key. Deterministic k prevents this without needing
 * an entropy pool.
 */

class Ecdsa {
  Sig? sig;
  KeyPair? keyPair;
  List<int>? hashBuf;
  BigIntX? k;
  Endian? endian;
  bool? verified;

  Ecdsa({
    this.sig,
    this.keyPair,
    this.hashBuf,
    this.k,
    this.endian,
    this.verified,
  });

  Map<String, dynamic> toJSON() {
    return {
      "sig": this.sig != null ? this.sig.toString() : null,
      "keyPair": this.keyPair != null ? this.keyPair!.toBuffer().toHex() : null,
      "hashBuf": this.hashBuf != null ? this.hashBuf!.toHex() : null,
      "k": this.k != null ? this.k.toString() : null,
      "endian": this.endian,
      "verified": this.verified
    };
  }

  Ecdsa fromJSON(Map<String, dynamic> json) {
    this.sig = json['sig'] != null ? new Sig().fromString(json['sig']) : null;
    this.keyPair = json['keyPair'] != null
        ? new KeyPair().fromBuffer(hex.decode(json['keyPair']))
        : null;
    this.hashBuf = json['hashBuf'] != null ? hex.decode(json['hashBuf']) : null;
    this.k = json['k'] != null ? new BigIntX.fromString(json['k']) : null;
    this.endian = json['endian'];
    this.verified = json['verified'];
    return this;
  }

  List<int> toBuffer() {
    var str = json.encode(this.toJSON());
    return utf8.encode(str);
  }

  Ecdsa fromBuffer(List<int> buf) {
    // var map = json.decode(buf.toString());
    var map = json.decode(utf8.decode(buf));
    return this.fromJSON(map);
  }

  Ecdsa calcrecovery() {
    for (var recovery = 0; recovery < 4; recovery++) {
      // ignore: non_constant_identifier_names
      PubKey Qprime;
      this.sig!.recovery = recovery;
      try {
        Qprime = this.sig2PubKey();
      } catch (e) {
        continue;
      }

      // if (Qprime.point.eq(this.keyPair.pubKey.point)) {
      if (Qprime.point == this.keyPair!.pubKey!.point) {
        var compressed = this.keyPair!.pubKey!.compressed;
        this.sig!.compressed =
            this.keyPair!.pubKey!.compressed == null ? true : compressed;
        return this;
      }
    }

    this.sig!.recovery = null;
    throw ('Unable to find valid recovery factor');
  }

  // ignore: slash_for_doc_comments
  /**
   * Calculates the recovery factor, and mutates sig so that it now contains
   * the recovery factor and the "compressed" variable. Throws an exception on
   * failure.
   */
  static Sig? staticCalcrecovery({
    Sig? sig,
    PubKey? pubKey,
    List<int>? hashBuf,
  }) {
    var ecdsa = new Ecdsa(
      sig: sig,
      keyPair: new KeyPair(pubKey: pubKey),
      hashBuf: hashBuf,
    );
    return ecdsa.calcrecovery().sig;
  }

  Ecdsa fromString(String str) {
    var obj = json.decode(str);
    if (obj['hashBuf'] != null) {
      this.hashBuf = hex.decode(obj['hashBuf']);
    }
    if (obj['keyPair'] != null) {
      this.keyPair = new KeyPair().fromString(obj['keyPair']);
    }
    if (obj['sig'] != null) {
      this.sig = new Sig().fromString(obj['sig']);
    }
    if (obj['k'] != null) {
      this.k = new BigIntX.fromString(obj['k']);
    }
    return this;
  }

  randomK() {
    var N = PointWrapper.getN();
    var k;
    do {
      k = new BigIntX.fromBuffer(RandomBytes.getRandomBuffer(32));
    } while (!(k.lt(N) && k.gt(0)));
    this.k = k;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * The traditional Ecdsa algorithm uses a purely random value of k. This has
     * the negative that when signing, your entropy must be good, or the private
     * key can be recovered if two signatures use the same value of k. It turns out
     * that k does not have to be purely random. It can be deterministic, so long
     * as an attacker can't guess it. RFC 6979 specifies how to do this using a
     * combination of the private key and the hash of the thing to be signed. It is
     * best practice to use this value, which can be tested for byte-for-byte
     * accuracy, and is resistant to a broken RNG. Note that it is actually the
     * case that bitcoin private keys have been compromised through that attack.
     * Deterministic k is a best practice.
     *
     * https://tools.ietf.org/html/rfc6979#section-3.2
     */
  Ecdsa deterministicK([int? badrs]) {
    var v = List.generate(32, (index) => 0x01).asUint8List();
    var k = List.generate(32, (index) => 0x00).asUint8List();
    var x = this.keyPair!.privKey!.bn!.toBuffer(size: 32).asUint8List();
    k = Hash.sha256Hmac(
      Uint8List.fromList([
        ...v,
        ...[0x00],
        ...x,
        ...this.hashBuf as Iterable<int>
      ]),
      k,
    ).data;

    v = Hash.sha256Hmac(v, k).data;
    k = Hash.sha256Hmac(
      Uint8List.fromList([
        ...v,
        ...[0x01],
        ...x,
        ...this.hashBuf as Iterable<int>
      ]),
      k,
    ).data;
    v = Hash.sha256Hmac(v, k).data;
    v = Hash.sha256Hmac(v, k).data;
    var T = new BigIntX.fromBuffer(v);
    var N = PointWrapper.getN();

    // if r or s were invalid when this function was used in signing,
    // we do not want to actually compute r, s here for efficiency, so,
    // we can increment badrs. explained at end of RFC 6979 section 3.2
    if (badrs == null) {
      badrs = 0;
    }

    // also explained in 3.2, we must ensure T is in the proper range (0, N)
    for (var i = 0; i < badrs || !(T.lt(N) && T.gt(0)); i++) {
      k = Hash.sha256Hmac(
        Uint8List.fromList([
          ...v,
          ...([0x00])
        ]),
        k,
      ).data;
      v = Hash.sha256Hmac(v, k).data;
      v = Hash.sha256Hmac(v, k).data;
      T = new BigIntX.fromBuffer(v);
    }

    this.k = T;
    return this;
  }

  PubKey sig2PubKey() {
    var recovery = this.sig!.recovery!;
    if (!(recovery == 0 || recovery == 1 || recovery == 2 || recovery == 3)) {
      throw ('i must be equal to 0, 1, 2, or 3');
    }

    var e = new BigIntX.fromBuffer(this.hashBuf!);
    var r = this.sig!.r!;
    var s = this.sig!.s!;

    // A set LSB signifies that the y-coordinate is odd
    var isYOdd = recovery & 1;

    // The more significant bit specifies whether we should use the
    // first or second candidate key.
    var isSecondKey = (recovery >> 1) == 1;

    var n = PointWrapper.getN();
    var G = PointWrapper.getG();

    // 1.1 var x = r + jn
    var x = isSecondKey ? r.add(n) : r;
    var R = PointWrapper.fromX(isOdd: isYOdd == 1, x: x.bn);

    // 1.4 Check that nR is at infinity
    // var errm = '';

    // 1.4 Check that nR is at infinity
    var nR = R.mul(n);
    if (!nR.isInfinity) {
      throw ('nR is not a valid curve point');
    }
    // try {
    //   var result = R.mul(n);
    //   print(result);
    //   // if(result.isInfinity){}
    // } catch (err) {
    //   errm = err.message;
    // }
    // if (errm != 'point mul out of range') {
    //   throw ('nR is not a valid curve point');
    // }

    // Compute -e from e
    var eNeg = e.neg().umod(n);

    // 1.6.1 Compute Q = r^-1 (sR - eG)
    // Q = r^-1 (sR + -eG)
    var rInv = r.invm(n);

    // var Q = R.multiplyTwo(s, G, eNeg).mul(rInv)
    var Q = R.mul(s).add(G.mul(eNeg)).mul(rInv);

    var pubKey = new PubKey(point: Q);
    pubKey.compressed = this.sig!.compressed;
    pubKey.validate();

    return pubKey;
  }

  static PubKey staticSig2PubKey({Sig? sig, List<int>? hashBuf}) {
    var ecdsa = new Ecdsa(sig: sig, hashBuf: hashBuf);
    return ecdsa.sig2PubKey();
  }

  dynamic verifyStr([bool? enforceLowS]) {
    enforceLowS = enforceLowS ?? true;
    if (!(this.hashBuf is List<int>) || this.hashBuf!.length != 32) {
      return 'hashBuf must be a 32 byte buffer';
    }

    try {
      this.keyPair!.pubKey!.validate();
    } catch (e) {
      return 'Invalid pubKey: ${e.toString()}';
    }

    var r = this.sig!.r!;
    var s = this.sig!.s;
    if (!(r.gt(0) && r.lt(PointWrapper.getN())) ||
        !(s!.gt(0) && s.lt(PointWrapper.getN()))) {
      return 'r and s not in range';
    }

    if (enforceLowS) {
      if (!this.sig!.hasLowS()) {
        return 's is too high and does not satisfy low s contraint - see bip 62';
      }
    }

    var e = new BigIntX.fromBuffer(
      this.hashBuf!,
      endian: this.endian != null ? this.endian : null,
    );
    var n = PointWrapper.getN();
    var sinv = s.invm(n);
    var u1 = sinv.mul(e).mod(n);
    var u2 = sinv.mul(r).mod(n);

    var p = PointWrapper.getG().mulAdd(u1, this.keyPair!.pubKey!.point!, u2);
    // var p = Point.getG().mulAdd(u1, this.keyPair.pubKey.point, u2)
    if (p.isInfinity) {
      return 'p is infinity';
    }

    if (!(p.getX().mod(n).cmp(r) == 0)) {
      return 'Invalid signature';
    } else {
      return false;
    }
  }

  Ecdsa sign() {
    var hashBuf = this.endian == Endian.little
        ? new Br(buf: this.hashBuf!.asUint8List()).readReverse()
        : this.hashBuf;

    var privKey = this.keyPair?.privKey;

    var d = privKey?.bn;

    if (hashBuf == null || privKey == null || d == null) {
      throw 'invalid parameters';
    }

    if (!(hashBuf is List<int>) || hashBuf.length != 32) {
      throw 'hashBuf must be a 32 byte buffer';
    }

    var N = PointWrapper.getN();
    var G = PointWrapper.getG();
    var e = new BigIntX.fromBuffer(hashBuf);

    // try different values of k until r, s are valid
    var badrs = 0;
    var k, Q, r, s;
    do {
      if (this.k == null || badrs > 0) {
        this.deterministicK(badrs);
      }
      badrs++;
      k = this.k;
      Q = G.mul(k);
      r = Q.getX().mod(N);
      s = k.invm(N).mul(e.add(d.mul(r))).mod(N);
    } while (r.cmp(0) <= 0 || s.cmp(0) <= 0);

    // enforce low s
    // see Bip 62, "low S values in signatures"
    if (s.gt(new BigIntX.fromBuffer(hex.decode(
        '7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0')))) {
      s = PointWrapper.getN().sub(s);
    }
    this.sig = Sig(
      r: r,
      s: s,
      compressed: this.keyPair!.pubKey!.compressed,
    );
    return this;
  }

  Ecdsa signRandomK() {
    this.randomK();
    return this.sign();
  }

  String toString() {
    var obj = {};
    if (this.hashBuf != null) {
      obj['hashBuf'] = this.hashBuf!.toHex();
    }
    if (this.keyPair != null) {
      obj['keyPair'] = this.keyPair.toString();
    }
    if (this.sig != null) {
      obj['sig'] = this.sig.toString();
    }
    if (this.k != null) {
      obj['k'] = this.k.toString();
    }
    return json.encode(obj);
  }

  Ecdsa verify([bool? enforceLowS]) {
    enforceLowS = enforceLowS ?? true;
    var result = this.verifyStr(enforceLowS);
    late var verified;
    if (result is bool) {
      verified = result;
    }
    if (result is String) {
      verified = result.isNotEmpty;
    }

    if (!verified) {
      this.verified = true;
    } else {
      this.verified = false;
    }
    return this;
  }

  static Sig? staticSign({
    List<int>? hashBuf,
    KeyPair? keyPair,
    Endian? endian,
  }) {
    return new Ecdsa(
      hashBuf: hashBuf,
      endian: endian,
      keyPair: keyPair,
    ).sign().sig;
  }

  static bool? staticVerify({
    List<int>? hashBuf,
    Sig? sig,
    PubKey? pubKey,
    Endian? endian,
    bool enforceLowS = true,
  }) {
    return Ecdsa(
      hashBuf: hashBuf,
      endian: endian,
      sig: sig,
      keyPair: new KeyPair(pubKey: pubKey),
    ).verify(enforceLowS).verified;
  }
}
