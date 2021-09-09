import 'package:bsv/address.dart';
import 'package:bsv/bip32.dart';
import 'package:bsv/bip39.dart';
import 'package:bsv/bip39_cn_worldlist.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:typed_data';

import 'package:bsv/bip39_en_worldlist.dart';
import 'package:bsv/random.dart';
import 'package:convert/convert.dart';
import 'package:bsv/extentsions/list.dart';

import 'vectors/bip39.dart';

void main() {
  group('Bip39', () {
    test('should have a wordlist of length 2048', () {
      expect(bip39EnWorldlist.length, 2048);
      expect(bip39CnWorldlist.length, 2048);
    });

    test('should handle this community-derived test vector', () {
      // There was a bug in Copay and bip32jp about deriving addresses with bip39
      // and bip44. This confirms we are handling the situation correctly and
      // derive the correct value.
      //
      // More information here:
      // https://github.com/iancoleman/bip39/issues/58
      var seed = Bip39.fromString(
              'fruit wave dwarf banana earth journey tattoo true farm silk olive fence')
          .toSeed('banana')!;
      var bip32 = Bip32.fromSeed(seed);
      bip32 = bip32.derive("m/44'/0'/0'/0/0");
      var address = Address.fromPubKey(bip32.pubKey!);
      expect(address.toString(), '17rxURoF96VhmkcEGCj5LNQkmN9HVhWb7F');
    });

    test('should generate a mnemonic phrase that passes the check', () {
      var mnemonic;

      // should be able to make a mnemonic with or without the default wordlist
      var bip39 = new Bip39En().fromRandom(128);
      expect(bip39.check(), true);
      bip39 = new Bip39().fromRandom(128);
      expect(bip39.check(), true);

      var entropy = List<int>.generate(32, (index) => 0).asUint8List();
      bip39 = new Bip39En().fromEntropy(entropy);
      expect(bip39.check(), true);

      mnemonic = bip39.mnemonic;

      // mnemonics with extra whitespace do not pass the check
      bip39 = new Bip39En().fromString(mnemonic + ' ');
      expect(bip39.check(), false);

      // mnemonics with a word replaced do not pass the check
      var words = mnemonic.split(' ');
      expect(words[words.length - 1] != 'zoo', true);
      words[words.length - 1] = 'zoo';
      mnemonic = words.join(' ');
      expect(new Bip39En().fromString(mnemonic).check(), false);
    });

    group('#toFastBuffer', () {
      test('should convert to a buffer', () {
        var bip39 = new Bip39().fromRandom();
        expect(bip39.seed != null, true);
        expect(bip39.mnemonic != null, true);
        var buf = bip39.toBuffer();
        expect(buf.length > 512 / 8 + 1 + 1, true);
      });
    });

    group('#fromFastBuffer', () {
      test('should convert from a buffer', () {
        var bip39a = new Bip39().fromRandom();
        var bip39b = new Bip39().fromBuffer(bip39a.toBuffer());

        expect(bip39a.mnemonic, bip39b.mnemonic);
        expect(bip39b.seed!.toHex(), bip39b.seed!.toHex());
      });
    });

    group('#fromRandom', () {
      test('should throw an error if bits is too low', () {
        expect(
          () => new Bip39().fromRandom(127),
          throwsA('bits must be multiple of 32'),
        );
      });

      test('should throw an error if bits is not a multiple of 32', () {
        expect(
          () => new Bip39().fromRandom(256 - 1),
          throwsA('bits must be multiple of 32'),
        );
      });
    });

    group('@fromRandom', () {
      test('should throw an error if bits is too low', () {
        expect(
          () => new Bip39.fromRandom(127),
          throwsA('bits must be multiple of 32'),
        );
      });

      test('should throw an error if bits is not a multiple of 32', () {
        expect(
          () => new Bip39.fromRandom(256 - 1),
          throwsA('bits must be multiple of 32'),
        );
      });
    });

    group('#fromEntropy', () {
      test('should build from entropy', () {
        var bip39 = new Bip39().fromEntropy(RandomBytes.getRandomBuffer(32));
        expect(bip39.mnemonic != null, true);
      });
    });

    group('@fromEntropy', () {
      test('should build from entropy', () {
        var bip39 = Bip39.fromEntropy(RandomBytes.getRandomBuffer(32));
        expect(bip39.mnemonic != null, true);
      });
    });

    group('#entropy2Mnemonic', () {
      test('should throw an error if you do not use enough entropy', () {
        var buf = Uint8List.fromList(List.generate(128 ~/ 8 - 1, (index) => 0));
        expect(
          () => new Bip39().entropy2Mnemonic(buf),
          throwsA(
              'Entropy is less than 128 bits. It must be 128 bits or more.'),
        );
      });

      test('should work with or without the wordlist', () {
        var buf = Uint8List.fromList(List.generate(128 ~/ 8, (index) => 0));
        var mnemonic1 = new Bip39().entropy2Mnemonic(buf).mnemonic;
        var mnemonic2 = new Bip39En().entropy2Mnemonic(buf).mnemonic;
        expect(mnemonic1, mnemonic2);
      });
    });

    group('#check', () {
      test('should work with or without optional wordlist', () {
        var buf = Uint8List.fromList(List.generate(128 ~/ 8, (index) => 0));
        var mnemonic = new Bip39().entropy2Mnemonic(buf).mnemonic!;
        expect(new Bip39().fromString(mnemonic).check(), true);
        expect(new Bip39En().fromString(mnemonic).check(), true);
      });
    });

    group('#fromString', () {
      test('should throw an error in invalid mnemonic', () {
        expect(
          () => new Bip39().fromString('invalid mnemonic').toSeed(),
          throwsA(
              'Mnemonic does not pass the check - was the mnemonic typed incorrectly? Are there extra spaces?'),
        );
      });
    });

    group('#asyncToSeed', () {
      test('should result the same as toSeed', () {
        var bip39 = new Bip39().fromRandom();
        var seed1a = bip39.toSeed()!;
        var seed2a = bip39.toSeed()!;
        expect(seed1a.toHex(), seed2a.toHex());
        var seed1b = bip39.toSeed('pass')!;
        var seed2b = bip39.toSeed('pass')!;
        expect(seed1b.toHex(), seed2b.toHex());
      });
    });

    group('@isValid', () {
      test('should know this is valid', () {
        var isValid = Bip39.staticIsValid(
            'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about',
            'TREZOR');
        expect(isValid, true);
      });

      test('should know this is invalid', () {
        var isValid = Bip39.staticIsValid(
            'abandonnnnnnn abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about',
            'TREZOR');
        expect(isValid, false);
      });
    });

    group('vectors', () {
      for (var i = 0; i < bip39vectors['english']!.length; i++) {
        var vector = bip39vectors['english']![i];
        test('should pass english test vector $i', () {
          var entropy = hex.decode(vector['entropy']!);
          var bip39 = new Bip39En().fromEntropy(entropy as Uint8List);
          expect(bip39.toString(), vector['mnemonic']);
          expect(bip39.check(), true);
          var seed = bip39.toSeed(vector['passphrase'])!;

          expect(seed.toHex(), vector['seed']);
          expect(new Bip32().fromSeed(seed).toString(), vector['bip32_xprv']);
        });
      }

      for (var i = 0; i < bip39vectors['japanese']!.length; i++) {
        var vector = bip39vectors['japanese']![i];
        test('should pass japanese test vector $i', () {
          var entropy = hex.decode(vector['entropy']!);
          var bip39 = new Bip39Jp().fromEntropy(entropy as Uint8List);
          expect(bip39.toString(), vector['mnemonic']);
          expect(bip39.check(), true);
          var seed = bip39.toSeed(vector['passphrase'])!;
          // print(bip39.toSeed().toHex());
          // print(hex.decode(vector['seed']));

          expect(seed.toHex(), vector['seed']);
          expect(new Bip32().fromSeed(seed).toString(), vector['bip32_xprv']);
        });
      }
    });
  });
}
