// // Not implement

// import 'dart:typed_data';

// import 'package:convert/convert.dart';
// import 'package:pointycastle/export.dart';

// class Aes {
//   static Uint32List encrypt(Uint8List messageBuf, Uint8List keyBuf) {
//     final key = Aes.buf2Words(keyBuf);
//     final message = Aes.buf2Words(messageBuf);

//     final a = AESFastEngine()
//       ..init(true, KeyParameter(key.buffer.asUint8List()));

//     final enc = a.process(message.buffer.asUint8List());

//     print(hex.encode(enc));
//     final encBuf = Aes.words2Buf(enc);
//     return encBuf;
//   }

//   static Uint32List decrypt(Uint8List encBuf, Uint8List keyBuf) {
//     final enc = Aes.buf2Words(encBuf);
//     final key = Aes.buf2Words(keyBuf);

//     final a = AESFastEngine()
//       ..init(false, KeyParameter(key.buffer.asUint8List()));

//     final message = a.process(enc.buffer.asUint8List());
//     final messageBuf = Aes.words2Buf(message);
//     return messageBuf;
//   }

//   // static Uint8List buf2Words(Uint8List buf) {
//   static Uint32List buf2Words(Uint8List buf) {
//     if (buf.length % 4 != 0) {
//       throw new Exception('buf length must be a multiple of 4');
//     }

//     var length = buf.length ~/ 4;

//     var words = Uint32List(length);

//     for (var i = 0; i < length; i++) {
//       var word = buf.buffer.asByteData().getUint32(i * 4, Endian.big);
//       // print(word);
//       words[i] = word;
//     }

//     // print(words);

//     return words;
//   }

//   static Uint32List words2Buf(List<int> words) {
//     var buf = Uint32List(words.length * 4);

//     for (var i = 0; i < words.length; i++) {
//       buf.buffer.asByteData().setUint32(i * 4, words[i], Endian.big);
//     }

//     return buf;
//   }
// }
