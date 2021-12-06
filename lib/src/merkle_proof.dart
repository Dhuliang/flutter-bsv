import 'package:bsv/bsv.dart';
import 'package:bsv/src/hash.dart';
import 'package:bsv/src/extentsions/list.dart';
import 'package:bsv/src/merkle_node.dart';
import 'package:bsv/src/util.dart';
import 'package:convert/convert.dart';

// ignore: slash_for_doc_comments
/**
 * MerkleProof
 * ===========
 *
 * A proof that a transaction was included in a block.
 *
 * Based on the Merkle Proof Standardized Format:
 *
 * https://tsc.bitcoinassociation.net/standards/merkle-proof-standardised-format/
 *
 * Reference implementation:
 *
 * https://github.com/bitcoin-sv-specs/merkle-proof-standard-example/
 */

class MerkleProof {
  late int flagsNum;
  int? indexNum;
  int? txLengthNum;
  List<int>? txOrIdBuf;
  List<int>? targetBuf;
  int? nodeCount;
  List<Map<String, dynamic>> nodes = [];

  MerkleProof({
    int? flagsNum,
    int? indexNum,
    int? txLengthNum,
    List<int>? txOrIdBuf,
    List<int>? targetBuf,
    int? nodeCount,
    List<Map<String, dynamic>>? nodes,
  }) {
    if (flagsNum == null) {
      this.setDefaultFlags();
    } else {
      this.flagsNum = flagsNum;
      this.indexNum = indexNum;
      this.txLengthNum = txLengthNum;
      this.txOrIdBuf = txOrIdBuf;
      this.targetBuf = targetBuf;
      this.nodeCount = nodeCount;
      this.nodes = nodes ?? [];
    }
  }

  void setDefaultFlags() {
    this.flagsNum = 0;
    this.setFlagsHasTx(false);
    this.setFlagsProofType('branch');
    this.setFlagsComposite(false);
    this.setFlagsTargetType('hash');
  }

  bool getFlagsHasTx() {
    return !!((this.flagsNum & 0x01 != 0));
  }

  void setFlagsHasTx([bool hasTx = true]) {
    if (hasTx) {
      this.flagsNum = this.flagsNum | 0x01;
    } else {
      this.flagsNum = this.flagsNum & 0xfffffffe;
    }
  }

  String getFlagsTargetType() {
    var val = this.flagsNum & (0x04 | 0x02);
    if (val == 0) {
      return 'hash';
    } else if (val == 2) {
      return 'header';
    } else if (val == 4) {
      return 'merkleRoot';
    } else {
      throw ('invalid flags target type');
    }
  }

  MerkleProof setFlagsTargetType([String? targetType]) {
    var val = 0;
    targetType = targetType ?? 'hash';
    if (targetType == 'hash') {
      val = 0;
    } else if (targetType == 'header') {
      val = 2;
    } else if (targetType == 'merkleRoot') {
      val = 4;
    } else {
      throw ('invalid target type');
    }
    this.flagsNum = this.flagsNum & ~(0x04 | 0x02) | val;
    return this;
  }

  String getFlagsProofType() {
    return (this.flagsNum & 0x08 != 0) ? 'tree' : 'branch';
  }

  MerkleProof setFlagsProofType([String? proofType]) {
    proofType = proofType ?? 'branch';
    if (proofType == 'branch') {
      this.flagsNum = this.flagsNum & ~0x08;
    } else if (proofType == 'tree') {
      this.flagsNum = this.flagsNum | 0x08;
    } else {
      throw ('invalid proof type');
    }
    return this;
  }

  bool getFlagsComposite() {
    return !!(this.flagsNum & 0x10 != 0);
  }

  MerkleProof setFlagsComposite([bool? composite]) {
    composite = composite ?? false;
    if (composite) {
      this.flagsNum = this.flagsNum | 0x10;
    } else {
      this.flagsNum = this.flagsNum & ~0x10;
    }
    return this;
  }

  MerkleProof fromBr(Br br) {
    this.flagsNum = br.readInt8();
    this.indexNum = br.readVarIntNum();
    this.txLengthNum = this.getFlagsHasTx() ? br.readVarIntNum() : null;
    this.txOrIdBuf =
        this.txLengthNum != null ? br.read(this.txLengthNum) : br.read(32);
    this.targetBuf =
        this.getFlagsTargetType() == 'header' ? br.read(80) : br.read(32);
    this.nodeCount = br.readVarIntNum();
    this.nodes = [];
    for (var i = 0; i < this.nodeCount!; i++) {
      var typeNum = br.readInt8();
      var nodeBuf;
      if (typeNum == 0) {
        nodeBuf = br.read(32);
      } else if (typeNum == 1) {
        nodeBuf = br.read(0);
      } else if (typeNum == 2) {
        nodeBuf = br.readVarIntBuf();
      } else {
        throw ('invalid node type');
      }
      this.nodes.add({"typeNum": typeNum, "nodeBuf": nodeBuf});
    }
    return this;
  }

  Bw toBw([Bw? bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    bw.writeInt8(this.flagsNum);
    bw.writeVarIntNum(this.indexNum!);
    if (this.txLengthNum != null) {
      bw.writeVarIntNum(this.txLengthNum!);
    }
    bw.write(this.txOrIdBuf!.asUint8List());
    bw.write(this.targetBuf!.asUint8List());
    bw.writeVarIntNum(this.nodeCount!);
    for (var i = 0; i < this.nodeCount!; i++) {
      var node = this.nodes[i];
      var typeNum = node['typeNum'];
      var nodeBuf = node['nodeBuf'];
      bw.writeInt8(typeNum);

      if (node['nodeBuf'] != null) {
        bw.write((nodeBuf as List<int>).asUint8List());
      } else {
        if (typeNum != 1) {
          throw ('if nodeBuf is not present then typeNum should be 1');
        }
      }
    }
    return bw;
  }

  factory MerkleProof.fromJSON(Map<dynamic, dynamic> json) {
    return new MerkleProof().fromJSON(json);
  }

  MerkleProof fromJSON(Map<dynamic, dynamic> json) {
    // this.flags = 0;
    this.indexNum = json['index'];
    var txOrIdBuf = hex.decode(json['txOrId']);
    this.txOrIdBuf = json['txOrId'].length == 64
        ? new Br(buf: txOrIdBuf.asUint8List()).readReverse()
        : txOrIdBuf;
    if (this.txOrIdBuf?.length == 32) {
      this.setFlagsHasTx(false);
    } else {
      this.txLengthNum = this.txOrIdBuf?.length;
      this.setFlagsHasTx(true);
    }
    this.targetBuf =
        new Br(buf: hex.decode(json['target']).asUint8List()).readReverse();
    this.nodeCount = json["nodes"].length;
    this.nodes = [];
    for (var i = 0; i < this.nodeCount!; i++) {
      if (json['nodes'][i] == '*') {
        this.nodes.add({"typeNum": 1, "nodeBuf": null});
      } else {
        var nodeBuf = new Br(buf: hex.decode(json['nodes'][i]).asUint8List())
            .readReverse();
        this.nodes.add({"typeNum": 0, "nodeBuf": nodeBuf});
      }
    }
    this.setFlagsTargetType(json['targetType']);
    this.setFlagsProofType(json['proofType']);
    this.setFlagsComposite(json['composite']);
    return this;
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {};
    json['flags'] = this.flagsNum;
    json['index'] = this.indexNum;
    json['txOrId'] = this.txOrIdBuf?.length == 32
        ? new Br(buf: this.txOrIdBuf!.asUint8List()).readReverse().toHex()
        : this.txOrIdBuf!.toHex();

    json['target'] =
        new Br(buf: this.targetBuf?.asUint8List()).readReverse().toHex();
    json['nodes'] = [];

    for (var i = 0; i < this.nodeCount!; i++) {
      if (this.nodes[i]['typeNum'] == 1) {
        json['nodes'].add('*');
      } else {
        json['nodes'].add(
            new Br(buf: (this.nodes[i]['nodeBuf'] as List<int>).asUint8List())
                .readReverse()
                .toHex());
      }
    }
    json['targetType'] = this.getFlagsTargetType();
    json['proofType'] = this.getFlagsProofType();
    json['composite'] = this.getFlagsComposite();
    return json;
  }

  dynamic verificationError(BlockHeader blockHeader, Tx tx) {
    if (this.getFlagsComposite()) {
      // composite proof type not supported
      return 'only single proof supported in this version';
    }

    if (this.getFlagsProofType() != 'branch') {
      // merkle tree proof type not supported
      return 'only merkle branch supported in this version';
    }

    try {
      // there is no reason to use this method, so we disable it. always deliver
      // the merkle root.
      if (this.getFlagsTargetType() == 'hash') {
        return 'target type hash not supported in this version';
      }
    } catch (err) {
      return 'invalid target type : ${err.toString()}';
    }

    var merkleRootBuf = blockHeader.merkleRootBuf;

    Hash c = tx.hash();
    return this.verificationErrorBuffer(merkleRootBuf, c);
    // var index = this.indexNum;
    // var merkleRootBuf = blockHeader.merkleRootBuf;

    // Hash c = tx.hash();
    // if (this.getFlagsHasTx()) {
    //   var tx2 = Tx.fromBuffer(this.txOrIdBuf!);

    //   var txCorrect = !(tx2.hash().data.compareTo(c.data) != 0);
    //   if (!txCorrect) {
    //     // the tx in the merkle proof does not match
    //     return false;
    //   }
    // } else {
    //   var txCorrect = !(this.txOrIdBuf!.asUint8List().compareTo(c.data) != 0);
    //   if (!txCorrect) {
    //     // the tx hash in the merkle proof does not match
    //     return false;
    //   }
    // }
    // // var isLastInTree = true

    // for (var i = 0; i < this.nodes.length; i++) {
    //   var typeNum = this.nodes[i]['typeNum'];
    //   var p = this.nodes[i]['nodeBuf'];

    //   // Check if the node is the left or the right child
    //   var cIsLeft = index! % 2 == 0;

    //   // Check for duplicate hash - this happens if the node (p) is
    //   // the last element of an uneven merkle tree layer
    //   if (typeNum == 1) {
    //     // If no pair is provided, we assume that c[0] is the Merkle root and compare it to the root provided in the block header.
    //     if (!cIsLeft) {
    //       // this shouldn't happen...
    //       throw ('invalid duplicate on left hand side according to index value');
    //     }
    //     p = c;
    //   }

    //   // This check fails at least once if it's not the last element
    //   // if (cIsLeft && c != p) {
    //   //   isLastInTree = false
    //   // }

    //   var merklec = new MerkleNode(hashBuf: c.data);
    //   var merklep = new MerkleNode(hashBuf: p);

    //   // Calculate the parent node
    //   if (cIsLeft) {
    //     // Concatenate left leaf (c) with right leaf (p)
    //     // c = MerkleNode.fromObject({merkle1: merklec, merkle2: merklep}).hash();
    //     c = MerkleNode(merkle1: merklec, merkle2: merklep).hash();
    //   } else {
    //     // Concatenate left leaf (p) with right leaf (c)
    //     // c = MerkleNode.fromObject({merkle1: merklep, merkle2: merklec}).hash();
    //     c = MerkleNode(merkle1: merklep, merkle2: merklec).hash();
    //   }

    //   // We need integer division here with remainder dropped.
    //   // Javascript does floating point math by default so we
    //   // need to use Math.floor to drop the fraction.
    //   index = (index / 2).floor();
    // }

    // // c is now the calculated merkle root
    // return (c.data.compareTo(merkleRootBuf));
  }

  dynamic verificationErrorBuffer(List<int> merkleRootBuf, Hash c) {
    var index = this.indexNum;

    if (this.getFlagsHasTx()) {
      var tx2 = Tx.fromBuffer(this.txOrIdBuf!);

      var txCorrect = !(tx2.hash().data.compareTo(c.data) != 0);
      if (!txCorrect) {
        // the tx in the merkle proof does not match
        return false;
      }
    } else {
      var txCorrect = !(this.txOrIdBuf!.asUint8List().compareTo(c.data) != 0);
      if (!txCorrect) {
        // the tx hash in the merkle proof does not match
        return false;
      }
    }
    // var isLastInTree = true

    for (var i = 0; i < this.nodes.length; i++) {
      var typeNum = this.nodes[i]['typeNum'];
      var p = this.nodes[i]['nodeBuf'];

      // Check if the node is the left or the right child
      var cIsLeft = index! % 2 == 0;

      // Check for duplicate hash - this happens if the node (p) is
      // the last element of an uneven merkle tree layer
      if (typeNum == 1) {
        // If no pair is provided, we assume that c[0] is the Merkle root and compare it to the root provided in the block header.
        if (!cIsLeft) {
          // this shouldn't happen...
          throw ('invalid duplicate on left hand side according to index value');
        }
        p = c.data;
      }

      // This check fails at least once if it's not the last element
      // if (cIsLeft && c != p) {
      //   isLastInTree = false
      // }

      var merklec = new MerkleNode(hashBuf: c.data);
      var merklep = new MerkleNode(hashBuf: p);

      // Calculate the parent node
      if (cIsLeft) {
        // Concatenate left leaf (c) with right leaf (p)
        // c = MerkleNode.fromObject({merkle1: merklec, merkle2: merklep}).hash();
        c = MerkleNode(merkle1: merklec, merkle2: merklep).hash();
      } else {
        // Concatenate left leaf (p) with right leaf (c)
        // c = MerkleNode.fromObject({merkle1: merklep, merkle2: merklec}).hash();
        c = MerkleNode(merkle1: merklep, merkle2: merklec).hash();
      }

      // We need integer division here with remainder dropped.
      // Javascript does floating point math by default so we
      // need to use Math.floor to drop the fraction.
      index = (index / 2).floor();
    }

    // c is now the calculated merkle root
    return (c.data.compareTo(merkleRootBuf));
  }

  String calculateMerkleRoot(Hash h) {
    if (this.getFlagsComposite()) {
      // composite proof type not supported
      throw 'only single proof supported in this version';
    }

    if (this.getFlagsProofType() != 'branch') {
      // merkle tree proof type not supported
      throw 'only merkle branch supported in this version';
    }

    try {
      // there is no reason to use this method, so we disable it. always deliver
      // the merkle root.
      if (this.getFlagsTargetType() == 'hash') {
        throw 'target type hash not supported in this version';
      }
    } catch (err) {
      throw 'invalid target type : ${err.toString()}';
    }

    Hash c = Hash(data: h.data);
    var index = this.indexNum;

    if (this.getFlagsHasTx()) {
      var tx2 = Tx.fromBuffer(this.txOrIdBuf!);

      var txCorrect = !(tx2.hash().data.compareTo(c.data) != 0);
      if (!txCorrect) {
        // the tx in the merkle proof does not match
        throw 'the tx in the merkle proof does not match';
      }
    } else {
      var txCorrect = !(this.txOrIdBuf!.asUint8List().compareTo(c.data) != 0);
      if (!txCorrect) {
        // the tx hash in the merkle proof does not match
        throw "the tx hash in the merkle proof does not match";
      }
    }
    // var isLastInTree = true

    for (var i = 0; i < this.nodes.length; i++) {
      var typeNum = this.nodes[i]['typeNum'];
      var p = this.nodes[i]['nodeBuf'];

      // Check if the node is the left or the right child
      var cIsLeft = index! % 2 == 0;

      // Check for duplicate hash - this happens if the node (p) is
      // the last element of an uneven merkle tree layer
      if (typeNum == 1) {
        // If no pair is provided, we assume that c[0] is the Merkle root and compare it to the root provided in the block header.
        if (!cIsLeft) {
          // this shouldn't happen...
          throw ('invalid duplicate on left hand side according to index value');
        }
        p = c.data;
      }

      // This check fails at least once if it's not the last element
      // if (cIsLeft && c != p) {
      //   isLastInTree = false
      // }

      var merklec = new MerkleNode(hashBuf: c.data);
      var merklep = new MerkleNode(hashBuf: p);

      // Calculate the parent node
      if (cIsLeft) {
        // Concatenate left leaf (c) with right leaf (p)
        // c = MerkleNode.fromObject({merkle1: merklec, merkle2: merklep}).hash();
        c = MerkleNode(merkle1: merklec, merkle2: merklep).hash();
      } else {
        // Concatenate left leaf (p) with right leaf (c)
        // c = MerkleNode.fromObject({merkle1: merklep, merkle2: merklec}).hash();
        c = MerkleNode(merkle1: merklep, merkle2: merklec).hash();
      }

      // We need integer division here with remainder dropped.
      // Javascript does floating point math by default so we
      // need to use Math.floor to drop the fraction.
      index = (index / 2).floor();
    }

    // c is now the calculated merkle root
    return c.data.reversed.toList().toHex();
  }

  bool verify(BlockHeader blockHeader, Tx tx) {
    dynamic result = this.verificationError(blockHeader, tx);
    return !Util.checkToBool(result);
  }

  factory MerkleProof.fromHex(String str) {
    return MerkleProof.fromBuffer(hex.decode(str));
  }

  MerkleProof fromHex(String str) {
    return this.fromBuffer(hex.decode(str));
  }

  MerkleProof fromBuffer(List<int> buf) {
    return this.fromBr(Br(buf: buf.asUint8List()));
  }

  factory MerkleProof.fromBuffer(List<int> buf) {
    return MerkleProof().fromBr(Br(buf: buf.asUint8List()));
  }

  String toHex() {
    return this.toBw().toHex();
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }
}
