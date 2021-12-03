import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/src/hash.dart';
import 'package:convert/convert.dart';
import './vectors/hash.dart';

void main() {
  group("Hash", () {
    final buf = Uint8List.fromList([0, 1, 2, 3, 253, 254, 255]);
    print(buf.buffer.asByteData());
    // String str = "test string";

    test('should have the blockSize for some hash functions', () {
      expect(Hash.shaBlockSizeMap['sha1'], 512);
      expect(Hash.shaBlockSizeMap['sha256'], 512);
      expect(Hash.shaBlockSizeMap['sha512'], 1024);
    });

    // not implement type checking
    // group('@hmac', () {
    //   test('should throw errors in these cases', () {
    //     expect(
    //         () => Hash.hmac('non-supported-hash-function',
    //             Uint8List(0), Uint8List(0)),
    //         throwsException);
    //   });
    // });

    group("@sha1", () {
      test('should calculate the hash of this buffer correctly', () {
        var hash = Hash.sha1(buf);
        // print(hex.encode(hash));
        // print(hash);
        expect(hash.toHex(), 'de69b8a4a5604d0486e6420db81e39eb464a17b2');
        hash = Hash.sha1(Uint8List(0));
        // print(hex.encode(hash));
        // print(hash);
        expect(hash.toHex(), 'da39a3ee5e6b4b0d3255bfef95601890afd80709');
      });
    });

    group('@sha1Hmac', () {
      test('should calculate this known empty test vector correctly', () {
        var _hex = 'b617318655057264e28bc0b6fb378c8ef146be00';

        // print(utf8.encode('Hi There'));
        // print(hex.decode('0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b'));

        var data = utf8.encode('Hi There');
        var key = hex.decode('0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b');
        final hash = Hash.sha1Hmac(data as Uint8List, key as Uint8List);

        expect(hash.toHex(), _hex);
      });
    });

    group("@sha256", () {
      test('should calculate the hash of this buffer correctly', () {
        var hash = Hash.sha256(buf);
        expect(hash.toHex(),
            '6f2c7b22fd1626998287b3636089087961091de80311b9279c4033ec678a83e8');
      });

      test('should compute a hash for 5mb data', () {
        // this.timeout(10000)
        final data = Uint8List(5e6.toInt());

        final hash1 = Hash.sha256(data);
        final hash2 = Hash.sha256(data);

        expect(hash1.toHex(), hash2.toHex());
      }, timeout: Timeout(Duration(milliseconds: 10000)));
    });

    group("@sha256Hmac", () {
      test('should compute this known empty test vector correctly', () {
        final key = utf8.encode('');
        final data = utf8.encode('');

        var hash = Hash.sha256Hmac(data as Uint8List, key as Uint8List);
        expect(hash.toHex(),
            'b613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad');
      });

      test('should compute this known non-empty test vector correctly', () {
        final key = utf8.encode('key');
        final data = utf8.encode('The quick brown fox jumps over the lazy dog');
        var hash = Hash.sha256Hmac(data as Uint8List, key as Uint8List);

        expect(hash.toHex(),
            'f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8');
      });
    });

    group('@sha256Sha256', () {
      test('should calculate the hash of this buffer correctly', () {
        final hash = Hash.sha256Sha256(buf);

        expect(hash.toHex(),
            'be586c8b20dee549bdd66018c7a79e2b67bb88b7c7d428fa4c970976d2bec5ba');
      });
    });

    group('@sha256Ripemd160', () {
      test('should calculate the hash of this buffer correctly', () {
        final hash = Hash.sha256Ripemd160(buf);
        expect(hash.toHex(), '7322e2bd8535e476c092934e16a6169ca9b707ec');
      });
    });

    group('@ripemd160', () {
      test('should calculate the hash of this buffer correctly', () {
        final hash = Hash.ripemd160(buf);
        expect(hash.toHex(), 'fa0f4565ff776fee0034c713cbf48b5ec06b7f5c');
      });
    });

    group('@sha512', () {
      test('should calculate the hash of this buffer correctly', () {
        final hash = Hash.sha512(buf);

        expect(hash.toHex(),
            'c0530aa32048f4904ae162bc14b9eb535eab6c465e960130005feddb71613e7d62aea75f7d3333ba06e805fc8e45681454524e3f8050969fe5a5f7f2392e31d0');
      });
    });

    group('@sha512Hmac', () {
      test(
          'should calculate this value where key size is the same as block size',
          () {
        final key = Uint8List(Hash.sha512BlockSize ~/ 8);
        final data = Uint8List(0);

        // // test vector calculated with node's createHmac
        final _hex =
            'b936cee86c9f87aa5d3c6f2e84cb5a4239a5fe50480a6ec66b70ab5b1f4ac6730c6c515421b327ec1d69402e53dfb49ad7381eb067b338fd7b0cb22247225d47';

        final hash = Hash.sha512Hmac(data, key);

        expect(hash.toHex(), _hex);
      });

      test('should calculate this known empty test vector correctly', () {
        final _hex =
            'b936cee86c9f87aa5d3c6f2e84cb5a4239a5fe50480a6ec66b70ab5b1f4ac6730c6c515421b327ec1d69402e53dfb49ad7381eb067b338fd7b0cb22247225d47';

        final hash = Hash.sha512Hmac(Uint8List(0), Uint8List(0));

        expect(hash.toHex(), _hex);
      });

      test('should calculate this known non-empty test vector correctly', () {
        final _hex =
            'c40bd7c15aa493b309c940e08a73ffbd28b2e4cb729eb94480d727e4df577b13cc403a78e6150d83595f3b17c4cc331f12ca5952691de3735a63c1d4c69a2bac';

        final data = utf8.encode('test1');
        final key = utf8.encode('test2');

        final hash = Hash.sha512Hmac(data as Uint8List, key as Uint8List);

        expect(hash.toHex(), _hex);
      });
    });

    group('vectors', () {
      final sha1vectors = hashJson['sha1']!;
      for (var i = 0; i < sha1vectors.length; i++) {
        List<String> vector = sha1vectors[i] as List<String>;

        test('should pass sjcl sha1 test vector $i', () {
          final data = utf8.encode(vector[0]);
          final hash = Hash.sha1(data as Uint8List);

          expect(hash.toHex(), vector[1]);
        });
      }

      final sha256vectors = hashJson['sha256']!;
      for (var i = 0; i < sha256vectors.length; i++) {
        List<String> vector = sha256vectors[i] as List<String>;

        test('should pass sjcl sha256 test vector $i', () {
          final data = utf8.encode(vector[0]);
          final hash = Hash.sha256(data as Uint8List);

          expect(hash.toHex(), vector[1]);
        });
      }

      final sha512vectors = hashJson['sha512']!;
      for (var i = 0; i < sha512vectors.length; i++) {
        List<String> vector = sha512vectors[i] as List<String>;

        test('should pass sjcl sha512 test vector $i', () {
          final data = utf8.encode(vector[0]);
          final hash = Hash.sha512(data as Uint8List);

          expect(hash.toHex(), vector[1]);
        });
      }

      final hmacvectors = hashJson['hmac']!;
      for (var i = 0; i < hmacvectors.length; i++) {
        dynamic vector = hmacvectors[i];

        test('should pass standard hmac test vector $i', () {
          final dataBuf = hex.decode(vector['data']);
          final keyBuf = hex.decode(vector['key']);

          final sha256HmacHex =
              Hash.sha256Hmac(dataBuf as Uint8List, keyBuf as Uint8List).toHex();
          final sha512HmacHex = Hash.sha512Hmac(dataBuf, keyBuf).toHex();

          expect(sha256HmacHex.substring(0, vector['sha256hmac'].length),
              vector['sha256hmac']);
          expect(sha512HmacHex.substring(0, vector['sha512hmac'].length),
              vector['sha512hmac']);
        });
      }
    });
  });
}
