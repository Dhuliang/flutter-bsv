import 'package:bsv/src/bip32.dart';
import 'package:bsv/src/bip39.dart';
import 'package:bsv/src/tx_out_map.dart';
import 'package:bsv/src/tx_verifier.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/src/address.dart';
import 'package:bsv/src/bn.dart';
import 'package:bsv/src/key_pair.dart';
import 'package:bsv/src/script.dart';
import 'package:bsv/src/tx.dart';
import 'package:bsv/src/tx_builder.dart';

void main() {
  test('adds one to input values', () {
    // 9-1 test
    // pig evidence box tired immense broom erase doctor mix because misery rotate
    // addr mz9HqCUkLKMkpJGVfyKEzBM1oCxAVZSuVE

    var mnemonic =
        'pig evidence box tired immense broom erase doctor mix because misery rotate';
    // '17axWVqFkYpcQsY3aDuk99njgzeJzC2siD';

    // 内网 mmTHakg5nSSY9p38EZ7nb1z8zV1rii3YbS

    // 9-1 test
    var rawtx =
        '020000000137d8191f94084acbc845995f16447a303a54022f6e19adbc55fa9e67cc6192390000000000ffffffff0440420f00000000001976a914cc518c21184d0a37203fcec6ce35396ffe86dc3488ac000000000000000014006a11506179416464726573735f353035333133b2074e05000000001976a91494c34853303be43a2d2eaba83d3add5617417b9f88ac00000000000000000c006a09446f7457616c6c657400000000';

    // TxBuilder()

    // var resulttx =
    //     '0200000001ac3fbf87b7d029a1c090498e1a735d644224690e5618378670dfd147ccd7c48e030000006b483045022100f9a99532dbdde8db07e37b54c83842b8a376f431eada4f74a0e51e5d18f1d2f9022074440ea9e339fd606b29c8ce09979d5f0afd2cde26b69ef93160d004aa8518ca412103d68ac4291efb214c3681f562ef00aef2be490f0a18cedf5171617a41bb052540ffffffff04a0860100000000001976a914411f310d201221fec3dfad567ba6860aa1c9d74e88ac000000000000000012006a0f506179416464726573735f323035392cdfb104000000001976a91415d8725a1ba730188f2786632c0344a56f33d70288ac00000000000000000c006a09446f7457616c6c657400000000';

    // 3045022100a686793567e9858ee85055e142b6ddcde86f173fe4107daf295d1611d2b25fd70220755a4c9820f766b7409915a1a2e5bc341e57359f4c2304779596779f675b3872

    // var signParams = [
    //   {
    //     "index": 0,
    //     "seed": "pro_wallet_BSV_5e1ac280-e811-4e7c-9a84-5c36e7af3fd6",
    //     "amount": 99998830,
    //     "script_hex": "76a9142b83b87827d263dcc7cab4ffb22c4477fba8a74088ac",
    //     "address_index": 25,
    //     "is_change": true,
    //     "appid": "test_bsv_coin_regular",
    //     "ownerid": null,
    //     "hash_type": 1,
    //     "unlocking_script_hexs": [
    //       "",
    //       "210276620b24faff9bf9652bc4d7c85f106bd2d561c95ce3c1ff4fd6064d4d00677e"
    //     ],
    //   }
    // ];

    // var signParams = [
    //   {
    //     "address_index": 37,
    //     "amount": 78765868,
    //     "appid": "test_bsv_coin_regular",
    //     "hash_type": 1,
    //     "index": 0,
    //     "is_change": true,
    //     "ownerid": null,
    //     "script_hex": "76a91415d8725a1ba730188f2786632c0344a56f33d70288ac",
    //     "seed": "pro_wallet_BSV_4b517956-abd9-4b86-a359-12b0caa172c5",
    //     "unlocking_script_hexs": [
    //       "",
    //       "210332649ee8b87a66be7c87c366b3b70b2671acaf684f4a47f9a7368c510c506073"
    //     ],
    //   }
    // ];

    var signParams = [
      {
        "address_index": 0,
        "amount": 90000000,
        "appid": "test_bsv_coin_regular",
        "hash_type": 1,
        "index": 0,
        "is_change": false,
        "ownerid": null,
        "script_hex": "76a914552be191569c260fddec1c56aeeaba52c946d6a288ac",
        "seed": "pro_wallet_BSV_6b62b1a8-6f2f-43b7-bd67-1be027ddb94b",
        "unlocking_script_hexs": [
          "",
          "210381e600130a675eae6250d32be3ff1386adbd5b7d51ec8c472e65354c362bceb5"
        ],
      }
    ];

    var tx = Tx.fromHex(rawtx);
    // tx.txIns[0].script.toAsmString();
    // tx.sign()

    // TxBuilder(tx: tx).signTxIn

    // print(tx.txIns![0].txHashBuf!.toHex());
    // print(Sig.SIGHASH_FORKID | Sig.SIGHASH_ALL);

    var buf = Bip39.fromString(mnemonic).toSeed();
    var bip32 = Bip32.Regtest().fromSeed(buf!);
    // var bip32 = Bip32.Mainnet().fromSeed(buf);
    // print(bip32.toString());

    var realHdPriv = bip32.derive("m/44'/0'/0'");
    // print(realHdPriv);

    signParams.forEach((Map<String, dynamic> param) {
      var tmpPriv_0 = realHdPriv.deriveChild(param['is_change'] ? 1 : 0);
      // print(tmpPriv_0.toString());
      // print(tmpPriv_0.toPublic().toString());
      var signPriv = tmpPriv_0.deriveChild(param['address_index'] as int);
      // print(signPriv.toString());
      // print(signPriv.toPublic().toString());

      var keyPair = KeyPair.fromPrivKey(signPriv.privKey!);
      Address.Regtest().fromPrivKey(signPriv.privKey!).toTxOutScript();

      // var subscript = Script.fromHex(
      //   (param['unlocking_script_hexs'] as List<String>).join(''),
      // );

      var subscript = Script.fromHex(param['script_hex'] as String);

      // var scrip = Script.fromHex(param['script_hex']);

      var pubKeySize = signPriv.pubKey.toString().length.toRadixString(16);
      var script = '$pubKeySize 0x${signPriv.pubKey.toString()}';

      var sig1 = tx.sign(
        keyPair: keyPair,
        nIn: param['index'] as int?,
        subScript: subscript,
        valueBn: BigIntX.fromNum(param['amount'] as num),
      );

      //  var sig1 = tx.sign(keyPair, param['index'], subscript, Bn(param['amount']));

      print('sig1=============================');
      var sigStr = sig1.toString();
      print(sigStr);
      print('sig1=============================');

      var scriptFinal =
          (signParams[0]['unlocking_script_hexs'] as List<String>).join(script);

      print(scriptFinal);

      // tx.sign(key)
      // tx2.signInput(
      //   param.index,
      //   signPriv.privateKey,
      //   sighashType:
      //       bsv.SighashType.SIGHASH_ALL | bsv.SighashType.SIGHASH_FORKID,
      // );
    });

    var hexStr = tx.toHex();
    print(hexStr);
  });

  test('a', () {
    var a1 = Script.fromHex(
        '483045022100db8b22ca68efdd7d38096170d62f4aa0c9079999e0da692b56bad5483b93c81c02206ed69a406d1e81c1c5fd8856e70fcf7d986d01489741a59ab26f57100035031e412103d5985e0259fa3937942c78b2b72c2067599d8090716ee09d5e3ca38def3ebaf8');
    print(a1.toString());
    var a2 = Script.fromHex(
        '47304402201f1fed92d6b014af0b080db1de58bccaa09941d736f7ed3972d7bd8d049e9a73022026acd0ab04337d5a0a960fff66633d21828df456a1142c1edb7a1d3a6abaa7074121030a93a634ab3e062b0f061b59d9bbc2fd2ba30878fdf382343e9e562ad7ddd62e');
    print(a2.toString());

    print('=============');

    var b1 = Script.fromHex(
        '48304502210082093f4aca4150889f3207d87a88f4c2884dc6c2ed54639dbca2c405b63a8cb50220475577bbb560c9b6f4bbe8c0f63bf0faef91c4cb86e0169135bf38f52934bd7841');
    print(b1.toString());
    var b2 = Script.fromHex(
        '483045022100aad942fae7111ecc5a170f4c9fcce9eb5327311b608aab82149fcb5178153b0002200bbe7eb66c5ce3c3570a557a10328f55cfd78582d0a147d6c25cdf25d24d270d41');
    print(b2.toString());
    //    0x3045022100aad942fae7111ecc5a170f4c9fcce9eb5327311b608aab82149fcb5178153b0002200bbe7eb66c5ce3c3570a557a10328f55cfd78582d0a147d6c25cdf25d24d270d41
    //    0x3045022100db8b22ca68efdd7d38096170d62f4aa0c9079999e0da692b56bad5483b93c81c02206ed69a406d1e81c1c5fd8856e70fcf7d986d01489741a59ab26f57100035031e41 21 03d5985e0259fa3937942c78b2b72c2067599d8090716ee09d5e3ca38def3ebaf8
    // 72 0x3045022100db8b22ca68efdd7d38096170d62f4aa0c9079999e0da692b56bad5483b93c81c02206ed69a406d1e81c1c5fd8856e70fcf7d986d01489741a59ab26f57100035031e41 33 0x03d5985e0259fa3937942c78b2b72c2067599d8090716ee09d5e3ca38def3ebaf8
    // 71 0x304402201f1fed92d6b014af0b080db1de58bccaa09941d736f7ed3972d7bd8d049e9a73022026acd0ab04337d5a0a960fff66633d21828df456a1142c1edb7a1d3a6abaa70741 33 0x030a93a634ab3e062b0f061b59d9bbc2fd2ba30878fdf382343e9e562ad7ddd62e
    // =============
    // 72 0x304502210082093f4aca4150889f3207d87a88f4c2884dc6c2ed54639dbca2c405b63a8cb50220475577bbb560c9b6f4bbe8c0f63bf0faef91c4cb86e0169135bf38f52934bd7841
    // 72 0x3045022100aad942fae7111ecc5a170f4c9fcce9eb5327311b608aab82149fcb5178153b0002200bbe7eb66c5ce3c3570a557a10328f55cfd78582d0a147d6c25cdf25d24d270d41
  });

  test('b', () {
    var a1 = Script.fromString(
        '73 0x304502210082093f4aca4150889f3207d87a88f4c2884dc6c2ed54639dbca2c405b63a8cb50220475577bbb560c9b6f4bbe8c0f63bf0faef91c4cb86e0169135bf38f52934bd7841 21 03d5985e0259fa3937942c78b2b72c2067599d8090716ee09d5e3ca38def3ebaf8');
    print(a1.toString());
    print(a1.toAsmString());
    // var a2 = Script.fromHex(
    //     '47304402201f1fed92d6b014af0b080db1de58bccaa09941d736f7ed3972d7bd8d049e9a73022026acd0ab04337d5a0a960fff66633d21828df456a1142c1edb7a1d3a6abaa7074121030a93a634ab3e062b0f061b59d9bbc2fd2ba30878fdf382343e9e562ad7ddd62e');
    // print(a2.toString());

    // print('=============');

    // var b1 = Script.fromHex(
    //     '48304502210082093f4aca4150889f3207d87a88f4c2884dc6c2ed54639dbca2c405b63a8cb50220475577bbb560c9b6f4bbe8c0f63bf0faef91c4cb86e0169135bf38f52934bd7841');
    // print(b1.toString());
    // var b2 = Script.fromHex(
    //     '483045022100aad942fae7111ecc5a170f4c9fcce9eb5327311b608aab82149fcb5178153b0002200bbe7eb66c5ce3c3570a557a10328f55cfd78582d0a147d6c25cdf25d24d270d41');
    // print(b2.toString());
  });

  test('c', () {
    var a1 = Script.fromString(
        '72 0x304502210082093f4aca4150889f3207d87a88f4c2884dc6c2ed54639dbca2c405b63a8cb50220475577bbb560c9b6f4bbe8c0f63bf0faef91c4cb86e0169135bf38f52934bd78412103d5985e0259fa3937942c78b2b72c2067599d8090716ee09d5e3ca38def3ebaf8');
    print(a1.toString());
    print(a1.toAsmString());
    // var a2 = Script.fromHex(
    //     '47304402201f1fed92d6b014af0b080db1de58bccaa09941d736f7ed3972d7bd8d049e9a73022026acd0ab04337d5a0a960fff66633d21828df456a1142c1edb7a1d3a6abaa7074121030a93a634ab3e062b0f061b59d9bbc2fd2ba30878fdf382343e9e562ad7ddd62e');
    // print(a2.toString());

    // print('=============');

    // var b1 = Script.fromHex(
    //     '48304502210082093f4aca4150889f3207d87a88f4c2884dc6c2ed54639dbca2c405b63a8cb50220475577bbb560c9b6f4bbe8c0f63bf0faef91c4cb86e0169135bf38f52934bd7841');
    // print(b1.toString());
    // var b2 = Script.fromHex(
    //     '483045022100aad942fae7111ecc5a170f4c9fcce9eb5327311b608aab82149fcb5178153b0002200bbe7eb66c5ce3c3570a557a10328f55cfd78582d0a147d6c25cdf25d24d270d41');
    // print(b2.toString());
  });

  test('mock signtx', () async {
    // 9-1 test
    // pig evidence box tired immense broom erase doctor mix because misery rotate
    // addr momr4rDTY3JeCD5nfBqdhktcKCLsNr3Hto
    // amount 0.01

    var mnemonic =
        'pig evidence box tired immense broom erase doctor mix because misery rotate';

    // 9-1 test
    var rawtx =
        '020000000279853ac0dfe74bb936785b1263269ba0c28b354a063fcf542b8345dac9a4bf910000000000ffffffff79853ac0dfe74bb936785b1263269ba0c28b354a063fcf542b8345dac9a4bf910200000000ffffffff0440420f00000000001976a9145a920c0eeaef3981e9f4f1221695ba377b39cb0b88ac000000000000000014006a11506179416464726573735f35303533313300000000000000000c006a09446f7457616c6c6574d7064e05000000001976a9144917bc585597620fdd5371c497f492044f3e53ab88ac00000000';

    var signParams = [
      {
        "address_index": 1,
        "amount": 1000000,
        "appid": "test_bsv_coin_regular",
        "hash_type": 1,
        "index": 0,
        "is_change": false,
        "ownerid": null,
        "script_hex": "76a914cc518c21184d0a37203fcec6ce35396ffe86dc3488ac",
        "seed": "pro_wallet_BSV_6b62b1a8-6f2f-43b7-bd67-1be027ddb94b",
        "unlocking_script_hexs": [
          "",
          "2103d5985e0259fa3937942c78b2b72c2067599d8090716ee09d5e3ca38def3ebaf8"
        ],
      },
      {
        "address_index": 0,
        "amount": 88999858,
        "appid": "test_bsv_coin_regular",
        "hash_type": 1,
        "index": 1,
        "is_change": true,
        "ownerid": null,
        "script_hex": "76a91494c34853303be43a2d2eaba83d3add5617417b9f88ac",
        "seed": "pro_wallet_BSV_6b62b1a8-6f2f-43b7-bd67-1be027ddb94b",
        "unlocking_script_hexs": [
          "",
          "21030a93a634ab3e062b0f061b59d9bbc2fd2ba30878fdf382343e9e562ad7ddd62e"
        ],
      }
    ];

    var tx = Tx.fromHex(rawtx);
    var txBuilder = TxBuilder(tx: tx);

    // print(tx.txIns[0].txHashBuf.toHex());

    var buf = Bip39.fromString(mnemonic).toSeed();
    var bip32 = Bip32.Regtest().fromSeed(buf!);

    var realHdPriv = bip32.derive("m/44'/0'/0'");

    signParams.forEach((Map<String, dynamic> param) {
      var tmpPriv_0 = realHdPriv.deriveChild(param['is_change']! ? 1 : 0);
      print(tmpPriv_0.toString());
      print(tmpPriv_0.toPublic().toString());
      var signPriv = tmpPriv_0.deriveChild(param['address_index'] as int);
      print(signPriv.toString());
      print(signPriv.toPublic().toString());

      var keyPair = KeyPair.fromPrivKey(signPriv.privKey!);
      Address.Regtest().fromPrivKey(signPriv.privKey!).toTxOutScript();

      var subscript = Script.fromHex(param['script_hex'] as String);
      print(Address.Regtest().fromPubKey(keyPair.pubKey!).toString());
      // print(Address.Regtest().fromPubKey(keyPair.pubKey).toHex());
      txBuilder.getSigWithUnlockingScriptHexs(
        keyPair: keyPair,
        nIn: param['index'] as int,
        subScript: subscript,
        unlockingScriptHexs: param['unlocking_script_hexs'] as List<String>,
        valueBn: BigIntX.fromNum(param['amount'] as num),
      );
    });

    var hexStr = txBuilder.tx.toHex();
    print(hexStr);

    var txOutMap = new TxOutMap().setTx(txBuilder.tx);
    // var txOutMap = new TxOutMap().setTx(tx);
    var r = await TxVerifier.staticVerify(
      tx: txBuilder.tx,
      txOutMap: txOutMap,
    );
    print(r);
  });

  test('example bip32.dart', () {
    var mnemonic =
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about";
    var bip39 = Bip39.fromString(mnemonic);
    print(bip39.mnemonic);
    print(Bip39.fromRandom(32 * 8));
  });
}
