import 'dart:convert';

import 'package:bsv/address.dart';
import 'package:bsv/bsm.dart';
import 'package:bsv/key_pair.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bsm', () {
    // test('should make a new bsm', () {
    //   var bsm = new Bsm()
    //   should.exist(bsm)
    // })

    // test('should make a new bsm when called without "new"', () {
    //   var bsm = new Bsm()
    //   should.exist(bsm)
    // })

    // group('#fromObject', () {
    //   test('should set the messageBuf', () {
    //     var messageBuf = Buffer.from('message')
    //     should.exist(new Bsm().fromObject({ messageBuf: messageBuf }).messageBuf)
    //   });
    // });

    group('@MagicHash', () {
      test('should return a hash', () {
        var buf = hex.decode('001122');
        var hashBuf = Bsm.magicHash(buf);
        expect(hashBuf.toBuffer() is List<int>, true);
      });
    });

    // group('@asyncMagicHash', () {
    //   test('should return a hash', async () {
    //     var buf = Buffer.from('001122', 'hex')
    //     var hashBuf = await Bsm.asyncMagicHash(buf)
    //     Buffer.isBuffer(hashBuf).should.equal(true)
    //   })
    // })

    group('@sign', () {
      var messageBuf = utf8.encode('this is my message');
      var keyPair = new KeyPair().fromRandom();

      test('should return a base64 string', () {
        var sigstr = Bsm.staticSign(messageBuf: messageBuf, keyPair: keyPair);
        var sigbuf = base64Decode(sigstr);
        expect(sigbuf.length, 1 + 32 + 32);
      });

      test('should sign with a compressed pubKey', () {
        var keyPair = new KeyPair().fromRandom();
        keyPair.pubKey!.compressed = true;
        var sigstr = Bsm.staticSign(messageBuf: messageBuf, keyPair: keyPair);
        var sigbuf = base64Decode(sigstr);
        expect(sigbuf[0] > 27 + 4 - 1, true);
        expect(sigbuf[0] < 27 + 4 + 4 - 1, true);
      });

      test('should sign with an uncompressed pubKey', () {
        var keyPair = new KeyPair().fromRandom();
        keyPair.pubKey!.compressed = false;
        var sigstr = Bsm.staticSign(messageBuf: messageBuf, keyPair: keyPair);
        var sigbuf = base64Decode(sigstr);
        expect(sigbuf[0] > 27 - 1, true);
        expect(sigbuf[0] < 27 + 4 - 1, true);
      });
    });

    // group('@asyncSign', () {
    //   var messageBuf = Buffer.from('this is my message')
    //   var keyPair = new KeyPair().fromRandom()

    //   test('should return the same as sign', async () {
    //     var sigstr1 = Bsm.sign(messageBuf, keyPair)
    //     var sigstr2 = await Bsm.asyncSign(messageBuf, keyPair)
    //     sigstr1.should.equal(sigstr2)
    //   })
    // })

    group('@verify', () {
      var messageBuf = utf8.encode('this is my message');
      var keyPair = new KeyPair().fromRandom();

      test('should verify a signed message', () {
        var sigstr = Bsm.staticSign(messageBuf: messageBuf, keyPair: keyPair);
        var addr = new Address().fromPubKey(keyPair.pubKey!);
        expect(
          Bsm.staticVerify(
            messageBuf: messageBuf,
            sigstr: sigstr,
            address: addr,
          ),
          true,
        );
      });

      test('should verify this known good signature', () {
        var addrstr = '1CKTmxj6DjGrGTfbZzVxnY4Besbv8oxSZb';
        var address = new Address().fromString(addrstr);
        var sigstr =
            'IOrTlbNBI0QO990xOw4HAjnvRl/1zR+oBMS6HOjJgfJqXp/1EnFrcJly0UcNelqJNIAH4f0abxOZiSpYmenMH4M=';

        Bsm.staticVerify(
          messageBuf: messageBuf,
          sigstr: sigstr,
          address: address,
        );
      });
    });

    // group('@asyncVerify', () {
    //   var messageBuf = Buffer.from('this is my message')
    //   var keyPair = new KeyPair().fromRandom()

    //   test('should verify a signed message', async () {
    //     var sigstr = Bsm.sign(messageBuf, keyPair)
    //     var addr = new Address().fromPubKey(keyPair.pubKey)
    //     var verified = await Bsm.verify(messageBuf, sigstr, addr)
    //     verified.should.equal(true)
    //   })
    // })

    group('#sign', () {
      var messageBuf = utf8.encode('this is my message');
      var keyPair = new KeyPair().fromRandom();

      test('should sign a message', () {
        var bsm = new Bsm();
        bsm.messageBuf = messageBuf;
        bsm.keyPair = keyPair;
        bsm.sign();
        var sig = bsm.sig;
        expect(sig != null, true);
      });
    });

    group('#verify', () {
      var messageBuf = utf8.encode('this is my message');
      var keyPair = new KeyPair().fromRandom();

      test('should verify a message that was just signed', () {
        var bsm = new Bsm();
        bsm.messageBuf = messageBuf;
        bsm.keyPair = keyPair;
        bsm.address = new Address().fromPubKey(keyPair.pubKey!);
        bsm.sign();
        bsm.verify();
        expect(bsm.verified, true);
      });
    });
  });
}
