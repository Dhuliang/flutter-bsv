import 'package:bsv/bn.dart';
import 'package:bsv/key_pair.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KeyPair', () {
    // test('should satisfy this basic API',  () {
    //   var key = new KeyPair()
    //   should.exist(key)
    //   key = new KeyPair()
    //   should.exist(key)

    //   KeyPair.Mainnet.should.equal(KeyPair.Mainnet)
    //   KeyPair.Testnet.should.equal(KeyPair.Testnet)
    //   new KeyPair.Mainnet()
    //     .fromRandom()
    //     .privKey.constructor.should.equal(PrivKey.Mainnet)
    //   new KeyPair.Testnet()
    //     .fromRandom()
    //     .privKey.constructor.should.equal(PrivKey.Testnet)
    // });

    // test('should make a key with a priv and pub',  () {
    //   var priv = new PrivKey();
    //   var pub = new PubKey();
    //   var key = new KeyPair(priv, pub)
    //   should.exist(key)
    //   should.exist(key.privKey)
    //   should.exist(key.pubKey)
    // })

    group('#fromJSON', () {
      test('should make a keyPair from this json', () {
        var privKey = new PrivKey.fromRandom();
        var pubKey = new PubKey().fromPrivKey(privKey);
        var keyPair = new KeyPair().fromJSON({
          "privKey": privKey.toJSON(),
          "pubKey": pubKey.toJSON(),
        });
        expect(keyPair.privKey.toString(), privKey.toString());
        expect(keyPair.pubKey.toString(), pubKey.toString());
      });
    });

    // group('#toJSON',  () {
    //   test('should make json from this keyPair',  () {
    //     var json = new KeyPair().fromRandom().toJSON()
    //     should.exist(json.privKey)
    //     should.exist(json.pubKey)
    //     var keyPair = new KeyPair().fromJSON(json)
    //     keyPair
    //       .toJSON()
    //       .privKey.toString()
    //       .should.equal(json.privKey.toString())
    //     keyPair
    //       .toJSON()
    //       .pubKey.toString()
    //       .should.equal(json.pubKey.toString())
    //   })
    // })

    group('#fromBuffer', () {
      test('should convert from a fast buffer', () {
        var keyPair = new KeyPair().fromRandom();
        var privKey1 = keyPair.privKey;
        var pubKey1 = keyPair.pubKey;
        var buf = keyPair.toBuffer();
        keyPair = new KeyPair().fromBuffer(buf);
        var privKey2 = keyPair.privKey;
        var pubKey2 = keyPair.pubKey;
        expect(privKey1.toString(), privKey2.toString());
        expect(pubKey1.toString(), pubKey2.toString());
      });
    });

    group('#toBuffer', () {
      test('should convert to a fast buffer', () {
        var keyPair, buf;

        keyPair = new KeyPair().fromRandom();
        keyPair.pubKey = null;
        buf = keyPair.toBuffer();
        expect(buf.length > 32, true);

        keyPair = new KeyPair().fromRandom();
        keyPair.privKey = null;
        buf = keyPair.toBuffer();
        expect(buf.length > 64, true);

        keyPair = new KeyPair().fromRandom();
        buf = keyPair.toBuffer();
        expect(buf.length > 32 + 64, true);
      });
    });

    group('#fromString', () {
      test('should convert to and from a string', () {
        var keyPair = new KeyPair().fromRandom();
        var str = keyPair.toString();
        expect(new KeyPair().fromString(str).toString(), str);
      });
    });

    group('#toPublic', () {
      test('should set the private key to null;', () {
        var keyPair = new KeyPair().fromRandom();
        var publicKeyPair = keyPair.toPublic();

        expect(publicKeyPair.pubKey != null, true);
        expect(publicKeyPair.privKey != null, false);
      });
    });

    group('#fromPrivKey', () {
      // test('should make a new key from a privKey',  () {
      //   should.exist(new KeyPair().fromPrivKey(new PrivKey().fromRandom()).pubKey)
      // })

      test('should convert this known PrivKey to known PubKey', () {
        var privhex =
            '906977a061af29276e40bf377042ffbde414e496ae2260bbf1fa9d085637bfff';
        var pubhex =
            '02a1633cafcc01ebfb6d78e39f687a1f0995c62fc95f51ead10a02ee0be551b5dc';
        var privKey = new PrivKey.fromBn(BigIntX.fromHex(privhex));
        var key = new KeyPair().fromPrivKey(privKey);
        expect(key.pubKey.toString(), pubhex);
      });

      test(
          'should convert this known PrivKey to known PubKey and preserve compressed=false',
          () {
        var privhex =
            '906977a061af29276e40bf377042ffbde414e496ae2260bbf1fa9d085637bfff';
        var privKey = new PrivKey.fromBn(BigIntX.fromHex(privhex));
        privKey.compressed = false;
        var key = new KeyPair().fromPrivKey(privKey);
        expect(key.pubKey!.compressed, false);
      });
    });

    group('@fromPrivKey', () {
      // test('should make a new key from a privKey',  () {
      //   should.exist(KeyPair.fromPrivKey(new PrivKey().fromRandom()).pubKey)
      // })

      test('should convert this known PrivKey to known PubKey', () {
        var privhex =
            '906977a061af29276e40bf377042ffbde414e496ae2260bbf1fa9d085637bfff';
        var pubhex =
            '02a1633cafcc01ebfb6d78e39f687a1f0995c62fc95f51ead10a02ee0be551b5dc';
        var privKey = new PrivKey.fromBn(BigIntX.fromHex(privhex));
        var key = KeyPair.fromPrivKey(privKey);
        expect(key.pubKey.toString(), pubhex);
      });

      test(
          'should convert this known PrivKey to known PubKey and preserve compressed=false',
          () {
        var privhex =
            '906977a061af29276e40bf377042ffbde414e496ae2260bbf1fa9d085637bfff';
        var privKey = new PrivKey.fromBn(BigIntX.fromHex(privhex));
        privKey.compressed = false;
        var key = KeyPair.fromPrivKey(privKey);
        expect(key.pubKey!.compressed, false);
      });
    });

    // group('#asyncFromPrivKey',  () {
    //   test('should convert a privKey same as .fromPrivKey', async  () {
    //     var privKey = new PrivKey().fromRandom()
    //     var keyPair = new KeyPair().fromPrivKey(privKey)
    //     var keyPair2 = await new KeyPair().asyncFromPrivKey(privKey)
    //     keyPair.pubKey.toString().should.equal(keyPair2.pubKey.toString())
    //   })
    // })

    // group('@asyncFromPrivKey',  () {
    //   test('should convert a privKey same as .fromPrivKey', async  () {
    //     var privKey = new PrivKey().fromRandom()
    //     var keyPair = KeyPair.fromPrivKey(privKey)
    //     var keyPair2 = await KeyPair.asyncFromPrivKey(privKey)
    //     keyPair.pubKey.toString().should.equal(keyPair2.pubKey.toString())
    //   })
    // })

    group('#fromRandom', () {
      test('should make a new priv and pub, should be compressed, mainnet', () {
        var key = new KeyPair();
        key.fromRandom();
        expect(key.privKey != null, true);
        expect(key.pubKey != null, true);
        expect(key.privKey!.bn!.gt(BigIntX.zero), (true));
        expect(key.pubKey!.point!.getX().gt(BigIntX.zero), (true));
        expect(key.pubKey!.point!.getY().gt(BigIntX.zero), (true));

        expect(key.privKey!.compressed, (true));
        expect(key.pubKey!.compressed, (true));
      });
    });

    group('@fromRandom', () {
      test('should make a new priv and pub, should be compressed, mainnet', () {
        var key = KeyPair.fromRandom();
        expect(key.privKey != null, true);
        expect(key.pubKey != null, true);
        expect(key.privKey!.bn!.gt(BigIntX.zero), (true));
        expect(key.pubKey!.point!.getX().gt(BigIntX.zero), (true));
        expect(key.pubKey!.point!.getY().gt(BigIntX.zero), (true));

        expect(key.privKey!.compressed, (true));
        expect(key.pubKey!.compressed, (true));
      });
    });

    // group('#asyncFromRandom',  () {
    //   test('should have a privKey and pubKey and compute same as pubKey methods', async  () {
    //     var keyPair = await new KeyPair().asyncFromRandom()
    //     var pubKey = new PubKey().fromPrivKey(keyPair.privKey)
    //     pubKey.toString().should.equal(keyPair.pubKey.toString())
    //   })
    // })

    // group('@asyncFromRandom',  () {
    //   test('should have a privKey and pubKey and compute same as pubKey methods', async  () {
    //     var keyPair = await KeyPair.asyncFromRandom()
    //     var pubKey = new PubKey().fromPrivKey(keyPair.privKey)
    //     pubKey.toString().should.equal(keyPair.pubKey.toString())
    //   })
    // });
  });
}
