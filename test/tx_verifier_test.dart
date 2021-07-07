import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/interp.dart';
import 'package:bsv/script.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/tx_out_map.dart';
import 'package:bsv/tx_verifier.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

import 'vectors/bitcoind/tx_invalid.dart';

void main() {
  group('TxVerifier', () {
    // test('should make a new txVerifier',  () {
    //   var txVerifier = new TxVerifier()
    //   ;(txVerifier instanceof TxVerifier).should.equal(true)
    //   txVerifier = new TxVerifier()
    //   ;(txVerifier instanceof TxVerifier).should.equal(true)
    //   txVerifier = new TxVerifier({
    //     tx: new Tx()
    //   })
    //   should.exist(txVerifier.tx)
    // })

    group('#getDebugObject', () {
      test('should get an object with these properties', () async {
        var vector = vectorsBitcoindTxInvalid[10];
        List inputs = vector[0];
        var txhex = vector[1];
        var flags = Interp.getFlags(vector[2]);

        var txOutMap = new TxOutMap();
        inputs.forEach((input) {
          var txOutNum = input[1];
          if (txOutNum == -1) {
            txOutNum = 0xffffffff; // bitcoind casts -1 to an unsigned int
          }
          var txOut = TxOut.fromProperties(
            valueBn: BigIntX.zero,
            script: new Script().fromBitcoindString(input[2]),
          );
          var txHashBuf = new Br(buf: hex.decode(input[0])).readReverse();
          txOutMap.set(txHashBuf, txOutNum, txOut);
        });

        var tx = new Tx().fromBuffer(hex.decode(txhex));
        var txVerifier = new TxVerifier(tx: tx, txOutMap: txOutMap);
        var verified = await txVerifier.verify(flags);
        expect(verified, false);
        var debugObject = txVerifier.getDebugObject();
        expect(debugObject['errStr'] != null, true);
        expect(debugObject['interpFailure'] != null, true);
      });
    });

    group('#getDebugString', () {
      test('should get an object with these properties', () async {
        var vector = vectorsBitcoindTxInvalid[10];
        List inputs = vector[0];
        var txhex = vector[1];
        var flags = Interp.getFlags(vector[2]);

        var txOutMap = new TxOutMap();
        inputs.forEach((input) {
          var txOutNum = input[1];
          if (txOutNum == -1) {
            txOutNum = 0xffffffff; // bitcoind casts -1 to an unsigned int
          }
          var txOut = TxOut.fromProperties(
            valueBn: BigIntX.zero,
            script: new Script().fromBitcoindString(input[2]),
          );
          var txHashBuf = new Br(buf: hex.decode(input[0])).readReverse();
          txOutMap.set(txHashBuf, txOutNum, txOut);
        });

        var tx = new Tx().fromBuffer(hex.decode(txhex));
        var txVerifier = new TxVerifier(tx: tx, txOutMap: txOutMap);
        var verified = await txVerifier.verify(flags);
        expect(verified, false);
        var debugString = txVerifier.getDebugString();
        expect(debugString != null, true);
      });
    });

    // TODO:NEXT
    // group('vectors',  () {
    //   test('should validate the coolest transaction ever',  () {
    //     // This test vector was given to me by JJ of bcoin. It is a transaction
    //     // with code seperators in the input. It also uses what used to be
    //     // OP_NOP2 but is now OP_CHECKLOCKTIMEVERIFY, so the
    //     // OP_CHECKLOCKTIMEVERIFY flag cannot be enabled to verify this tx.
    //     var flags = 0
    //     var tx = Tx.fromHex(coolestTxVector.tx)
    //     var intx0 = Tx.fromHex(coolestTxVector.intx0)
    //     var intx1 = Tx.fromHex(coolestTxVector.intx1)
    //     var txOutMap = new TxOutMap()
    //     txOutMap.setTx(intx0)
    //     txOutMap.setTx(intx1)
    //     var txVerifier = new TxVerifier(tx, txOutMap)
    //     var str = txVerifier.verifyStr(flags)
    //     str.should.equal(false)
    //   })

    //   test('should validate this sighash single test vector',  () {
    //     // This test vector was given to me by JJ of bcoin. It is a transaction
    //     // on testnet, not mainnet. It highlights the famous "sighash single bug"
    //     // which is where sighash single returns a transaction hash of all 00s in
    //     // the case where there are more inputs than outputs. Peter Todd has
    //     // written about the sighash single bug here:
    //     // https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2014-November/006878.html
    //     var flags = 0
    //     var tx = Tx.fromHex(sighashSingleVector.tx)
    //     var intx0 = Tx.fromHex(sighashSingleVector.intx0)
    //     var intx1 = Tx.fromHex(sighashSingleVector.intx1)
    //     var txOutMap = new TxOutMap()
    //     txOutMap.setTx(intx0)
    //     txOutMap.setTx(intx1)
    //     var txVerifier = new TxVerifier(tx, txOutMap)
    //     var str = txVerifier.verifyStr(flags)
    //     str.should.equal(false)
    //   })
    // })

    // group('TxVerifier Vectors',  () {
    //   var c = 0
    //   txValid.forEach( (vector, i) {
    //     if (vector.length == 1) {
    //       return
    //     }
    //     c++
    //     test('should verify txValid vector ' + c,  () {
    //       var inputs = vector[0]
    //       var txhex = vector[1]
    //       var flags = Interp.getFlags(vector[2])

    //       var txOutMap = new TxOutMap()
    //       inputs.forEach( (input) {
    //         var txOutNum = input[1]
    //         if (txOutNum == -1) {
    //           txOutNum = 0xffffffff // bitcoind casts -1 to an unsigned int
    //         }
    //         var txOut = TxOut.fromProperties(
    //           new Bn(0),
    //           new Script().fromBitcoindString(input[2])
    //         )
    //         var txHashBuf = new Br(Buffer.from(input[0], 'hex')).readReverse()
    //         txOutMap.set(txHashBuf, txOutNum, txOut)
    //       })

    //       var tx = new Tx().fromBuffer(Buffer.from(txhex, 'hex'))
    //       var verified = TxVerifier.verify(tx, txOutMap, flags)
    //       verified.should.equal(true)
    //     })

    //     test('should async verify txValid vector ' + c, async  () {
    //       var inputs = vector[0]
    //       var txhex = vector[1]
    //       var flags = Interp.getFlags(vector[2])

    //       var txOutMap = new TxOutMap()
    //       inputs.forEach( (input) {
    //         var txOutNum = input[1]
    //         if (txOutNum == -1) {
    //           txOutNum = 0xffffffff // bitcoind casts -1 to an unsigned int
    //         }
    //         var txOut = TxOut.fromProperties(
    //           new Bn(0),
    //           new Script().fromBitcoindString(input[2])
    //         )
    //         var txHashBuf = new Br(Buffer.from(input[0], 'hex')).readReverse()
    //         txOutMap.set(txHashBuf, txOutNum, txOut)
    //       })

    //       var tx = new Tx().fromBuffer(Buffer.from(txhex, 'hex'))
    //       var verified = await TxVerifier.asyncVerify(tx, txOutMap, flags)
    //       verified.should.equal(true)
    //     })
    //   })

    //   c = 0
    //   txInvalid.forEach( (vector, i) {
    //     if (vector.length == 1) {
    //       return
    //     }
    //     c++
    //     test('should unverify txInvalid vector ' + c,  () {
    //       var inputs = vector[0]
    //       var txhex = vector[1]
    //       var flags = Interp.getFlags(vector[2])

    //       var txOutMap = new TxOutMap()
    //       inputs.forEach( (input) {
    //         var txOutNum = input[1]
    //         if (txOutNum == -1) {
    //           txOutNum = 0xffffffff // bitcoind casts -1 to an unsigned int
    //         }
    //         var txOut = TxOut.fromProperties(
    //           new Bn(0),
    //           new Script().fromBitcoindString(input[2])
    //         )
    //         var txHashBuf = new Br(Buffer.from(input[0], 'hex')).readReverse()
    //         txOutMap.set(txHashBuf, txOutNum, txOut)
    //       })

    //       var tx = new Tx().fromBuffer(Buffer.from(txhex, 'hex'))

    //       var verified = TxVerifier.verify(tx, txOutMap, flags)
    //       verified.should.equal(false)
    //     })

    //     test('should async unverify txInvalid vector ' + c, async  () {
    //       var inputs = vector[0]
    //       var txhex = vector[1]
    //       var flags = Interp.getFlags(vector[2])

    //       var txOutMap = new TxOutMap()
    //       inputs.forEach( (input) {
    //         var txOutNum = input[1]
    //         if (txOutNum == -1) {
    //           txOutNum = 0xffffffff // bitcoind casts -1 to an unsigned int
    //         }
    //         var txOut = TxOut.fromProperties(
    //           new Bn(0),
    //           new Script().fromBitcoindString(input[2])
    //         )
    //         var txHashBuf = new Br(Buffer.from(input[0], 'hex')).readReverse()
    //         txOutMap.set(txHashBuf, txOutNum, txOut)
    //       })

    //       var tx = new Tx().fromBuffer(Buffer.from(txhex, 'hex'))

    //       var verified = await TxVerifier.asyncVerify(tx, txOutMap, flags)
    //       verified.should.equal(false)
    //     })
    //   })
    // })
  });
}
