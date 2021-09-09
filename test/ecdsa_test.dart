import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/ecdsa.dart';
import 'package:bsv/hash.dart';
import 'package:bsv/key_pair.dart';
import 'package:bsv/point.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/sig.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/extentsions/list.dart';
// import 'package:bsv/extentsions/string.dart';

import 'vectors/ecdsa.dart';

void main() {
  group('Ecdsa', () {
    // test('should create a blank ecdsa',  () {
    //   var ecdsa = new Ecdsa();
    //   should.exist(ecdsa)
    // });

    var ecdsa = new Ecdsa();
    ecdsa.hashBuf = Hash.sha256(utf8.encode('test data') as Uint8List).data!.toList();
    ecdsa.keyPair = new KeyPair();
    ecdsa.keyPair!.privKey =
        new PrivKey().fromBn(new BigIntX.fromBuffer(hex.decode(
      'fee0a1f7afebf9d2a5a80c0c98a31c709681cce195cbcd06342b517970c0be1e',
    )));
    ecdsa.keyPair!.pubKey = new PubKey(
      point: new PointWrapper(
        x: new BigIntX.fromBuffer(hex.decode(
          'ac242d242d23be966085a2b2b893d989f824e06c9ad0395a8a52f055ba39abb2',
        )).bn,
        y: new BigIntX.fromBuffer(hex.decode(
          '4836ab292c105a711ed10fcfd30999c31ff7c02456147747e03e739ad527c380',
        )).bn,
      ),
    );

    // group('#fromObject',  () {
    //   test('should set hashBuf',  () {
    //     should.exist(new Ecdsa().fromObject({ hashBuf: ecdsa.hashBuf }).hashBuf)
    //   })
    // })

    group('#toJSON', () {
      test('should return json', () {
        var json = ecdsa.toJSON();
        expect(json['keyPair'] != null, true);
        expect(json['hashBuf'] != null, true);
      });
    });

    group('#fromJSON', () {
      test('should convert from json', () {
        var json = ecdsa.toJSON();
        var ecdsa2 = new Ecdsa().fromJSON(json);

        expect(ecdsa2.keyPair.toString().isNotEmpty, true);
        expect(ecdsa2.hashBuf.toString().isNotEmpty, true);
      });
    });

    group('#toBuffer', () {
      test('should return buffer', () {
        var buf = ecdsa.toBuffer();
        expect(buf is List<int>, true);
      });
    });

    group('#fromBuffer', () {
      test('should return from buffer', () {
        var buf = ecdsa.toBuffer();
        var ecdsa2 = new Ecdsa().fromBuffer(buf);
        expect(ecdsa2.keyPair.toString().isNotEmpty, true);
        expect(ecdsa2.hashBuf.toString().isNotEmpty, true);
      });
    });

    group('#calcrecovery', () {
      test('should calculate pubKey recovery number', () {
        ecdsa.randomK();
        ecdsa.sign();
        ecdsa.calcrecovery();
        expect(ecdsa.sig!.recovery != null, true);
      });

      test('should calculate this known pubKey recovery number', () {
        var hashBuf = Hash.sha256(utf8.encode('some data') as Uint8List);
        var r = new BigIntX.fromString(
          '71706645040721865894779025947914615666559616020894583599959600180037551395766',
        );
        var s = new BigIntX.fromString(
          '109412465507152403114191008482955798903072313614214706891149785278625167723646',
        );
        var ecdsa = new Ecdsa();
        ecdsa.keyPair = new KeyPair().fromPrivKey(new PrivKey().fromBn(
            new BigIntX.fromBuffer(Hash.sha256(utf8.encode('test') as Uint8List).data!)));
        ecdsa.hashBuf = hashBuf.data!.toList();
        ecdsa.sig = Sig(r: r, s: s);

        ecdsa.calcrecovery();
        expect(ecdsa.sig!.recovery, 1);
      });

      test('should do a round trip with signature parsing', () {
        ecdsa.calcrecovery();
        var pubKey = ecdsa.keyPair!.pubKey!;
        var sig = ecdsa.sig!;
        var hashBuf = ecdsa.hashBuf;
        expect(
          Ecdsa.staticSig2PubKey(sig: sig, hashBuf: hashBuf).toHex(),
          pubKey.toHex(),
        );

        sig = sig.fromCompact(sig.toCompact());

        expect(
          Ecdsa.staticSig2PubKey(sig: sig, hashBuf: hashBuf).toHex(),
          pubKey.toHex(),
        );
      });
    });

    // group('#asyncCalcrecovery',  () {
    //   test('should calculate pubKey recovery number', async  () {
    //     ecdsa.randomK()
    //     ecdsa.sign()
    //     await ecdsa.asyncCalcrecovery()
    //     should.exist(ecdsa.sig.recovery)
    //   })

    //   test('should calculate this known pubKey recovery number', async  () {
    //     var hashBuf = Hash.sha256(Buffer.from('some data'));
    //     var r = new BigIntX(;
    //       '71706645040721865894779025947914615666559616020894583599959600180037551395766',
    //       10
    //     )
    //     var s = new BigIntX(;
    //       '109412465507152403114191008482955798903072313614214706891149785278625167723646',
    //       10
    //     )
    //     var ecdsa = new Ecdsa();
    //     ecdsa.keyPair = new KeyPair().fromPrivKey(
    //       new PrivKey().fromBn(
    //         new BigIntX.fromBuffer(Hash.sha256(Buffer.from('test')))
    //       )
    //     )
    //     ecdsa.hashBuf = hashBuf
    //     ecdsa.sig = Sig.fromObject({ r: r, s: s })

    //     await ecdsa.asyncCalcrecovery()
    //     ecdsa.sig.recovery.should.equal(1)
    //   })

    //   test('should do a round trip with signature parsing', async  () {
    //     await ecdsa.asyncCalcrecovery()
    //     var pubKey = ecdsa.keyPair.pubKey;
    //     var sig = ecdsa.sig
    //     var hashBuf = ecdsa.hashBuf;
    //     Ecdsa.sig2PubKey(sig, hashBuf)
    //       .toHex()
    //       .should.equal(pubKey.toHex())

    //     sig = sig.fromCompact(sig.toCompact())
    //     Ecdsa.sig2PubKey(sig, hashBuf)
    //       .toHex()
    //       .should.equal(pubKey.toHex())
    //   })
    // });

    group('@calcrecovery', () {
      test('should calculate pubKey recovery number same as #calcrecovery', () {
        ecdsa.randomK();
        ecdsa.sign();
        var sig1 = ecdsa.calcrecovery().sig!;
        var sig2 = Ecdsa.staticCalcrecovery(
          sig: ecdsa.sig,
          pubKey: ecdsa.keyPair!.pubKey,
          hashBuf: ecdsa.hashBuf,
        )!;
        expect(listEquals(sig1.toCompact(), sig2.toCompact()), true);
      });

      test(
          'should calulate this known pubKey recovery number same as #calcrecovery',
          () {
        var hashBuf = Hash.sha256(utf8.encode('some data') as Uint8List);
        var r = new BigIntX.fromString(
          '71706645040721865894779025947914615666559616020894583599959600180037551395766',
        );
        var s = new BigIntX.fromString(
          '109412465507152403114191008482955798903072313614214706891149785278625167723646',
        );
        var ecdsa = new Ecdsa();
        ecdsa.keyPair = new KeyPair().fromPrivKey(new PrivKey().fromBn(
            new BigIntX.fromBuffer(Hash.sha256(utf8.encode('test') as Uint8List).data!)));
        ecdsa.hashBuf = hashBuf.data;
        ecdsa.sig = Sig(r: r, s: s);

        var sig1 = ecdsa.calcrecovery().sig!;
        var sig2 = Ecdsa.staticCalcrecovery(
          sig: ecdsa.sig,
          pubKey: ecdsa.keyPair!.pubKey,
          hashBuf: ecdsa.hashBuf,
        )!;
        expect(listEquals(sig1.toCompact(), sig2.toCompact()), true);
      });
    });

    // group('@asyncCalcrecovery',  () {
    //   test('should calculate pubKey recovery number same as #calcrecovery', async  () {
    //     ecdsa.randomK()
    //     ecdsa.sign()
    //     var sig1 = ecdsa.calcrecovery().sig;
    //     var sig2 = await Ecdsa.asyncCalcrecovery(;
    //       ecdsa.sig,
    //       ecdsa.keyPair.pubKey,
    //       ecdsa.hashBuf
    //     )
    //     Buffer.compare(sig1.toCompact(), sig2.toCompact()).should.equal(0)
    //   })

    //   test('should calulate this known pubKey recovery number same as #calcrecovery', async  () {
    //     var hashBuf = Hash.sha256(Buffer.from('some data'));
    //     var r = new BigIntX(;
    //       '71706645040721865894779025947914615666559616020894583599959600180037551395766',
    //       10
    //     )
    //     var s = new BigIntX(;
    //       '109412465507152403114191008482955798903072313614214706891149785278625167723646',
    //       10
    //     )
    //     var ecdsa = new Ecdsa();
    //     ecdsa.keyPair = new KeyPair().fromPrivKey(
    //       new PrivKey().fromBn(
    //         new BigIntX.fromBuffer(Hash.sha256(Buffer.from('test')))
    //       )
    //     )
    //     ecdsa.hashBuf = hashBuf
    //     ecdsa.sig = Sig.fromObject({ r: r, s: s })

    //     var sig1 = ecdsa.calcrecovery().sig;
    //     var sig2 = await Ecdsa.asyncCalcrecovery(;
    //       ecdsa.sig,
    //       ecdsa.keyPair.pubKey,
    //       ecdsa.hashBuf
    //     )
    //     Buffer.compare(sig1.toCompact(), sig2.toCompact()).should.equal(0)
    //   })
    // })

    group('#fromString', () {
      test('should to a round trip with to string', () {
        var str = ecdsa.toString();
        var ecdsa2 = new Ecdsa();
        ecdsa2.fromString(str);
        expect(ecdsa.hashBuf != null, true);
        expect(ecdsa.keyPair != null, true);
      });
    });

    group('#randomK', () {
      test('should generate a new random k when called twice in a row', () {
        ecdsa.randomK();
        var k1 = ecdsa.k!;
        ecdsa.randomK();
        var k2 = ecdsa.k;
        expect(k1.cmp(k2) == 0, false);
      });

      test(
          'should generate a random k that is (almost always) greater than this relatively small number',
          () {
        ecdsa.randomK();
        var k1 = ecdsa.k;
        var k2 = new BigIntX.fromNum(pow(2, 32))
            .mul(new BigIntX.fromNum(pow(2, 32)))
            .mul(new BigIntX.fromNum(pow(2, 32)));
        expect(k2.gt(k1), false);
      });
    });

    group('#deterministicK', () {
      test('should generate the same deterministic k', () {
        ecdsa.deterministicK();
        expect(
          ecdsa.k!.toBuffer().toHex(),
          'fcce1de7a9bcd6b2d3defade6afa1913fb9229e3b7ddf4749b55c4848b2a196e',
        );
      });

      test('should generate the same deterministic k if badrs is set', () {
        ecdsa.deterministicK(0);
        expect(
          ecdsa.k!.toBuffer().toHex(),
          ('fcce1de7a9bcd6b2d3defade6afa1913fb9229e3b7ddf4749b55c4848b2a196e'),
        );
        ecdsa.deterministicK(1);
        expect(
          ecdsa.k!.toBuffer().toHex() !=
              'fcce1de7a9bcd6b2d3defade6afa1913fb9229e3b7ddf4749b55c4848b2a196e',
          true,
        );
        expect(
          ecdsa.k!.toBuffer().toHex(),
          ('727fbcb59eb48b1d7d46f95a04991fc512eb9dbf9105628e3aec87428df28fd8'),
        );
      });

      test('should compute this test vector correctly', () {
        // test fixture from bitcoinjs
        // https://github.com/bitcoinjs/bitcoinjs-lib/blob/10630873ebaa42381c5871e20336fbfb46564ac8/test/fixtures/ecdsa.json#L6
        var ecdsa = new Ecdsa();
        ecdsa.hashBuf = Hash.sha256(utf8
                .encode(
                    'Everything should be made as simple as possible, but not simpler.')
                .asUint8List())
            .data;
        ecdsa.keyPair = new KeyPair().fromPrivKey(new PrivKey(bn: BigIntX.one));
        ecdsa.deterministicK();
        expect(
          ecdsa.k!.toBuffer().toHex(),
          'ec633bd56a5774a0940cb97e27a9e4e51dc94af737596a0c5cbb3d30332d92a5',
        );
        ecdsa.sign();
        expect(
          ecdsa.sig!.r.toString(),
          '23362334225185207751494092901091441011938859014081160902781146257181456271561',
        );
        expect(
          ecdsa.sig!.s.toString(),
          '50433721247292933944369538617440297985091596895097604618403996029256432099938',
        );
      });
    });

    group('#sig2PubKey', () {
      test(
          'should calculate the correct public key for this signature with low s',
          () {
        ecdsa.sig = new Sig().fromString(
            '3045022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f6650220278cf15b05ce47fb37d2233802899d94c774d5480bba9f0f2d996baa13370c43');
        ecdsa.sig!.recovery = 0;
        var pubKey = ecdsa.sig2PubKey();
        expect(pubKey.point == ecdsa.keyPair!.pubKey!.point, true);
      });

      test(
          'should calculate the correct public key for this signature with high s',
          () {
        ecdsa.sign();
        ecdsa.sig = new Sig().fromString(
            '3046022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f665022100d8730ea4fa31b804c82ddcc7fd766269f33a079ea38e012c9238f2e2bcff34fe');
        ecdsa.sig!.recovery = 1;
        var pubKey = ecdsa.sig2PubKey();
        expect(pubKey.point == ecdsa.keyPair!.pubKey!.point, true);
      });
    });

    // group('#asyncSig2PubKey',  () {
    //   test('should calculate the correct public key for this signature with low s', async  () {
    //     ecdsa.sig = new Sig().fromString(
    //       '3045022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f6650220278cf15b05ce47fb37d2233802899d94c774d5480bba9f0f2d996baa13370c43'
    //     )
    //     ecdsa.sig.recovery = 0
    //     var pubKey = await ecdsa.asyncSig2PubKey();
    //     pubKey.point.eq(ecdsa.keyPair.pubKey.point).should.equal(true)
    //   })

    //   test('should calculate the correct public key for this signature with high s', async  () {
    //     ecdsa.sign()
    //     ecdsa.sig = new Sig().fromString(
    //       '3046022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f665022100d8730ea4fa31b804c82ddcc7fd766269f33a079ea38e012c9238f2e2bcff34fe'
    //     )
    //     ecdsa.sig.recovery = 1
    //     var pubKey = await ecdsa.asyncSig2PubKey();
    //     pubKey.point.eq(ecdsa.keyPair.pubKey.point).should.equal(true)
    //   })
    // })

    group('@sig2PubKey', () {
      test('should calculate the correct public key', () {
        ecdsa.k = new BigIntX.fromString(
          '114860389168127852803919605627759231199925249596762615988727970217268189974335',
        );
        ecdsa.sign();
        ecdsa.sig!.recovery = 0;
        var pubKey1 = ecdsa.sig2PubKey();
        var pubKey2 =
            Ecdsa.staticSig2PubKey(sig: ecdsa.sig, hashBuf: ecdsa.hashBuf);
        expect(pubKey1.toString(), pubKey2.toString());
      });

      test(
          'should calculate the correct public key for this signature with low s',
          () {
        ecdsa.k = new BigIntX.fromString(
          '114860389168127852803919605627759231199925249596762615988727970217268189974335',
        );
        ecdsa.sig = new Sig().fromString(
            '3045022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f6650220278cf15b05ce47fb37d2233802899d94c774d5480bba9f0f2d996baa13370c43');
        ecdsa.sig!.recovery = 0;
        var pubKey1 = ecdsa.sig2PubKey();
        var pubKey2 =
            Ecdsa.staticSig2PubKey(sig: ecdsa.sig, hashBuf: ecdsa.hashBuf);
        expect(pubKey1.toString(), pubKey2.toString());
      });

      test(
          'should calculate the correct public key for this signature with high s',
          () {
        ecdsa.k = new BigIntX.fromString(
          '114860389168127852803919605627759231199925249596762615988727970217268189974335',
        );
        ecdsa.sign();
        ecdsa.sig = new Sig().fromString(
            '3046022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f665022100d8730ea4fa31b804c82ddcc7fd766269f33a079ea38e012c9238f2e2bcff34fe');
        ecdsa.sig!.recovery = 1;
        var pubKey1 = ecdsa.sig2PubKey();
        var pubKey2 =
            Ecdsa.staticSig2PubKey(sig: ecdsa.sig, hashBuf: ecdsa.hashBuf);
        expect(pubKey1.toString(), pubKey2.toString());
      });
    });

    // group('@asyncSig2PubKey',  () {
    //   test('should calculate the correct public key', async  () {
    //     ecdsa.k = new BigIntX(
    //       '114860389168127852803919605627759231199925249596762615988727970217268189974335',
    //       10
    //     )
    //     ecdsa.sign()
    //     ecdsa.sig.recovery = 0
    //     var pubKey1 = ecdsa.sig2PubKey();
    //     var pubKey2 = await Ecdsa.asyncSig2PubKey(ecdsa.sig, ecdsa.hashBuf);
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })

    //   test('should calculate the correct public key for this signature with low s', async  () {
    //     ecdsa.k = new BigIntX(
    //       '114860389168127852803919605627759231199925249596762615988727970217268189974335',
    //       10
    //     )
    //     ecdsa.sig = new Sig().fromString(
    //       '3045022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f6650220278cf15b05ce47fb37d2233802899d94c774d5480bba9f0f2d996baa13370c43'
    //     )
    //     ecdsa.sig.recovery = 0
    //     var pubKey1 = ecdsa.sig2PubKey();
    //     var pubKey2 = await Ecdsa.asyncSig2PubKey(ecdsa.sig, ecdsa.hashBuf);
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })

    //   test('should calculate the correct public key for this signature with high s', async  () {
    //     ecdsa.k = new BigIntX(
    //       '114860389168127852803919605627759231199925249596762615988727970217268189974335',
    //       10
    //     )
    //     ecdsa.sign()
    //     ecdsa.sig = new Sig().fromString(
    //       '3046022100ec3cfe0e335791ad278b4ec8eac93d0347a97877bb1d54d35d189e225c15f665022100d8730ea4fa31b804c82ddcc7fd766269f33a079ea38e012c9238f2e2bcff34fe'
    //     )
    //     ecdsa.sig.recovery = 1
    //     var pubKey1 = ecdsa.sig2PubKey();
    //     var pubKey2 = await Ecdsa.asyncSig2PubKey(ecdsa.sig, ecdsa.hashBuf);
    //     pubKey1.toString().should.equal(pubKey2.toString())
    //   })
    // })

    group('#verifyStr', () {
      test('should return an error if the hash is invalid', () {
        var ecdsa = new Ecdsa();
        expect(ecdsa.verifyStr(), ('hashBuf must be a 32 byte buffer'));
      });

      test('should return an error if the pubKey is invalid', () {
        var ecdsa = new Ecdsa();
        ecdsa.hashBuf = Hash.sha256(utf8.encode('test') as Uint8List).data;
        expect(
            (ecdsa.verifyStr() as String).startsWith('Invalid pubKey'), true);
      });

      test('should return an error if r, s are invalid', () {
        var ecdsa = new Ecdsa();
        ecdsa.hashBuf = Hash.sha256(utf8.encode('test') as Uint8List).data;
        var pk = new PubKey();
        pk.fromDer(hex.decode(
          '041ff0fe0f7b15ffaa85ff9f4744d539139c252a49710fb053bb9f2b933173ff9a7baad41d04514751e6851f5304fd243751703bed21b914f6be218c0fa354a341',
        ));
        ecdsa.keyPair = new KeyPair();
        ecdsa.keyPair!.pubKey = pk;
        ecdsa.sig = new Sig();
        ecdsa.sig!.r = BigIntX.zero;
        ecdsa.sig!.s = BigIntX.zero;
        expect(ecdsa.verifyStr(), ('r and s not in range'));
      });

      test('should return an error if the signature is incorrect', () {
        ecdsa.sig = new Sig();
        ecdsa.sig!.fromString(
            '3046022100e9915e6236695f093a4128ac2a956c40ed971531de2f4f41ba05fac7e2bd019c02210094e6a4a769cc7f2a8ab3db696c7cd8d56bcdbfff860a8c81de4bc6a798b90827');
        ecdsa.sig!.r = ecdsa.sig!.r!.add(BigIntX.one);
        expect(ecdsa.verifyStr(false), 'Invalid signature');
      });
    });

    group('#sign', () {
      test('should create a valid signature', () {
        ecdsa.randomK();
        ecdsa.sign();
        expect(ecdsa.verify().verified, true);
      });

      test('should should throw an error if hashBuf is not 32 bytes', () {
        var ecdsa2 = new Ecdsa(
            hashBuf: ecdsa.hashBuf!.slice(0, 31), keyPair: ecdsa.keyPair);
        ecdsa2.randomK();
        expect(
          () => ecdsa2.sign(),
          throwsA('hashBuf must be a 32 byte buffer'),
        );
      });
    });

    // group('#asyncSign',  () {
    //   test('should create the same signature as sign', async  () {
    //     ecdsa.sign()
    //     var sig = ecdsa.sig;
    //     var sig2 = ecdsa.sig;
    //     await ecdsa.asyncSign()
    //     sig.toString().should.equal(sig2.toString())
    //   })
    // })

    group('#signRandomK', () {
      test('should produce a signature, and be different when called twice',
          () {
        ecdsa.signRandomK();
        expect(ecdsa.sig != null, true);
        var ecdsa2 = Ecdsa().fromJSON(ecdsa.toJSON());
        ecdsa2.signRandomK();
        expect(ecdsa.sig.toString() != ecdsa2.sig.toString(), true);
      });
    });

    // group('#toString',  () {
    //   test('should convert this to a string',  () {
    //     var str = ecdsa.toString();
    //     ;(typeof str == 'string').should.equal(true)
    //   })
    // })

    group('#verify', () {
      test('should verify a signature that was just signed', () {
        ecdsa.sign();
        expect(ecdsa.verify().verified, true);
      });

      test('should verify this known good signature', () {
        ecdsa.sig = new Sig();
        ecdsa.sig!.fromString(
            '3046022100e9915e6236695f093a4128ac2a956c40ed971531de2f4f41ba05fac7e2bd019c02210094e6a4a769cc7f2a8ab3db696c7cd8d56bcdbfff860a8c81de4bc6a798b90827');
        expect(ecdsa.verify(false).verified, true);
      });
    });

    // group('#asyncVerify',  () {
    //   test('should verify this known good signature', async  () {
    //     ecdsa.verified = undefined
    //     ecdsa.signRandomK()
    //     await ecdsa.asyncVerify()
    //     ecdsa.verified.should.equal(true)
    //   })
    // })

    group('@sign', () {
      test('should produce a signature', () {
        var sig =
            Ecdsa.staticSign(hashBuf: ecdsa.hashBuf, keyPair: ecdsa.keyPair);
        expect(sig is Sig, true);
      });
    });

    // group('@asyncSign',  () {
    //   test('should produce the same signature as @sign', async  () {
    //     var sig = Ecdsa.sign(ecdsa.hashBuf, ecdsa.keyPair);
    //     var sigstr = sig.toString();
    //     var sig2 = await Ecdsa.asyncSign(ecdsa.hashBuf, ecdsa.keyPair);
    //     var sig2str = sig2.toString();
    //     sigstr.should.equal(sig2str)
    //   })
    // })

    group('@verify', () {
      test('should verify a valid signature, and unverify an invalid signature',
          () {
        var sig =
            Ecdsa.staticSign(hashBuf: ecdsa.hashBuf, keyPair: ecdsa.keyPair)!;
        expect(
          Ecdsa.staticVerify(
            hashBuf: ecdsa.hashBuf,
            sig: sig,
            pubKey: ecdsa.keyPair!.pubKey,
          ),
          true,
        );
        var fakesig = new Sig(r: sig.r!.add(BigIntX.one), s: sig.s);

        expect(
          Ecdsa.staticVerify(
            hashBuf: ecdsa.hashBuf,
            sig: fakesig,
            pubKey: ecdsa.keyPair!.pubKey,
          ),
          false,
        );
      });

      test('should work with big and little endian', () {
        var sig = Ecdsa.staticSign(
            hashBuf: ecdsa.hashBuf, keyPair: ecdsa.keyPair, endian: Endian.big);
        expect(
          Ecdsa.staticVerify(
              hashBuf: ecdsa.hashBuf,
              sig: sig,
              pubKey: ecdsa.keyPair!.pubKey,
              endian: Endian.big),
          true,
        );

        expect(
          Ecdsa.staticVerify(
            hashBuf: ecdsa.hashBuf,
            sig: sig,
            pubKey: ecdsa.keyPair!.pubKey,
            endian: Endian.little,
          ),
          false,
        );

        sig = Ecdsa.staticSign(
            hashBuf: ecdsa.hashBuf,
            keyPair: ecdsa.keyPair,
            endian: Endian.little);

        expect(
          Ecdsa.staticVerify(
              hashBuf: ecdsa.hashBuf,
              sig: sig,
              pubKey: ecdsa.keyPair!.pubKey,
              endian: Endian.big),
          false,
        );

        expect(
          Ecdsa.staticVerify(
            hashBuf: ecdsa.hashBuf,
            sig: sig,
            pubKey: ecdsa.keyPair!.pubKey,
            endian: Endian.little,
          ),
          true,
        );
      });
    });

    // group('@asyncVerify',  () {
    //   test('should verify a valid signature, and unverify an invalid signature', async  () {
    //     var sig = Ecdsa.sign(ecdsa.hashBuf, ecdsa.keyPair);
    //     var verified = await Ecdsa.asyncVerify(
    //       ecdsa.hashBuf,
    //       sig,
    //       ecdsa.keyPair.pubKey
    //     )
    //     verified.should.equal(true)
    //     var fakesig = new Sig(sig.r.add(1), sig.s);
    //     verified = await Ecdsa.asyncVerify(
    //       ecdsa.hashBuf,
    //       fakesig,
    //       ecdsa.keyPair.pubKey
    //     )
    //     verified.should.equal(false)
    //   })
    // })

    group('vectors', () {
      var valid = ecdsaJson['valid'];

      for (var i = 0; i < valid.length; i++) {
        test('should validate valid vector $i', () {
          var obj = valid[i];
          var ecdsa = Ecdsa(
            keyPair: KeyPair().fromPrivKey(
                PrivKey().fromBn(BigIntX.fromBuffer(hex.decode(obj['d'])))),
            k: BigIntX.fromBuffer(hex.decode(obj['k'])),
            hashBuf: Hash.sha256(utf8.encode(obj['message']) as Uint8List).data,
            sig: Sig(
              r: BigIntX.fromString(obj['signature']['r']),
              s: BigIntX.fromString(obj['signature']['s']),
              recovery: obj['i'],
            ),
          );
          var ecdsa2 = Ecdsa().fromJSON(ecdsa.toJSON());
          ecdsa2.k = null;
          ecdsa2.sign();
          ecdsa2.calcrecovery();
          expect(ecdsa2.sig.toString(), (ecdsa.sig.toString()));
          expect(ecdsa2.sig!.recovery, (ecdsa.sig!.recovery));
          expect(ecdsa.verify().verified, (true));
        });
      }

      var invalid = ecdsaJson['invalid']['verifystr'];

      for (var i = 0; i < invalid.length; i++) {
        var obj = invalid[i];
        test(
            'should validate invalid.verifystr vector $i: ${obj['description']}',
            () {
          var ecdsa = Ecdsa(
            keyPair: KeyPair(
              pubKey: PubKey(
                point: PointWrapper.fromX(
                  isOdd: true,
                  x: BigInt.one,
                ),
              ),
            ),
            sig: Sig(
              r: BigIntX.fromString(obj['signature']['r']),
              s: BigIntX.fromString(obj['signature']['s']),
            ),
            hashBuf: Hash.sha256(utf8.encode(obj['message']) as Uint8List).data,
          );
          expect(ecdsa.verifyStr(), obj['exception']);
        });
      }

      var deterministicK = ecdsaJson['deterministicK'];

      for (var i = 0; i < deterministicK.length; i++) {
        var obj = deterministicK[i];

        test('should validate deterministicK vector $i', () {
          var hashBuf = Hash.sha256(utf8.encode(obj['message']) as Uint8List);

          var privKey = new PrivKey(
            bn: new BigIntX.fromBuffer(hex.decode(obj['privkey'])),
          );

          var ecdsa = new Ecdsa(
            keyPair: new KeyPair(privKey: privKey),
            hashBuf: hashBuf.data,
          );

          expect(ecdsa.deterministicK(0).k!.toHex(), obj['k_bad00']);
          expect(ecdsa.deterministicK(1).k!.toHex(), obj['k_bad01']);
          expect(ecdsa.deterministicK(15).k!.toHex(), obj['k_bad15']);
        });
      }
    });
  });
}
