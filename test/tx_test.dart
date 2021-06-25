import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/interp.dart';
import 'package:bsv/key_pair.dart';
import 'package:bsv/script.dart';
import 'package:bsv/sig.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_in.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/var_int.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

import 'vectors/bip69.dart';
import 'vectors/bitcoin-abc/sighash.dart';
import 'vectors/bitcoind/sighash.dart';
import 'vectors/bitcoind/tx_invalid.dart';
import 'vectors/bitcoind/tx_valid.dart';
import 'vectors/largesttx.dart';

void main() {
  group('Tx', () {
    var txIn = new TxIn().fromBuffer(hex.decode(
      '00000000000000000000000000000000000000000000000000000000000000000000000001ae00000000',
    ));

    var txOut = new TxOut().fromBuffer(hex.decode('050000000000000001ae'));
    var tx = new Tx(
      versionBytesNum: 0,
      txInsVi: VarInt.fromNumber(1),
      txIns: [txIn],
      txOutsVi: VarInt.fromNumber(1),
      txOuts: [txOut],
      nLockTime: 0,
    );
    var txhex =
        '000000000100000000000000000000000000000000000000000000000000000000000000000000000001ae0000000001050000000000000001ae00000000';
    var txbuf = hex.decode(txhex);

    var tx2idhex =
        '8c9aa966d35bfeaf031409e0001b90ccdafd8d859799eb945a3c515b8260bcf2';
    var tx2hex =
        '01000000029e8d016a7b0dc49a325922d05da1f916d1e4d4f0cb840c9727f3d22ce8d1363f000000008c493046022100e9318720bee5425378b4763b0427158b1051eec8b08442ce3fbfbf7b30202a44022100d4172239ebd701dae2fbaaccd9f038e7ca166707333427e3fb2a2865b19a7f27014104510c67f46d2cbb29476d1f0b794be4cb549ea59ab9cc1e731969a7bf5be95f7ad5e7f904e5ccf50a9dc1714df00fbeb794aa27aaff33260c1032d931a75c56f2ffffffffa3195e7a1ab665473ff717814f6881485dc8759bebe97e31c301ffe7933a656f020000008b48304502201c282f35f3e02a1f32d2089265ad4b561f07ea3c288169dedcf2f785e6065efa022100e8db18aadacb382eed13ee04708f00ba0a9c40e3b21cf91da8859d0f7d99e0c50141042b409e1ebbb43875be5edde9c452c82c01e3903d38fa4fd89f3887a52cb8aea9dc8aec7e2c9d5b3609c03eb16259a2537135a1bf0f9c5fbbcbdbaf83ba402442ffffffff02206b1000000000001976a91420bb5c3bfaef0231dc05190e7f1c8e22e098991e88acf0ca0100000000001976a9149e3e2d23973a04ec1b02be97c30ab9f2f27c3b2c88ac00000000';
    var tx2buf = hex.decode(tx2hex);

    test('should make a new transaction', () {
      var tx = new Tx();

      expect(Tx.fromBuffer(txbuf).toBuffer().toHex(), txhex);

      // should set known defaults
      expect(tx.versionBytesNum, (1));
      expect(tx.txInsVi.toNumber(), (0));
      expect(tx.txIns.length, (0));
      expect(tx.txOutsVi.toNumber(), (0));
      expect(tx.txOuts.length, (0));
      expect(tx.nLockTime, (0));
    });

    group('#constructor', () {
      test('should set these known defaults', () {
        var tx = new Tx();
        expect(tx.versionBytesNum, (1));
        expect(tx.txInsVi.toNumber(), (0));
        expect(tx.txIns.length, (0));
        expect(tx.txOutsVi.toNumber(), (0));
        expect(tx.txOuts.length, (0));
        expect(tx.nLockTime, (0));
      });
    });

    // group('#clone',  () {
    //   test('should clone a tx',  () {
    //     var tx1 = Tx.fromHex(tx2hex)
    //     var tx2 = tx1.clone()
    //     tx2.should.not.equal(tx1)
    //     tx2.toHex().should.equal(tx1.toHex())
    //   })
    // })

    // group('#cloneByBuffer', () {
    //   test('should clone a tx by buffer', () {
    //     var tx1 = Tx.fromHex(tx2hex);
    //     var tx2 = tx1.cloneByBuffer();
    //     expect(tx2 != tx1, true);
    //     expect(tx2.toHex(), tx1.toHex());
    //   });
    // });

    // group('#fromObject',  () {
    //   test('should set all the basic parameters',  () {
    //     var tx = new Tx().fromObject({
    //       versionBytesNum: 0,
    //       txInsVi: VarInt.fromNumber(1),
    //       txIns: [txIn],
    //       txOutsVi: VarInt.fromNumber(1),
    //       txOuts: [txOut],
    //       nLockTime: 0
    //     })
    //     should.exist(tx.versionBytesNum)
    //     should.exist(tx.txInsVi)
    //     should.exist(tx.txIns)
    //     should.exist(tx.txOutsVi)
    //     should.exist(tx.txOuts)
    //     should.exist(tx.nLockTime)
    //   })
    // })

    group('#fromJSON', () {
      test('should set all the basic parameters', () {
        var tx = new Tx().fromJSON({
          "versionBytesNum": 0,
          "txInsVi": VarInt.fromNumber(1).toJSON(),
          "txIns": [txIn.toJSON()],
          "txOutsVi": VarInt.fromNumber(1).toJSON(),
          "txOuts": [txOut.toJSON()],
          "nLockTime": 0
        });
        expect(tx.versionBytesNum != null, true);
        expect(tx.txInsVi != null, true);
        expect(tx.txIns != null, true);
        expect(tx.txOutsVi != null, true);
        expect(tx.txOuts != null, true);
        expect(tx.nLockTime != null, true);
      });
    });

    group('#toJSON', () {
      test('should recover all the basic parameters', () {
        var json = tx.toJSON();
        expect(json['versionBytesNum'] != null, true);
        expect(json['txInsVi'] != null, true);
        expect(json['txIns'] != null, true);
        expect(json['txOutsVi'] != null, true);
        expect(json['txOuts'] != null, true);
        expect(json['nLockTime'] != null, true);
      });
    });

    group('#fromHex', () {
      test('should recover from this known tx', () {
        expect(Tx().fromHex(txhex).toHex(), txhex);
      });

      test('should recover from this known tx from the blockchain', () {
        expect(Tx().fromHex(tx2hex).toHex(), tx2hex);
      });
    });

    group('#fromBuffer', () {
      test('should recover from this known tx', () {
        expect(Tx().fromBuffer(txbuf).toBuffer().toHex(), txhex);
      });

      test('should recover from this known tx from the blockchain', () {
        expect(Tx().fromBuffer(tx2buf).toBuffer().toHex(), tx2hex);
      });
    });

    group('#fromBr', () {
      test('should recover from this known tx', () {
        expect(new Tx().fromBr(new Br(buf: txbuf)).toBuffer().toHex(), txhex);
      });
    });

    group('#toHex', () {
      test('should produce this known tx', () {
        expect(new Tx().fromHex(txhex).toHex(), txhex);
      });
    });

    group('#toBuffer', () {
      test('should produce this known tx', () {
        expect(new Tx().fromBuffer(txbuf).toBuffer().toHex(), txhex);
      });
    });

    group('#toBw', () {
      test('should produce this known tx', () {
        expect(new Tx().fromBuffer(txbuf).toBw().toBuffer().toHex(), txhex);
      });
    });

    group('#sighash', () {
      test('should hash this transaction', () {
        expect(tx.sighash(nHashType: 0, nIn: 0, subScript: new Script()).length,
            32);
      });

      test('should return 1 for the SIGHASH_SINGLE bug', () {
        var tx = Tx.fromBuffer(tx2buf);
        tx.txOuts.length = 1;
        tx.txOutsVi = VarInt.fromNumber(1);
        expect(
          tx
              .sighash(
                nHashType: Sig.SIGHASH_SINGLE,
                nIn: 1,
                subScript: new Script(),
              )
              .toHex(),
          '0000000000000000000000000000000000000000000000000000000000000001',
        );
      });
    });

    // group('#asyncSighash',  () {
    //   test('should hash this transaction', async  () {
    //     var hashBuf = await tx.asyncSighash(0, 0, new Script())
    //     hashBuf.length.should.equal(32)
    //   })

    //   test('should return 1 for the SIGHASH_SINGLE bug', async  () {
    //     var tx = Tx.fromBuffer(tx2buf)
    //     tx.txOuts.length = 1
    //     tx.txOutsVi = VarInt.fromNumber(1)
    //     var hashBuf = await tx.asyncSighash(Sig.SIGHASH_SINGLE, 1, new Script())
    //     hashBuf
    //       .toString('hex')
    //       .should.equal(
    //         '0000000000000000000000000000000000000000000000000000000000000001'
    //       )
    //   })
    // })

    group('#sign', () {
      test('should return a signature', () {
        var keyPair = new KeyPair().fromRandom();
        var sig1 = tx.sign(
          keyPair: keyPair,
          nHashType: Sig.SIGHASH_ALL,
          nIn: 0,
          subScript: new Script(),
        );
        expect(sig1 != null, true);
        var sig2 = tx.sign(
          keyPair: keyPair,
          nHashType: Sig.SIGHASH_SINGLE,
          nIn: 0,
          subScript: new Script(),
        );
        var sig3 = tx.sign(
          keyPair: keyPair,
          nHashType: Sig.SIGHASH_ALL,
          nIn: 0,
          subScript: new Script().fromString('OP_RETURN'),
        );
        expect(sig1.toString() != sig2.toString(), true);
        expect(sig1.toString() != sig3.toString(), true);
      });
    });

    // group('#asyncSign',  () {
    //   test('should return a signature', async  () {
    //     var keyPair = new KeyPair().fromRandom()
    //     var sig1 = tx.sign(keyPair, Sig.SIGHASH_ALL, 0, new Script())
    //     var sig1b = await tx.asyncSign(keyPair, Sig.SIGHASH_ALL, 0, new Script())
    //     var sig2 = tx.sign(keyPair, Sig.SIGHASH_SINGLE, 0, new Script())
    //     var sig2b = await tx.asyncSign(
    //       keyPair,
    //       Sig.SIGHASH_SINGLE,
    //       0,
    //       new Script()
    //     )
    //     var sig3 = tx.sign(
    //       keyPair,
    //       Sig.SIGHASH_ALL,
    //       0,
    //       new Script().fromString('OP_RETURN')
    //     )
    //     var sig3b = await tx.asyncSign(
    //       keyPair,
    //       Sig.SIGHASH_ALL,
    //       0,
    //       new Script().fromString('OP_RETURN')
    //     )
    //     sig1.toString().should.equal(sig1b.toString())
    //     sig2.toString().should.equal(sig2b.toString())
    //     sig3.toString().should.equal(sig3b.toString())
    //   })
    // })

    group('#verify', () {
      test('should return a signature', () {
        var keyPair = new KeyPair().fromRandom();
        var sig1 = tx.sign(
          keyPair: keyPair,
          nHashType: Sig.SIGHASH_ALL,
          nIn: 0,
          subScript: new Script(),
        );
        expect(
          tx.verify(
            sig: sig1,
            pubKey: keyPair.pubKey,
            nIn: 0,
            subScript: new Script(),
          ),
          true,
        );
      });
    });

    // group('#asyncVerify',  () {
    //   test('should return a signature', async  () {
    //     var keyPair = new KeyPair().fromRandom()
    //     var sig1 = tx.sign(keyPair, Sig.SIGHASH_ALL, 0, new Script())
    //     var verified = await tx.asyncVerify(sig1, keyPair.pubKey, 0, new Script())
    //     verified.should.equal(true)
    //   })
    // })

    group('#hash', () {
      test('should correctly calculate the hash of this known transaction', () {
        var tx = Tx.fromBuffer(tx2buf);
        var txHashBuf = List<int>.from(
          // Array.apply([], hex.decode(tx2idhex, 'hex')).reverse()
          hex.decode(tx2idhex).reversed.toList(),
        );

        expect(tx.hash().data.toList().toHex(), txHashBuf.toHex());
      });
    });

    // group('#asyncHash',  () {
    //   test('should correctly calculate the hash of this known transaction', async  () {
    //     var tx = Tx.fromBuffer(tx2buf)
    //     var txHashBuf = hex.decode(
    //       Array.apply([], hex.decode(tx2idhex, 'hex')).reverse()
    //     )
    //     var hashBuf = await tx.asyncHash()
    //     hashBuf.toString('hex').should.equal(txHashBuf.toString('hex'))
    //   })
    // })

    group('#id', () {
      test('should correctly calculate the id of this known transaction', () {
        var tx = Tx.fromBuffer(tx2buf);
        expect(tx.id(), tx2idhex);
      });
    });

    // group('#asyncId',  () {
    //   test('should correctly calculate the id of this known transaction', async  () {
    //     var tx = Tx.fromBuffer(tx2buf)
    //     var idbuf = await tx.asyncId()
    //     idbuf.should.equal(tx2idhex)
    //   })
    // })

    group('#addTxIn', () {
      test('should add an input', () {
        var txIn = new TxIn();
        var tx = new Tx();
        expect(tx.txInsVi.toNumber(), 0);
        tx.addTxIn(data: txIn);
        expect(tx.txInsVi.toNumber(), 1);
        expect(tx.txIns.length, 1);
      });
    });

    group('#addTxOut', () {
      test('should add an output', () {
        var txOut = new TxOut();
        var tx = new Tx();
        expect(tx.txOutsVi.toNumber(), 0);
        tx.addTxOut(data: txOut);
        expect(tx.txOutsVi.toNumber(), 1);
        expect(tx.txOuts.length, 1);
      });
    });

    group('bectors: bip69 (from bitcoinjs)', () {
      // returns index-based order of sorted against original
      getIndexOrder(List original, List sorted) {
        return sorted.map((value) {
          return original.indexOf(value);
        });
      }

      var inputs = bip69JSON['inputs'];

      for (var i = 0; i < inputs.length; i++) {
        var inputSet = inputs[i];
        test(inputSet['description'], () {
          var tx = new Tx();
          var list = inputSet['inputs'] as List<dynamic>;
          var txIns = list.map((input) {
            var txHashBuf = hex.decode(input['txId']).reversed.toList();
            var txOutNum = input['vout'];
            var script = new Script();
            var txIn = TxIn.fromProperties(
              txHashBuf: txHashBuf,
              txOutNum: txOutNum,
              script: script,
            );
            return txIn;
          }).toList();
          tx.txIns = [...txIns];
          tx.sort();
          expect(
            getIndexOrder(txIns, tx.txIns).toList().toString(),
            inputSet['expected'].toString(),
          );
          // getIndexOrder(txIns, tx.txIns).toString().should.equal(inputSet.expected.toString())
        });
      }

      var outputs = bip69JSON['outputs'];

      for (var i = 0; i < outputs.length; i++) {
        var outputSet = outputs[i];
        test(outputSet['description'], () {
          var tx = new Tx();
          var list = outputSet['outputs'] as List<dynamic>;

          var txOuts = list.map((output) {
            var txOut = TxOut.fromProperties(
              valueBn: BigIntX.fromNum(output['value']),
              script: Script.fromAsmString(output['script']),
            );
            return txOut;
          }).toList();
          tx.txOuts = [...txOuts];
          tx.sort();

          expect(
            getIndexOrder(txOuts, tx.txOuts).toList().toString(),
            outputSet['expected'].toString(),
          );
        });
      }
    });

    group('vectors: a 1mb transaction', () {
      test(
          'should find the correct id of this (valid, on the blockchain) 1 mb transaction',
          () {
        var txidhex = largesttxvector['txidhex'];
        var txhex = largesttxvector['txhex'];
        var tx = Tx.fromHex(txhex);
        var txid = tx.id();
        expect(txid, txidhex);
      });
    });

    group('vectors: sighash and serialization', () {
      //
      for (var i = 0; i < vectorsBitcoindSighash.length; i++) {
        // break;
        if (i == 0) {
          continue;
        }
        var vector = vectorsBitcoindSighash[i];

        test('should pass bitcoind sighash test vector $i', () {
          var txbuf = hex.decode(vector[0]);
          var scriptbuf = hex.decode(vector[1]);
          var subScript = new Script().fromBuffer(scriptbuf);
          var nIn = vector[2];
          var nHashType = vector[3];
          var sighashBuf = hex.decode(vector[4]);
          var tx = Tx.fromBuffer(txbuf);

          // make sure transacion to/from buffer is isomorphic
          expect(tx.toHex(), txbuf.toHex());

          // sighash ought to be correct
          expect(
            tx
                .sighash(
                  nHashType: nHashType,
                  nIn: nIn,
                  subScript: subScript,
                )
                .toHex(),
            sighashBuf.toHex(),
          );
        });
        // break;
      }

      // for (var i = 503; i < vectorsBitcoinABCSighash.length; i++) {
      for (var i = 0; i < vectorsBitcoinABCSighash.length; i++) {
        // break;
        if (i == 0) {
          continue;
        }
        var vector = vectorsBitcoinABCSighash[i];
        test('should pass bitcoin-abc sighash test vector $i', () {
          if (vector[0] == 'Test vectors for SIGHASH_FORKID') {
            return;
          }
          var txbuf = hex.decode(vector[0]);
          var scriptbuf = hex.decode(vector[1]);
          var subScript = new Script().fromBuffer(scriptbuf);
          var nIn = vector[2];
          var nHashType = vector[3] as int;
          var sighashBuf = hex.decode(vector[4]);
          var tx = Tx.fromBuffer(txbuf);

          // make sure transacion to/from buffer is isomorphic
          expect(tx.toBuffer().toHex(), txbuf.toHex());

          // sighash ought to be correct
          var valueBn = BigIntX.zero;
          var flags = 0;
          if (nHashType & Sig.SIGHASH_FORKID != 1) {
            flags = Interp.SCRIPT_ENABLE_SIGHASH_FORKID;
          }
          expect(
            tx
                .sighash(
                  nHashType: nHashType,
                  nIn: nIn,
                  subScript: subScript,
                  valueBn: valueBn,
                  flags: flags,
                )
                .toHex(),
            sighashBuf.toHex(),
          );
        });
      }

      for (var i = 0; i < vectorsBitcoindTxValid.length; i++) {
        var vector = vectorsBitcoindTxValid[i];
        if (vector.length == 1) {
          continue;
        }
        test('should correctly serialized/deserialize tx_valid test vector $i',
            () {
          var txhex = vector[1];
          var txbuf = hex.decode(vector[1]);
          var tx = Tx.fromBuffer(txbuf);
          expect(tx.toBuffer().toHex(), txhex);
        });
      }

      for (var i = 0; i < vectorsBitcoindTxInvalid.length; i++) {
        var vector = vectorsBitcoindTxValid[i];
        if (vector.length == 1) {
          continue;
        }
        test(
            'should correctly serialized/deserialize tx_invalid test vector $i',
            () {
          var txhex = vector[1];
          var txbuf = hex.decode(vector[1]);
          var tx = Tx.fromBuffer(txbuf);
          expect(tx.toBuffer().toHex(), txhex);
        });
      }
    });
  });
}
