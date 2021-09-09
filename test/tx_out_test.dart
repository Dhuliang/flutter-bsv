import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/script.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/var_int.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  group('TxOut', () {
    var valueBn = new BigIntX.fromNum(5);
    var script = new Script().fromString('OP_CHECKMULTISIG');
    var scriptVi = VarInt.fromNumber(script.toBuffer().length);
    var txOut = new TxOut(valueBn: valueBn, scriptVi: scriptVi, script: script);

    test('should make a new txOut', () {
      expect(
        TxOut(valueBn: valueBn, scriptVi: scriptVi, script: script)
            .valueBn
            .toString(),
        '5',
      );
    });

    // group('#fromObject',  () {
    //   test('should set this object',  () {
    //     var txOut = new TxOut().fromObject({
    //       valueBn: valueBn,
    //       scriptVi: scriptVi,
    //       script: script
    //     })
    //     should.exist(txOut.valueBn)
    //     should.exist(txOut.scriptVi)
    //     should.exist(txOut.script)
    //   })
    // })

    group('#setScript', () {
      test('should set the script size correctly', () {
        var txOut2 = new TxOut(
          valueBn: txOut.valueBn,
          scriptVi: txOut.scriptVi,
          script: txOut.script,
        );
        expect(
          txOut2
              .setScript(
                  new Script().fromString('OP_RETURN OP_RETURN OP_RETURN'))
              .scriptVi!
              .toNumber(),
          3,
        );
      });
    });

    group('#fromProperties', () {
      test('should make a new txOut', () {
        var valueBn = BigIntX.zero;
        var script = Script.fromString('OP_RETURN');
        var txOut =
            new TxOut().fromProperties(valueBn: valueBn, script: script);
        expect(txOut.scriptVi!.toNumber(), 1);
      });
    });

    group('@fromProperties', () {
      test('should make a new txOut', () {
        var valueBn = BigIntX.zero;
        var script = Script.fromString('OP_RETURN');
        var txOut = TxOut.fromProperties(valueBn: valueBn, script: script);

        expect(txOut.scriptVi!.toNumber(), 1);
      });
    });

    group('#fromJSON', () {
      test('should set from this json', () {
        var txOut = new TxOut().fromJSON({
          "valueBn": valueBn.toJSON(),
          "scriptVi": scriptVi.toJSON(),
          "script": script.toJSON()
        });
        expect(txOut.valueBn != null, true);
        expect(txOut.scriptVi != null, true);
        expect(txOut.script != null, true);
      });
    });

    group('#toJSON', () {
      test('should return this json', () {
        var txOut = new TxOut().fromJSON({
          "valueBn": valueBn.toJSON(),
          "scriptVi": scriptVi.toJSON(),
          "script": script.toJSON()
        });
        var json = txOut.toJSON();
        expect(json['valueBn'] != null, true);
        expect(json['scriptVi'] != null, true);
        expect(json['script'] != null, true);
      });
    });

    group('#fromHex', () {
      test('should make this txIn from this known hex', () {
        var txOut = new TxOut().fromHex('050000000000000001ae');
        expect(txOut.toBuffer().toHex(), '050000000000000001ae');
      });

      // test('should work with this problematic json',  () {
      //   var json = {
      //     valueBn: '20000',
      //     scriptVi: '56',
      //     script: 'OP_SHA256 32 0x8cc17e2a2b10e1da145488458a6edec4a1fdb1921c2d5ccbc96aa0ed31b4d5f8 OP_EQUALVERIFY OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIGVERIFY OP_EQUALVERIFY OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIG'
      //   }
      //   var txOut = TxOut.fromJSON(json)
      //   txOut.toString().should.equal(TxOut.fromHex(txOut.toHex()).toString())
      // });
    });

    group('#fromBuffer', () {
      test('should make this txIn from this known buffer', () {
        var txOut = new TxOut().fromBuffer(hex.decode('050000000000000001ae'));
        expect(txOut.toBuffer().toHex(), '050000000000000001ae');
      });
    });

    group('#fromBr', () {
      test('should make this txIn from this known buffer', () {
        var txOut = new TxOut()
            .fromBr(Br(buf: hex.decode('050000000000000001ae') as Uint8List?));
        expect(txOut.toBuffer().toHex(), '050000000000000001ae');
      });
    });

    group('#toBuffer', () {
      test('should output this known buffer', () {
        var txOut = new TxOut()
            .fromBr(Br(buf: hex.decode('050000000000000001ae') as Uint8List?));

        expect(txOut.toBuffer().toHex(), '050000000000000001ae');
      });
    });

    group('#toBw', () {
      test('should output this known buffer', () {
        var txOut = new TxOut()
            .fromBr(Br(buf: hex.decode('050000000000000001ae') as Uint8List?));

        expect(txOut.toBw().toBuffer().toHex(), '050000000000000001ae');
      });
    });
  });
}
