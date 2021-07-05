import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/interp.dart';
import 'package:bsv/key_pair.dart';
import 'package:bsv/script.dart';
import 'package:bsv/sig.dart';
import 'package:bsv/tx.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

import 'vectors/bitcoin-abc/script_tests.dart';
import 'vectors/bitcoin-sv/script_tests.dart';
import 'vectors/bitcoind/script_invalid.dart';
import 'vectors/bitcoind/script_valid.dart';

void main() {
  group('Interp', () {
    test('should make a new interp', () {
      var interp = new Interp();

      expect(interp.stack.length, 0);
      expect(interp.altStack.length, 0);
      expect(interp.pc, 0);
      expect(interp.pBeginCodeHash, 0);
      expect(interp.nOpCount, 0);
      expect(interp.ifStack.length, 0);
      expect(interp.errStr, '');
      expect(interp.flags, Interp.defaultFlags);
      interp = new Interp();

      expect(interp.stack.length, 0);
      expect(interp.altStack.length, 0);
      expect(interp.pc, 0);
      expect(interp.pBeginCodeHash, 0);
      expect(interp.nOpCount, 0);
      expect(interp.ifStack.length, 0);
      expect(interp.errStr, '');
      expect(interp.flags, Interp.defaultFlags);
    });

    group('#fromJSON', () {
      test('should convert a json to an interp', () {
        var interp = new Interp(
          script: new Script(),
          stack: [hex.decode('00')],
          altStack: [hex.decode('00')],
        );
        var json = interp.toJSON();
        var interp2 = new Interp().fromJSON(json);
        expect(interp2.script != null, true);
        expect(interp2.stack[0] != null, true);
        expect(interp2.altStack[0] != null, true);
      });
    });

    group('#fromFastBuffer', () {
      test('should convert an interp buf to an interp', () {
        var interp = new Interp(
          script: new Script(),
          stack: [hex.decode('00')],
          altStack: [hex.decode('00')],
        );
        var json = interp.toBuffer();
        var interp2 = new Interp().fromBuffer(json);
        expect(interp2.script != null, true);
        expect(interp2.stack[0] != null, true);
        expect(interp2.altStack[0] != null, true);
      });

      test('should convert an interp buf to an interp', () {
        var interp = new Interp(
          script: new Script(),
          stack: [hex.decode('00')],
          altStack: [hex.decode('00')],
          tx: new Tx(),
        );
        var buf = interp.toBuffer();
        var interp2 = new Interp().fromBuffer(buf);
        expect(interp2.script != null, true);
        expect(interp2.stack[0] != null, true);
        expect(interp2.altStack[0] != null, true);
      });
    });

    group('#toJSON', () {
      test('should convert an interp to json', () {
        var interp = new Interp(script: new Script());
        var json = interp.toJSON();
        expect(json['script'] != null, true);
        expect(json['tx'] == null, true);
      });
    });

    group('#toFastBuffer', () {
      test('should convert an interp to buf with no tx', () {
        var interp = new Interp(script: new Script());
        expect(interp.toBuffer() is List<int>, true);
      });

      test('should convert an interp to buf with a tx', () {
        var interp = new Interp(script: new Script(), tx: new Tx());
        expect(interp.toBuffer() is List<int>, true);
      });
    });

    group('@castToBool', () {
      test('should cast these bufs to bool correctly', () {
        expect(
            Interp.castToBool(BigIntX.fromNum(0).toSm(endian: Endian.little)),
            false);
        expect(Interp.castToBool(hex.decode('0080')), false); // negative 0
        expect(
            Interp.castToBool(BigIntX.fromNum(1).toSm(endian: Endian.little)),
            true);
        expect(
            Interp.castToBool(BigIntX.fromNum(-1).toSm(endian: Endian.little)),
            true);

        var buf = hex.decode('00');
        var b = BigIntX.fromSm(buf, endian: Endian.little).cmp(0) != 0;
        expect(Interp.castToBool(buf), b);
      });
    });

    group('#getDebugObject', () {
      test('should get a failure explanation object', () async {
        var scriptSig = Script.fromBitcoindString(
            '0x47 0x3044022057292e2d4dfe775becdd0a9e6547997c728cdf35390f6a017da56d654d374e4902206b643be2fc53763b4e284845bfea2c597d2dc7759941dce937636c9d341b71ed01');
        var scriptPubKey = Script.fromBitcoindString(
            '0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG');

        var flags = Interp.SCRIPT_VERIFY_P2SH |
            Interp.SCRIPT_VERIFY_CHECKLOCKTIMEVERIFY |
            Interp.SCRIPT_VERIFY_CHECKSEQUENCEVERIFY;

        var hashBuf = List.generate(32, (index) => 0);

        var credtx = new Tx();
        credtx.addTxIn(
          data: hashBuf,
          txOutNum: 0xffffffff,
          script: new Script().writeString('OP_0 OP_0'),
          nSequence: 0xffffffff,
        );
        credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

        var idbuf = credtx.hash();
        var spendtx = new Tx();

        spendtx.addTxIn(
          data: idbuf.data.toList(),
          txOutNum: 0,
          script: new Script(),
          nSequence: 0xffffffff,
        );
        spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());

        var interp = new Interp();
        await interp.verify(
          scriptSig: scriptSig,
          scriptPubKey: scriptPubKey,
          tx: spendtx,
          nIn: 0,
          flags: flags,
        );

        var debugObject = interp.getDebugObject();
        expect(debugObject['errStr'] != null, true);
        expect(debugObject['scriptStr'] != null, true);
        expect(debugObject['pc'] != null, true);
        expect(debugObject['opCodeStr'] != null, true);
      });
    });

    group('#getDebugString', () {
      test('should get a failure explanation object', () async {
        var scriptSig = Script.fromBitcoindString(
            '0x47 0x3044022057292e2d4dfe775becdd0a9e6547997c728cdf35390f6a017da56d654d374e4902206b643be2fc53763b4e284845bfea2c597d2dc7759941dce937636c9d341b71ed01');
        var scriptPubKey = Script.fromBitcoindString(
            '0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG');
        var flags = Interp.SCRIPT_VERIFY_P2SH |
            Interp.SCRIPT_VERIFY_CHECKLOCKTIMEVERIFY |
            Interp.SCRIPT_VERIFY_CHECKSEQUENCEVERIFY;

        var hashBuf = List.generate(32, (index) => 0);

        var credtx = new Tx();
        credtx.addTxIn(
          data: hashBuf,
          txOutNum: 0xffffffff,
          script: new Script().writeString('OP_0 OP_0'),
          nSequence: 0xffffffff,
        );
        credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

        var idbuf = credtx.hash();
        var spendtx = new Tx();

        spendtx.addTxIn(
          data: idbuf.data.toList(),
          txOutNum: 0,
          script: new Script(),
          nSequence: 0xffffffff,
        );
        spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());
        var interp = new Interp();
        var result = await interp.verify(
          scriptSig: scriptSig,
          scriptPubKey: scriptPubKey,
          tx: spendtx,
          nIn: 0,
          flags: flags,
        );
        print(result);

        var debugString = interp.getDebugString();
        expect(debugString,
            '{"errStr":"","scriptStr":"65 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 OP_CHECKSIG","pc":1,"stack":["01"],"altStack":[],"opCodeStr":"OP_CHECKSIG"}');
      });
    });

    group('#verify', () {
      test('should has correct stack size after verify', () async {
        var interp = new Interp();
        var script = Script.fromAsmString('OP_1');
        interp.script = script;
        await interp.verify();
        expect(interp.stack.length, 1);
      });

      test(
          'should verify or unverify these trivial scripts from script_valid.json',
          () async {
        var verified;
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('OP_1'),
          scriptPubKey: new Script().writeString('OP_1'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('OP_1'),
          scriptPubKey: new Script().writeString('OP_0'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, false);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('OP_0'),
          scriptPubKey: new Script().writeString('OP_1'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('OP_CODESEPARATOR'),
          scriptPubKey: new Script().writeString('OP_1'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString(''),
          scriptPubKey: new Script().writeString('OP_DEPTH OP_0 OP_EQUAL'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('OP_1 OP_2'),
          scriptPubKey:
              new Script().writeString('OP_2 OP_EQUALVERIFY OP_1 OP_EQUAL'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('9 0x000000000000000010'),
          scriptPubKey: new Script().writeString(''),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('OP_1'),
          scriptPubKey: new Script().writeString('OP_15 OP_ADD OP_16 OP_EQUAL'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
        verified = await new Interp().verify(
          scriptSig: new Script().writeString('OP_0'),
          scriptPubKey:
              new Script().writeString('OP_IF OP_VER OP_ELSE OP_1 OP_ENDIF'),
          tx: new Tx(),
          nIn: 0,
        );
        expect(verified, true);
      });

      test('should verify this new pay-to-pubKey script', () async {
        var keyPair = new KeyPair().fromRandom();
        var scriptPubKey = new Script()
            .writeBuffer(keyPair.pubKey.toDer(true).asUint8List())
            .writeString('OP_CHECKSIG');

        var hashBuf = List.generate(32, (index) => 0);
        var credtx = new Tx();
        credtx.addTxIn(
          data: hashBuf,
          txOutNum: 0xffffffff,
          script: new Script().writeString('OP_0 OP_0'),
          nSequence: 0xffffffff,
        );
        credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

        var idbuf = credtx.hash();
        var spendtx = new Tx();
        spendtx.addTxIn(
          data: idbuf.data.toList(),
          txOutNum: 0,
          script: new Script(),
          nSequence: 0xffffffff,
        );
        spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());

        var sig = spendtx.sign(
          keyPair: keyPair,
          nHashType: Sig.SIGHASH_ALL,
          nIn: 0,
          subScript: scriptPubKey,
        );
        var scriptSig =
            new Script().writeBuffer(sig.toTxFormat().asUint8List());
        spendtx.txIns[0].setScript(scriptSig);

        var interp = new Interp();
        var verified = await interp.verify(
          scriptSig: scriptSig,
          scriptPubKey: scriptPubKey,
          tx: spendtx,
          nIn: 0,
        );
        expect(verified, true);
      });

      test('should verify this pay-to-pubKey script from script_valid.json',
          () async {
        var scriptSig = new Script().fromBitcoindString(
            '0x47 0x3044022007415aa37ce7eaa6146001ac8bdefca0ddcba0e37c5dc08c4ac99392124ebac802207d382307fd53f65778b07b9c63b6e196edeadf0be719130c5db21ff1e700d67501');
        var scriptPubKey = new Script().fromBitcoindString(
            '0x41 0x0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG');

        var hashBuf = List.generate(32, (index) => 0);
        var credtx = new Tx();
        credtx.addTxIn(
          data: hashBuf,
          txOutNum: 0xffffffff,
          script: new Script().writeString('OP_0 OP_0'),
          nSequence: 0xffffffff,
        );
        credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

        var idbuf = credtx.hash();
        var spendtx = new Tx();
        spendtx.addTxIn(
          data: idbuf.data.toList(),
          txOutNum: 0,
          script: scriptSig,
          nSequence: 0xffffffff,
        );
        spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());

        var interp = new Interp();
        var verified = await interp.verify(
          scriptSig: scriptSig,
          scriptPubKey: scriptPubKey,
          tx: spendtx,
          nIn: 0,
          flags: 0,
        );
        expect(verified, true);
      });
    });

    group('Interp vectors', () {
      // var c;

      // c = 0;
      for (var i = 0; i < bitcoinABCScriptTests.length; i++) {
        // break;
        var vector = bitcoinABCScriptTests[i];

        if (vector.length == 1) {
          continue;
        }
        // c++;
        test('should verify bitcoindScriptValid vector $i', () async {
          // ["Format is: [scriptSig, scriptPubKey, flags, expected_scripterror, ... comments]"],
          // Test vectors for SIGHASH_FORKID
          var scriptSig = new Script().fromBitcoindString(vector[0]);
          var scriptPubKey = new Script().fromBitcoindString(vector[1]);
          var flags = Interp.getFlags(vector[2]);
          var expectedError = vector[3];

          var hashBuf = List.generate(32, (index) => 0);
          var credtx = new Tx();

          credtx.addTxIn(
            data: hashBuf,
            txOutNum: 0xffffffff,
            script: new Script().writeString('OP_0 OP_0'),
            nSequence: 0xffffffff,
          );
          credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

          var idbuf = credtx.hash();
          var spendtx = new Tx();
          spendtx.addTxIn(
            data: idbuf.data.toList(),
            txOutNum: 0,
            script: scriptSig,
            nSequence: 0xffffffff,
          );
          spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());

          var interp = new Interp();
          var valueBn = new BigIntX.fromNum(0);
          var verified = await interp.verify(
            scriptSig: scriptSig,
            scriptPubKey: scriptPubKey,
            tx: spendtx,
            nIn: 0,
            flags: flags,
            valueBn: valueBn,
          );
          try {
            if (expectedError == 'OK') {
              expect(verified, true);
            } else {
              expect(verified, false);
            }
          } catch (err) {
            // console.log(vector)
            // throw new Error('failure', err)
          }
        });
      }

      // c = 0;
      for (var i = 0; i < bitcoinSVScriptTests.length; i++) {
        // for (var i = 187; i < bitcoinSVScriptTests.length; i++) {
        // break;
        var vector = bitcoinSVScriptTests[i];

        if (vector.length == 1) {
          continue;
        }
        // c++;
        test('should verify bitcoinSVScriptTests vector $i', () async {
          // ["Format is: [scriptSig, scriptPubKey, flags, expected_scripterror, ... comments]"],

          var scriptSig = new Script().fromBitcoindString(vector[0]);
          var scriptPubKey = new Script().fromBitcoindString(vector[1]);
          var flags = Interp.getFlags(vector[2]);
          var expectedError = vector[3];

          var hashBuf = List.generate(32, (index) => 0);
          var credtx = new Tx();
          credtx.addTxIn(
            data: hashBuf,
            txOutNum: 0xffffffff,
            script: new Script().writeString('OP_0 OP_0'),
            nSequence: 0xffffffff,
          );
          credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

          var idbuf = credtx.hash();
          var spendtx = new Tx();
          spendtx.addTxIn(
            data: idbuf.data.toList(),
            txOutNum: 0,
            script: scriptSig,
            nSequence: 0xffffffff,
          );
          spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());

          var interp = new Interp();
          var valueBn = new BigIntX.fromNum(0);
          var verified = await interp.verify(
            scriptSig: scriptSig,
            scriptPubKey: scriptPubKey,
            tx: spendtx,
            nIn: 0,
            flags: flags,
            valueBn: valueBn,
          );
          try {
            if (expectedError == 'OK') {
              expect(verified, true);
            } else {
              expect(verified, false);
            }
          } catch (err) {
            // console.log(vector)
            // throw new Error('failure', err)
          }
        });
      }

      // c = 0
      for (var i = 0; i < bitcoindScriptValid.length; i++) {
        // break;
        // for (var i = 576; i < bitcoindScriptValid.length; i++) {
        var vector = bitcoindScriptValid[i];

        if (vector.length == 1) {
          continue;
        }
        // c++;
        test('should verify bitcoindScriptValid vector $i', () async {
          var scriptSig = new Script().fromBitcoindString(vector[0]);
          var scriptPubKey = new Script().fromBitcoindString(vector[1]);
          var flags = Interp.getFlags(vector[2]);

          var hashBuf = List.generate(32, (index) => 0);
          var credtx = new Tx();
          credtx.addTxIn(
            data: hashBuf,
            txOutNum: 0xffffffff,
            script: new Script().writeString('OP_0 OP_0'),
            nSequence: 0xffffffff,
          );
          credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

          var idbuf = credtx.hash();
          var spendtx = new Tx();
          spendtx.addTxIn(
            data: idbuf.data.toList(),
            txOutNum: 0,
            script: scriptSig,
            nSequence: 0xffffffff,
          );
          spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());

          var interp = new Interp();
          var verified = await interp.verify(
            scriptSig: scriptSig,
            scriptPubKey: scriptPubKey,
            tx: spendtx,
            nIn: 0,
            flags: flags,
          );

          expect(verified, true);
        });
        // break;
      }

      for (var i = 0; i < bitcoindScriptInvalid.length; i++) {
        // for (var i = 400; i < bitcoindScriptInvalid.length; i++) {
        // break;
        var vector = bitcoindScriptInvalid[i];

        if (vector.length == 1) {
          continue;
        }
        test('should unverify bitcoindScriptInvalid vector $i', () async {
          // vector = [
          //   "",
          //   "DEPTH",
          //   "P2SH,STRICTENC",
          //   "Test the test: we should have an empty stack after scriptSig evaluation"
          // ];
          var scriptSig = new Script().fromBitcoindString(vector[0]);
          var scriptPubKey = new Script().fromBitcoindString(vector[1]);
          var flags = Interp.getFlags(vector[2]);

          var hashBuf = List.generate(32, (index) => 0);
          var credtx = new Tx();
          credtx.addTxIn(
            data: hashBuf,
            txOutNum: 0xffffffff,
            script: new Script().writeString('OP_0 OP_0'),
            nSequence: 0xffffffff,
          );
          credtx.addTxOut(data: BigIntX.fromNum(0), script: scriptPubKey);

          var idbuf = credtx.hash();
          var spendtx = new Tx();
          spendtx.addTxIn(
            data: idbuf.data.toList(),
            txOutNum: 0,
            script: scriptSig,
            nSequence: 0xffffffff,
          );
          spendtx.addTxOut(data: BigIntX.fromNum(0), script: new Script());

          var interp = new Interp();
          var verified = await interp.verify(
            scriptSig: scriptSig,
            scriptPubKey: scriptPubKey,
            tx: spendtx,
            nIn: 0,
            flags: flags,
          );

          expect(verified, false);
        });
        // break;
      }
    });
  });
}
