// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:bsv/hash.dart';
// import 'package:convert/convert.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:bsv/aes.dart';

// void main() {
//   group("Aes", () {
//     final m128 = Hash.sha256(utf8.encode('test1')).data.sublist(0, 128 ~/ 8);

//     final k128 = Hash.sha256(utf8.encode('test2')).data.sublist(0, 128 ~/ 8);
//     final k192 = Hash.sha256(utf8.encode('test2')).data.sublist(0, 192 ~/ 8);
//     final k256 = Hash.sha256(utf8.encode('test2')).data.sublist(0, 256 ~/ 8);

//     final e128 = hex.decode('3477e13884125038f4dc24e9d2cfbbc7');
//     final e192 = hex.decode('b670954c0e2da1aaa5f9063de04eb961');
//     final e256 = hex.decode('dd2ce24581183a4a7c0b1068f8bc79f0');

//     group('@encrypt', () {
//       test('should encrypt with a 128 bit key', () {
//         final encBuf = Aes.encrypt(m128, k128);
//         encBuf.sublist(0, 16).buffer.asUint8List();

//         expect(hex.encode(encBuf), '3477e13884125038f4dc24e9d2cfbbc7');
//       });

//       // test('should encrypt with a 192 bit key', () {
//       //   final encBuf = Aes.encrypt(m128, k192);
//       //   encBuf.toString('hex').should.equal(e192.toString('hex'));
//       // });

//       // test('should encrypt with a 256 bit key', () {
//       //   final encBuf = Aes.encrypt(m128, k256);
//       //   encBuf.toString('hex').should.equal(e256.toString('hex'));
//       // });
//     });

//     group('@buf2Words', () {
//       test('should convert this 4 length buffer into an array', () {
//         final buf = Uint8List.fromList([0, 0, 0, 0]);
//         final words = Aes.buf2Words(buf);

//         expect(words.length, 1);
//       });

//       test('should throw an error on this 5 length buffer', () {
//         final buf = Uint8List.fromList([0, 0, 0, 0, 0]);

//         expect(() => Aes.buf2Words(buf), throwsException);
//       });
//     });

//     group('@words2Buf', () {
//       test('should convert this array into a buffer', () {
//         final a = [100, 0];
//         final buf = Aes.words2Buf(a);

//         expect(buf.length, 8);
//       });
//     });
//   });
// }
