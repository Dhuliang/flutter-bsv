import 'dart:convert';
import 'dart:typed_data';

import 'package:bsv/bsv.dart';
import 'package:bsv/src/bip39_cn_worldlist.dart';
import 'package:bsv/src/bip39_en_worldlist.dart';
import 'package:bsv/src/bip39_jp_worldlist.dart';
import 'package:bsv/src/br.dart';
import 'package:bsv/src/bw.dart';
import 'package:bsv/src/hash.dart';
import 'package:bsv/src/random.dart';
import 'package:bsv/src/extentsions/list.dart';
import 'package:bsv/src/extentsions/string.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';
import "package:unorm_dart/unorm_dart.dart" as unorm;

class Bip39 {
  Uint8List? seed;
  String? mnemonic;
  late List<String> worldList;
  late String worldListSpace;

  Bip39({
    Uint8List? seed,
    String? mnemonic,
    List<String>? worldList,
    String? worldListSpace,
  }) {
    this.seed = seed;
    this.mnemonic = mnemonic;
    this.worldList = worldList ?? bip39EnWorldlist;
    this.worldListSpace = worldListSpace ?? ' ';
  }

  static const INVALID_MNEMONIC = 'Invalid mnemonic';
  static const INVALID_ENTROPY = 'Invalid entropy';
  static const INVALID_CHECKSUM = 'Invalid mnemonic checksum';

  Bw toBw([Bw? bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    if (this.mnemonic != null) {
      var buf = utf8.encode(this.mnemonic!);
      bw.writeVarIntNum(buf.length);
      bw.write(buf as Uint8List?);
    } else {
      bw.writeVarIntNum(0);
    }
    if (this.seed != null) {
      bw.writeVarIntNum(this.seed!.length);
      bw.write(this.seed);
    } else {
      bw.writeVarIntNum(0);
    }
    return bw;
  }

  Bip39 fromBr(Br br) {
    var mnemoniclen = br.readVarIntNum();
    if (mnemoniclen > 0) {
      this.mnemonic = utf8.decode(br.read(mnemoniclen));
    }
    var seedlen = br.readVarIntNum();
    if (seedlen > 0) {
      this.seed = br.read(seedlen);
    }
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Generate a random new mnemonic from the wordlist.
     */
  Bip39 fromRandom([int? bits]) {
    if (bits == null) {
      bits = 128;
    }
    if (bits % 32 != 0) {
      throw ('bits must be multiple of 32');
    }
    if (bits < 128) {
      throw ('bits must be at least 128');
    }

    var buf = RandomBytes.getRandomBuffer(bits ~/ 8);
    this.entropy2Mnemonic(buf);
    this.mnemonic2Seed();
    return this;
  }

  factory Bip39.fromRandom([int? bits]) {
    return new Bip39().fromRandom(bits);
  }

  Bip39 fromEntropy(Uint8List buf) {
    this.entropy2Mnemonic(buf);
    return this;
  }

  factory Bip39.fromEntropy(Uint8List buf) {
    return new Bip39().fromEntropy(buf);
  }

  Bip39 fromString(String mnemonic) {
    this.mnemonic = mnemonic;
    return this;
  }

  factory Bip39.fromString(String mnemonic) {
    return Bip39().fromString(mnemonic);
  }

  String toString() {
    return this.mnemonic!;
  }

  Uint8List? toSeed([String? passphrase]) {
    this.mnemonic2Seed(passphrase);
    return this.seed;
  }

  // ignore: slash_for_doc_comments
  /**
     * Generate a new mnemonic from some entropy generated somewhere else. The
     * entropy must be at least 128 bits.
     */
  Bip39 entropy2Mnemonic(Uint8List buf) {
    if (!(buf is Uint8List) || buf.length < 128 / 8) {
      throw ('Entropy is less than 128 bits. It must be 128 bits or more.');
    }

    var hash = Hash.sha256(buf).data;
    var bin = '';
    var bits = buf.length * 8;
    for (var i = 0; i < buf.length; i++) {
      bin = bin + ('00000000' + buf[i].toRadixString(2)).slice(-8);
    }
    var hashbits = hash[0].toRadixString(2);
    hashbits = ('00000000' + hashbits).slice(-8).slice(0, bits ~/ 32);
    bin = bin + hashbits;

    if (bin.length % 11 != 0) {
      throw ('internal error - entropy not an even multiple of 11 bits - ${bin.length}');
    }

    var mnemonic = '';
    for (var i = 0; i < bin.length / 11; i++) {
      if (mnemonic != '') {
        mnemonic = mnemonic + this.worldListSpace;
      }
      var wi = int.tryParse(bin.slice(i * 11, (i + 1) * 11), radix: 2)!;
      mnemonic = mnemonic + this.worldList[wi];
    }

    this.mnemonic = mnemonic;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
     * Check that a mnemonic is valid. This means there should be no superfluous
     * whitespace, no invalid words, and the checksum should match.
     */
  bool check() {
    var mnemonic = this.mnemonic!;

    // confirm no invalid words
    var words = mnemonic.split(this.worldListSpace);
    var bin = '';
    for (var i = 0; i < words.length; i++) {
      var ind = this.worldList.indexOf(words[i]);
      if (ind < 0) {
        return false;
      }
      bin = bin + ('00000000000' + ind.toRadixString(2)).slice(-11);
    }

    if (bin.length % 11 != 0) {
      throw ('internal error - entropy not an even multiple of 11 bits - ${bin.length}');
    }

    // confirm checksum
    var cs = bin.length ~/ 33;
    var hashBits = bin.slice(-cs);
    var nonhashBits = bin.slice(0, bin.length - cs);
    var buf = Uint8List(nonhashBits.length ~/ 8);
    for (var i = 0; i < nonhashBits.length / 8; i++) {
      ByteData.view(buf.buffer)
          .setUint8(i, int.tryParse(bin.slice(i * 8, (i + 1) * 8), radix: 2)!);
      // buf.writeUInt8( int.tryParse (bin.slice(i * 8, (i + 1) * 8), radix:2), i);
    }
    var hash = Hash.sha256(buf).data;
    var expectedHashBits = hash[0].toRadixString(2);
    expectedHashBits = ('00000000' + expectedHashBits).slice(-8).slice(0, cs);

    return expectedHashBits == hashBits;
  }

  // ignore: slash_for_doc_comments
  /**
     * Convert a mnemonic to a seed. Does not check for validity of the mnemonic -
     * for that, you should manually run check() first.
     */
  Bip39 mnemonic2Seed([String? passphrase]) {
    passphrase = passphrase ?? '';
    var mnemonic = this.mnemonic!;
    if (!this.check()) {
      throw ('Mnemonic does not pass the check - was the mnemonic typed incorrectly? Are there extra spaces?');
    }
    // if (typeof passphrase != 'string') {
    //   throw ('passphrase must be a string or undefined')
    // }

    mnemonic = unorm.nfkd(mnemonic);
    passphrase = unorm.nfkd(passphrase);
    var mbuf = Uint8List.fromList(utf8.encode(mnemonic));
    var pbuf = Uint8List.fromList([
      ...utf8.encode('mnemonic'),
      ...utf8.encode(passphrase),
    ]);
    // this.seed = pbkdf2.pbkdf2Sync(mbuf, pbuf, 2048, 64, 'sha512')

    // final hmacSha512 = HMac(SHA512Digest(), 2048)..init(KeyParameter(mbuf));
    // final derivator = PBKDF2KeyDerivator(hmacSha512);
    final derivator = KeyDerivator('SHA-512/HMAC/PBKDF2')
      ..init(Pbkdf2Parameters(pbuf, 2048, 64));

    // KeyDerivator('SHA-512/HMAC/PBKDF2')
    //   ..init(Pbkdf2Parameters(mbuf, 2048, 64))
    //   ..process(pbuf);

    // this.seed = derivator.process(pbuf);
    this.seed = derivator.process(mbuf);

    return this;
  }

  bool isValid([String? passphrase]) {
    passphrase = passphrase ?? '';
    bool isValid;
    try {
      this.mnemonic2Seed(passphrase);
      isValid = true;
    } catch (err) {
      isValid = false;
    }
    return isValid;
  }

  static bool staticIsValid(String mnemonic, [String passphrase = '']) {
    return new Bip39(mnemonic: mnemonic).isValid(passphrase);
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }

  Bip39 fromBuffer(List<int> buf) {
    return this.fromBr(Br(buf: buf.asUint8List()));
  }

  // String toString() {
  //   return Base58Check.encode(this.toBuffer().asUint8List());
  // }

  // // toJSON() {
  // //   return this.toFastHex();
  // // }

  // // fromJSON(json) {
  // //   return this.fromFastHex(json);
  // // }

  // Bip32 fromHex(String str) {
  //   return this.fromBuffer(hex.decode(str));
  // }

  // String toHex() {
  //   return this.toBuffer().toHex();
  // }

  // bool isPrivate() {
  //   return this.versionBytesNum == this.bip32PrivKey;
  // }

  // String toEntropy([String? passphrase]) {
  //   return this.toSeed(passphrase)!.toHex();
  // }

//Uint8List _createUint8ListFromString( String s ) {
//  var ret = new Uint8List(s.length);
//  for( var i=0 ; i<s.length ; i++ ) {
//    ret[i] = s.codeUnitAt(i);
//  }
//  return ret;
//}

  static String bytesToBinary(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
  }

  static int binaryToByte(String binary) {
    return int.parse(binary, radix: 2);
  }

  static String deriveChecksumBits(Uint8List entropy) {
    final ent = entropy.length * 8;
    final cs = ent ~/ 32;
    final hash = Hash.sha256(entropy);
    return bytesToBinary(Uint8List.fromList(hash.data)).slice(0, cs);
  }

  static String entropyToMnemonic(String entropyString) {
    final List<int> entropy = hex.decode(entropyString);
    if (entropy.length < 16) {
      throw ArgumentError(INVALID_ENTROPY);
    }
    if (entropy.length > 32) {
      throw ArgumentError(INVALID_ENTROPY);
    }
    if (entropy.length % 4 != 0) {
      throw ArgumentError(INVALID_ENTROPY);
    }
    final entropyBits = bytesToBinary(Uint8List.fromList(entropy));
    final checksumBits = deriveChecksumBits(Uint8List.fromList(entropy));
    final bits = entropyBits + checksumBits;
    final regex =
        new RegExp(r".{1,11}", caseSensitive: false, multiLine: false);
    final chunks = regex
        .allMatches(bits)
        .map((match) => match.group(0))
        .toList(growable: false);
    List<String> wordlist = Globals.bip39Worldlist;
    String words = chunks
        .map((binary) => wordlist[binaryToByte(binary!)])
        .join(Globals.bip39WorldSpace);
    return words;
  }

  static String mnemonicToEntropy(String mnemonic) {
    var words = mnemonic.split(Globals.bip39WorldSpace);

    if (words.length % 3 != 0) {
      throw new ArgumentError(INVALID_MNEMONIC);
    }
    final wordlist = Globals.bip39Worldlist;
    // convert word indices to 11 bit binary strings
    final bits = words.map((word) {
      final index = wordlist.indexOf(word);
      if (index == -1) {
        throw new ArgumentError(INVALID_MNEMONIC);
      }
      return index.toRadixString(2).padLeft(11, '0');
    }).join('');
    // split the binary string into ENT/CS
    final dividerIndex = (bits.length / 33).floor() * 32;
    final entropyBits = bits.substring(0, dividerIndex);
    final checksumBits = bits.substring(dividerIndex);

    // calculate the checksum and compare
    final entropyBytes = Uint8List.fromList(RegExp(r".{1,8}")
        .allMatches(entropyBits)
        .map((match) => binaryToByte(match.group(0)!))
        .toList(growable: false));

    if (entropyBytes.length < 16) {
      throw StateError(INVALID_ENTROPY);
    }
    if (entropyBytes.length > 32) {
      throw StateError(INVALID_ENTROPY);
    }
    if (entropyBytes.length % 4 != 0) {
      throw StateError(INVALID_ENTROPY);
    }
    final newChecksum = deriveChecksumBits(entropyBytes);
    if (newChecksum != checksumBits) {
      throw StateError(INVALID_CHECKSUM);
    }

    final entropy = hex.encode(entropyBytes);
    return entropy;
  }
}

class Bip39En extends Bip39 {
  Bip39En({
    Uint8List? seed,
    String? mnemonic,
  }) : super(seed: seed, mnemonic: mnemonic) {
    this.worldList = bip39EnWorldlist;
    this.worldListSpace = bip39EnWorldSpace;
  }
}

class Bip39Cn extends Bip39 {
  Bip39Cn({
    Uint8List? seed,
    String? mnemonic,
  }) : super(seed: seed, mnemonic: mnemonic) {
    this.worldList = bip39CnWorldlist;
    this.worldListSpace = bip39CnWorldSpace;
  }
}

class Bip39Jp extends Bip39 {
  Bip39Jp({
    Uint8List? seed,
    String? mnemonic,
  }) : super(seed: seed, mnemonic: mnemonic) {
    this.worldList = bip39JpWorldlist;
    this.worldListSpace = bip39JpWorldSpace;
  }
}
