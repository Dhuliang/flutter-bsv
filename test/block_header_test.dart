import 'dart:typed_data';

import 'package:bsv/src/block_header.dart';
import 'package:bsv/src/br.dart';
import 'package:bsv/src/bw.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/src/extentsions/list.dart';

void main() {
  group('BlockHeader', () {
    var versionBytesNum = 1;
    var prevBlockHashBuf = List.generate(32, (index) => 5);
    var merkleRootBuf = List.generate(32, (index) => 9);
    var time = 2;
    var bits = 3;
    var nonce = 4;

    var bh = new BlockHeader(
      versionBytesNum: versionBytesNum,
      prevBlockHashBuf: prevBlockHashBuf,
      merkleRootBuf: merkleRootBuf,
      time: time,
      bits: bits,
      nonce: nonce,
    );

    bh = BlockHeader(
        versionBytesNum: versionBytesNum,
        prevBlockHashBuf: prevBlockHashBuf,
        merkleRootBuf: merkleRootBuf,
        time: time,
        bits: bits,
        nonce: nonce);
    var bhhex =
        '0100000005050505050505050505050505050505050505050505050505050505050505050909090909090909090909090909090909090909090909090909090909090909020000000300000004000000';
    var bhbuf = hex.decode(bhhex);

    // test('should make a new blockHeader', () {
    //   var blockHeader = new BlockHeader
    //   should.exist(blockHeader)
    //   blockHeader = new BlockHeader
    //   should.exist(blockHeader)
    // })

    // group('#fromObject', () {
    //   test('should set all the variables', () {
    //     // bh.fromObject({
    //     //   versionBytesNum: versionBytesNum,
    //     //   prevBlockHashBuf: prevBlockHashBuf,
    //     //   merkleRootBuf: merkleRootBuf,
    //     //   time: time,
    //     //   bits: bits,
    //     //   nonce: nonce
    //     // })
    //     expect(bh.versionBytesNum != null, true);
    //     expect(bh.prevBlockHashBuf != null, true);
    //     expect(bh.merkleRootBuf != null, true);
    //     expect(bh.time != null, true);
    //     expect(bh.bits != null, true);
    //     expect(bh.nonce != null, true);
    //   });
    // });

    group('#fromJSON', () {
      test('should set all the variables', () {
        var bh = new BlockHeader.fromJSON({
          "versionBytesNum": versionBytesNum,
          "prevBlockHashBuf": prevBlockHashBuf.toHex(),
          "merkleRootBuf": merkleRootBuf.toHex(),
          "time": time,
          "bits": bits,
          "nonce": nonce
        });
        // ignore: unnecessary_null_comparison
        expect(bh.versionBytesNum != null, true);
        // ignore: unnecessary_null_comparison
        expect(bh.prevBlockHashBuf != null, true);
        // ignore: unnecessary_null_comparison
        expect(bh.merkleRootBuf != null, true);
        // ignore: unnecessary_null_comparison
        expect(bh.time != null, true);
        // ignore: unnecessary_null_comparison
        expect(bh.bits != null, true);
        // ignore: unnecessary_null_comparison
        expect(bh.nonce != null, true);
      });
    });

    group('#toJSON', () {
      test('should set all the variables', () {
        var json = bh.toJSON();
        expect(json['versionBytesNum'] != null, true);
        expect(json['prevBlockHashBuf'] != null, true);
        expect(json['merkleRootBuf'] != null, true);
        expect(json['time'] != null, true);
        expect(json['bits'] != null, true);
        expect(json['nonce'] != null, true);
      });
    });

    group('#fromHex', () {
      test('should parse this known hex string', () {
        expect(new BlockHeader.fromHex(bhhex).toBuffer().toHex(), bhhex);
      });
    });

    group('#fromBuffer', () {
      test('should parse this known buffer', () {
        expect(new BlockHeader.fromBuffer(bhbuf).toBuffer().toHex(), bhhex);
      });
    });

    group('#fromBr', () {
      test('should parse this known buffer', () {
        expect(
            new BlockHeader.fromBr(new Br(buf: bhbuf as Uint8List?))
                .toBuffer()
                .toHex(),
            bhhex);
      });
    });

    group('#toHex', () {
      test('should output this known hex string', () {
        expect(new BlockHeader.fromBuffer(bhbuf).toHex(), bhhex);
      });
    });

    group('#toBuffer', () {
      test('should output this known buffer', () {
        expect(new BlockHeader.fromBuffer(bhbuf).toBuffer().toHex(), bhhex);
      });
    });

    group('#toBw', () {
      test('should output this known buffer', () {
        expect(
            new BlockHeader.fromBuffer(bhbuf).toBw().toBuffer().toHex(), bhhex);

        var bw = new Bw();
        new BlockHeader.fromBuffer(bhbuf).toBw(bw);
        expect(bw.toBuffer().toHex(), bhhex);
      });
    });
  });
}
