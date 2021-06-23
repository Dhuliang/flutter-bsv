import 'package:bsv/bn.dart';
import 'package:bsv/script.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_out.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/extentsions/string.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  group('TxOutMap', () {
    // TODO:NEXT
    var txHashBuf = List.generate(32, (index) => 0);
    var label = txHashBuf.toHex() + ':' + '0';
    var txOut = TxOut.fromProperties(
      valueBn: BigIntX.zero,
      script: Script.fromString('OP_RETURN'),
    );
    var map = new Map();
    map[label] = txOut;

    // var tx = new Tx().fromHex(
    // '0100000001795b88d47a74e3be0948fc9d1b4737f96097474d57151afa6f77c787961e47cc120000006a47304402202289f9e1ae2ed981cd0bf62f822f6ae4aea40c65c7339d90643cea90de93ad1502205c8a08b3265f9ba7e99057d030d5b91c889a1b99f94a3a5b79d7daaada2409b6012103798b51f980e7a3690af6b43ce3467db75bede190385702c4d9d48c0a735ff4a9ffffffff01c0a83200000000001976a91447b8e62e008f82d95d1f565055a8243cc243d32388ac00000000');

    // it('should make a new txOutMap',  () {
    //   let txOutMap = new TxOutMap()
    //   txOutMap = new TxOutMap({ map: map })
    //   should.exist(txOutMap)
    //   should.exist(txOutMap.map)
    // })

    // group('#fromObject',  () {
    //   it('should set a map',  () {
    //     var txOutMap = new TxOutMap().fromObject({ map: map })
    //     txOutMap.map
    //       .get(label)
    //       .toHex()
    //       .should.equal(txOut.toHex())
    //     txOutMap.fromObject({})
    //     txOutMap.map
    //       .get(label)
    //       .toHex()
    //       .should.equal(txOut.toHex())
    //   })
    // })

    // group('#toJSON',  () {
    //   it('convert to json',  () {
    //     var txOutMap = new TxOutMap()
    //       .set(txHashBuf, 0, txOut)
    //       .set(txHashBuf, 1, txOut)
    //       .set(txHashBuf, 2, txOut)
    //     var json = txOutMap.toJSON()
    //     Object.keys(json).length.should.equal(3)
    //   })
    // })

    // group('#fromJSON',  () {
    //   it('convert to/from json roundtrip',  () {
    //     var txOutMap = new TxOutMap()
    //       .set(txHashBuf, 0, txOut)
    //       .set(txHashBuf, 1, txOut)
    //       .set(txHashBuf, 2, txOut)
    //     var txOutMap2 = new TxOutMap().fromJSON(txOutMap.toJSON())
    //     txOutMap2
    //       .get(txHashBuf, 0)
    //       .toHex()
    //       .should.equal(txOutMap.get(txHashBuf, 0).toHex())
    //     txOutMap2
    //       .get(txHashBuf, 1)
    //       .toHex()
    //       .should.equal(txOutMap.get(txHashBuf, 1).toHex())
    //     txOutMap2
    //       .get(txHashBuf, 2)
    //       .toHex()
    //       .should.equal(txOutMap.get(txHashBuf, 2).toHex())
    //   })
    // })

    // group('#set',  () {
    //   it('should set a txOut to the txOutMap',  () {
    //     var txOutMap = new TxOutMap().set(txHashBuf, 0, txOut)
    //     should.exist(txOutMap.map.get(label))
    //   })
    // })

    // group('#get',  () {
    //   it('should get a txOut',  () {
    //     var txOutMap = new TxOutMap().fromObject({ map: map })
    //     txOutMap
    //       .get(txHashBuf, 0)
    //       .toHex()
    //       .should.equal(txOut.toHex())
    //   })
    // })

    // group('#setTx',  () {
    //   it('should set all outputs from a tx',  () {
    //     var txOutMap = new TxOutMap().setTx(tx)
    //     var txHashBuf = tx.hash()
    //     var txOut = tx.txOuts[0]
    //     txOutMap
    //       .get(txHashBuf, 0)
    //       .toHex()
    //       .should.equal(txOut.toHex())
    //   })
    // })
  });
}
