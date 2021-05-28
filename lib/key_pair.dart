import 'dart:convert';

import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/extentsions/list.dart';

/**
 * KeyPair
 * =======
 *
 * A keyPair is a collection of a private key and a public key.
 * var keyPair = new KeyPair().fromRandom()
 * var keyPair = new KeyPair().fromPrivKey(privKey)
 * var privKey = keyPair.privKey
 * var pubKey = keyPair.pubKey
 */

class KeyPair {
  PrivKey privKey;
  PubKey pubKey;

  KeyPair({PrivKey privKey, PubKey pubKey}) {
    this.privKey = privKey;
    this.pubKey = pubKey;
  }

  factory KeyPair.fromPrivKey(privKey) {
    return new KeyPair().fromPrivKey(privKey);
  }

  factory KeyPair.fromRandom() {
    return new KeyPair().fromRandom();
  }

  KeyPair fromJSON(Map<String, dynamic> json) {
    if (json['privKey'] != null) {
      this.privKey = PrivKey.fromString(json['privKey']);
    }
    if (json['pubKey'] != null) {
      this.pubKey = PubKey.fromHex(json['pubKey']);
    }
    return this;
  }

  KeyPair fromBr(Br br) {
    var buflen1 = br.readUInt8();
    if (buflen1 > 0) {
      this.privKey = new PrivKey().fromBuffer(br.read(buflen1));
    }
    var buflen2 = br.readUInt8();
    if (buflen2 > 0) {
      this.pubKey = new PubKey().fromFastBuffer(br.read(buflen2));
    }
    return this;
  }

  Bw toBw([Bw bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    if (this.privKey != null) {
      var privKeybuf = this.privKey.toBuffer();
      bw.writeUInt8(privKeybuf.length);
      bw.write(privKeybuf.toBuffer());
    } else {
      bw.writeUInt8(0);
    }
    if (this.pubKey != null) {
      var pubKeybuf = this.pubKey.toFastBuffer();
      bw.writeUInt8(pubKeybuf.length);
      bw.write(pubKeybuf.toBuffer());
    } else {
      bw.writeUInt8(0);
    }
    return bw;
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }

  KeyPair fromBuffer(List<int> buf) {
    var br = new Br(buf: buf.toBuffer());
    return this.fromBr(br);
  }

  KeyPair fromString(String str) {
    return this.fromJSON(json.decode(str));
  }

  String toString() {
    return json.encode(this.toJSON());
  }

  Map<String, String> toJSON() {
    return {
      "privKey": privKey.toString(),
      "pubKey": pubKey.toString(),
    };
  }

  KeyPair toPublic() {
    var keyPair = new KeyPair().fromJSON(this.toJSON());
    keyPair.privKey = null;
    return keyPair;
  }

  KeyPair fromPrivKey(PrivKey privKey) {
    this.privKey = privKey;
    this.pubKey = new PubKey().fromPrivKey(privKey);
    return this;
  }

  KeyPair fromRandom() {
    this.privKey = new PrivKey().fromRandom();
    this.pubKey = new PubKey().fromPrivKey(this.privKey);
    return this;
  }
}
