import 'package:bsv/block_header.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/hash.dart';
import 'package:bsv/merkle.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/var_int.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:convert/convert.dart';

// ignore: slash_for_doc_comments
/**
 * Block
 * =====
 *
 * A block, of course, is a collection of transactions. This class is somewhat
 * incompconste at the moment. In the future, it should support the ability to
 * check to see if a transaction is in a block (thanks to the magic of merkle
 * trees). You will probably never use Yours Bitcoin to create a block, since almost
 * everyone will use bitcoind for that. As such, the primary way to use this is
 * new Block().fromBuffer(buf), which will parse the block and prepare its insides
 * for you to inspect.
 */

class Block {
  static const MAX_BLOCK_SIZE = 1000000;

  BlockHeader blockHeader;
  VarInt txsVi;
  List<Tx> txs;

  Block({
    this.blockHeader,
    this.txsVi,
    this.txs,
  });

  factory Block.fromHex(String str) {
    return Block.fromHex(str);
  }

  Block fromHex(String str) {
    return this.fromBuffer(hex.decode(str));
  }

  factory Block.fromBuffer(List<int> buf) {
    return Block().fromBuffer(buf);
  }

  Block fromBuffer(List<int> buf) {
    return this.fromBr(Br(buf: buf.asUint8List()));
  }

  String toHex() {
    return this.toBuffer().toHex();
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }

  Block fromJSON(Map json) {
    List<Tx> txs = [];
    json['txs'].forEach((tx) {
      txs.add(new Tx().fromJSON(tx));
    });

    return Block(
      blockHeader: new BlockHeader().fromJSON(json['blockHeader']),
      txsVi: new VarInt().fromJSON(json['txsVi']),
      txs: txs,
    );
  }

  Map<String, dynamic> toJSON() {
    var txs = [];
    this.txs.forEach((tx) {
      txs.add(tx.toJSON());
    });
    return {
      "blockHeader": this.blockHeader.toJSON(),
      "txsVi": this.txsVi.toJSON(),
      "txs": txs
    };
  }

  Block fromBr(Br br) {
    this.blockHeader = new BlockHeader().fromBr(br);
    this.txsVi = new VarInt(buf: br.readVarIntBuf());
    var txsNum = this.txsVi.toNumber();
    this.txs = [];
    for (var i = 0; i < txsNum; i++) {
      this.txs.add(new Tx().fromBr(br));
    }
    return this;
  }

  Bw toBw([Bw bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.write(this.blockHeader.toBuffer().asUint8List());
    bw.write(this.txsVi.buf);
    var txsNum = this.txsVi.toNumber();
    for (var i = 0; i < txsNum; i++) {
      this.txs[i].toBw(bw);
    }
    return bw;
  }

  Hash hash() {
    return Hash.sha256Sha256(this.blockHeader.toBuffer().asUint8List());
  }

  // async asyncHash () {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'hash', [])
  //   return workersResult.resbuf
  // }

  String id() {
    return new Br(buf: this.hash().data).readReverse().toHex();
  }

  // async asyncId () {
  //   var workersResult = await Workers.asyncObjectMethod(this, 'id', [])
  //   return JSON.parse(workersResult.resbuf.toString())
  // }

  int verifyMerkleRoot() {
    var txsbufs = this.txs.map((tx) => tx.toBuffer()).toList();
    var merkleRootBuf = Merkle.fromBuffers(txsbufs).hash();
    return merkleRootBuf.compareTo(this.blockHeader.merkleRootBuf);
    // return Buffer.compare(merkleRootBuf, this.blockHeader.merkleRootBuf);
  }

  /**
   * Sometimes we don't want to parse an entire block into memory. Instead, we
   * simply want to iterate through all transactions in the block. That is what
   * this method is for. This method returns an efficient iterator which can be
   * used in a `for (tx of txs)` construct that returns each tx one at a time
   * without first parsing all of them into memory.
   *
   * @param {Buffer} blockBuf A buffer of a block.
   */
  // static iterateTxs (blockBuf) {
  //   var br = new Br(blockBuf)
  //   var blockHeader = new BlockHeader().fromBr(br)
  //   var txsVi = new VarInt(br.readVarIntBuf())
  //   var txsNum = txsVi.toNumber()
  //   return {
  //     blockHeader,
  //     txsVi,
  //     txsNum,
  //     * [Symbol.iterator] () {
  //       for (var i = 0; i < txsNum; i++) {
  //         yield new Tx().fromBr(br)
  //       }
  //     }
  //   }
  // }
}
