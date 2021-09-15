import 'dart:typed_data';

import 'package:bsv/src/block.dart';
import 'package:bsv/src/block_header.dart';
import 'package:bsv/src/br.dart';
import 'package:bsv/src/bw.dart';
import 'package:bsv/src/tx.dart';
import 'package:bsv/src/var_int.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/src/extentsions/list.dart';

import 'vectors/largesttxblock.dart';

void main() {
  group('Block', () {
    // var txidhex = '8c9aa966d35bfeaf031409e0001b90ccdafd8d859799eb945a3c515b8260bcf2'
    var txhex =
        '01000000029e8d016a7b0dc49a325922d05da1f916d1e4d4f0cb840c9727f3d22ce8d1363f000000008c493046022100e9318720bee5425378b4763b0427158b1051eec8b08442ce3fbfbf7b30202a44022100d4172239ebd701dae2fbaaccd9f038e7ca166707333427e3fb2a2865b19a7f27014104510c67f46d2cbb29476d1f0b794be4cb549ea59ab9cc1e731969a7bf5be95f7ad5e7f904e5ccf50a9dc1714df00fbeb794aa27aaff33260c1032d931a75c56f2ffffffffa3195e7a1ab665473ff717814f6881485dc8759bebe97e31c301ffe7933a656f020000008b48304502201c282f35f3e02a1f32d2089265ad4b561f07ea3c288169dedcf2f785e6065efa022100e8db18aadacb382eed13ee04708f00ba0a9c40e3b21cf91da8859d0f7d99e0c50141042b409e1ebbb43875be5edde9c452c82c01e3903d38fa4fd89f3887a52cb8aea9dc8aec7e2c9d5b3609c03eb16259a2537135a1bf0f9c5fbbcbdbaf83ba402442ffffffff02206b1000000000001976a91420bb5c3bfaef0231dc05190e7f1c8e22e098991e88acf0ca0100000000001976a9149e3e2d23973a04ec1b02be97c30ab9f2f27c3b2c88ac00000000';
    var txbuf = hex.decode(txhex);
    var magicNum = 0xd9b4bef9;
    var blockSize = 50;
    var bhhex =
        '0100000005050505050505050505050505050505050505050505050505050505050505050909090909090909090909090909090909090909090909090909090909090909020000000300000004000000';
    var bhbuf = hex.decode(bhhex);
    var bh = new BlockHeader.fromBuffer(bhbuf);
    var txsVi = VarInt.fromNumber(1);
    var txs = [new Tx().fromBuffer(txbuf)];
    var block = new Block(
        // magicNum: magicNum,
        // blockSize: blockSize,
        blockHeader: bh,
        txsVi: txsVi,
        txs: txs);
    var blockHex =
        '01000000050505050505050505050505050505050505050505050505050505050505050509090909090909090909090909090909090909090909090909090909090909090200000003000000040000000101000000029e8d016a7b0dc49a325922d05da1f916d1e4d4f0cb840c9727f3d22ce8d1363f000000008c493046022100e9318720bee5425378b4763b0427158b1051eec8b08442ce3fbfbf7b30202a44022100d4172239ebd701dae2fbaaccd9f038e7ca166707333427e3fb2a2865b19a7f27014104510c67f46d2cbb29476d1f0b794be4cb549ea59ab9cc1e731969a7bf5be95f7ad5e7f904e5ccf50a9dc1714df00fbeb794aa27aaff33260c1032d931a75c56f2ffffffffa3195e7a1ab665473ff717814f6881485dc8759bebe97e31c301ffe7933a656f020000008b48304502201c282f35f3e02a1f32d2089265ad4b561f07ea3c288169dedcf2f785e6065efa022100e8db18aadacb382eed13ee04708f00ba0a9c40e3b21cf91da8859d0f7d99e0c50141042b409e1ebbb43875be5edde9c452c82c01e3903d38fa4fd89f3887a52cb8aea9dc8aec7e2c9d5b3609c03eb16259a2537135a1bf0f9c5fbbcbdbaf83ba402442ffffffff02206b1000000000001976a91420bb5c3bfaef0231dc05190e7f1c8e22e098991e88acf0ca0100000000001976a9149e3e2d23973a04ec1b02be97c30ab9f2f27c3b2c88ac00000000';
    var blockBuf = hex.decode(blockHex);

    var genesishex =
        '0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c0101000000010000000000000000000000000000000000000000000000000000000000000000ffffffff4d04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73ffffffff0100f2052a01000000434104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac00000000';
    var genesisbuf = hex.decode(genesishex);
    var genesisidhex =
        '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f';

    // test('should make a new block', () {
    //   var block = new Block()
    //   should.exist(block)
    //   block = new Block()
    //   should.exist(block)
    // })

    group('#fromObject', () {
      test('should set these known values', () {
        var block = new Block(
            // magicNum: magicNum,
            // blockSize: blockSize,
            blockHeader: bh,
            txsVi: txsVi,
            txs: txs);
        // should.exist(block.magicNum)
        // should.exist(block.blockSize)
        // ignore: unnecessary_null_comparison
        expect(block.blockHeader != null, true);
        // ignore: unnecessary_null_comparison
        expect(block.txsVi != null, true);
        // ignore: unnecessary_null_comparison
        expect(block.txs != null, true);
      });
    });

    group('#fromJSON', () {
      test('should set these known values', () {
        var block = new Block.fromJSON({
          "magicNum": magicNum,
          "blockSize": blockSize,
          "blockHeader": bh.toJSON(),
          "txsVi": txsVi.toJSON(),
          "txs": [txs[0].toJSON()]
        });
        // ignore: unnecessary_null_comparison
        expect(block.blockHeader != null, true);
        // ignore: unnecessary_null_comparison
        expect(block.txsVi != null, true);
        // ignore: unnecessary_null_comparison
        expect(block.txs != null, true);
      });
    });

    group('#toJSON', () {
      test('should recover these known values', () {
        var json = block.toJSON();
        expect(json['blockHeader'] != null, true);
        expect(json['txsVi'] != null, true);
        expect(json['txs'] != null, true);
      });
    });

    group('#fromHex', () {
      test('should make a block from this known hex', () {
        var block = new Block.fromHex(blockHex);
        expect(block.toBuffer().toHex(), blockHex);
      });
    });

    group('#fromBuffer', () {
      test('should make a block from this known buffer', () {
        var block = new Block.fromBuffer(blockBuf);
        expect(block.txs.length, 1);
        expect(block.toBuffer().toHex(), blockHex);
      });
    });

    group('#fromBr', () {
      test('should make a block from this known buffer', () {
        var block = new Block.fromBr(new Br(buf: blockBuf as Uint8List?));
        expect(block.toBuffer().toHex(), blockHex);
      });
    });

    group('#toHex', () {
      test('should recover a block from this known hex', () {
        var block = new Block.fromHex(blockHex);
        expect(block.toBuffer().toHex(), blockHex);
      });
    });

    group('#toBuffer', () {
      test('should recover a block from this known buffer', () {
        var block = new Block.fromBuffer(blockBuf);
        expect(block.toBuffer().toHex(), blockHex);
      });
    });

    group('#toBw', () {
      test('should recover a block from this known buffer', () {
        var block = new Block.fromBuffer(blockBuf);

        expect(block.toBw().toBuffer().toHex(), blockHex);

        var bw = new Bw();
        block.toBw(bw);

        expect(block.toBuffer().toHex(), blockHex);
      });
    });

    group('#hash', () {
      test('should return the correct hash of the genesis block', () {
        var block = new Block.fromBuffer(genesisbuf);
        // var blockhash = hex.decode(
        //   Array.apply([], hex.decode(genesisidhex)).reverse()
        // );
        // var blockhash = hex.decode(
        var blockhash = hex.decode(genesisidhex).reversed.toList();

        expect(block.hash().data.toHex(), blockhash.toHex());
      });
    });

    group('#asyncHash', () {
      // test('should return the correct hash of the genesis block', async () {
      //   var block = new Block.fromBuffer(genesisbuf)
      //   var hash = await block.asyncHash()
      //   var genesishashhex = new Br(hex.decode(genesisidhex, 'hex'))
      //     .readReverse()
      //     .toString('hex')
      //   hash.toString('hex').should.equal(genesishashhex)
      // })

      test('should return the correct hash of block containing the largest tx',
          () {
        // this.timeout(10000)
        var block = new Block.fromHex(largesttxblockvector['blockhex']!);
        var buf = block.toBuffer();
        block = Block.fromBuffer(buf);
        var hash = block.hash();
        var blockidhex = largesttxblockvector['blockidhex']!;
        var blockhashBuf =
            new Br(buf: hex.decode(blockidhex) as Uint8List).readReverse();
        var blockhashhex = blockhashBuf.toHex();
        expect(hash.toHex, blockhashhex);
      });
    });

    group('#id', () {
      test('should return the correct id of the genesis block', () {
        var block = new Block.fromBuffer(genesisbuf);
        expect(block.id(), genesisidhex);
      });

      test('should return the correct id of block containing the largest tx',
          () {
        var block = new Block.fromHex(largesttxblockvector['blockhex']!);
        expect(block.id(), largesttxblockvector['blockidhex']);
      });
    });

    // group('#asyncId', () {
    //   test('should return the correct id of the genesis block', async () {
    //     var block = new Block.fromBuffer(genesisbuf)
    //     var id = await block.asyncId()
    //     id.should.equal(genesisidhex)
    //   })

    //   test('should return the correct id of block containing the largest tx', async () {
    //     var block = new Block.fromHex(largesttxblockvector.blockhex)
    //     var id = await block.asyncId()
    //     id.should.equal(largesttxblockvector.blockidhex)
    //   })
    // })

    group('#verifyMerkleRoot', () {
      test(
          'should verify the merkle root of this known block with one tx (in addition to the coinbase tx)',
          () {
        var block = new Block.fromHex(largesttxblockvector['blockhex']!);
        expect(block.verifyMerkleRoot(), 0);
      });
    });

    // group('@iterateTxs', () {
    //   test('should make a block from this known buffer', () {
    //     var txs = Block.iterateTxs(blockBuf)
    //     txs.txsNum.should.equal(1)
    //     var count = 0
    //     for (var tx of txs) {
    //       ;(tx instanceof Tx).should.equal(true)
    //       count++
    //     }
    //     count.should.equal(1)
    //   })
    // })
  });
}
