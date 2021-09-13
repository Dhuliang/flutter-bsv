import 'dart:typed_data';

import 'package:bsv/src/bn.dart';
import 'package:bsv/src/br.dart';
import 'package:bsv/src/interp.dart';
import 'package:bsv/src/script.dart';
import 'package:bsv/src/tx.dart';
import 'package:bsv/src/tx_out.dart';
import 'package:bsv/src/tx_out_map.dart';
import 'package:bsv/src/tx_verifier.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

import 'vectors/bitcoind/tx_invalid.dart';
import 'vectors/bitcoind/tx_valid.dart';
import 'vectors/coolest-tx-ever-sent.dart';
import 'vectors/sighash-single-bug.dart';

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
        List inputs = vector[0] as List<dynamic>;
        var txhex = vector[1];
        var flags = Interp.getFlags(vector[2] as String);

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
          var txHashBuf =
              new Br(buf: hex.decode(input[0]) as Uint8List?).readReverse();
          txOutMap.set(txHashBuf, txOutNum, txOut);
        });

        var tx = new Tx().fromBuffer(hex.decode(txhex as String));
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
        List inputs = vector[0] as List<dynamic>;
        var txhex = vector[1];
        var flags = Interp.getFlags(vector[2] as String);

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
          var txHashBuf =
              new Br(buf: hex.decode(input[0]) as Uint8List?).readReverse();
          txOutMap.set(txHashBuf, txOutNum, txOut);
        });

        var tx = new Tx().fromBuffer(hex.decode(txhex as String));
        var txVerifier = new TxVerifier(tx: tx, txOutMap: txOutMap);
        var verified = await txVerifier.verify(flags);
        expect(verified, false);
        var debugString = txVerifier.getDebugString();
        expect(debugString.isNotEmpty, true);
      });
    });

    group('vectors', () {
      test('should validate the coolest transaction ever', () async {
        // This test vector was given to me by JJ of bcoin. It is a transaction
        // with code seperators in the input. It also uses what used to be
        // OP_NOP2 but is now OP_CHECKLOCKTIMEVERIFY, so the
        // OP_CHECKLOCKTIMEVERIFY flag cannot be enabled to verify this tx.
        var flags = 0;
        var tx = Tx.fromHex(coolestTxVector['tx']!);
        var intx0 = Tx.fromHex(coolestTxVector['intx0']!);
        var intx1 = Tx.fromHex(coolestTxVector['intx1']!);
        var txOutMap = new TxOutMap();
        txOutMap.setTx(intx0);
        txOutMap.setTx(intx1);
        var txVerifier = new TxVerifier(tx: tx, txOutMap: txOutMap);
        var str = await txVerifier.verifyStr(flags);
        expect(str, false);
      });

      test('should validate this sighash single test vector', () async {
        // This test vector was given to me by JJ of bcoin. It is a transaction
        // on testnet, not mainnet. It highlights the famous "sighash single bug"
        // which is where sighash single returns a transaction hash of all 00s in
        // the case where there are more inputs than outputs. Peter Todd has
        // written about the sighash single bug here:
        // https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2014-November/006878.html
        var flags = 0;
        var tx = Tx.fromHex(sighashSingleVector['tx']!);
        var intx0 = Tx.fromHex(sighashSingleVector['intx0']!);
        var intx1 = Tx.fromHex(sighashSingleVector['intx1']!);
        var txOutMap = new TxOutMap();
        txOutMap.setTx(intx0);
        txOutMap.setTx(intx1);
        var txVerifier = new TxVerifier(tx: tx, txOutMap: txOutMap);
        var str = await txVerifier.verifyStr(flags);
        expect(str != null, true);
      });
    });

    group('TxVerifier Vectors', () {
      for (var i = 0; i < vectorsBitcoindTxValid.length; i++) {
        var vector = vectorsBitcoindTxValid[i];
        if (vector.length == 1) {
          continue;
        }
        test('should verify txValid vector $i', () async {
          List inputs = vector[0] as List<dynamic>;
          var txhex = vector[1];
          var flags = Interp.getFlags(vector[2] as String);

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
            var txHashBuf =
                new Br(buf: hex.decode(input[0]) as Uint8List?).readReverse();
            txOutMap.set(txHashBuf, txOutNum, txOut);
          });

          var tx = new Tx().fromBuffer(hex.decode(txhex as String));
          var verified = await TxVerifier.staticVerify(
            tx: tx,
            txOutMap: txOutMap,
            flags: flags,
          );
          expect(verified, true);
        });
        // break;
      }

      for (var i = 0; i < vectorsBitcoindTxInvalid.length; i++) {
        var vector = vectorsBitcoindTxInvalid[i];
        if (vector.length == 1) {
          continue;
        }

        test('should unverify txInvalid vector $i', () async {
          List inputs = vector[0] as List<dynamic>;
          var txhex = vector[1];
          var flags = Interp.getFlags(vector[2] as String);

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
            var txHashBuf =
                new Br(buf: hex.decode(input[0]) as Uint8List?).readReverse();
            txOutMap.set(txHashBuf, txOutNum, txOut);
          });

          var tx = new Tx().fromBuffer(hex.decode(txhex as String));

          var verified = await TxVerifier.staticVerify(
            tx: tx,
            txOutMap: txOutMap,
            flags: flags,
          );
          expect(verified, false);
        });
        // break;
      }
    });
  });
}
