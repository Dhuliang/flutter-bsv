import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:bsv/address.dart';
import 'package:bsv/bn.dart';
import 'package:bsv/interp.dart';
import 'package:bsv/key_pair.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/script.dart';
import 'package:bsv/sig.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_builder.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/tx_out_map.dart';
import 'package:bsv/tx_verifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  test(
      // 'should sign and verify a large number of inputs and outputs with converting to/from JSON',
      'xxx', () async {
    var nIns = 50;
    var nOuts = 50;

    // make change address
    var privKey = new PrivKey().fromBn(BigIntX.fromNum(100));
    var keyPair = new KeyPair().fromPrivKey(privKey);
    var changeaddr = new Address().fromPubKey(keyPair.pubKey);

    // make addresses to send from (and to)
    List<PrivKey> privKeys = [];
    List<KeyPair> keyPairs = [];
    List<Address> addrs = [];
    for (var i = 0; i < nIns; i++) {
      privKeys.add(new PrivKey().fromBn(BigIntX.fromNum(i + 1)));
      keyPairs.add(new KeyPair().fromPrivKey(privKeys[i]));
      addrs.add(new Address().fromPubKey(keyPairs[i].pubKey));
    }

    // txOuts that we are spending
    var scriptouts = [];
    var txOuts = [];
    for (var i = 0; i < nIns; i++) {
      scriptouts.add(new Script().fromString('OP_DUP OP_HASH160 20 0x' +
          addrs[i].hashBuf.toHex() +
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

    expect(txb.tx.txIns.length, nIns);
    expect(txb.tx.txOuts.length, nOuts + 1);

    // before signing, convert to/from JSON, simulating real-world walvar use-case
    txb = TxBuilder().fromJSON(txb.toJSON());

    // partially sign - deliberately resulting in invalid tx
    txb.signWithKeyPairs([keyPairs[0], keyPairs[1], keyPairs[2]]);

    // var result =
    //     await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
    // print(txb.txOuts.length);
    // print(txb.txIns.length);
    // // transaction not fully signed yet, so should be invalid
    // expect(result, false);

    // fully sign
    txb.signWithKeyPairs(keyPairs);

    print(txb.txOuts.length);
    print(txb.txIns.length);
    var result =
        await TxVerifier.staticVerify(tx: txb.tx, txOutMap: txb.uTxOutMap);
    expect(result, true);
  });
}
