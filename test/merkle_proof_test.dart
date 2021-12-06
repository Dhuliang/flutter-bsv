import 'dart:convert';

import 'package:bsv/src/block_header.dart';
import 'package:bsv/src/br.dart';
import 'package:bsv/src/hash.dart';
import 'package:bsv/src/merkle_proof.dart';
import 'package:bsv/src/tx.dart';
import 'package:bsv/src/util.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/src/extentsions/list.dart';

void main() {
  group('MerkleProof', () {
    // test('should satisfy this basic API',  () {
    //   var merkleProof = new MerkleProof();
    //   should.exist(merkleProof)
    // })

    group('#setFlagsHasTx', () {
      test('should get and set has tx', () {
        var merkleProof = new MerkleProof();
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');
        merkleProof.setFlagsHasTx(true);
        expect(merkleProof.getFlagsHasTx(), true);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');
      });
    });

    group('#setFlagsTargetType', () {
      test('should get and set target type', () {
        var merkleProof = new MerkleProof();
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');

        merkleProof.setFlagsTargetType('hash');
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');

        merkleProof.setFlagsTargetType('header');
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'header');

        merkleProof.setFlagsTargetType('merkleRoot');
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'merkleRoot');
      });
    });

    group('#setFlagsTargetType', () {
      test('should get and set target type', () {
        var merkleProof = new MerkleProof();
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');

        merkleProof.setFlagsProofType('branch');
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');

        merkleProof.setFlagsProofType('tree');
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'tree');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');
      });
    });

    group('#setFlagsComposite', () {
      test('should get and set target type', () {
        var merkleProof = new MerkleProof();
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');

        merkleProof.setFlagsComposite(true);
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), true);
        expect(merkleProof.getFlagsTargetType(), 'hash');

        merkleProof.setFlagsComposite(false);
        expect(merkleProof.getFlagsHasTx(), false);
        expect(merkleProof.getFlagsProofType(), 'branch');
        expect(merkleProof.getFlagsComposite(), false);
        expect(merkleProof.getFlagsTargetType(), 'hash');
      });
    });

    group('@fromBuffer', () {
      test('should deserialize and serialize this test vector', () {
        var merkleProofHex =
            '000cef65a4611570303539143dabd6aa64dbd0f41ed89074406dc0e7cd251cf1efff69f17b44cfe9c2a23285168fe05084e1254daa5305311ed8cd95b19ea6b0ed7505008e66d81026ddb2dae0bd88082632790fc6921b299ca798088bef5325a607efb9004d104f378654a25e35dbd6a539505a1e3ddbba7f92420414387bb5b12fc1c10f00472581a20a043cee55edee1c65dd6677e09903f22992062d8fd4b8d55de7b060006fcc978b3f999a3dbb85a6ae55edc06dd9a30855a030b450206c3646dadbd8c000423ab0273c2572880cdc0030034c72ec300ec9dd7bbc7d3f948a9d41b3621e39';
        var merkleProof = MerkleProof.fromHex(merkleProofHex);
        expect(merkleProof.toHex(), merkleProofHex);
      });
    });

    group('@fromJSON', () {
      test('should deserialize and serialize this test vector', () {
        var merkleProofJSONStr = """{
          "index": 12,
          "txOrId": "ffeff11c25cde7c06d407490d81ef4d0db64aad6ab3d14393530701561a465ef",
          "target": "75edb0a69eb195cdd81e310553aa4d25e18450e08f168532a2c2e9cf447bf169",
          "nodes": [
            "b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e",
            "0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d",
            "60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547",
            "c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f",
            "391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42"
          ]
        }""";
        var merkleProofJSON = jsonDecode(merkleProofJSONStr);
        var merkleProof = MerkleProof().fromJSON(merkleProofJSON);
        var merkleProofJSON2 = merkleProof.toJSON();
        expect(merkleProofJSON['index'], merkleProofJSON2['index']);
        expect(merkleProofJSON['txOrId'], merkleProofJSON2['txOrId']);
        expect(merkleProofJSON['target'], merkleProofJSON2['target']);
        expect(merkleProofJSON['nodes'][0], merkleProofJSON2['nodes'][0]);
        expect(merkleProofJSON['nodes'][1], merkleProofJSON2['nodes'][1]);
        expect(merkleProofJSON['nodes'][2], merkleProofJSON2['nodes'][2]);
        expect(merkleProofJSON['nodes'][3], merkleProofJSON2['nodes'][3]);
        expect(merkleProofJSON['nodes'][4], merkleProofJSON2['nodes'][4]);
      });

      test('should make a round trip through buffers and back to json', () {
        var merkleProofJSONStr = """{
          "index": 12,
          "txOrId": "ffeff11c25cde7c06d407490d81ef4d0db64aad6ab3d14393530701561a465ef",
          "target": "75edb0a69eb195cdd81e310553aa4d25e18450e08f168532a2c2e9cf447bf169",
          "nodes": [
            "b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e",
            "0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d",
            "60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547",
            "c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f",
            "391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42"
          ]
        }""";
        var merkleProofJSON = jsonDecode(merkleProofJSONStr);
        var merkleProof = MerkleProof().fromJSON(merkleProofJSON);
        merkleProof = merkleProof.fromBuffer(merkleProof.toBuffer());
        var merkleProofJSON2 = merkleProof.toJSON();
        expect(merkleProofJSON['index'], merkleProofJSON2['index']);
        expect(merkleProofJSON['txOrId'], merkleProofJSON2['txOrId']);
        expect(merkleProofJSON['target'], merkleProofJSON2['target']);
        expect(merkleProofJSON['nodes'][0], merkleProofJSON2['nodes'][0]);
        expect(merkleProofJSON['nodes'][1], merkleProofJSON2['nodes'][1]);
        expect(merkleProofJSON['nodes'][2], merkleProofJSON2['nodes'][2]);
        expect(merkleProofJSON['nodes'][3], merkleProofJSON2['nodes'][3]);
        expect(merkleProofJSON['nodes'][4], merkleProofJSON2['nodes'][4]);
      });
    });

    group('#verify', () {
      test('should verify this test vector containing tx and blockheader', () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'header',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": txHex,
          "target": blockHeaderHex,
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test(
          'should verify this binary test vector containing tx and blockheader',
          () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'header',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": txHex,
          "target": blockHeaderHex,
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        merkleProof = MerkleProof.fromBuffer(merkleProof.toBuffer());
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test('should verify this test vector containing tx id and blockheader',
          () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'header',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": tx.id(),
          "target": blockHeaderHex,
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test(
          'should verify this binary test vector containing tx id and blockheader',
          () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'header',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": tx.id(),
          "target": blockHeaderHex,
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        merkleProof = MerkleProof.fromBuffer(merkleProof.toBuffer());
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test('should verify this test vector containing tx and merkle root', () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'merkleRoot',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": txHex,
          "target": new Br(buf: blockHeader.merkleRootBuf.asUint8List())
              .readReverse()
              .toHex(),
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test(
          'should verify this binary test vector containing tx and merkle root',
          () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'merkleRoot',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": txHex,
          "target": new Br(buf: blockHeader.merkleRootBuf.asUint8List())
              .readReverse()
              .toHex(),
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        merkleProof = MerkleProof.fromBuffer(merkleProof.toBuffer());
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test('should verify this test vector containing tx id and merkle root',
          () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'merkleRoot',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": tx.id(),
          "target": new Br(buf: blockHeader.merkleRootBuf.asUint8List())
              .readReverse()
              .toHex(),
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test(
          'should verify this binary test vector containing tx id and merkle root',
          () {
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'merkleRoot',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": tx.id(),
          "target": new Br(buf: blockHeader.merkleRootBuf.asUint8List())
              .readReverse()
              .toHex(),
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        merkleProof = MerkleProof.fromBuffer(merkleProof.toBuffer());
        expect(merkleProof.verify(blockHeader, tx), true);
      });

      test('should (not) verify this test vector containing tx id and hash',
          () {
        // there is no reason to use this method, so we disable it. always deliver
        // the merkle root.
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'hash',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": tx.id(),
          "target": '00' * (32), // fake block hash
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        expect(merkleProof.verify(blockHeader, tx), false);
      });

      test(
          'should (not) verify this binary test vector containing tx id and hash',
          () {
        // there is no reason to use this method, so we disable it. always deliver
        // the merkle root.
        var txHex =
            '0200000001080e8558d7af4763fef68042ef1e723d521948a0fb465237d5fb21fafb61f0580000000049483045022100fb4c94dc29cfa7423775443f8d8bb49b5814dcf709553345fcfad240efce22920220558569f97acd0d2b7bbe1954d570b9629ddf5491d9341867d7c41a8e6ee4ed2a41feffffff0200e1f505000000001976a914e296a740f5d9ecc22e0a74f9799f54ec44ee215a88ac80dc4a1f000000001976a914c993ce218b406cb71c60bad1f2be9469d91593cd88ac85020000';
        var blockHeaderHex =
            '000000208e33a53195acad0ab42ddbdbe3e4d9ca081332e5b01a62e340dbd8167d1a787b702f61bb913ac2063e0f2aed6d933d3386234da5c8eb9e30e498efd25fb7cb96fff12c60ffff7f2001000000';
        var tx = Tx.fromHex(txHex);
        var blockHeader = BlockHeader.fromHex(blockHeaderHex);
        var merkleProof = MerkleProof.fromJSON({
          "targetType": 'hash',
          "proofType": 'branch',
          "composite": false,
          "index": 12,
          "txOrId": tx.id(),
          "target": '00' * (32), // fake block hash
          "nodes": [
            'b9ef07a62553ef8b0898a79c291b92c60f7932260888bde0dab2dd2610d8668e',
            '0fc1c12fb1b57b38140442927fbadb3d1e5a5039a5d6db355ea25486374f104d',
            '60b0e75dd5b8d48f2d069229f20399e07766dd651ceeed55ee3c040aa2812547',
            'c0d8dbda46366c2050b430a05508a3d96dc0ed55aea685bb3d9a993f8b97cc6f',
            '391e62b3419d8a943f7dbc7bddc90e30ec724c033000dc0c8872253c27b03a42'
          ]
        });
        merkleProof = MerkleProof.fromBuffer(merkleProof.toBuffer());
        expect(merkleProof.verify(blockHeader, tx), false);
      });

      test(
          'should verify this uneven test vector containing tx id and merkleRoot',
          () {
        // there is no reason to use this method, so we disable it. always deliver
        // the merkle root.
        var txId =
            '75edb0a69eb195cdd81e310553aa4d25e18450e08f168532a2c2e9cf447bf169';
        var merkleRootId =
            '6c9d85bf51ebb0c474616fad91a115590e9a8316f21cab836dc949cfa267b0a7';

        var hash = Hash(
            data: Br(buf: hex.decode(txId).asUint8List())
                .readReverse()
                .asUint8List());

        var merkleRootBuf =
            new Br(buf: hex.decode(merkleRootId).asUint8List()).readReverse();

        var merkleProof = MerkleProof.fromJSON({
          "index": 2,
          "targetType": 'merkleRoot',
          "txOrId": txId,
          "target": merkleRootId,
          "nodes": [
            '*',
            '0afecafecafecafecafecafecafecafecafecafecafecafecafecafecafecafe',
            '1afecafecafecafecafecafecafecafecafecafecafecafecafecafecafecafe'
          ]
        });
        dynamic result =
            merkleProof.verificationErrorBuffer(merkleRootBuf, hash);

        expect(!Util.checkToBool(result), true);
      });

      test(
          'should verify this uneven binary test vector containing tx id and merkleRoot',
          () {
        // there is no reason to use this method, so we disable it. always deliver
        // the merkle root.
        var txId =
            '75edb0a69eb195cdd81e310553aa4d25e18450e08f168532a2c2e9cf447bf169';
        var merkleRootId =
            '6c9d85bf51ebb0c474616fad91a115590e9a8316f21cab836dc949cfa267b0a7';

        var hash = Hash(
            data: Br(buf: hex.decode(txId).asUint8List())
                .readReverse()
                .asUint8List());

        var merkleRootBuf =
            new Br(buf: hex.decode(merkleRootId).asUint8List()).readReverse();

        var merkleProof = MerkleProof.fromJSON({
          "index": 2,
          "targetType": 'merkleRoot',
          "txOrId": txId,
          "target": merkleRootId,
          "nodes": [
            '*',
            '0afecafecafecafecafecafecafecafecafecafecafecafecafecafecafecafe',
            '1afecafecafecafecafecafecafecafecafecafecafecafecafecafecafecafe'
          ]
        });

        merkleProof = MerkleProof.fromBuffer(merkleProof.toBuffer());

        dynamic result =
            merkleProof.verificationErrorBuffer(merkleRootBuf, hash);

        expect(!Util.checkToBool(result), true);
      });

      test('should calculate merkle root0', () {
        // there is no reason to use this method, so we disable it. always deliver
        // the merkle root.
        var txId =
            '75edb0a69eb195cdd81e310553aa4d25e18450e08f168532a2c2e9cf447bf169';
        var merkleRootId =
            '6c9d85bf51ebb0c474616fad91a115590e9a8316f21cab836dc949cfa267b0a7';

        var hash = Hash(
            data: Br(buf: hex.decode(txId).asUint8List())
                .readReverse()
                .asUint8List());

        var merkleProof = MerkleProof.fromJSON({
          "index": 2,
          "targetType": 'merkleRoot',
          "txOrId": txId,
          "target": merkleRootId,
          "nodes": [
            '*',
            '0afecafecafecafecafecafecafecafecafecafecafecafecafecafecafecafe',
            '1afecafecafecafecafecafecafecafecafecafecafecafecafecafecafecafe'
          ]
        });

        String merkleRoot = merkleProof.calculateMerkleRoot(hash);

        expect(merkleRoot, merkleRootId);
      });

      test('should calculate merkle root1', () {
        // there is no reason to use this method, so we disable it. always deliver
        // the merkle root.
        var txId =
            '8fbdc210a30749296e77b72dbff2065582ed13e10c92cac3dca3ec71457066c0';
        var merkleRootId =
            'e89889a3d17431126a2ed0532ce98815778a6f1e23caf0ee6a4513e44555952c';

        var hash = Hash(
            data: Br(buf: hex.decode(txId).asUint8List())
                .readReverse()
                .asUint8List());

        var merkleProof = MerkleProof.fromJSON({
          "index": 632,
          "targetType": 'merkleRoot',
          "txOrId": txId,
          "target": merkleRootId,
          "nodes": [
            "e57c0f7dde88c0185e62544c73246e03560ab2ac8625c996a608c9da71a4d130",
            "16c99343b8baac3dacf561fe633231cfb0c09983687cd4a00eaa9ce54b1984d7",
            "6ac61d8b94df3e2551ef3b64963b237421e4b567db15d17ed26a449ab4f669df",
            "150d674ba440e9da7879773623eef1d1968c42f1b44356c72834f2049ed2ba4b",
            "4869fee350abaad55c4b9b27e243274c451235e251aebbb8646a359760cb7ddb",
            "9c093eee173d65a9f793e5aa41ea593da0194f8f653d2b030579adaaa257244c",
            "5ade12c612f32b581160720478f63c42a21aa9faba49ff0bd266ecb2cc55bdbd",
            "d762835582cdb83ce854eb599e738011f76ff201665617885fd323c13229fda5",
            "4d5998e89b2b46238d63aa73dd02ec8239a1310be9fbaf8b29cc060520a07314",
            "10a00c3d94a581056d163fe3554e8339d5141a97b8dd59084174fde5ede4c1ba",
          ]
        });

        String merkleRoot = merkleProof.calculateMerkleRoot(hash);
        expect(merkleRoot, merkleRootId);
      });
    });
  });
}
