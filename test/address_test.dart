import 'package:bsv/address.dart';
import 'package:bsv/constants.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/script.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/extentsions/list.dart';
// import 'package:bsv/extentsions/string.dart';

void main() {
  group('Address', () {
    var pubKeyHash = hex.decode('3c3fa3d4adcaf8f52d5b1843975e122548269937');
    // var versionByteNum = 0;
    var buf = List<int>.from([
      ...[0],
      ...pubKeyHash
    ]);
    var str = '16VZnHwRhwrExfeHFHGjwrgEMq8VcYPs9r';

    test('should satisfy these basic API features', () {
      // var address = new Address()
      // should.exist(address)
      // address = new Address()
      // should.exist(address)
      // address = new Address(versionByteNum, pubKeyHash)
      // should.exist(address)
      // new Address().constructor.should.equal(new Address().constructor)
      // new Address.Testnet().constructor.should.equal(
      //   new Address.Testnet().constructor
      // )
      var testAddr = Address.Testnet().fromRandom().toString();
      expect(testAddr[0] == 'm' || testAddr[0] == 'n', true);
    });

    group('@isValid', () {
      test('should validate this valid address string', () {
        expect(Address.isValid(str), (true));
      });

      test('should invalidate this valid address string', () {
        expect(Address.isValid(str.substring(1)), (false));
      });
    });

    group('#fromHex', () {
      test('should make an address from a hex string', () {
        expect(
          new Address().fromHex(buf.toHex()).toBuffer().slice(1).toHex(),
          pubKeyHash.toHex(),
        );

        expect(
          new Address().fromHex(buf.toHex()).toString(),
          str,
        );
      });
    });

    group('#fromBuffer', () {
      test('should make an address from a buffer', () {
        expect(
          new Address().fromBuffer(buf).toBuffer().slice(1).toHex(),
          pubKeyHash.toHex(),
        );

        expect(
          new Address().fromBuffer(buf).toString(),
          str,
        );
      });

      test('should throw for invalid buffers', () {
        expect(
          () => new Address().fromBuffer(List<int>.from([
            ...buf,
            ...([0])
          ])),
          throwsA(Address.INVALID_ADDRESS_LENGTH),
        );

        var buf2 = List<int>.from(buf);
        buf2[0] = 50;

        expect(
          () => new Address().fromBuffer(buf2),
          throwsA(Address.INVALID_ADDRESS_VERSION_BYTE_NUM_BYTE),
        );
      });
    });

    group('@fromBuffer', () {
      test('should make an address from a buffer', () {
        expect(
          Address.fromBuffer(buf).toBuffer().slice(1).toHex(),
          pubKeyHash.toHex(),
        );

        expect(
          Address.fromBuffer(buf).toString(),
          str,
        );
      });

      test('should throw for invalid buffers', () {
        expect(
          () => Address.fromBuffer(List<int>.from([
            ...buf,
            ...([0])
          ])),
          throwsA(Address.INVALID_ADDRESS_LENGTH),
        );

        var buf2 = List<int>.from(buf);
        buf2[0] = 50;

        expect(
          () => Address.fromBuffer(buf2),
          throwsA(Address.INVALID_ADDRESS_VERSION_BYTE_NUM_BYTE),
        );
      });
    });

    group('#fromPubKeyHashBuf', () {
      test('should make an address from a hashBuf', () {
        var buf = List<int>.generate(20, (index) => 0);
        var address = new Address().fromPubKeyHashBuf(buf);
        expect(address.toString(), '1111111111111111111114oLvT2');
      });
    });

    group('@fromPubKeyHashBuf', () {
      test('should make an address from a hashBuf', () {
        var buf = List<int>.generate(20, (index) => 0);
        var address = Address.fromPubKeyHashBuf(buf);
        expect(address.toString(), '1111111111111111111114oLvT2');
      });
    });

    group('#fromPubKey', () {
      test('should make this address from a compressed pubKey', () {
        var pubKey = new PubKey();
        pubKey.fromDer(hex.decode(
          '0285e9737a74c30a873f74df05124f2aa6f53042c2fc0a130d6cbd7d16b944b004',
        ));
        var address = new Address();
        address.fromPubKey(pubKey);
        expect(address.toString(), '19gH5uhqY6DKrtkU66PsZPUZdzTd11Y7ke');
      });

      test('should make this address from an uncompressed pubKey', () {
        var pubKey = new PubKey();
        pubKey.fromDer(hex.decode(
          '0285e9737a74c30a873f74df05124f2aa6f53042c2fc0a130d6cbd7d16b944b004',
        ));
        var address = new Address();
        pubKey.compressed = false;
        address.fromPubKey(pubKey);
        expect(address.toString(), '16JXnhxjJUhxfyx4y6H4sFcxrgt8kQ8ewX');
      });
    });

    group('@fromPubKey', () {
      test('should make this address from a compressed pubKey', () {
        var pubKey = new PubKey();
        pubKey.fromDer(hex.decode(
          '0285e9737a74c30a873f74df05124f2aa6f53042c2fc0a130d6cbd7d16b944b004',
        ));
        var address = Address.fromPubKey(pubKey);
        expect(address.toString(), '19gH5uhqY6DKrtkU66PsZPUZdzTd11Y7ke');
      });

      test('should make this address from an uncompressed pubKey', () {
        var pubKey = new PubKey();
        pubKey.fromDer(hex.decode(
          '0285e9737a74c30a873f74df05124f2aa6f53042c2fc0a130d6cbd7d16b944b004',
        ));
        var address = Address.fromPubKey(pubKey);
        pubKey.compressed = false;
        address.fromPubKey(pubKey);
        expect(address.toString(), '16JXnhxjJUhxfyx4y6H4sFcxrgt8kQ8ewX');
      });
    });

    // group('#asyncFromPubKey',  () {
    //   test('should asynchronously convert pubKey to address same as fromPubKey', async  () {
    //     var pubKey = new PubKey().fromPrivKey(new PrivKey().fromRandom())
    //     var address1 = new Address().fromPubKey(pubKey)
    //     var address2 = await new Address().asyncFromPubKey(pubKey)
    //     address1.toString().should.equal(address2.toString())
    //   })
    // })

    // group('@asyncFromPubKey',  () {
    //   test('should asynchronously convert pubKey to address same as fromPubKey', async  () {
    //     var pubKey = new PubKey().fromPrivKey(new PrivKey().fromRandom())
    //     var address1 = Address.fromPubKey(pubKey)
    //     var address2 = await Address.asyncFromPubKey(pubKey)
    //     address1.toString().should.equal(address2.toString())
    //   })
    // })

    group('#fromPrivKey', () {
      test('should make this address from a compressed pubKey', () {
        var privKey = new PrivKey().fromRandom();
        var pubKey = new PubKey().fromPrivKey(privKey);
        var address = new Address().fromPrivKey(privKey);
        var address2 = new Address().fromPubKey(pubKey);
        expect(address.toString(), address2.toString());
      });
    });

    group('@fromPrivKey', () {
      test(
          'should make this address from a compressed pubKey using static method',
          () {
        var privKey = new PrivKey().fromRandom();
        var pubKey = new PubKey().fromPrivKey(privKey);
        var address = Address.fromPrivKey(privKey);
        var address2 = Address.fromPubKey(pubKey);
        expect(address.toString(), address2.toString());
      });
    });

    // group('#asyncFromPrivKey',  () {
    //   test('should asynchronously convert privKey to address same as fromPrivKey', async  () {
    //     var privKey = new PrivKey().fromRandom()
    //     var address1 = new Address().fromPrivKey(privKey)
    //     var address2 = await new Address().asyncFromPrivKey(privKey)
    //     address1.toString().should.equal(address2.toString())
    //   })
    // })

    // group('@asyncFromPrivKey',  () {
    //   test('should asynchronously convert privKey to address same as fromPrivKey', async  () {
    //     var privKey = new PrivKey().fromRandom()
    //     var address1 = Address.fromPrivKey(privKey)
    //     var address2 = await Address.asyncFromPrivKey(privKey)
    //     address1.toString().should.equal(address2.toString())
    //   })
    // })

    // group('#fromRandom',  () {
    //   test('should make an address from random',  () {
    //     var address = new Address().fromRandom()
    //     should.exist(address)
    //     ;(address instanceof Address).should.equal(true)
    //   })
    // })

    // group('@fromRandom',  () {
    //   test('should make an address from random using static method',  () {
    //     var address = Address.fromRandom()
    //     should.exist(address)
    //     ;(address instanceof Address).should.equal(true)
    //   })
    // })

    // group('#asyncFromRandom',  () {
    //   test('should asynchronously make an address from random', async  () {
    //     var address = await new Address().asyncFromRandom()
    //     should.exist(address)
    //     ;(address instanceof Address).should.equal(true)
    //   })
    // })

    // group('@asyncFromRandom',  () {
    //   test('should asynchronously make an address from random using static method', async  () {
    //     var address = await Address.asyncFromRandom()
    //     should.exist(address)
    //     ;(address instanceof Address).should.equal(true)
    //   })
    // })

    group('@fromTxInScript', () {
      test('should make this address from an input script', () {
        var script = Script.fromAsmString(
            '3045022100ff812330880f443637e93ae1045985de38a29e26e4e589db84e86d0f17069f9a02203ed91e19a8cfa5e406bed1becc0e292c89346f9102358317e3238cb394a9ab0b 020536acad4d0763f39718143494811f5c0ffd39f5dc3667cfe3b4a7815b331a17');
        var address = Address.fromTxInScript(script);
        expect(address.toString(), '1EyV93Vhz4YLdfb67UaNujrBkd9CC6zvgG');
      });

      test('should make this address from a zero length public key', () {
        var script = Script.fromAsmString(
            '3045022100ff812330880f443637e93ae1045985de38a29e26e4e589db84e86d0f17069f9a02203ed91e19a8cfa5e406bed1becc0e292c89346f9102358317e3238cb394a9ab0b 0');
        var address = Address.fromTxInScript(script);
        expect(address.toString(), '1HqoNfpAJFMy9E36DBSk1ktPQ9o9fn2RxX');
      });
    });

    group('@fromTxOutScript', () {
      test('should make this address from a script', () {
        expect(
          Address.fromPubKeyHashBuf(
            hex.decode('6fa5502ea094d59576898b490d866b32a61b89f6'),
          ).toString(),
          '1BBL3TUavUCRauDreKv2JJ1CPgnyNxVHpA',
        );
      });

      test('should make an address from a hashBuf', () {
        var buf = List<int>.generate(20, (index) => 0);
        var address = new Address().fromPubKeyHashBuf(buf);
        var script = address.toTxOutScript();
        address = Address.fromTxOutScript(script);
        expect(address.toString(), ('1111111111111111111114oLvT2'));
      });
    });

    group('#fromString', () {
      test('should derive from this known address string mainnet', () {
        var address = new Address();
        address.fromString(str);
        expect(
          address.toBuffer().slice(1).toHex(),
          pubKeyHash.toHex(),
        );
      });

      test('should derive from this known address string testnet', () {
        var address = new Address.Testnet();
        address.fromString('mm1X5M2QWyHVjn7txrF7mmtZDpjCXzoa98');
        address.versionByteNum = Constants.Testnet.addressPubKeyHash;
        address.fromString(address.toString());
        expect(address.toString(), 'mm1X5M2QWyHVjn7txrF7mmtZDpjCXzoa98');
      });
    });

    group('@fromString', () {
      test('should derive from this known address string mainnet', () {
        var address = Address.fromString(str);
        expect(
          address.toBuffer().slice(1).toHex(),
          pubKeyHash.toHex(),
        );
      });
    });

    // group('#asyncFromString',  () {
    //   test('should derive the same as fromString', async  () {
    //     var address1 = new Address().fromString(str)
    //     var address2 = await new Address().asyncFromString(str)
    //     address1.toString().should.equal(address2.toString())
    //   })
    // })

    // group('@asyncFromString',  () {
    //   test('should derive the same as fromString', async  () {
    //     var address1 = Address.fromString(str)
    //     var address2 = await Address.asyncFromString(str)
    //     address1.toString().should.equal(address2.toString())
    //   })
    // })

    group('#isValid', () {
      test('should describe this valid address as valid', () {
        var address = new Address();
        address.fromString('1111111111111111111114oLvT2');
        expect(address.checkValid(), true);
      });

      test(
          'should describe this address with unknown versionByteNum as invalid',
          () {
        var address = new Address();
        address.fromString('1111111111111111111114oLvT2');
        address.versionByteNum = 1;
        expect(address.checkValid(), false);
      });
    });

    group('#toHex', () {
      test('should output this known hash', () {
        var address = new Address();
        address.fromString(str);
        expect(address.toHex().substring(2), pubKeyHash.toHex());
      });
    });

    group('#toBuffer', () {
      test('should output this known hash', () {
        var address = new Address();
        address.fromString(str);

        expect(address.toBuffer().slice(1).toHex(), pubKeyHash.toHex());
      });
    });

    // group('#toJSON',  () {
    //   test('should convert an address to json',  () {
    //     var addrbuf = Buffer.alloc(21)
    //     addrbuf.fill(0)
    //     var address = new Address().fromBuffer(addrbuf)
    //     var json = address.toJSON()
    //     should.exist(json.hashBuf)
    //     json.versionByteNum.should.equal(0)
    //   })
    // })

    // group('#fromJSON',  () {
    //   test('should convert a json to an address',  () {
    //     var addrbuf = Buffer.alloc(21)
    //     addrbuf.fill(0)
    //     var address = new Address().fromBuffer(addrbuf)
    //     var json = address.toJSON()
    //     var address2 = new Address().fromJSON(json)
    //     should.exist(address2.hashBuf)
    //     address2.versionByteNum.should.equal(0)
    //   })
    // })

    group('#toTxOutScript', () {
      test('should convert this address into known scripts', () {
        var addrbuf = List<int>.generate(21, (index) => 0);
        var addr = new Address().fromBuffer(addrbuf);
        var script = addr.toTxOutScript();
        expect(
          script.toString(),
          'OP_DUP OP_HASH160 20 0x0000000000000000000000000000000000000000 OP_EQUALVERIFY OP_CHECKSIG',
        );
      });
    });

    group('#toString', () {
      test('should output the same thing that was input', () {
        var address = new Address();
        address.fromString(str);
        expect(address.toString(), (str));
      });
    });

    // group('#asyncToString',  () {
    //   test('should output the same as toString', async  () {
    //     var str1 = new Address().fromString(str).toString()
    //     var str2 = await new Address().fromString(str).asyncToString()
    //     str1.should.equal(str2)
    //   })
    // })

    group('#validate', () {
      test('should not throw an error on this valid address', () {
        var address = new Address();
        address.fromString(str);
        expect(address.validate() != null, true);
      });

      test('should throw an error on this invalid versionByteNum', () {
        var address = new Address();
        address.fromString(str);
        address.versionByteNum = 1;
        expect(
          () => address.validate(),
          throwsA(Address.INVALID_ADDRESS_VERSION_BYTE_NUM),
        );
      });

      test('should throw an error on this invalid versionByteNum', () {
        var address = new Address();
        address.fromString(str);
        address.hashBuf = List<int>.from([
          ...address.hashBuf,
          ...([0])
        ]);
        expect(
          () => address.validate(),
          throwsA(Address.INVALID_ADDRESS_HASH_BUF),
        );
      });
    });
  });
}
