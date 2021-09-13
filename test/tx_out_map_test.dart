import 'package:bsv/src/bn.dart';
import 'package:bsv/src/script.dart';
import 'package:bsv/src/tx.dart';
import 'package:bsv/src/tx_out.dart';
import 'package:bsv/src/tx_out_map.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/src/extentsions/list.dart';

void main() {
  group('TxOutMap', () {
    var txHashBuf = List.generate(32, (index) => 0);
    var label = txHashBuf.toHex() + ':' + '0';
    var txOut = TxOut.fromProperties(
      valueBn: BigIntX.zero,
      script: Script.fromString('OP_RETURN'),
    );
    var map = new Map();
    map[label] = txOut;

    var tx = new Tx().fromHex(
        '0100000001795b88d47a74e3be0948fc9d1b4737f96097474d57151afa6f77c787961e47cc120000006a47304402202289f9e1ae2ed981cd0bf62f822f6ae4aea40c65c7339d90643cea90de93ad1502205c8a08b3265f9ba7e99057d030d5b91c889a1b99f94a3a5b79d7daaada2409b6012103798b51f980e7a3690af6b43ce3467db75bede190385702c4d9d48c0a735ff4a9ffffffff01c0a83200000000001976a91447b8e62e008f82d95d1f565055a8243cc243d32388ac00000000');

    // test('should make a new txOutMap',  () {
    //   let txOutMap = new TxOutMap()
    //   txOutMap = new TxOutMap({ map: map })
    //   should.exist(txOutMap)
    //   should.exist(txOutMap.map)
    // })

    group('#fromObject', () {
      test('should set a map', () {
        var txOutMap = new TxOutMap(map: map);
        expect(
          txOutMap.map[label].toHex(),
          txOut.toHex(),
        );
      });
    });

    group('#toJSON', () {
      test('convert to json', () {
        var txOutMap = new TxOutMap()
            .set(txHashBuf, 0, txOut)
            .set(txHashBuf, 1, txOut)
            .set(txHashBuf, 2, txOut);
        var json = txOutMap.toJSON();

        expect(json.keys.length, 3);
      });
    });

    group('#fromJSON', () {
      test('convert to/from json roundtrip', () {
        var txOutMap = new TxOutMap()
            .set(txHashBuf, 0, txOut)
            .set(txHashBuf, 1, txOut)
            .set(txHashBuf, 2, txOut);
        var txOutMap2 = new TxOutMap().fromJSON(txOutMap.toJSON());

        expect(
          txOutMap2.get(txHashBuf, 0).toHex(),
          txOutMap.get(txHashBuf, 0).toHex(),
        );
        expect(
          txOutMap2.get(txHashBuf, 1).toHex(),
          txOutMap.get(txHashBuf, 1).toHex(),
        );
        expect(
          txOutMap2.get(txHashBuf, 2).toHex(),
          txOutMap.get(txHashBuf, 2).toHex(),
        );
      });
    });

    group('#set', () {
      test('should set a txOut to the txOutMap', () {
        var txOutMap = new TxOutMap().set(txHashBuf, 0, txOut);

        expect(txOutMap.map[label] != null, true);
      });
    });

    group('#get', () {
      test('should get a txOut', () {
        var txOutMap = new TxOutMap(map: map);
        expect(txOutMap.get(txHashBuf, 0).toHex(), txOut.toHex());
      });
    });

    group('#setTx', () {
      test('should set all outputs from a tx', () {
        var txOutMap = new TxOutMap().setTx(tx);
        var txHashBuf = tx.hash();
        var txOut = tx.txOuts![0];

        expect(txOutMap.get(txHashBuf.data!, 0).toHex(), txOut.toHex());
      });
    });
  });
}
