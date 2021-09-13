import 'dart:convert';

import 'package:bsv/src/address.dart';
import 'package:bsv/src/bn.dart';
import 'package:bsv/src/interp.dart';
import 'package:bsv/src/key_pair.dart';
import 'package:bsv/src/priv_key.dart';
import 'package:bsv/src/pub_key.dart';
import 'package:bsv/src/script.dart';
import 'package:bsv/src/sig.dart';
import 'package:bsv/src/tx.dart';
import 'package:bsv/src/tx_builder.dart';
import 'package:bsv/src/tx_out.dart';
import 'package:bsv/src/tx_out_map.dart';
import 'package:bsv/src/tx_verifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/src/extentsions/list.dart';

void main() {
  group('TxBuilder', () {
    // test('should make a new txbuilder',  () {
    //   var txb = new TxBuilder()
    //   ;(txb instanceof TxBuilder).should.equal(true)
    //   should.exist(txb.tx)
    //   txb = new TxBuilder()
    //   ;(txb instanceof TxBuilder).should.equal(true)
    //   should.exist(txb.tx)
    //   txb = new TxBuilder({
    //     tx: new Tx()
    //   })
    //   should.exist(txb.tx)
    // });

    Map<String, dynamic> prepareTxBuilder() {
      var txb = new TxBuilder();

      // make change address
      var privKey = new PrivKey().fromBn(BigIntX.fromNum(1));
      var keyPair = new KeyPair().fromPrivKey(privKey);
      var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

      // make addresses to send from
      var privKey1 = new PrivKey().fromBn(BigIntX.fromNum(2));
      var keyPair1 = new KeyPair().fromPrivKey(privKey1);
      var addr1 = new Address().fromPubKey(keyPair1.pubKey!);

      var privKey2 = new PrivKey().fromBn(BigIntX.fromNum(3));
      var keyPair2 = new KeyPair().fromPrivKey(privKey2);
      var addr2 = new Address().fromPubKey(keyPair2.pubKey!);

      // make addresses to send to
      var saddr1 = addr1;

      // txOuts that we are spending

      // pubKeyHash out
      var scriptout1 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
          addr1.hashBuf!.toHex() +
          ' OP_EQUALVERIFY OP_CHECKSIG');

      // pubKeyHash out
      var scriptout2 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
          addr2.hashBuf!.toHex() +
          ' OP_EQUALVERIFY OP_CHECKSIG');

      var txOut1 = TxOut.fromProperties(
          valueBn: BigIntX.fromNum(1e8), script: scriptout1);
      var txOut2 = TxOut.fromProperties(
          valueBn: BigIntX.fromNum(1e8), script: scriptout2);
      // total balance: 2e8

      var txHashBuf = List.generate(32, (index) => 0);
      var txOutNum1 = 0;
      var txOutNum2 = 1;

      txb.setFeePerKbNum(0.0001e8);
      txb.setChangeAddress(changeaddr);
      txb.inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum1,
          txOut: txOut1,
          pubKey: keyPair1.pubKey);
      txb.inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum2,
          txOut: txOut2,
          pubKey: keyPair2.pubKey);
      txb.outputToAddress(
          valueBn: BigIntX.fromNum(1.5e8), addr: saddr1); // pubKeyHash address
      // total sending: 2e8 (plus fee)
      // txb.randomizeInputs()
      // txb.randomizeOutputs()

      return {
        "txb": txb,
        "keyPair1": keyPair1,
        "keyPair2": keyPair2,
        "addr1": addr1,
        "addr2": addr2,
        "saddr1": saddr1,
        "changeaddr": changeaddr,
        "txOut1": txOut1,
        "txOut2": txOut2
      };
    }

    prepareAndBuildTxBuilder() {
      var obj = prepareTxBuilder();
      (obj['txb'] as TxBuilder).build();
      return obj;
    }

    group('#toJSON', () {
      test('should convert this txb to JSON', () {
        var obj = prepareAndBuildTxBuilder();
        var txb = obj['txb'];
        var json = txb.toJSON();
        expect(json['tx'] != null, true);
        expect(json['txIns'] != null, true);
        expect(json['txIns'][0] != null, true);
        expect(json['txOuts'] != null, true);
        expect(json['uTxOutMap'] != null, true);
        expect(json['txOuts'][0] != null, true);
        expect(json['changeScript'] != null, true);
        expect(json['feePerKbNum'] != null, true);
      });
    });

    group('#fromJSON', () {
      test('should convert to/from json isomorphically', () {
        var obj = prepareAndBuildTxBuilder();
        var txb = obj['txb'];
        var json = txb.toJSON();
        var txb2 = new TxBuilder().fromJSON(json);
        var json2 = txb2.toJSON();
        expect(json2['tx'], json['tx']);
        expect(json2['txIns'][0], json['txIns'][0]);
        expect(json2['txOuts'][0], json['txOuts'][0]);
        expect(jsonEncode(json2['uTxOutMap']), jsonEncode(json['uTxOutMap']));
        expect(json2['changeScript'], json['changeScript']);
        expect(json2['feePerKbNum'], json['feePerKbNum']);
      });
    });

    group('#setDust', () {
      test('should set the dust', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.setDust(200);
        expect(txb.dust, 200);
        txb.setDust(400);
        expect(txb.dust, 400);
      });
    });

    group('#dustChangeToFees', () {
      test('should set the dustChangeToFees', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.sendDustChangeToFees(true);
        expect(txb.dustChangeToFees, true);
        txb.build();
        txb.sendDustChangeToFees(false);
        expect(txb.dustChangeToFees, false);
        txb.build();
      });

      test(
          'should not be able to build a tx if dust is greater than all outputs',
          () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.sendDustChangeToFees(true);
        txb.setDust(4e8.toInt());
        expect(
          () => txb.build(),
          throwsA('cannot create output lesser than dust'),
        );
      });

      test(
          'should not be able to build a tx if dust is greater than all outputs',
          () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.sendDustChangeToFees(true);
        txb.setDust((4e8 + 1).toInt());
        expect(
          () => txb.build(),
          throwsA('cannot create output lesser than dust'),
        );
      });

      test('should have two outputs if dust is zero', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.sendDustChangeToFees(true);
        txb.setDust(0);
        txb.build();
        expect(txb.tx.txOuts!.length, 2);
      });
    });

    group('#setFeePerKbNum', () {
      test('should set the feePerKbNum', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.setFeePerKbNum(1000);
        expect(txb.feePerKbNum, 1000);
      });

      test('allows zero', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.setFeePerKbNum(0);
        expect(txb.feePerKbNum, 0);
      });
    });

    group('#setChangeAddress', () {
      test('should set the change address', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        var privKey = new PrivKey().fromRandom();
        var address = new Address().fromPrivKey(privKey);
        txb.setChangeAddress(address);
        expect(txb.changeScript.toString(), address.toTxOutScript().toString());
      });
    });

    group('#setChangeScript', () {
      test('should set the changeScript', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        var privKey = new PrivKey().fromRandom();
        var address = new Address().fromPrivKey(privKey);
        txb.setChangeScript(address.toTxOutScript());
        expect(txb.changeScript.toString(), address.toTxOutScript().toString());
      });
    });

    group('#setNLocktime', () {
      test('should set the nLockTime', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.setNLocktime(1);
        txb.build();
        expect(txb.tx.nLockTime, 1);
      });
    });

    group('#setVersion', () {
      test('should set the versionBytesNum', () {
        var obj = prepareTxBuilder();
        TxBuilder txb = obj['txb'];
        txb.setVersion(2);
        txb.build();
        expect(txb.tx.versionBytesNum, 2);
      });
    });

    group('#importPartiallySignedTx', () {
      test('should set tx', () {
        var tx = new Tx();
        var txb = new TxBuilder().importPartiallySignedTx(tx);
        // ignore: unnecessary_null_comparison
        expect(txb.tx != null, true);
      });

      test('should set tx and uTxOutMap', () {
        var tx = new Tx();
        var uTxOutMap = new TxOutMap();
        var txb = new TxBuilder().importPartiallySignedTx(tx, uTxOutMap);
        // ignore: unnecessary_null_comparison
        expect(txb.tx != null, true);
        // ignore: unnecessary_null_comparison
        expect(txb.uTxOutMap != null, true);
      });
    });

    group('#outputToAddress', () {
      test('should add a pubKeyHash address', () {
        var pubKey = new PubKey().fromPrivKey(new PrivKey().fromRandom());
        var address = new Address().fromPubKey(pubKey);
        var txb = new TxBuilder();
        txb.outputToAddress(valueBn: BigIntX.zero, addr: address);
        expect(txb.txOuts.length, 1);
      });
    });

    group('#outputToScript', () {
      test('should add an OP_RETURN output', () {
        var script = new Script().fromString('OP_RETURN');
        var txb = new TxBuilder();
        txb.outputToScript(valueBn: BigIntX.zero, script: script);
        expect(txb.txOuts.length, 1);
      });
    });

    group('#build', () {
      TxBuilder prepareTxBuilder([BigIntX? outAmountBn]) {
        outAmountBn = outAmountBn ?? BigIntX.fromNum(1e8);
        var txb = new TxBuilder();

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(1));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from
        var privKey1 = new PrivKey().fromBn(BigIntX.fromNum(2));
        var keyPair1 = new KeyPair().fromPrivKey(privKey1);
        var addr1 = new Address().fromPubKey(keyPair1.pubKey!);

        var privKey2 = new PrivKey().fromBn(BigIntX.fromNum(3));
        var keyPair2 = new KeyPair().fromPrivKey(privKey2);
        var addr2 = new Address().fromPubKey(keyPair2.pubKey!);

        var privKey3 = new PrivKey().fromBn(BigIntX.fromNum(4));
        var keyPair3 = new KeyPair().fromPrivKey(privKey3);
        var addr3 = new Address().fromPubKey(keyPair3.pubKey!);

        var txOut1 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: addr1.toTxOutScript());
        var txOut2 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: addr2.toTxOutScript());
        var txOut3 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: addr3.toTxOutScript());
        // total balance: 3e8

        var txHashBuf = List.generate(32, (index) => 0);
        var txOutNum1 = 0;
        var txOutNum2 = 1;
        var txOutNum3 = 2;

        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);
        txb.inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum1,
          txOut: txOut1,
          pubKey: keyPair1.pubKey,
        );
        txb.inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum2,
          txOut: txOut2,
          pubKey: keyPair2.pubKey,
        );
        txb.inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum3,
          txOut: txOut3,
          pubKey: keyPair3.pubKey,
        );
        txb.outputToAddress(valueBn: outAmountBn, addr: addr1);

        return txb;
      }

      test('should build a tx where all inputs are NOT required', () {
        var txb = prepareTxBuilder();

        txb.build();

        expect(txb.tx.txIns!.length, 2);
      });

      test('should build a tx where all inputs are required', () {
        var txb = prepareTxBuilder();

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, 3);
      });

      test('should buld a tx with zero fees', () {
        var txb = new TxBuilder();

        var changePrivKey = new PrivKey().fromBn(BigIntX.fromNum(1));
        var changeKeyPair = new KeyPair().fromPrivKey(changePrivKey);
        var changeAddr = new Address().fromPubKey(changeKeyPair.pubKey!);

        var inputPrivKey = new PrivKey().fromBn(BigIntX.fromNum(2));
        var inputKeyPair = new KeyPair().fromPrivKey(inputPrivKey);
        var inputAddress = new Address().fromPubKey(inputKeyPair.pubKey!);

        var txHashBuf = List<int>.filled(32, 1);
        var txOutNum = 0;
        var inputAmount = BigIntX.fromNum(1000);
        var inputScript = inputAddress.toTxOutScript();
        var txOut =
            TxOut.fromProperties(valueBn: inputAmount, script: inputScript);

        txb.inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          txOut: txOut,
          pubKey: inputKeyPair.pubKey,
        );
        txb.setChangeAddress(changeAddr);
        txb.setFeePerKbNum(0);

        try {
          txb.build();
          expect(true, true);
        } catch (e) {
          expect(true, false);
        }

        var tx = txb.tx;
        expect(tx.txOuts![0].valueBn.toString(), inputAmount.toString());
      });
    });

    // group('#sort',  () {
    //   test('it should call tx sort',  () {
    //     var txBuilder = new TxBuilder()
    //     var called = 0
    //     txBuilder.tx.sort = () => { called++ }
    //     txBuilder.sort()
    //     called.should.equal(1)
    //   });
    // });

    group('@allSigsPresent', () {
      test('should know all sigs are or are not present these scripts', () {
        var script;
        script = new Script().fromString(
            'OP_0 71 0x304402204c99f293ca4d84f01e8f319e93978866877c948628cb4d4ff5ccdf42ae8434cc02206516aa37dcd9f50ddb2f7484aeaef3c0fbab77db60eeafd5ad91b0ba54b715e901 72 0x3045022100ff53e3f8ee64eb0f816a85a244d5e3bc20e7ade814e4377be5279a12130c8414022068e00c79272539d03357d4d589bf4c0c7a517023aaa2abe3f341c26ca9077d0801 OP_PUSHDATA1 105 0x522102c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee52102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f92102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f953ae');
        expect(TxBuilder.allSigsPresent(2, script), true);
        script = new Script().fromString(
            'OP_0 71 0x304402204c99f293ca4d84f01e8f319e93978866877c948628cb4d4ff5ccdf42ae8434cc02206516aa37dcd9f50ddb2f7484aeaef3c0fbab77db60eeafd5ad91b0ba54b715e901 71 0x304402204c99f293ca4d84f01e8f319e93978866877c948628cb4d4ff5ccdf42ae8434cc02206516aa37dcd9f50ddb2f7484aeaef3c0fbab77db60eeafd5ad91b0ba54b715e901 72 0x3045022100ff53e3f8ee64eb0f816a85a244d5e3bc20e7ade814e4377be5279a12130c8414022068e00c79272539d03357d4d589bf4c0c7a517023aaa2abe3f341c26ca9077d0801 OP_PUSHDATA1 105 0x522102c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee52102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f92102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f953ae');
        expect(TxBuilder.allSigsPresent(3, script), true);
        script = new Script().fromString(
            'OP_0 OP_0 71 0x304402204c99f293ca4d84f01e8f319e93978866877c948628cb4d4ff5ccdf42ae8434cc02206516aa37dcd9f50ddb2f7484aeaef3c0fbab77db60eeafd5ad91b0ba54b715e901 72 0x3045022100ff53e3f8ee64eb0f816a85a244d5e3bc20e7ade814e4377be5279a12130c8414022068e00c79272539d03357d4d589bf4c0c7a517023aaa2abe3f341c26ca9077d0801 OP_PUSHDATA1 105 0x522102c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee52102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f92102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f953ae');
        expect(TxBuilder.allSigsPresent(3, script), false);
      });
    });

    group('@removeBlankSigs', () {
      test('should know all sigs are or are not present these scripts', () {
        var script;
        script = new Script().fromString(
            'OP_0 OP_0 71 0x304402204c99f293ca4d84f01e8f319e93978866877c948628cb4d4ff5ccdf42ae8434cc02206516aa37dcd9f50ddb2f7484aeaef3c0fbab77db60eeafd5ad91b0ba54b715e901 72 0x3045022100ff53e3f8ee64eb0f816a85a244d5e3bc20e7ade814e4377be5279a12130c8414022068e00c79272539d03357d4d589bf4c0c7a517023aaa2abe3f341c26ca9077d0801 OP_PUSHDATA1 105 0x522102c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee52102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f92102f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f953ae');
        expect(TxBuilder.allSigsPresent(3, script), false);
        script = TxBuilder.removeBlankSigs(script);
        expect(TxBuilder.allSigsPresent(2, script), true);
      });
    });

    group('#inputFromScript', () {
      test('should add an input from a script', () {
        var keyPair = new KeyPair().fromRandom();
        var address = new Address().fromPubKey(keyPair.pubKey!);
        var txOut = TxOut.fromProperties(
          valueBn: BigIntX.fromNum(1000),
          script: new Script().fromPubKeyHash(address.hashBuf!.asUint8List()),
        );
        var script = new Script().fromString('OP_RETURN');
        var txHashBuf = List.generate(32, (index) => 0);
        var txOutNum = 0;
        var txbuilder = new TxBuilder().inputFromScript(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          txOut: txOut,
          script: script,
        );
        expect(txbuilder.txIns.length, 1);
      });

      test('should add an input from a script and set nSequence', () {
        var keyPair = new KeyPair().fromRandom();
        var address = new Address().fromPubKey(keyPair.pubKey!);
        var txOut = TxOut.fromProperties(
          valueBn: BigIntX.fromNum(1000),
          script: new Script().fromPubKeyHash(address.hashBuf!.asUint8List()),
        );
        var script = new Script().fromString('OP_RETURN');
        var txHashBuf = List.generate(32, (index) => 0);
        var txOutNum = 0;
        var txbuilder = new TxBuilder().inputFromScript(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          txOut: txOut,
          script: script,
          nSequence: 0xf0f0f0f0,
        );
        expect(txbuilder.txIns.length, 1);
        expect(txbuilder.txIns[0].nSequence, 0xf0f0f0f0);
      });
    });

    group('#inputFromPubKeyHash', () {
      test('should add an input from a pubKeyHash output', () {
        var keyPair = new KeyPair().fromRandom();
        var address = new Address().fromPubKey(keyPair.pubKey!);
        var txOut = TxOut.fromProperties(
          valueBn: BigIntX.fromNum(1000),
          script: new Script().fromPubKeyHash(address.hashBuf!.asUint8List()),
        );
        var txHashBuf = List.generate(32, (index) => 0);
        var txOutNum = 0;
        var txbuilder = new TxBuilder().inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          txOut: txOut,
          pubKey: keyPair.pubKey,
        );

        expect(
          listEquals(
            txbuilder.txIns[0].script!.chunks[1].buf,
            keyPair.pubKey!.toBuffer(),
          ),
          true,
        );
      });

      test('should add an input from a pubKeyHash output and set nSequence',
          () {
        var keyPair = new KeyPair().fromRandom();
        var address = new Address().fromPubKey(keyPair.pubKey!);
        var txOut = TxOut.fromProperties(
          valueBn: BigIntX.fromNum(1000),
          script: new Script().fromPubKeyHash(address.hashBuf!.asUint8List()),
        );
        var txHashBuf = List.generate(32, (index) => 0);
        var txOutNum = 0;
        var txbuilder = new TxBuilder().inputFromPubKeyHash(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          txOut: txOut,
          pubKey: keyPair.pubKey,
          nSequence: 0xf0f0f0f0,
        );
        expect(
          listEquals(
            txbuilder.txIns[0].script!.chunks[1].buf,
            keyPair.pubKey!.toBuffer(),
          ),
          true,
        );
        expect(txbuilder.txIns[0].nSequence, 0xf0f0f0f0);
      });
    });

    group('#getSig', () {
      TxBuilder? txb;
      KeyPair? keyPair1;
      // TxOut txOut1;
      var obj = prepareAndBuildTxBuilder();
      txb = obj['txb'];
      keyPair1 = obj['keyPair1'];
      // txOut1 = obj['txOut1'];

      test('should sign and verify synchronously', () {
        var sig = txb!.getSig(
          keyPair: keyPair1,
          nHashType: Sig.SIGHASH_ALL,
          nIn: 0,
          subScript: new Script(),
        );
        expect(sig is Sig, true);
      });
    });

    group('#signTxIn', () {
      test('should sign and verify no SIGHASH_FORKID synchronously', () async {
        // prepare
        var obj = prepareAndBuildTxBuilder();
        TxBuilder txb = obj['txb'];
        KeyPair? keyPair1 = obj['keyPair1'];
        KeyPair? keyPair2 = obj['keyPair2'];
        Address saddr1 = obj['saddr1'];
        Address changeaddr = obj['changeaddr'];

        // begin signing
        var nHashType = Sig.SIGHASH_ALL;
        var flags = Interp.SCRIPT_VERIFY_P2SH;
        txb.signTxIn(
          nIn: 0,
          keyPair: keyPair1,
          txOut: null,
          nScriptChunk: null,
          nHashType: nHashType,
          flags: flags,
        );

        // transaction not fully signed yet, so should be invalid
        var result = await TxVerifier.staticVerify(
          tx: txb.tx,
          txOutMap: txb.uTxOutMap,
          flags: flags,
        );
        expect(result, false);

        txb.signTxIn(
          nIn: 1,
          keyPair: keyPair2,
          txOut: null,
          nScriptChunk: null,
          nHashType: nHashType,
          flags: flags,
        );

        expect(
          txb.tx.txOuts![0].script!.chunks[2].buf!.toHex(),
          saddr1.hashBuf!.toHex(),
        );
        expect(txb.tx.txOuts![0].valueBn!.eq(1.5e8), true);
        expect(txb.tx.txOuts![1].valueBn!.gt(546), true);
        expect(txb.tx.txOuts![1].valueBn!.toNumber(), 49996250);
        expect(txb.changeAmountBn!.toNumber(), 49996250);
        expect(txb.feeAmountBn!.toNumber(), 3750);
        expect(
          txb.tx.txOuts![1].script!.chunks[2].buf!.toHex(),
          changeaddr.hashBuf!.toHex(),
        );

        result = await TxVerifier.staticVerify(
          tx: txb.tx,
          txOutMap: txb.uTxOutMap,
          flags: flags,
        );
        expect(result, true);
      });

      test('should sign and verify SIGHASH_FORKID synchronously', () async {
        // prepare
        var obj = prepareAndBuildTxBuilder();
        TxBuilder txb = obj['txb'];
        KeyPair? keyPair1 = obj['keyPair1'];
        KeyPair? keyPair2 = obj['keyPair2'];
        Address saddr1 = obj['saddr1'];
        Address changeaddr = obj['changeaddr'];

        // begin signing
        var nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID;
        var flags =
            Interp.SCRIPT_ENABLE_SIGHASH_FORKID | Interp.SCRIPT_VERIFY_P2SH;
        txb.signTxIn(
          nIn: 0,
          keyPair: keyPair1,
          txOut: null,
          nScriptChunk: null,
          nHashType: nHashType,
          flags: flags,
        );

        // transaction not fully signed yet, so should be invalid
        var result = await TxVerifier.staticVerify(
          tx: txb.tx,
          txOutMap: txb.uTxOutMap,
          flags: flags,
        );
        expect(result, false);

        txb.signTxIn(
          nIn: 1,
          keyPair: keyPair2,
          txOut: null,
          nScriptChunk: null,
          nHashType: nHashType,
          flags: flags,
        );

        expect(
          txb.tx.txOuts![0].script!.chunks[2].buf!.toHex(),
          saddr1.hashBuf!.toHex(),
        );
        expect(txb.tx.txOuts![0].valueBn!.eq(1.5e8), true);
        expect(txb.tx.txOuts![1].valueBn!.gt(546), true);
        expect(txb.tx.txOuts![1].valueBn!.toNumber(), 49996250);
        expect(txb.changeAmountBn!.toNumber(), 49996250);
        expect(txb.feeAmountBn!.toNumber(), 3750);
        expect(
          txb.tx.txOuts![1].script!.chunks[2].buf!.toHex(),
          changeaddr.hashBuf!.toHex(),
        );

        result = await TxVerifier.staticVerify(
          tx: txb.tx,
          txOutMap: txb.uTxOutMap,
          flags: flags,
        );
        expect(result, true);
      });

      // test('should pass in txOut',  () {
      //   // prepare
      //   var obj = prepareAndBuildTxBuilder();
      //   TxBuilder txb = obj['txb'];
      //   var keyPair1 = obj.keyPair1;
      //   var txOut1 = obj.txOut1;

      //   txb.txOutMap = sinon.spy()
      //   txb.uTxOutMap = {
      //     get: sinon.spy()
      //   }
      //   txb.signTxIn(0, keyPair1, txOut1, null, Sig.SIGHASH_ALL, 0)
      //   txb.uTxOutMap.get.calledOnce.should.equal(false)
      // });
    });

    // group('#asyncGetSig',  () {
    //   var txb, keyPair1, txOut1

    //   before( () {
    //     var obj = prepareAndBuildTxBuilder()
    //     txb = obj.txb
    //     keyPair1 = obj.keyPair1
    //     txOut1 = obj.txOut1
    //   })

    //   test('should sign and verify synchronously', async  () {
    //     var sig = await txb.asyncGetSig(
    //       keyPair1,
    //       Sig.SIGHASH_ALL,
    //       0,
    //       keyPair1,
    //       txOut1
    //     )
    //     ;(sig instanceof Sig).should.equal(true)
    //   })
    // })

    // group('#asyncSignTxIn',  () {
    //   test('should sign and verify no SIGHASH_FORKID asynchronously', async  () {
    //     // prepare
    //     var obj = prepareAndBuildTxBuilder()
    //     TxBuilder txb = obj['txb'];
    //     var keyPair1 = obj.keyPair1
    //     var keyPair2 = obj.keyPair2
    //     var saddr1 = obj.saddr1
    //     var changeaddr = obj.changeaddr

    //     // begin signing
    //     var nHashType = Sig.SIGHASH_ALL
    //     var flags = Interp.SCRIPT_VERIFY_P2SH
    //     await txb.asyncSignTxIn(0, keyPair1, null, null, nHashType, flags)

    //     // transaction not fully signed yet, so should be invalid
    //     TxVerifier.staticVerify(txb.tx, txb.uTxOutMap, flags).should.equal(false)

    //     await txb.asyncSignTxIn(1, keyPair2, null, null, nHashType, flags)

    //     txb.tx.txOuts[0].script.chunks[2].buf
    //       .toString('hex')
    //       .should.equal(saddr1.hashBuf.toString('hex'))
    //     txb.tx.txOuts[0].valueBn.eq(1.5e8).should.equal(true)
    //     txb.tx.txOuts[1].valueBn.gt(546).should.equal(true)
    //     txb.tx.txOuts[1].valueBn.toNumber().should.equal(49996250)
    //     txb.changeAmountBn.toNumber().should.equal(49996250)
    //     txb.feeAmountBn.toNumber().should.equal(3750)
    //     txb.tx.txOuts[1].script.chunks[2].buf
    //       .toString('hex')
    //       .should.equal(changeaddr.hashBuf.toString('hex'))

    //     TxVerifier.staticVerify(txb.tx, txb.uTxOutMap, flags).should.equal(true)
    //   })

    //   test('should sign and verify SIGHASH_FORKID asynchronously', async  () {
    //     // prepare
    //     var obj = prepareAndBuildTxBuilder()
    //     TxBuilder txb = obj['txb'];
    //     var keyPair1 = obj.keyPair1
    //     var keyPair2 = obj.keyPair2
    //     var saddr1 = obj.saddr1
    //     var changeaddr = obj.changeaddr

    //     // begin signing
    //     var nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID
    //     var flags =
    //       Interp.SCRIPT_ENABLE_SIGHASH_FORKID | Interp.SCRIPT_VERIFY_P2SH
    //     await txb.asyncSignTxIn(0, keyPair1, null, null, nHashType, flags)

    //     // transaction not fully signed yet, so should be invalid
    //     TxVerifier.staticVerify(txb.tx, txb.uTxOutMap, flags).should.equal(false)

    //     await txb.asyncSignTxIn(1, keyPair2, null, null, nHashType, flags)

    //     txb.tx.txOuts[0].script.chunks[2].buf
    //       .toString('hex')
    //       .should.equal(saddr1.hashBuf.toString('hex'))
    //     txb.tx.txOuts[0].valueBn.eq(1.5e8).should.equal(true)
    //     txb.tx.txOuts[1].valueBn.gt(546).should.equal(true)
    //     txb.tx.txOuts[1].valueBn.toNumber().should.equal(49996250)
    //     txb.changeAmountBn.toNumber().should.equal(49996250)
    //     txb.feeAmountBn.toNumber().should.equal(3750)
    //     txb.tx.txOuts[1].script.chunks[2].buf
    //       .toString('hex')
    //       .should.equal(changeaddr.hashBuf.toString('hex'))

    //     TxVerifier.staticVerify(txb.tx, txb.uTxOutMap, flags).should.equal(true)
    //   })

    //   test('should pass in txOut', async  () {
    //     var obj = prepareAndBuildTxBuilder()
    //     TxBuilder txb = obj['txb'];
    //     var keyPair1 = obj.keyPair1
    //     var txOut1 = obj.txOut1
    //     txb.txOutMap = sinon.spy()
    //     txb.uTxOutMap = {
    //       get: sinon.spy()
    //     }
    //     await txb.asyncSignTxIn(0, keyPair1, txOut1, null, Sig.SIGHASH_ALL, 0)
    //     txb.uTxOutMap.get.calledOnce.should.equal(false)
    //   })
    // })

    group('#signWithKeyPairs', () {
      test('should sign and verify synchronously', () async {
        // prepare
        var obj = prepareAndBuildTxBuilder();
        TxBuilder txb = obj['txb'];
        KeyPair? keyPair1 = obj['keyPair1'];
        KeyPair? keyPair2 = obj['keyPair2'];
        Address saddr1 = obj['saddr1'];
        Address changeaddr = obj['changeaddr'];

        // begin signing
        txb.signWithKeyPairs([keyPair1]);

        expect(
          txb.sigOperations.map[
                  '0000000000000000000000000000000000000000000000000000000000000000:0']
              [0]['log'],
          'successfully inserted signature',
        );
        expect(
          txb.sigOperations.map[
                  '0000000000000000000000000000000000000000000000000000000000000000:0']
              [1]['log'],
          'successfully inserted public key',
        );
        expect(
          txb.sigOperations.map[
                  '0000000000000000000000000000000000000000000000000000000000000000:1']
              [0]['log'],
          'cannot find keyPair for addressStr 1CUNEBjYrCn2y1SdiUMohaKUi4wpP326Lb',
        );
        expect(
          txb.sigOperations.map[
                  '0000000000000000000000000000000000000000000000000000000000000000:1']
              [1]['log'],
          'cannot find keyPair for addressStr 1CUNEBjYrCn2y1SdiUMohaKUi4wpP326Lb',
        );

        // transaction not fully signed yet, so should be invalid
        expect(
          await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
          false,
        );

        // this should effectively add
        txb.signWithKeyPairs([keyPair2]);

        expect(
          txb.tx.txOuts![0].script!.chunks[2].buf!.toHex(),
          saddr1.hashBuf!.toHex(),
        );
        expect(txb.tx.txOuts![0].valueBn!.eq(1.5e8), true);
        expect(txb.tx.txOuts![1].valueBn!.gt(546), true);
        expect(txb.tx.txOuts![1].valueBn!.toNumber(), 49996250);
        expect(txb.changeAmountBn!.toNumber(), 49996250);
        expect(txb.feeAmountBn!.toNumber(), 3750);
        expect(
          txb.tx.txOuts![1].script!.chunks[2].buf!.toHex(),
          changeaddr.hashBuf!.toHex(),
        );

        expect(
          await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
          true,
        );

        // re-signing just puts the same signatures back into the same place and
        // thus should still be valid
        txb.signWithKeyPairs([keyPair1, keyPair2]);
        expect(
          await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
          true,
        );
      });

      test(
          'should sign and verify synchronously with no public key inserted at input',
          () async {
        prepareTxBuilder() {
          var txb = new TxBuilder();

          // make change address
          var privKey = new PrivKey().fromBn(BigIntX.fromNum(1));
          var keyPair = new KeyPair().fromPrivKey(privKey);
          var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

          // make addresses to send from
          var privKey1 = new PrivKey().fromBn(BigIntX.fromNum(2));
          var keyPair1 = new KeyPair().fromPrivKey(privKey1);
          var addr1 = new Address().fromPubKey(keyPair1.pubKey!);

          var privKey2 = new PrivKey().fromBn(BigIntX.fromNum(3));
          var keyPair2 = new KeyPair().fromPrivKey(privKey2);
          var addr2 = new Address().fromPubKey(keyPair2.pubKey!);

          // make addresses to send to
          var saddr1 = addr1;

          // txOuts that we are spending

          // pubKeyHash out
          var scriptout1 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addr1.hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG');

          // pubKeyHash out
          var scriptout2 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addr2.hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG');

          var txOut1 = TxOut.fromProperties(
              valueBn: BigIntX.fromNum(1e8), script: scriptout1);
          var txOut2 = TxOut.fromProperties(
              valueBn: BigIntX.fromNum(1e8), script: scriptout2);
          // total balance: 2e8

          var txHashBuf = List.generate(32, (index) => 0);
          var txOutNum1 = 0;
          var txOutNum2 = 1;

          txb.setFeePerKbNum(0.0001e8);
          txb.setChangeAddress(changeaddr);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: txOutNum1,
            txOut: txOut1,
          );
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: txOutNum2,
            txOut: txOut2,
          );

          txb.outputToAddress(
              valueBn: BigIntX.fromNum(1.5e8),
              addr: saddr1); // pubKeyHash address
          // total sending: 2e8 (plus fee)
          // txb.randomizeInputs()
          // txb.randomizeOutputs()

          return {
            "txb": txb,
            "keyPair1": keyPair1,
            "keyPair2": keyPair2,
            "addr1": addr1,
            "addr2": addr2,
            "saddr1": saddr1,
            "changeaddr": changeaddr,
            "txOut1": txOut1,
            "txOut2": txOut2
          };
        }

        prepareAndBuildTxBuilder() {
          var obj = prepareTxBuilder();
          (obj['txb'] as TxBuilder).build();
          return obj;
        }

        // prepare
        var obj = prepareAndBuildTxBuilder();
        TxBuilder txb = obj['txb'] as TxBuilder;
        KeyPair? keyPair1 = obj['keyPair1'] as KeyPair?;
        KeyPair? keyPair2 = obj['keyPair2'] as KeyPair?;
        Address saddr1 = obj['saddr1'] as Address;
        Address changeaddr = obj['changeaddr'] as Address;

        // begin signing
        txb.signWithKeyPairs([keyPair1]);

        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:0']
                [0]['log'],
            'successfully inserted signature');
        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:0']
                [1]['log'],
            'successfully inserted public key');
        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:1']
                [0]['log'],
            'cannot find keyPair for addressStr 1CUNEBjYrCn2y1SdiUMohaKUi4wpP326Lb');
        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:1']
                [1]['log'],
            'cannot find keyPair for addressStr 1CUNEBjYrCn2y1SdiUMohaKUi4wpP326Lb');

        // transaction not fully signed yet, so should be invalid
        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            false);

        // this should effectively add
        txb.signWithKeyPairs([keyPair2]);

        expect(
          txb.tx.txOuts![0].script!.chunks[2].buf!.toHex(),
          saddr1.hashBuf!.toHex(),
        );
        expect(txb.tx.txOuts![0].valueBn!.eq(1.5e8), true);
        expect(txb.tx.txOuts![1].valueBn!.gt(546), true);
        expect(txb.tx.txOuts![1].valueBn!.toNumber(), 49996250);
        expect(txb.changeAmountBn!.toNumber(), 49996250);
        expect(txb.feeAmountBn!.toNumber(), 3750);
        expect(
          txb.tx.txOuts![1].script!.chunks[2].buf!.toHex(),
          changeaddr.hashBuf!.toHex(),
        );

        expect(
          await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
          true,
        );

        // re-signing just puts the same signatures back into the same place and
        // thus should still be valid
        txb.signWithKeyPairs([keyPair1, keyPair2]);

        expect(
          await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
          true,
        );
      });

      test('should work with custom scripts', () {
        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        var privKey1 = new PrivKey().fromBn(BigIntX.fromNum(1));
        var keyPair1 = new KeyPair().fromPrivKey(privKey1);
        var addr1 = new Address().fromPubKey(keyPair1.pubKey!);

        var customScript = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr1.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');

        var txOut1 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: customScript);

        var txHashBuf = List.generate(32, (index) => 1);

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);
        txb.inputFromScript(
          txHashBuf: txHashBuf,
          txOutNum: 0,
          txOut: txOut1,
          script: customScript,
        );
        txb.build();
        try {
          txb.signWithKeyPairs([keyPair1]);
          expect(true, true);
        } catch (e) {}
        // should(() => txb.signWithKeyPairs([keyPair1])).not.throw()
      });

      test('should sign and verify a lot of inputs and outputs', () async {
        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        var privKey1 = new PrivKey().fromBn(BigIntX.fromNum(1));
        var keyPair1 = new KeyPair().fromPrivKey(privKey1);
        var addr1 = new Address().fromPubKey(keyPair1.pubKey!);

        var privKey2 = new PrivKey().fromBn(BigIntX.fromNum(2));
        var keyPair2 = new KeyPair().fromPrivKey(privKey2);
        var addr2 = new Address().fromPubKey(keyPair2.pubKey!);

        var privKey3 = new PrivKey().fromBn(BigIntX.fromNum(3));
        var keyPair3 = new KeyPair().fromPrivKey(privKey3);
        var addr3 = new Address().fromPubKey(keyPair3.pubKey!);

        var privKey4 = new PrivKey().fromBn(BigIntX.fromNum(4));
        var keyPair4 = new KeyPair().fromPrivKey(privKey4);
        var addr4 = new Address().fromPubKey(keyPair4.pubKey!);

        var privKey5 = new PrivKey().fromBn(BigIntX.fromNum(5));
        var keyPair5 = new KeyPair().fromPrivKey(privKey5);
        var addr5 = new Address().fromPubKey(keyPair5.pubKey!);

        var privKey6 = new PrivKey().fromBn(BigIntX.fromNum(6));
        var keyPair6 = new KeyPair().fromPrivKey(privKey6);
        var addr6 = new Address().fromPubKey(keyPair6.pubKey!);

        var privKey7 = new PrivKey().fromBn(BigIntX.fromNum(7));
        var keyPair7 = new KeyPair().fromPrivKey(privKey7);
        var addr7 = new Address().fromPubKey(keyPair7.pubKey!);

        var privKey8 = new PrivKey().fromBn(BigIntX.fromNum(8));
        var keyPair8 = new KeyPair().fromPrivKey(privKey8);
        var addr8 = new Address().fromPubKey(keyPair8.pubKey!);

        var privKey9 = new PrivKey().fromBn(BigIntX.fromNum(9));
        var keyPair9 = new KeyPair().fromPrivKey(privKey9);
        var addr9 = new Address().fromPubKey(keyPair9.pubKey!);

        var privKey10 = new PrivKey().fromBn(BigIntX.fromNum(10));
        var keyPair10 = new KeyPair().fromPrivKey(privKey10);
        var addr10 = new Address().fromPubKey(keyPair10.pubKey!);

        var privKey11 = new PrivKey().fromBn(BigIntX.fromNum(11));
        var keyPair11 = new KeyPair().fromPrivKey(privKey11);
        var addr11 = new Address().fromPubKey(keyPair11.pubKey!);

        // txOuts that we are spending
        var scriptout1 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr1.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout2 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr2.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout3 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr3.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout4 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr4.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout5 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr5.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout6 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr6.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout7 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr7.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout8 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr8.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout9 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr9.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout10 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr10.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout11 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr11.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');

        var txOut1 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout1);
        var txOut2 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout2);
        var txOut3 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout3);
        var txOut4 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout4);
        var txOut5 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout5);
        var txOut6 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout6);
        var txOut7 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout7);
        var txOut8 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout8);
        var txOut9 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout9);
        var txOut10 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout10);
        var txOut11 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout11);
        // total balance: 11e8

        var txHashBuf = List.generate(32, (index) => 1);
        var txOutNum1 = 0;
        var txOutNum2 = 1;
        var txOutNum3 = 2;
        var txOutNum4 = 3;
        var txOutNum5 = 4;
        var txOutNum6 = 5;
        var txOutNum7 = 6;
        var txOutNum8 = 7;
        var txOutNum9 = 8;
        var txOutNum10 = 9;
        var txOutNum11 = 10;

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum1, txOut: txOut1);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum2, txOut: txOut2);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum3, txOut: txOut3);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum4, txOut: txOut4);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum5, txOut: txOut5);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum6, txOut: txOut6);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum7, txOut: txOut7);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum8, txOut: txOut8);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum9, txOut: txOut9);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum10, txOut: txOut10);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum11, txOut: txOut11);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr1);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr2);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr3);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr4);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr5);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr6);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr7);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr8);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr9);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr10);
        txb.outputToAddress(valueBn: BigIntX.fromNum(0.999e8), addr: addr11);
        // total sending: 10.989e8 (plus fee)

        txb.build();

        // partially sign - deliberately resulting in invalid tx
        txb.signWithKeyPairs([keyPair1, keyPair2, keyPair3]);

        // transaction not fully signed yet, so should be invalid

        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            false);

        // fully sign
        txb.signWithKeyPairs([
          keyPair1,
          keyPair2,
          keyPair3,
          keyPair4,
          keyPair5,
          keyPair6,
          keyPair7,
          keyPair8,
          keyPair9,
          keyPair10,
          keyPair11,
        ]);

        // txb.changeAmountBn.toNumber().should.equal(49996250)
        // txb.feeAmountBn.toNumber().should.equal(3750)

        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            true);

        // re-signing just puts the same signatures back into the same place and
        // thus should still be valid
        txb.signWithKeyPairs([
          keyPair1,
          keyPair2,
          keyPair3,
          keyPair4,
          keyPair5,
          keyPair6,
          keyPair7,
          keyPair8,
          keyPair9,
          keyPair10,
          keyPair11,
        ]);
        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            true);
      });

      test('should be able to add more inputs to pay the fee', () async {
        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        var privKey1 = new PrivKey().fromBn(BigIntX.fromNum(1));
        var keyPair1 = new KeyPair().fromPrivKey(privKey1);
        var addr1 = new Address().fromPubKey(keyPair1.pubKey!);

        var privKey2 = new PrivKey().fromBn(BigIntX.fromNum(2));
        var keyPair2 = new KeyPair().fromPrivKey(privKey2);
        var addr2 = new Address().fromPubKey(keyPair2.pubKey!);

        var privKey3 = new PrivKey().fromBn(BigIntX.fromNum(3));
        var keyPair3 = new KeyPair().fromPrivKey(privKey3);
        var addr3 = new Address().fromPubKey(keyPair3.pubKey!);

        var privKey4 = new PrivKey().fromBn(BigIntX.fromNum(4));
        var keyPair4 = new KeyPair().fromPrivKey(privKey4);
        var addr4 = new Address().fromPubKey(keyPair4.pubKey!);

        // txOuts that we are spending
        var scriptout1 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr1.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout2 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr2.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout3 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr3.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');
        var scriptout4 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
            addr4.hashBuf!.toHex() +
            ' OP_EQUALVERIFY OP_CHECKSIG');

        var txOut1 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout1);
        var txOut2 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout2);
        var txOut3 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout3);
        var txOut4 = TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8), script: scriptout4);
        // total balance: 4e8

        var txHashBuf = List.generate(32, (index) => 1);
        var txOutNum1 = 0;
        var txOutNum2 = 1;
        var txOutNum3 = 2;
        var txOutNum4 = 3;

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum1, txOut: txOut1);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum2, txOut: txOut2);
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum3, txOut: txOut3);
        // don't add fourth input yet
        // txb.inputFromPubKeyHash(txHashBuf, txOutNum4, txOut4)

        // amount is sum of first three, but requires the fourth input to pay the fees
        txb.outputToAddress(valueBn: BigIntX.fromNum(3e8), addr: addr1);

        // first try failure
        var errors = 0;
        try {
          txb.build();
        } catch (err) {
          errors++;
        }
        expect(errors, 1);

        // add fourth input. this should succeed.
        txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf, txOutNum: txOutNum4, txOut: txOut4);
        txb.build();
        // fully sign
        txb.signWithKeyPairs([keyPair1, keyPair2, keyPair3, keyPair4]);

        expect(
          await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
          true,
        );
      });

      test(
          'should sign and verify synchronously with no public key inserted at input',
          () async {
        prepareTxBuilder() {
          var txb = new TxBuilder();

          // make change address
          var privKey = new PrivKey().fromBn(BigIntX.fromNum(1));
          var keyPair = new KeyPair().fromPrivKey(privKey);
          var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

          // make addresses to send from
          var privKey1 = new PrivKey().fromBn(BigIntX.fromNum(2));
          var keyPair1 = new KeyPair().fromPrivKey(privKey1);
          var addr1 = new Address().fromPubKey(keyPair1.pubKey!);

          var privKey2 = new PrivKey().fromBn(BigIntX.fromNum(3));
          var keyPair2 = new KeyPair().fromPrivKey(privKey2);
          var addr2 = new Address().fromPubKey(keyPair2.pubKey!);

          // make addresses to send to
          var saddr1 = addr1;

          // txOuts that we are spending

          // pubKeyHash out
          var scriptout1 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addr1.hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG');

          // pubKeyHash out
          var scriptout2 = new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addr2.hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG');

          var txOut1 = TxOut.fromProperties(
              valueBn: BigIntX.fromNum(1e8), script: scriptout1);
          var txOut2 = TxOut.fromProperties(
              valueBn: BigIntX.fromNum(1e8), script: scriptout2);
          // total balance: 2e8

          var txHashBuf = List.generate(32, (index) => 0);
          var txOutNum1 = 0;
          var txOutNum2 = 1;

          txb.setFeePerKbNum(0.0001e8);
          txb.setChangeAddress(changeaddr);
          txb.inputFromPubKeyHash(
              txHashBuf: txHashBuf, txOutNum: txOutNum1, txOut: txOut1);
          txb.inputFromPubKeyHash(
              txHashBuf: txHashBuf, txOutNum: txOutNum2, txOut: txOut2);
          txb.outputToAddress(
              valueBn: BigIntX.fromNum(1.5e8),
              addr: saddr1); // pubKeyHash address
          // total sending: 2e8 (plus fee)
          // txb.randomizeInputs()
          // txb.randomizeOutputs()

          return {
            "txb": txb,
            "keyPair1": keyPair1,
            "keyPair2": keyPair2,
            "addr1": addr1,
            "addr2": addr2,
            "saddr1": saddr1,
            "changeaddr": changeaddr,
            "txOut1": txOut1,
            "txOut2": txOut2
          };
        }

        prepareAndBuildTxBuilder() {
          var obj = prepareTxBuilder();
          (obj['txb'] as TxBuilder).build();
          return obj;
        }

        // prepare
        var obj = prepareAndBuildTxBuilder();
        TxBuilder txb = obj['txb'] as TxBuilder;
        KeyPair? keyPair1 = obj['keyPair1'] as KeyPair?;
        KeyPair? keyPair2 = obj['keyPair2'] as KeyPair?;
        Address saddr1 = obj['saddr1'] as Address;
        Address changeaddr = obj['changeaddr'] as Address;

        // begin signing
        txb.signWithKeyPairs([keyPair1]);

        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:0']
                [0]['log'],
            'successfully inserted signature');
        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:0']
                [1]['log'],
            'successfully inserted public key');
        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:1']
                [0]['log'],
            'cannot find keyPair for addressStr 1CUNEBjYrCn2y1SdiUMohaKUi4wpP326Lb');
        expect(
            txb.sigOperations.map[
                    '0000000000000000000000000000000000000000000000000000000000000000:1']
                [1]['log'],
            'cannot find keyPair for addressStr 1CUNEBjYrCn2y1SdiUMohaKUi4wpP326Lb');

        // transaction not fully signed yet, so should be invalid
        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            false);

        // this should effectively add
        txb.signWithKeyPairs([keyPair2]);

        expect(
          txb.tx.txOuts![0].script!.chunks[2].buf!.toHex(),
          saddr1.hashBuf!.toHex(),
        );
        expect(txb.tx.txOuts![0].valueBn!.eq(1.5e8), true);
        expect(txb.tx.txOuts![1].valueBn!.gt(546), true);
        expect(txb.tx.txOuts![1].valueBn!.toNumber(), 49996250);
        expect(txb.changeAmountBn!.toNumber(), 49996250);
        expect(txb.feeAmountBn!.toNumber(), 3750);
        expect(
          txb.tx.txOuts![1].script!.chunks[2].buf!.toHex(),
          changeaddr.hashBuf!.toHex(),
        );

        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            true);

        // re-signing just puts the same signatures back into the same place and
        // thus should still be valid
        txb.signWithKeyPairs([keyPair1, keyPair2]);
        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            true);
      });

      test('should sign and verify a really large number of inputs and outputs',
          () async {
        // this.timeout(10000)
        var nIns = 100;
        var nOuts = 100;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
              valueBn: BigIntX.fromNum(1e8), script: scriptouts[i]));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
              txHashBuf: txHashBuf, txOutNum: i, txOut: txOuts[i]);
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
              valueBn: BigIntX.fromNum(0.999e8), addr: addrs[i]);
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // partially sign - deliberately resulting in invalid tx
        txb.signWithKeyPairs([keyPairs[0], keyPairs[1], keyPairs[2]]);

        // transaction not fully signed yet, so should be invalid
        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            false);

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        expect(
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap),
            true);
      });

      test(
          'should sign and verify a large number of inputs and outputs with converting to/from JSON',
          () async {
        var nIns = 50;
        var nOuts = 50;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8 * (i + 1)),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(0.999e8 * (i + 1)),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // partially sign - deliberately resulting in invalid tx
        txb.signWithKeyPairs([keyPairs[0], keyPairs[1], keyPairs[2]]);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        // print(txb.txOuts.length);
        // print(txb.txIns.length);
        // // transaction not fully signed yet, so should be invalid
        expect(result, false);

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with incrementing amounts, with converting to/from JSON',
          () async {
        var nIns = 50;
        var nOuts = 30;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8 * (i + 1)),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(0.999e8 * (i + 1)),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // partially sign - deliberately resulting in invalid tx
        txb.signWithKeyPairs([keyPairs[0], keyPairs[1], keyPairs[2]]);

        // transaction not fully signed yet, so should be invalid
        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, false);

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with the same key, with converting to/from JSON',
          () async {
        var nIns = 50;
        var nOuts = 30;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(0.999e8),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with BIP 69 sorting, with converting to/from JSON',
          () async {
        var nIns = 50;
        var nOuts = 30;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(0.999e8),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);
        txb.sort();

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with BIP 69 sorting with incrementing amounts, with converting to/from JSON',
          () async {
        var nIns = 50;
        var nOuts = 30;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8 + i),
            script: scriptouts[i],
          ));
        }

        // total input amount: nIns * 1e8...plus a bit due to incrementing amounts

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(0.999e8),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);
        txb.sort();

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with BIP 69 sorting with decrementing amounts, with converting to/from JSON',
          () async {
        var nIns = 50;
        var nOuts = 30;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1e8 + 10000 - i),
            script: scriptouts[i],
          ));
        }

        // total input amount: nIns * 1e8...plus a bit due to incrementing amounts

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0001e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(0.999e8),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);
        txb.sort();

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify with one output if change is less than dust with dropping change with converting to/from JSON',
          () async {
        var nIns = 3;
        var nOuts = 1;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(200),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8 = 600

        var txb = new TxBuilder();
        txb.setFeePerKbNum(1);
        txb.sendDustChangeToFees(true);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(590),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with very small amounts for inputs (1000 satoshis), with converting to/from JSON',
          () async {
        var nIns = 100;
        var nOuts = 1;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1000),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0000500e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(1000),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with very small amounts for inputs (1000 satoshis, 0.01 sat/byte fee), with converting to/from JSON',
          () async {
        var nIns = 100;
        var nOuts = 1;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1000),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0000010e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(1000),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with very small amounts for inputs (1499 satoshis, 0.01 sat/byte fee), with converting to/from JSON',
          () async {
        var nIns = 100;
        var nOuts = 1;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1499),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0000010e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(1000),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should sign and verify a large number of inputs and outputs, with very small amounts for inputs (1499 satoshis, 0.5 sat/byte fee), with converting to/from JSON',
          () async {
        var nIns = 100;
        var nOuts = 1;

        // make change address
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
        var keyPair = new KeyPair().fromPrivKey(privKey);
        var changeaddr = new Address().fromPubKey(keyPair.pubKey!);

        // make addresses to send from (and to)
        List<PrivKey> privKeys = [];
        List<KeyPair> keyPairs = [];
        List<Address> addrs = [];
        for (var i = 0; i < nIns; i++) {
          privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
          keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
          addrs.add(new Address().fromPubKey(keyPairs[i].pubKey!));
        }

        // txOuts that we are spending
        var scriptouts = [];
        var txOuts = [];
        for (var i = 0; i < nIns; i++) {
          scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
              addrs[i].hashBuf!.toHex() +
              ' OP_EQUALVERIFY OP_CHECKSIG'));
          txOuts.add(TxOut.fromProperties(
            valueBn: BigIntX.fromNum(1499),
            script: scriptouts[i],
          ));
        }
        // total input amount: nIns * 1e8

        var txb = new TxBuilder();
        txb.setFeePerKbNum(0.0000500e8);
        txb.setChangeAddress(changeaddr);

        // put inputs into tx
        for (var i = 0; i < nIns; i++) {
          var txHashBuf = List.generate(32, (index) => i + 1);
          txb.inputFromPubKeyHash(
            txHashBuf: txHashBuf,
            txOutNum: i,
            txOut: txOuts[i],
          );
        }

        // put outputs into tx
        for (var i = 0; i < nOuts; i++) {
          txb.outputToAddress(
            valueBn: BigIntX.fromNum(1000),
            addr: addrs[i],
          );
        }
        // total sending: nOuts * 0.999e8

        txb.build(useAllInputs: true);

        expect(txb.tx.txIns!.length, nIns);
        expect(txb.tx.txOuts!.length, nOuts + 1);

        // before signing, convert to/from JSON, simulating real-world walvar use-case
        txb = TxBuilder().fromJSON(txb.toJSON());

        // fully sign
        txb.signWithKeyPairs(keyPairs);

        var result =
            await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
        expect(result, true);
      });

      test(
          'should not mess up with bip 69 sorting with this known txbuilder object',
          () async {
        var txbJSON =
            '{"tx":"0100000005b27d77a351245f3ed2c38e40114d432ffecee69d8c64dc06fe427a1ac09f1b40000000006b483045022100f7831904c76f49e23bdd5d2813cd708074ec77d345a0311ee7150fcfcd494cf3022058cbce7ea22b8d759c35d37a375ce0c73b9e1e87d047cb7748ade1fd082370d1412102bf0925d874daedbc1e0abdffa399b2b2042fddbba1cca850cdfdfc3ec9f218ffffffffff98f1664e4ad769225b39033b5a7269afdff54cc676908724d74d4efdebc2ee59000000006b483045022100f2e3195d6c104aacbf04589916d3e529414abbc8379b7d92fa6d32c32c297f05022024775901b5d71cb639297cf9b757d97738b16715023320ef9a51311bb1a97e94412102cd925e193fe4e0848e1f99e0975904a73eea7f779ff0e870115ad16b784803ceffffffff011ac299dce0415097d1fd67287e83cb92fbd2b9b7efe2c91751eb454e05c394000000006a4730440220739794fc726b205a34569c590d32e13459f5127fcf71d2169fc5944a727de8be0220505d2cbedc63514a6147fe756d45f7faf9bd5852df446fa35b62b554fb2d32514121034828cbbf04f9ae5608fdcf47598e191846b4970c1b6eda66519661ca75035a9dffffffffe85c87e34ed16ab8988fc398c16b9738f6032e9a4377b6636e2ec6a0ee752fcb000000006a473044022030e01c5bda4da0d4aadec98c5ece7b3529509b0aef6f437a14417abaf833956002207d8ece580800807132bca535ce06398ac5c68c68acd20566ecd3db0ecd58d7114121033fb03af6776d59cdb6ae78dff502d36b5a51429f243116f827e3d7438343b213ffffffff19cc6850ec0e9b8a01ef6ea0ef9888fbdc0e6794b9a6b7c7c36621d80665a0ec000000006b4830450221009f25a7e50bc857eb75f6dd06b55ec495a3f11c73f1f0151190bbb417f051978b02207169bb7aaa05d58dcc50f091d9b0a584157420cc2e4c3d841cafddf891356a95412103582a67dd32baefe4063e0408809bc740df4233c44dc2e5e3737de5c2249f0863ffffffff028d160000000000001976a914821972770205b3466023acd90790f95aee37914488accc580300000000001976a9145ff56ab8054c9e038254ee92f9ba364f84c2736188ac00000000","txIns":["98f1664e4ad769225b39033b5a7269afdff54cc676908724d74d4efdebc2ee5900000000020000ffffffff","011ac299dce0415097d1fd67287e83cb92fbd2b9b7efe2c91751eb454e05c39400000000020000ffffffff","b27d77a351245f3ed2c38e40114d432ffecee69d8c64dc06fe427a1ac09f1b4000000000020000ffffffff","e85c87e34ed16ab8988fc398c16b9738f6032e9a4377b6636e2ec6a0ee752fcb00000000020000ffffffff","19cc6850ec0e9b8a01ef6ea0ef9888fbdc0e6794b9a6b7c7c36621d80665a0ec00000000020000ffffffff"],"txOuts":["cc580300000000001976a9145ff56ab8054c9e038254ee92f9ba364f84c2736188ac"],"uTxOutMap":{"98f1664e4ad769225b39033b5a7269afdff54cc676908724d74d4efdebc2ee59:0":"f9140000000000001976a9145629fb19a3c46420707f61785c1b63cc69b7da3288ac","011ac299dce0415097d1fd67287e83cb92fbd2b9b7efe2c91751eb454e05c394:0":"1ad70000000000001976a91462698da42f87021fc8cdb4c945d09d93e82480a088ac","b27d77a351245f3ed2c38e40114d432ffecee69d8c64dc06fe427a1ac09f1b40:0":"acd60000000000001976a9144c6daa9f0afa439dc98075c531e1fb614139818e88ac","e85c87e34ed16ab8988fc398c16b9738f6032e9a4377b6636e2ec6a0ee752fcb:0":"1ad70000000000001976a914841067d1f0abdd78ef8feb3aa42b52c0d7ee83a188ac","19cc6850ec0e9b8a01ef6ea0ef9888fbdc0e6794b9a6b7c7c36621d80665a0ec:0":"1ad70000000000001976a914d3647137576bc3561444a2c84018c942796ab5bb88ac"},"sigOperations":{"98f1664e4ad769225b39033b5a7269afdff54cc676908724d74d4efdebc2ee59:0":[{"nScriptChunk":0,"type":"sig","addressStr":"18rbQNxxgYdpMnsvNjvbXJP1TBZ9zQM3WJ","nHashType":65,"log":"successfully inserted signature"},{"nScriptChunk":1,"type":"pubKey","addressStr":"18rbQNxxgYdpMnsvNjvbXJP1TBZ9zQM3WJ","nHashType":65,"log":"successfully inserted public key"}],"011ac299dce0415097d1fd67287e83cb92fbd2b9b7efe2c91751eb454e05c394:0":[{"nScriptChunk":0,"type":"sig","addressStr":"19yMfmgJAEsGHUS4J6ZXqtv3Z4hG3NT4pA","nHashType":65,"log":"successfully inserted signature"},{"nScriptChunk":1,"type":"pubKey","addressStr":"19yMfmgJAEsGHUS4J6ZXqtv3Z4hG3NT4pA","nHashType":65,"log":"successfully inserted public key"}],"b27d77a351245f3ed2c38e40114d432ffecee69d8c64dc06fe427a1ac09f1b40:0":[{"nScriptChunk":0,"type":"sig","addressStr":"17y7jLk1f1oQcV78pRsnv7dUNBLnFUzakZ","nHashType":65,"log":"successfully inserted signature"},{"nScriptChunk":1,"type":"pubKey","addressStr":"17y7jLk1f1oQcV78pRsnv7dUNBLnFUzakZ","nHashType":65,"log":"successfully inserted public key"}],"e85c87e34ed16ab8988fc398c16b9738f6032e9a4377b6636e2ec6a0ee752fcb:0":[{"nScriptChunk":0,"type":"sig","addressStr":"1D3HrCYVc1fybgtY4e8Yhg1k1KF7X9C725","nHashType":65,"log":"successfully inserted signature"},{"nScriptChunk":1,"type":"pubKey","addressStr":"1D3HrCYVc1fybgtY4e8Yhg1k1KF7X9C725","nHashType":65,"log":"successfully inserted public key"}],"19cc6850ec0e9b8a01ef6ea0ef9888fbdc0e6794b9a6b7c7c36621d80665a0ec:0":[{"nScriptChunk":0,"type":"sig","addressStr":"1LGjuKv9eqPUzg2YsMdfzJWckuAwfcnmZo","nHashType":65,"log":"successfully inserted signature"},{"nScriptChunk":1,"type":"pubKey","addressStr":"1LGjuKv9eqPUzg2YsMdfzJWckuAwfcnmZo","nHashType":65,"log":"successfully inserted public key"}]},"changeScript":"76a914821972770205b3466023acd90790f95aee37914488ac","changeAmountBn":5773,"feeAmountBn":410,"feePerKbNum":500,"sigsPerInput":1,"dust":546,"dustChangeToFees":true,"hashCache":{"prevoutsHashBuf":"1d67bdef4b743591ada4922b5af092d7cce85efcf8f630e94afcde068f6fa2d0","sequenceHashBuf":"99399659a6e129b6497faa061be7d8f6558a8594b5dd80474859a12d6ccf0b20","outputsHashBuf":"bcda35b250afaa69c8ffe37021ebece36afbe749c1935f69de3eab93e450fd3d"}}';
        var txb = TxBuilder().fromJSON(json.decode(txbJSON));

        List<KeyPair> keyPairs = [];
        keyPairs.add(KeyPair().fromJSON(json.decode(
            '{"privKey":"8032334c28c99a38fce22a6d4224e766d894e727a0a9cccfd2038fe4d4ca23ec9901","pubKey":"0104cd925e193fe4e0848e1f99e0975904a73eea7f779ff0e870115ad16b784803ce70874550b3e86a8d670422d4e138c9f7700e4903f1d1e4af35eac9fba6377ef4"}')));
        keyPairs.add(KeyPair().fromJSON(json.decode(
            '{"privKey":"803f50e990b3518c654c022f6bc8ee9464db857aee821133bbe8090c035f81851201","pubKey":"01044828cbbf04f9ae5608fdcf47598e191846b4970c1b6eda66519661ca75035a9dd6228621b4462f6a6791897b6d60b2ec1492509ba871a707b34bf94eade868e5"}')));
        keyPairs.add(KeyPair().fromJSON(json.decode(
            '{"privKey":"80f7744e00816dc306b7c452fef77883317efbd59863f7adcac0a0d95b489b196701","pubKey":"0104bf0925d874daedbc1e0abdffa399b2b2042fddbba1cca850cdfdfc3ec9f218ff0bdb932b2ced35cefc0988116b426cbb68f563c401329e77e9eaae29256aad5c"}')));
        keyPairs.add(KeyPair().fromJSON(json.decode(
            '{"privKey":"805d3c50621207fc5783c82bf7e7f090161154818467258c49368dfbf95a6cb5a301","pubKey":"01043fb03af6776d59cdb6ae78dff502d36b5a51429f243116f827e3d7438343b213ab07f6bc08e1a0afba025e0cd34395afedce01bf8e9b6b7c6d385eaaee57403d"}')));
        keyPairs.add(KeyPair().fromJSON(json.decode(
            '{"privKey":"80aaf1703f957b80a023088c5a04c9fb4d4950705dcd8b7aaf6cd9eea66e807f8801","pubKey":"0104582a67dd32baefe4063e0408809bc740df4233c44dc2e5e3737de5c2249f08630bb6640376b7ed60ed12ec161a458c8bbb3417a7e3474a3e9436cc32d9296627"}')));

        var txVerifier = new TxVerifier(tx: txb.tx, txOutMap: txb.uTxOutMap);

        // txb.uTxOutMap.map.forEach((txOut, label) => {
        //   console.log(label, Address.fromTxOutScript(txOut.script).toString(), txOut.valueBn.toNumber())
        // })

        // txb.tx.txIns.forEach((txIn, nIn) => {
        //   var verified = txVerifier.staticVerifyNIn(nIn, Interp.SCRIPT_ENABLE_SIGHASH_FORKID)
        //   console.log(txIn.txHashBuf.toString('hex'), txIn.txOutNum, Address.fromTxInScript(txIn.script).toString(), verified)
        // })

        var result = await txVerifier
            .verify(); // this was computed with signatures in the wrong place; it should be invalid
        expect(result, false);

        var txb2 = new TxBuilder();
        txb2.sendDustChangeToFees(true);
        txb2.setChangeAddress(Address.fromTxOutScript(txb.changeScript!));
        txb2.inputFromPubKeyHash(
          txHashBuf: txb.txIns[0].txHashBuf,
          txOutNum: txb.txIns[0].txOutNum,
          txOut: txb.uTxOutMap.get(
            txb.txIns[0].txHashBuf!,
            txb.txIns[0].txOutNum,
          ),
        );
        txb2.inputFromPubKeyHash(
          txHashBuf: txb.txIns[1].txHashBuf,
          txOutNum: txb.txIns[1].txOutNum,
          txOut: txb.uTxOutMap.get(
            txb.txIns[1].txHashBuf!,
            txb.txIns[1].txOutNum,
          ),
        );
        txb2.inputFromPubKeyHash(
          txHashBuf: txb.txIns[2].txHashBuf,
          txOutNum: txb.txIns[2].txOutNum,
          txOut: txb.uTxOutMap.get(
            txb.txIns[2].txHashBuf!,
            txb.txIns[2].txOutNum,
          ),
        );
        txb2.inputFromPubKeyHash(
          txHashBuf: txb.txIns[3].txHashBuf,
          txOutNum: txb.txIns[3].txOutNum,
          txOut: txb.uTxOutMap.get(
            txb.txIns[3].txHashBuf!,
            txb.txIns[3].txOutNum,
          ),
        );
        txb2.inputFromPubKeyHash(
          txHashBuf: txb.txIns[4].txHashBuf,
          txOutNum: txb.txIns[4].txOutNum,
          txOut: txb.uTxOutMap.get(
            txb.txIns[4].txHashBuf!,
            txb.txIns[4].txOutNum,
          ),
        );

        txb2.build(useAllInputs: true);
        txb2.sort(); // NOT sorting should lead to valid tx
        txb2.signWithKeyPairs(keyPairs);

        var txVerifier2 = new TxVerifier(tx: txb2.tx, txOutMap: txb2.uTxOutMap);

        // txb2.uTxOutMap.map.forEach((txOut, label) => {
        //   console.log(label, Address.fromTxOutScript(txOut.script).toString(), txOut.valueBn.toNumber())
        // })

        // txb2.tx.txIns.forEach((txIn, nIn) => {
        //   var verified = txVerifier2.verifyNIn(nIn, Interp.SCRIPT_ENABLE_SIGHASH_FORKID)
        //   console.log(txIn.txHashBuf.toString('hex'), txIn.txOutNum, Address.fromTxInScript(txIn.script).toString(), verified)
        // })

        result = await txVerifier2
            .verify(); // this was computed with signatures in the wrong place; it should be invalid
        expect(result, true);
      });
    });
  });
}
