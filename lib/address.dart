import 'dart:typed_data';

import 'package:bsv/constants.dart';
import 'package:bsv/hash.dart';
import 'package:bsv/op_code.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/script.dart';
import 'package:convert/convert.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:bs58check/bs58check.dart' as Base58Check;

// ignore: slash_for_doc_comments
/**
 * Bitcoin Address
 * ===============
 *
 * A bitcoin address. Normal use cases:
 * var address = new Address().fromPubKey(pubKey)
 * var address = new Address().fromString(string)
 * var string = address.toString()
 * var script = address.toTxOutScript()
 * var isValid = Address.isValid(string)
 *
 * Can also do testnet:
 * var address = Address.Testnet()
 *
 * Note that an Address and an Addr are two completely different things. An
 * Address is what you send bitcoin to. An Addr is an ip address and port that
 * you connect to over the internet.
 */

class Address {
  int? pubKeyHash;
  int? versionByteNum;
  int? payToScriptHash;
  List<int>? hashBuf;

  Address({
    int? pubKeyHash,
    int? versionByteNum,
    int? payToScriptHash,
    List<int>? hashBuf,
  }) {
    this.versionByteNum = versionByteNum;
    this.hashBuf = hashBuf;
    this.pubKeyHash = pubKeyHash ?? Globals.network.addressPubKeyHash;
    this.payToScriptHash =
        payToScriptHash ?? Globals.network.addressPayToScriptHash;
  }

  static const INVALID_ADDRESS_LENGTH =
      'address buffers must be exactly 21 bytes';

  static const INVALID_ADDRESS_VERSION_BYTE_NUM_BYTE =
      'address: invalid versionByteNum byte';

  static const INVALID_ADDRESS_HASH_BUF =
      'hashBuf must be a buffer of 20 bytes';

  static const INVALID_ADDRESS_VERSION_BYTE_NUM = 'invalid versionByteNum';

  Address fromBuffer(List<int> buf) {
    if (buf.length != 1 + 20) {
      throw INVALID_ADDRESS_LENGTH;
    }
    if (buf[0] != this.pubKeyHash) {
      throw INVALID_ADDRESS_VERSION_BYTE_NUM_BYTE;
    }
    this.versionByteNum = buf[0];
    this.hashBuf = buf.slice(1);
    return this;
  }

  factory Address.fromBuffer(List<int> buf) {
    return Address().fromBuffer(buf);
  }

  Address fromHex(String str) {
    return this.fromBuffer(hex.decode(str));
  }

  Address fromPubKeyHashBuf(List<int> hashBuf) {
    this.hashBuf = hashBuf;
    this.versionByteNum = this.pubKeyHash;
    return this;
  }

  factory Address.fromPubKeyHashBuf(List<int> hashBuf) {
    return Address().fromPubKeyHashBuf(hashBuf);
  }

  Address fromPubKey(PubKey pubKey) {
    var hashBuf = Hash.sha256Ripemd160(pubKey.toBuffer().asUint8List());
    return this.fromPubKeyHashBuf(hashBuf.toBuffer());
  }

  factory Address.fromPubKey(PubKey pubKey) {
    return Address().fromPubKey(pubKey);
  }

  Address fromPrivKey(PrivKey privKey) {
    var pubKey = new PubKey().fromPrivKey(privKey);
    var hashBuf = Hash.sha256Ripemd160(pubKey.toBuffer().asUint8List());
    return this.fromPubKeyHashBuf(hashBuf.toBuffer());
  }

  factory Address.fromPrivKey(PrivKey privKey) {
    return Address().fromPrivKey(privKey);
  }

  Address fromRandom() {
    var randomPrivKey = PrivKey.fromRandom();
    return this.fromPrivKey(randomPrivKey);
  }

  factory Address.fromRandom() {
    return Address().fromRandom();
  }

  Address fromString(String str) {
    var buf = Base58Check.decode(str);
    return this.fromBuffer(buf.toList());
  }

  factory Address.fromString(String str) {
    return Address().fromString(str);
  }

  static bool staticIsValid(String addrstr) {
    Address address;
    try {
      address = new Address().fromString(addrstr);
    } catch (e) {
      return false;
    }
    return address.isValid();
  }

  // ignore: unused_element
  bool isValid() {
    try {
      this.validate();
      return true;
    } catch (e) {
      return false;
    }
  }

  Script toTxOutScript() {
    var script = new Script();
    script.writeOpCode(OpCode.OP_DUP);
    script.writeOpCode(OpCode.OP_HASH160);
    script.writeBuffer(this.hashBuf!.asUint8List());
    script.writeOpCode(OpCode.OP_EQUALVERIFY);
    script.writeOpCode(OpCode.OP_CHECKSIG);

    return script;
  }

  Address fromTxInScript(Script script) {
    var pubKeyHashBuf = Hash.sha256Ripemd160(
      script.chunks[1].buf ?? hex.decode('00' * 32) as Uint8List,
    );
    return this.fromPubKeyHashBuf(pubKeyHashBuf.toBuffer());
  }

  factory Address.fromTxInScript(Script script) {
    return new Address().fromTxInScript(script);
  }

  Address fromTxOutScript(Script script) {
    return this.fromPubKeyHashBuf(script.chunks[2].buf!);
  }

  factory Address.fromTxOutScript(Script script) {
    return new Address().fromTxOutScript(script);
  }

  List<int> toBuffer() {
    var versionByteBuf = List<int>.from([this.versionByteNum]);
    var buf = List<int>.from([...versionByteBuf, ...this.hashBuf!]);
    return buf;
  }

  // toJSON () {
  //   var json = {}
  //   if (this.hashBuf) {
  //     json.hashBuf = this.hashBuf.toString('hex')
  //   }
  //   if (typeof this.versionByteNum != 'undefined') {
  //     json.versionByteNum = this.versionByteNum
  //   }
  //   return json
  // }

  // fromJSON (json) {
  //   if (json.hashBuf) {
  //     this.hashBuf = Buffer.from(json.hashBuf, 'hex')
  //   }
  //   if (typeof json.versionByteNum != 'undefined') {
  //     this.versionByteNum = json.versionByteNum
  //   }
  //   return this
  // }

  String toString() {
    return Base58Check.encode(this.toBuffer().asUint8List());
  }

  Address validate() {
    if (!(this.hashBuf is List<int>) || this.hashBuf!.length != 20) {
      throw INVALID_ADDRESS_HASH_BUF;
    }
    if (this.versionByteNum != this.pubKeyHash) {
      throw INVALID_ADDRESS_VERSION_BYTE_NUM;
    }
    return this;
  }

  String toHex() {
    return this.toBuffer().toHex();
  }

  // ignore: non_constant_identifier_names
  factory Address.Testnet({
    int? versionByteNum,
    List<int>? hashBuf,
  }) {
    return Address(
      versionByteNum: versionByteNum,
      hashBuf: hashBuf,
      pubKeyHash: Constants.Testnet.addressPubKeyHash,
      payToScriptHash: Constants.Testnet.addressPayToScriptHash,
    );
  }

  // ignore: non_constant_identifier_names
  factory Address.Regtest({
    int? versionByteNum,
    List<int>? hashBuf,
  }) {
    return Address(
      versionByteNum: versionByteNum,
      hashBuf: hashBuf,
      pubKeyHash: Constants.Regtest.addressPubKeyHash,
      payToScriptHash: Constants.Regtest.addressPayToScriptHash,
    );
  }

  // ignore: non_constant_identifier_names
  factory Address.Mainnet({
    int? versionByteNum,
    List<int>? hashBuf,
  }) {
    return Address(
      versionByteNum: versionByteNum,
      hashBuf: hashBuf,
      pubKeyHash: Globals.network.addressPubKeyHash,
      payToScriptHash: Globals.network.addressPayToScriptHash,
    );
  }
}
