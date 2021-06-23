import 'package:bsv/br.dart';
import 'package:bsv/script.dart';
import 'package:bsv/tx_in.dart';
import 'package:bsv/var_int.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/string.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  group('TxIn', () {
    var txHashBuf = List<int>.generate(32, (index) => 0);
    var txOutNum = 0;
    var script = new Script().fromString('OP_CHECKMULTISIG');
    var scriptVi = VarInt.fromNumber(script.toBuffer().length);
    var nSequence = 0;
    var txIn = new TxIn(
      txHashBuf: txHashBuf,
      txOutNum: txOutNum,
      scriptVi: scriptVi,
      script: script,
      nSequence: nSequence,
    );

    // test('should make a new txIn',  () {
    //   var txIn = new TxIn()
    //   should.exist(txIn)
    //   txIn = new TxIn()
    //   should.exist(txIn)
    //   var txHashBuf = Buffer.alloc(32)
    //   txHashBuf.fill(0)
    //   new TxIn(txHashBuf, 0).txHashBuf.length.should.equal(32)
    // });

    group('#initialize', () {
      test('should default to 0xffffffff nSequence', () {
        expect(new TxIn().nSequence, (0xffffffff));
      });
    });

    // group('#fromObject',  () {
    //   test('should set these vars',  () {
    //     var txIn = new TxIn().fromObject({
    //       txHashBuf: txHashBuf,
    //       txOutNum: txOutNum,
    //       scriptVi: scriptVi,
    //       script: script,
    //       nSequence: nSequence
    //     })
    //     should.exist(txIn.txHashBuf)
    //     should.exist(txIn.txOutNum)
    //     should.exist(txIn.scriptVi)
    //     should.exist(txIn.script)
    //     should.exist(txIn.nSequence)
    //   });
    // });

    group('#fromProperties', () {
      test('should make a new txIn', () {
        var txIn = new TxIn().fromProperties(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          script: script,
          nSequence: nSequence,
        );
        expect(txIn.scriptVi != null, true);
      });
    });

    group('@fromProperties', () {
      test('should make a new txIn', () {
        var txIn = TxIn.fromProperties(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          script: script,
          nSequence: nSequence,
        );
        expect(txIn.scriptVi != null, true);
      });
    });

    group('#setScript', () {
      test('should calculate the varInt size correctly', () {
        var txIn2 = new TxIn(
          txHashBuf: txIn.txHashBuf,
          txOutNum: txIn.txOutNum,
          script: txIn.script,
          nSequence: txIn.nSequence,
        );
        expect(
          txIn2
              .setScript(Script().fromString('OP_RETURN OP_RETURN OP_RETURN'))
              .scriptVi
              .toNumber(),
          3,
        );
      });
    });

    group('#fromJSON', () {
      test('should set these vars', () {
        var txIn2 = new TxIn().fromJSON(txIn.toJSON());
        expect(txIn2.txHashBuf != null, true);
        expect(txIn2.txOutNum != null, true);
        expect(txIn2.scriptVi != null, true);
        expect(txIn2.script != null, true);
        expect(txIn2.nSequence != null, true);
      });
    });

    group('#toJSON', () {
      test('should set these vars', () {
        var json = txIn.toJSON();
        expect(json['txHashBuf'] != null, true);
        expect(json['txOutNum'] != null, true);
        expect(json['scriptVi'] != null, true);
        expect(json['script'] != null, true);
        expect(json['nSequence'] != null, true);
      });
    });

    group('#fromHex', () {
      test('should convert this known buffer', () {
        var hexStr =
            '00000000000000000000000000000000000000000000000000000000000000000000000001ae00000000';
        var txIn = new TxIn().fromHex(hexStr);
        expect(txIn.scriptVi.toNumber(), 1);
        expect(txIn.script.toString(), 'OP_CHECKMULTISIG');
      });
    });

    group('#fromBuffer', () {
      test('should convert this known buffer', () {
        var hexStr =
            '00000000000000000000000000000000000000000000000000000000000000000000000001ae00000000';
        var buf = hexStr.toBuffer();
        var txIn = new TxIn().fromBuffer(buf);
        expect(txIn.scriptVi.toNumber(), 1);
        expect(txIn.script.toString(), 'OP_CHECKMULTISIG');
      });
    });

    group('#fromBr', () {
      test('should convert this known buffer', () {
        var hexStr =
            '00000000000000000000000000000000000000000000000000000000000000000000000001ae00000000';
        var buf = hexStr.toBuffer();
        var br = new Br(buf: buf);
        var txIn = new TxIn().fromBr(br);
        expect(txIn.scriptVi.toNumber(), 1);
        expect(txIn.script.toString(), 'OP_CHECKMULTISIG');
      });
    });

    group('#toHex', () {
      test('should convert this known hex', () {
        expect(
          txIn.toHex(),
          '00000000000000000000000000000000000000000000000000000000000000000000000001ae00000000',
        );
      });
    });

    group('#toBuffer', () {
      test('should convert this known buffer', () {
        expect(
          txIn.toBuffer().toHex(),
          '00000000000000000000000000000000000000000000000000000000000000000000000001ae00000000',
        );
      });
    });

    group('#toBw', () {
      test('should convert this known buffer', () {
        expect(
          txIn.toBw().toBuffer().toHex(),
          '00000000000000000000000000000000000000000000000000000000000000000000000001ae00000000',
        );
      });
    });

    // TODO:需要实现
    // group('#fromPubKeyHashTxOut',  () {
    //   test('should convert from pubKeyHash out',  () {
    //     var keyPair = new KeyPair().fromRandom()
    //     var address = new Address().fromPubKey(keyPair.pubKey)
    //     var txOut = TxOut.fromProperties(
    //       new Bn(1000),
    //       new Script().fromPubKeyHash(address.hashBuf)
    //     )
    //     var txHashBuf = Buffer.alloc(32)
    //     txHashBuf.fill(0)
    //     var txOutNum = 0
    //     var txIn = new TxIn().fromPubKeyHashTxOut(
    //       txHashBuf,
    //       txOutNum,
    //       txOut,
    //       keyPair.pubKey
    //     )
    //     should.exist(txIn)
    //   });
    // });
  });
}
