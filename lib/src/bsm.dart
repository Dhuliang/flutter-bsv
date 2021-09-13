import 'dart:convert';
import 'dart:typed_data';

import 'package:bsv/src/address.dart';
import 'package:bsv/src/cmp.dart';
import 'package:bsv/src/ecdsa.dart';
import 'package:bsv/src/hash.dart';
import 'package:bsv/src/key_pair.dart';
import 'package:bsv/src/sig.dart';
import 'package:bsv/src/bw.dart';
import 'package:bsv/src/extentsions/list.dart';

// ignore: slash_for_doc_comments
/**
 * Bitcoin Signed Message
 * ======================
 *
 * "Bitcoin Signed Message" just refers to a standard way of signing and
 * verifying an arbitrary message. The standard way to do this involves using a
 * "Bitcoin Signed Message:\n" prefix, which this code does. You are probably
 * interested in the static Bsm.sign( ... ) and Bsm.verify( ... ) functions,
 * which deal with a base64 string representing the compressed format of a
 * signature.
 */

class Bsm {
  static var magicBytes = utf8.encode('Bitcoin Signed Message:\n');

  List<int>? messageBuf;
  KeyPair? keyPair;
  Sig? sig;
  Address? address;
  bool? verified;

  Bsm({
    this.messageBuf,
    this.keyPair,
    this.sig,
    this.address,
    this.verified,
  });

  static Hash magicHash(List<int>? messageBuf) {
    if (!(messageBuf is List<int>)) {
      throw ('messageBuf must be a buffer');
    }
    var bw = new Bw();
    bw.writeVarIntNum(Bsm.magicBytes.length);
    bw.write(Bsm.magicBytes as Uint8List?);
    bw.writeVarIntNum(messageBuf.length);
    bw.write(messageBuf as Uint8List?);
    var buf = bw.toBuffer();

    var hashBuf = Hash.sha256Sha256(buf.asUint8List());

    return hashBuf;
  }

  // static async asyncMagicHash (messageBuf) {
  //   var args = [messageBuf]
  //   var workersResult = await Workers.asyncClassMethod(Bsm, 'magicHash', args)
  //   return workersResult.resbuf
  // }

  static String staticSign({List<int>? messageBuf, KeyPair? keyPair}) {
    var m = new Bsm(messageBuf: messageBuf, keyPair: keyPair);
    m.sign();
    var sigbuf = m.sig!.toCompact();
    // var sigstr = utf8.decode(sigbuf);
    var sigstr = base64Encode(sigbuf);
    return sigstr;
  }

  // static async asyncSign (messageBuf, keyPair) {
  //   var args = [messageBuf, keyPair]
  //   var workersResult = await Workers.asyncClassMethod(Bsm, 'sign', args)
  //   var sigstr = JSON.parse(workersResult.resbuf.toString())
  //   return sigstr
  // }

  static staticVerify({
    List<int>? messageBuf,
    required String sigstr,
    Address? address,
  }) {
    var sigbuf = base64Decode(sigstr).toList();
    var message = new Bsm();
    message.messageBuf = messageBuf;
    message.sig = new Sig().fromCompact(sigbuf);
    message.address = address;

    return message.verify().verified;
  }

  // static async asyncVerify (messageBuf, sigstr, address) {
  //   var args = [messageBuf, sigstr, address]
  //   var workersResult = await Workers.asyncClassMethod(Bsm, 'verify', args)
  //   var res = JSON.parse(workersResult.resbuf.toString())
  //   return res
  // }

  Bsm sign() {
    var hashBuf = Bsm.magicHash(this.messageBuf);
    var ecdsa = new Ecdsa(hashBuf: hashBuf.data, keyPair: this.keyPair);
    ecdsa.sign();
    ecdsa.calcrecovery();
    this.sig = ecdsa.sig;
    return this;
  }

  verify() {
    var hashBuf = Bsm.magicHash(this.messageBuf);

    var ecdsa = new Ecdsa();
    ecdsa.hashBuf = hashBuf.toBuffer();
    ecdsa.sig = this.sig;
    ecdsa.keyPair = new KeyPair();
    ecdsa.keyPair!.pubKey = ecdsa.sig2PubKey();

    if (!ecdsa.verify().verified!) {
      this.verified = false;
      return this;
    }

    var address = new Address().fromPubKey(
      ecdsa.keyPair!.pubKey!,
      // null,
      // this.sig.compressed,
    );
    // TODOS: what if livenet/testnet mismatch?
    if (cmp(
      address.hashBuf!.asUint8List(),
      this.address!.hashBuf!.asUint8List(),
    )) {
      this.verified = true;
    } else {
      this.verified = false;
    }

    return this;
  }
}
