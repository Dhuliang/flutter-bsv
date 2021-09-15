import 'dart:typed_data';

// import 'package:bsv/src/common_util.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';

class Hash {
  // static Map<String, Function> shaFuncMap = {
  //   "sha1": sha1,
  //   "sha256": sha256,
  //   "sha512": sha512,
  // };
  Uint8List data;
  Hash({required this.data});

  String get toHex => hex.encode(this.data);

  List<int> toBuffer() => this.data.toList();

  ByteBuffer get buffer => this.data.buffer;

  static int sha1BlockSize = 512;
  static int sha256BlockSize = 512;
  static int sha512BlockSize = 1024;

  static Map<String, int> shaBlockSizeMap = {
    "sha1": sha1BlockSize,
    "sha256": sha256BlockSize,
    "sha512": sha512BlockSize,
  };

  static Hash sha1(Uint8List data) {
    final sha1 = SHA1Digest();
    return Hash(data: sha1.process(data));
  }

  static Hash sha256(Uint8List data) {
    final sha256 = SHA256Digest();

    return Hash(data: sha256.process(data));
  }

  static Hash sha256Sha256(Uint8List data) {
    return sha256(sha256(data).data);
  }

  static Hash ripemd160(Uint8List data) {
    final ripemd160 = RIPEMD160Digest();
    return Hash(data: ripemd160.process(data));
  }

  static Hash sha256Ripemd160(Uint8List data) {
    return ripemd160(sha256(data).data);
  }

  static Hash sha512(Uint8List data) {
    final sha512 = SHA512Digest();
    return Hash(data: sha512.process(data));
  }

  static Hash sha1Hmac(Uint8List data, Uint8List key) {
    final hmac = HMac(SHA1Digest(), 64)..init(KeyParameter(key));
    return Hash(data: hmac.process(data));
  }

  static Hash sha256Hmac(Uint8List data, Uint8List key) {
    final hmac = HMac(SHA256Digest(), 64)..init(KeyParameter(key));
    return Hash(data: hmac.process(data));
  }

  static Hash sha512Hmac(Uint8List data, Uint8List key) {
    final hmac = HMac(SHA512Digest(), 128)..init(KeyParameter(key));
    return Hash(data: hmac.process(data));
  }
}
