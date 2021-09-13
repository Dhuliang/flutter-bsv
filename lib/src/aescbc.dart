// not implement

// import 'dart:convert';
import 'dart:typed_data';

// import 'package:bsv/src/random.dart';

import "package:pointycastle/export.dart";

class Aescbc {
  // Uint8List encrypt(String data, String token, String cipherIV) {
  //   var key = utf8.encode(token);
  //   var iv = utf8.encode(cipherIV);

  //   CipherParameters params = new PaddedBlockCipherParameters(
  //       new ParametersWithIV(new KeyParameter(key), iv), null);

  //   PaddedBlockCipherImpl cipherImpl = new PaddedBlockCipherImpl(
  //       new PKCS7Padding(), new CBCBlockCipher(new AESFastEngine()));
  //   cipherImpl.init(true, params);
  //   return cipherImpl.process(utf8.encode(data));
  // }

  static Uint8List encrypt(Uint8List data, Uint8List key, Uint8List iv) {
    assert(data.length != 0);
    // var key = utf8.encode(token);
    // var iv = utf8.encode(cipherIV);

    CipherParameters params = new PaddedBlockCipherParameters(
        new ParametersWithIV(new KeyParameter(key), iv), null);

    PaddedBlockCipherImpl cipherImpl = new PaddedBlockCipherImpl(
        new PKCS7Padding(), new CBCBlockCipher(new AESFastEngine()));
    cipherImpl.init(
        true,
        params as PaddedBlockCipherParameters<CipherParameters?,
            CipherParameters?>);
    // return cipherImpl.process(utf8.encode(data));
    return cipherImpl.process((data));
  }

  static Uint8List decrypt(Uint8List data, Uint8List key, Uint8List iv) {
    assert(data.length != 0);
    // var key = utf8.encode(token);
    // var iv = utf8.encode(cipherIV);

    CipherParameters params = new PaddedBlockCipherParameters(
        new ParametersWithIV(new KeyParameter(key), iv), null);

    PaddedBlockCipherImpl cipherImpl = new PaddedBlockCipherImpl(
        new PKCS7Padding(), new CBCBlockCipher(new AESFastEngine()));
    cipherImpl.init(
        false,
        params as PaddedBlockCipherParameters<CipherParameters?,
            CipherParameters?>);
    // return cipherImpl.process(utf8.encode(data));
    return cipherImpl.process((data));
  }

  // static Uint8List encrypt(
  //     {Uint8List messageBuf,
  //     Uint8List cipherKeyBuf,
  //     Uint8List ivBuf,
  //     bool concatIvBuf = true}) {
  //   ivBuf = ivBuf == null ? RandomBytes.getRandomBuffer(128 ~/ 8) : ivBuf;

  //   // final ctBuf = Cbc.encrypt(messageBuf, ivBuf, Aes, cipherKeyBuf);

  //   final ctBuf = aesCbcEncrypt(
  //       key: cipherKeyBuf, iv: ivBuf, paddedPlaintext: messageBuf);
  //   // if (concatIvBuf) {
  //   //   // return Buffer.concat([ivBuf, ctBuf]);
  //   // } else {
  //   return ctBuf;
  //   // }
  // }

  static Uint8List aesCbcEncrypt(
      {required Uint8List key,
      required Uint8List iv,
      required Uint8List paddedPlaintext}) {
    // Create a CBC block cipher with AES, and initialize with key and IV

    final cbc = CBCBlockCipher(AESFastEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

    // Encrypt the plaintext block-by-block

    final cipherText = Uint8List(paddedPlaintext.length); // allocate space

    var offset = 0;
    while (offset < paddedPlaintext.length) {
      offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
    }
    assert(offset == paddedPlaintext.length);

    return cipherText;
  }

  static Uint8List aesCbcDecrypt(
      Uint8List key, Uint8List iv, Uint8List cipherText) {
    // Create a CBC block cipher with AES, and initialize with key and IV

    final cbc = CBCBlockCipher(AESFastEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

    // Decrypt the cipherText block-by-block

    final paddedPlainText = Uint8List(cipherText.length); // allocate space

    var offset = 0;
    while (offset < cipherText.length) {
      offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
    }
    assert(offset == cipherText.length);

    return paddedPlainText;
  }
}
