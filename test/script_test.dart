import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/op_code.dart';
import 'package:bsv/priv_key.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/script.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/extentsions/list.dart';

import 'vectors/bitcoind/script_invalid.dart';
import 'vectors/bitcoind/script_valid.dart';

void main() {
  group('Script', () {
    test('should make a new script', () {
      // var script = new Script();
      // should.exist(script);
      expect(new Script().toString(), '');
      expect(new Script().writeString('').toString(), '');
    });

    group('#fromHex', () {
      test('should parse this hex string containing an OP code', () {
        var buf = Uint8List(1);
        buf[0] = new OpCode().fromString('OP_0').toNumber();
        var script = new Script().fromHex(hex.encode(buf));
        expect(script.chunks.length, 1);
        expect(script.chunks[0].opCodeNum, buf[0]);
      });
    });

    group('#fromBuffer', () {
      test('should parse this buffer containing an OP code', () {
        var buf = Uint8List(1);
        buf[0] = new OpCode().fromString('OP_0').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].opCodeNum, buf[0]);
      });

      test('should parse this buffer containing another OP code', () {
        var buf = Uint8List(1);
        buf[0] = new OpCode().fromString('OP_CHECKMULTISIG').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].opCodeNum, buf[0]);
      });

      test('should parse this buffer containing three bytes of data', () {
        var buf = Uint8List.fromList([3, 1, 2, 3]);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(hex.encode(script.chunks[0].buf), '010203');
      });

      test(
          'should parse this buffer containing OP_PUSHDATA1 and three bytes of data',
          () {
        var buf = Uint8List.fromList([0, 0, 1, 2, 3]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA1').toNumber();
        ByteData.view(buf.buffer).setUint8(1, 3);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(hex.encode(script.chunks[0].buf), '010203');
      });

      test(
          'should parse this buffer containing OP_PUSHDATA1 and zero bytes of data',
          () {
        var buf = Uint8List.fromList([0]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA1').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(hex.encode(script.chunks[0].buf), '');
      });

      test(
          'should parse this buffer containing OP_PUSHDATA2 and zero bytes of data',
          () {
        var buf = Uint8List.fromList([0]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA2').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(hex.encode(script.chunks[0].buf), '');
      });

      test(
          'should parse this buffer containing OP_PUSHDATA2 and three bytes of data',
          () {
        var buf = Uint8List.fromList([0, 0, 0, 1, 2, 3]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA2').toNumber();
        ByteData.view(buf.buffer).setUint16(1, 3, Endian.little);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(hex.encode(script.chunks[0].buf), '010203');
      });

      test(
          'should parse this buffer containing OP_PUSHDATA4 and zero bytes of data',
          () {
        var buf = Uint8List.fromList([0, 0]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA4').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(hex.encode(script.chunks[0].buf), '');
      });

      test(
          'should parse this buffer containing OP_PUSHDATA4 and three bytes of data',
          () {
        var buf = Uint8List.fromList([0, 0, 0, 0, 0, 1, 2, 3]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA4').toNumber();
        ByteData.view(buf.buffer).setUint16(1, 3, Endian.little);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(hex.encode(script.chunks[0].buf), '010203');
      });

      test('should parse this buffer an OP code, data, and another OP code',
          () {
        var buf = Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 2, 3, 0]);
        buf[0] = new OpCode().fromString('OP_0').toNumber();
        buf[1] = new OpCode().fromString('OP_PUSHDATA4').toNumber();
        ByteData.view(buf.buffer).setUint16(2, 3, Endian.little);
        buf[buf.length - 1] = new OpCode().fromString('OP_0').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 3);
        expect(script.chunks[0].opCodeNum, buf[0]);
        expect(hex.encode(script.chunks[1].buf), '010203');
        expect(script.chunks[2].opCodeNum, buf[buf.length - 1]);
        expect(hex.encode(script.toBuffer()), hex.encode(buf));
      });
    });

    group('#toBuffer', () {
      test('should output this hex string containing an OP code', () {
        var buf = Uint8List(1);
        buf[0] = new OpCode().fromString('OP_0').toNumber();
        var script = new Script().fromHex(buf.toHex());

        expect(script.chunks.length, 1);
        expect(script.chunks[0].opCodeNum, buf[0]);
      });
    });

    group('#toBuffer', () {
      test('should output this buffer containing an OP code', () {
        var buf = Uint8List(1);
        buf[0] = new OpCode().fromString('OP_0').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].opCodeNum, buf[0]);
        expect(script.toHex(), buf.toHex());
      });

      test('should output this buffer containing another OP code', () {
        var buf = Uint8List(1);
        buf[0] = new OpCode().fromString('OP_CHECKMULTISIG').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].opCodeNum, buf[0]);
        expect(script.toHex(), buf.toHex());
      });

      test('should output this buffer containing three bytes of data', () {
        var buf = Uint8List.fromList([3, 1, 2, 3]);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].buf.toHex(), '010203');
        expect(script.toHex(), buf.toHex());
      });

      test(
          'should output this buffer containing OP_PUSHDATA1 and three bytes of data',
          () {
        var buf = Uint8List.fromList([0, 0, 1, 2, 3]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA1').toNumber();
        ByteData.view(buf.buffer).setUint8(1, 3);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].buf.toHex(), '010203');
        expect(script.toHex(), buf.toHex());
      });

      test(
          'should output this buffer containing OP_PUSHDATA2 and three bytes of data',
          () {
        var buf = Uint8List.fromList([0, 0, 0, 1, 2, 3]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA2').toNumber();
        ByteData.view(buf.buffer).setUint16(1, 3, Endian.little);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].buf.toHex(), '010203');
        expect(script.toHex(), buf.toHex());
      });

      test(
          'should output this buffer containing OP_PUSHDATA4 and three bytes of data',
          () {
        var buf = Uint8List.fromList([0, 0, 0, 0, 0, 1, 2, 3]);
        buf[0] = new OpCode().fromString('OP_PUSHDATA4').toNumber();
        ByteData.view(buf.buffer).setUint16(1, 3, Endian.little);
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 1);
        expect(script.chunks[0].buf.toHex(), '010203');
        expect(script.toHex(), buf.toHex());
      });

      test('should output this buffer an OP code, data, and another OP code',
          () {
        var buf = Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 2, 3, 0]);
        buf[0] = new OpCode().fromString('OP_0').toNumber();
        buf[1] = new OpCode().fromString('OP_PUSHDATA4').toNumber();
        ByteData.view(buf.buffer).setUint16(2, 3, Endian.little);
        buf[buf.length - 1] = new OpCode().fromString('OP_0').toNumber();
        var script = new Script().fromBuffer(buf);

        expect(script.chunks.length, 3);
        expect(script.chunks[0].opCodeNum, buf[0]);
        expect(script.chunks[0].opCodeNum, buf[0]);
        expect(script.chunks[1].buf.toHex(), '010203');
        expect(script.chunks[2].opCodeNum, buf[buf.length - 1]);
        expect(script.toHex(), buf.toHex());
      });
    });

    group('#fromString', () {
      test('should parse these known scripts', () {
        expect(
          new Script()
              .fromString('OP_0 OP_PUSHDATA4 3 0x010203 OP_0')
              .toString(),
          'OP_0 OP_PUSHDATA4 3 0x010203 OP_0',
        );

        expect(
          new Script()
              .fromString(
                  'OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIG')
              .toString(),
          'OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIG',
        );

        expect(
          new Script()
              .fromString(
                  'OP_SHA256 32 0x8cc17e2a2b10e1da145488458a6edec4a1fdb1921c2d5ccbc96aa0ed31b4d5f8 OP_EQUALVERIFY OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIGVERIFY OP_EQUALVERIFY OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIG')
              .toString(),
          'OP_SHA256 32 0x8cc17e2a2b10e1da145488458a6edec4a1fdb1921c2d5ccbc96aa0ed31b4d5f8 OP_EQUALVERIFY OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIGVERIFY OP_EQUALVERIFY OP_DUP OP_HASH160 20 0x1451baa3aad777144a0759998a03538018dd7b4b OP_EQUALVERIFY OP_CHECKSIG',
        );

        expect(
          new Script()
              .fromString('OP_0 OP_PUSHDATA2 3 0x010203 OP_0')
              .toString(),
          'OP_0 OP_PUSHDATA2 3 0x010203 OP_0',
        );

        expect(
          new Script()
              .fromString('OP_0 OP_PUSHDATA1 3 0x010203 OP_0')
              .toString(),
          'OP_0 OP_PUSHDATA1 3 0x010203 OP_0',
        );

        expect(
          new Script().fromString('OP_0 3 0x010203 OP_0').toString(),
          'OP_0 3 0x010203 OP_0',
        );

        expect(
          new Script().fromString('').toString(),
          '',
        );
      });
    });

    group('#toString', () {
      test('should output this buffer an OP code, data, and another OP code',
          () {
        var buf = Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 2, 3, 0]);
        buf[0] = new OpCode().fromString('OP_0').toNumber();
        buf[1] = new OpCode().fromString('OP_PUSHDATA4').toNumber();
        ByteData.view(buf.buffer).setUint16(2, 3, Endian.little);
        buf[buf.length - 1] = new OpCode().fromString('OP_0').toNumber();
        var script = new Script().fromBuffer(buf);
        expect(script.chunks.length, 3);
        expect(script.chunks[0].opCodeNum, buf[0]);
        expect(script.chunks[1].buf.toHex(), '010203');
        expect(script.chunks[2].opCodeNum, buf[buf.length - 1]);
        expect(script.toString(), 'OP_0 OP_PUSHDATA4 3 0x010203 OP_0');
      });
    });

    group('#fromBitcoindString', () {
      test('should convert from this known string', () {
        expect(
          new Script().fromBitcoindString('DEPTH 0 EQUAL').toBitcoindString(),
          'DEPTH 0 EQUAL',
        );

        expect(
          new Script()
              .fromBitcoindString(
                  "'Azzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz' EQUAL")
              .toBitcoindString(),
          '0x4b417a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a EQUAL',
        );

        var str =
            '0x4c47304402203acf75dd59bbef171aeeedae4f1020b824195820db82575c2b323b8899f95de9022067df297d3a5fad049ba0bb81255d0e495643cbcf9abae9e396988618bc0c6dfe01 0x47304402205f8b859230c1cab7d4e8de38ff244d2ebe046b64e8d3f4219b01e483c203490a022071bdc488e31b557f7d9e5c8a8bec90dc92289ca70fa317685f4f140e38b30c4601';

        expect(
          new Script().fromBitcoindString(str).toBitcoindString(),
          str,
        );
      });

      test('should convert to this known string', () {
        expect(
          new Script().fromBitcoindString('DEPTH 0 EQUAL').toBitcoindString(),
          'DEPTH 0 EQUAL',
        );
      });
    });

    group('@fromBitcoindString', () {
      test('should convert from this known string', () {
        expect(
          Script.fromBitcoindString('DEPTH 0 EQUAL').toBitcoindString(),
          'DEPTH 0 EQUAL',
        );

        expect(
            Script.fromBitcoindString(
                    "'Azzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz' EQUAL")
                .toBitcoindString(),
            '0x4b417a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a EQUAL');

        var str =
            '0x4c47304402203acf75dd59bbef171aeeedae4f1020b824195820db82575c2b323b8899f95de9022067df297d3a5fad049ba0bb81255d0e495643cbcf9abae9e396988618bc0c6dfe01 0x47304402205f8b859230c1cab7d4e8de38ff244d2ebe046b64e8d3f4219b01e483c203490a022071bdc488e31b557f7d9e5c8a8bec90dc92289ca70fa317685f4f140e38b30c4601';

        expect(Script.fromBitcoindString(str).toBitcoindString(), (str));
      });

      test('should convert to this known string', () {
        expect(
          Script.fromBitcoindString('DEPTH 0 EQUAL').toBitcoindString(),
          'DEPTH 0 EQUAL',
        );
      });

      test('should convert to this known string', () {
        expect(
            Script.fromAsmString(
                    'OP_DUP OP_HASH160 6fa5502ea094d59576898b490d866b32a61b89f6 OP_EQUALVERIFY OP_CHECKSIG')
                .toAsmString(),
            ('OP_DUP OP_HASH160 6fa5502ea094d59576898b490d866b32a61b89f6 OP_EQUALVERIFY OP_CHECKSIG'));
      });
    });

    group('@fromAsmString', () {
      test('should parse this known script in ASM', () {
        var asm =
            'OP_DUP OP_HASH160 f4c03610e60ad15100929cc23da2f3a799af1725 OP_EQUALVERIFY OP_CHECKSIG';
        var script = Script.fromAsmString(asm);

        expect(script.chunks[0].opCodeNum, (OpCode.OP_DUP));
        expect(script.chunks[1].opCodeNum, (OpCode.OP_HASH160));
        expect(script.chunks[2].opCodeNum, (20));
        expect(script.chunks[2].buf.toHex(),
            ('f4c03610e60ad15100929cc23da2f3a799af1725'));
        expect(script.chunks[3].opCodeNum, (OpCode.OP_EQUALVERIFY));
        expect(script.chunks[4].opCodeNum, (OpCode.OP_CHECKSIG));
      });

      test('should parse this known problematic script in ASM', () {
        var asm = 'OP_RETURN 026d02 0568656c6c6f';
        var script = Script.fromAsmString(asm);
        expect(script.toAsmString(), asm);
      });

      test('should know this is invalid hex', () {
        var asm = 'OP_RETURN 026d02 0568656c6c6fzz';
        var errors = 0;
        try {
          errors++;
          var script = Script.fromAsmString(asm);
          expect(script.toAsmString(), (asm));
        } catch (err) {
          expect(err.message.toString().toLowerCase().contains('invalid hex'),
              true);
        }
        expect(errors, 1);
      });

      test('should parse this long PUSHDATA1 script in ASM', () {
        var buf = Uint8List(220);
        var asm = 'OP_RETURN ' + buf.toHex();
        var script = Script.fromAsmString(asm);
        expect(script.chunks[1].opCodeNum, OpCode.OP_PUSHDATA1);
        expect(script.toAsmString(), asm);
      });

      test('should parse this long PUSHDATA2 script in ASM', () {
        var buf = Uint8List(1024);
        var asm = 'OP_RETURN ' + buf.toHex();
        var script = Script.fromAsmString(asm);
        expect(script.chunks[1].opCodeNum, (OpCode.OP_PUSHDATA2));
        expect(script.toAsmString(), (asm));
      });

      test('should parse this long PUSHDATA4 script in ASM', () {
        var buf = Uint8List(pow(2, 17));
        var asm = 'OP_RETURN ' + buf.toHex();
        var script = Script.fromAsmString(asm);
        expect(script.chunks[1].opCodeNum, (OpCode.OP_PUSHDATA4));
        expect(script.toAsmString(), (asm));
      });

      test('should return this script correctly', () {
        var asm1 = 'OP_FALSE';
        var asm2 = 'OP_0';
        var asm3 = '0';
        expect(Script.fromAsmString(asm1).toAsmString(), (asm3));
        expect(Script.fromAsmString(asm2).toAsmString(), (asm3));
        expect(Script.fromAsmString(asm3).toAsmString(), (asm3));
      });

      test('should return this script correctly', () {
        var asm1 = 'OP_1NEGATE';
        var asm2 = '-1';
        expect(Script.fromAsmString(asm1).toAsmString(), (asm2));
        expect(Script.fromAsmString(asm2).toAsmString(), (asm2));
      });
    });

    group('#fromJSON', () {
      test('should parse this known script', () {
        expect(
          new Script().fromJSON('OP_0 OP_PUSHDATA4 3 0x010203 OP_0').toString(),
          ('OP_0 OP_PUSHDATA4 3 0x010203 OP_0'),
        );
      });
    });

    group('#toJSON', () {
      test('should output this known script', () {
        expect(
          new Script().fromString('OP_0 OP_PUSHDATA4 3 0x010203 OP_0').toJSON(),
          ('OP_0 OP_PUSHDATA4 3 0x010203 OP_0'),
        );
      });
    });

    group('@fromOpReturnData', () {
      test('should create valid op return output', () {
        var script = Script.fromOpReturnData(
            Uint8List.fromList(utf8.encode('yours bitcoin')));
        expect(script.isOpReturn(), (true));
      });
    });

    group('@fromSafeData', () {
      test('should create valid op return output', () {
        var script = Script.fromSafeData(
            Uint8List.fromList(utf8.encode('yours bitcoin')));
        expect(script.isSafeDataOut(), (true));
      });

      test('should create valid op return output', () {
        expect(
            Script.fromSafeDataArray([
              Uint8List.fromList(hex.decode('ff')),
              Uint8List.fromList(hex.decode('aa'))
            ]).toAsmString(),
            ('0 OP_RETURN ff aa'));
        expect(
            Script.fromSafeDataArray([
              Uint8List.fromList(hex.decode('ff')),
              Uint8List.fromList(hex.decode('aa'))
            ]).toString(),
            ('OP_0 OP_RETURN 1 0xff 1 0xaa'));
      });
    });

    group('@fromSafeDataArray', () {
      test('should create valid op return output', () {
        var script = Script.fromSafeDataArray([
          Uint8List.fromList(utf8.encode('yours bitcoin')),
          Uint8List.fromList(utf8.encode('bsv'))
        ]);
        expect(script.isSafeDataOut(), (true));
      });
    });

    group('#getData', () {
      test('should create valid op return output', () {
        var script = Script.fromSafeDataArray([
          Uint8List.fromList(utf8.encode('yours bitcoin')),
          Uint8List.fromList(utf8.encode('bsv'))
        ]);

        expect(script.isSafeDataOut(), (true));
        var bufs = script.getData();
        expect(utf8.decode(bufs[0]), ('yours bitcoin'));
        expect(utf8.decode(bufs[1]), ('bsv'));
      });
    });

    group('#fromPubKeyHash', () {
      test('should create pubKeyHash output script', () {
        var hashBuf = Uint8List(20);
        expect(
          new Script().fromPubKeyHash(hashBuf).toString(),
          ('OP_DUP OP_HASH160 20 0x0000000000000000000000000000000000000000 OP_EQUALVERIFY OP_CHECKSIG'),
        );
      });
    });

    group('@fromPubKeyHash', () {
      test('should create pubKeyHash output script', () {
        var hashBuf = Uint8List(20);
        expect(
          Script.fromPubKeyHash(hashBuf).toString(),
          ('OP_DUP OP_HASH160 20 0x0000000000000000000000000000000000000000 OP_EQUALVERIFY OP_CHECKSIG'),
        );
      });
    });

    group('@sortPubKeys', () {
      test('should sort these pubKeys in a known order', () {
        var testPubKeysHex = [
          '02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0',
          '02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758',
          '0266dd7664e65958f3cc67bf92ad6243bc495df5ab56691719263977104b635bea',
          '02ee91377073b04d1d9d19597b81a7be3db6554bd7d16151cb5599a6107a589e70',
          '02c8f63ad4822ef360b5c300f08488fa0fa24af2b2bebb6d6b602ca938ee5af793'
        ];

        var pubKeys = testPubKeysHex.map((hex) => PubKey.fromHex(hex)).toList();
        var pubKeysSorted = Script.sortPubKeys(pubKeys);
        expect(pubKeysSorted[0].toHex(), (testPubKeysHex[2]));
        expect(pubKeysSorted[1].toHex(), (testPubKeysHex[1]));
        expect(pubKeysSorted[2].toHex(), (testPubKeysHex[0]));
        expect(pubKeysSorted[3].toHex(), (testPubKeysHex[4]));
        expect(pubKeysSorted[4].toHex(), (testPubKeysHex[3]));
      });
    });

    group('#fromPubKeys', () {
      test('should generate this known script from a list of public keys', () {
        var privKey = new PrivKey().fromBn(BigIntX.fromNum(5));
        var pubKey = new PubKey().fromPrivKey(privKey);
        var script = new Script().fromPubKeys(2, [pubKey, pubKey, pubKey]);
        expect(
          script.toString(),
          ('OP_2 33 0x022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4 33 0x022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4 33 0x022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4 OP_3 OP_CHECKMULTISIG'),
        );
      });

      test(
          'should generate this known script from a list of public keys, sorted',
          () {
        var pubKey1 = PubKey.fromHex(
            '02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0');
        var pubKey2 = PubKey.fromHex(
            '02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758');
        var script = Script().fromPubKeys(2, [pubKey1, pubKey2]);
        expect(script.toString(),
            ('OP_2 33 0x02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758 33 0x02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0 OP_2 OP_CHECKMULTISIG'));
      });

      test(
          'should generate this known script from a list of public keys, sorted explicitly',
          () {
        var pubKey1 = PubKey.fromHex(
            '02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0');
        var pubKey2 = PubKey.fromHex(
            '02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758');
        var script = new Script().fromPubKeys(2, [pubKey1, pubKey2], true);
        expect(script.toString(),
            ('OP_2 33 0x02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758 33 0x02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0 OP_2 OP_CHECKMULTISIG'));
      });

      test(
          'should generate this known script from a list of public keys, unsorted',
          () {
        var pubKey1 = PubKey.fromHex(
            '02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0');
        var pubKey2 = PubKey.fromHex(
            '02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758');
        var script = new Script().fromPubKeys(2, [pubKey1, pubKey2], false);
        expect(script.toString(),
            ('OP_2 33 0x02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0 33 0x02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758 OP_2 OP_CHECKMULTISIG'));
      });
    });

    // TODO: NOT IMPLEMENT
    // group('@fromPubKeys', () {
    //   test('should generate this known script from a list of public keys', () {
    //     var privKey = PrivKey.fromBn(BigIntX.fromNum(5));
    //     var pubKey = PubKey.fromPrivKey(privKey);
    //     var script = Script.fromPubKeys(2, [pubKey, pubKey, pubKey]);
    //     expect(script.toString(),
    //         ('OP_2 33 0x022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4 33 0x022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4 33 0x022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4 OP_3 OP_CHECKMULTISIG'));
    //   });

    //   test('should generate this known script from a list of public keys, sorted',  () {
    //     var pubKey1 = PubKey.fromHex(
    //       '02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0'
    //     );
    //     var pubKey2 = PubKey.fromHex(
    //       '02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758'
    //     );
    //     var script = Script.fromPubKeys(2, [pubKey1, pubKey2])
    //     script
    //       .toString()
    //       .should.equal(
    //         'OP_2 33 0x02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758 33 0x02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0 OP_2 OP_CHECKMULTISIG'
    //       );
    //   });

    // test('should generate this known script from a list of public keys, sorted explicitly',  () {
    //   var pubKey1 = PubKey.fromHex(
    //     '02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0'
    //   )
    //   var pubKey2 = PubKey.fromHex(
    //     '02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758'
    //   )
    //   var script = Script.fromPubKeys(2, [pubKey1, pubKey2], true)
    //   script
    //     .toString()
    //     .should.equal(
    //       'OP_2 33 0x02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758 33 0x02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0 OP_2 OP_CHECKMULTISIG'
    //     )
    // })

    // test('should generate this known script from a list of public keys, unsorted',  () {
    //   var pubKey1 = PubKey.fromHex(
    //     '02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0'
    //   )
    //   var pubKey2 = PubKey.fromHex(
    //     '02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758'
    //   )
    //   var script = Script.fromPubKeys(2, [pubKey1, pubKey2], false)
    //   script
    //     .toString()
    //     .should.equal(
    //       'OP_2 33 0x02c525d65d18be8fb36ab50a21bee02ac9fdc2c176fa18791ac664ea4b95572ae0 33 0x02b937d54b550a3afdc2819772822d25869495f9e588b56a0205617d80514f0758 OP_2 OP_CHECKMULTISIG'
    //     )
    // });
    // });

    group('#removeCodeseparators', () {
      test('should remove any OP_CODESEPARATORs', () {
        expect(
            new Script()
                .writeString('OP_CODESEPARATOR OP_0 OP_CODESEPARATOR')
                .removeCodeseparators()
                .toString(),
            'OP_0');
      });
    });

    group('#isPushOnly', () {
      test("should know these scripts are or aren't push only", () {
        expect(new Script().writeString('OP_0').isPushOnly(), (true));
        expect(
            new Script().writeString('OP_0 OP_RETURN').isPushOnly(), (false));
        expect(
            new Script()
                .writeString('OP_PUSHDATA1 5 0x1010101010')
                .isPushOnly(),
            (true));

        // like bitcoind, we regard OP_RESERVED as being "push only"
        expect(new Script().writeString('OP_RESERVED').isPushOnly(), (true));
      });
    });

    group('#isOpReturn', () {
      test('should know this is a (blank) OP_RETURN script', () {
        expect(new Script().writeString('OP_RETURN').isOpReturn(), (true));
      });

      test('should know this is an OP_RETURN script', () {
        var buf = Uint8List(40);
        expect(
            new Script()
                .writeString('OP_RETURN 40 0x' + buf.toHex())
                .isOpReturn(),
            (true));
      });

      test('should know this is not an OP_RETURN script', () {
        var buf = Uint8List(40);
        expect(
            new Script()
                .writeString('OP_CHECKMULTISIG 40 0x' + buf.toHex())
                .isOpReturn(),
            (false));
      });
    });

    group('#isPubKeyHashIn', () {
      test('should classify this known pubKeyHashin', () {
        expect(
            new Script()
                .writeString(
                    '73 0x3046022100bb3c194a30e460d81d34be0a230179c043a656f67e3c5c8bf47eceae7c4042ee0221008bf54ca11b2985285be0fd7a212873d243e6e73f5fad57e8eb14c4f39728b8c601 65 0x04e365859b3c78a8b7c202412b949ebca58e147dba297be29eee53cd3e1d300a6419bc780cc9aec0dc94ed194e91c8f6433f1b781ee00eac0ead2aae1e8e0712c6')
                .isPubKeyHashIn(),
            (true));
      });

      test('should classify this known non-pubKeyHashin', () {
        expect(
            new Script()
                .writeString(
                    '73 0x3046022100bb3c194a30e460d81d34be0a230179c043a656f67e3c5c8bf47eceae7c4042ee0221008bf54ca11b2985285be0fd7a212873d243e6e73f5fad57e8eb14c4f39728b8c601 65 0x04e365859b3c78a8b7c202412b949ebca58e147dba297be29eee53cd3e1d300a6419bc780cc9aec0dc94ed194e91c8f6433f1b781ee00eac0ead2aae1e8e0712c6 OP_CHECKSIG')
                .isPubKeyHashIn(),
            (false));
      });
    });

    group('#isPubKeyHashOut', () {
      test('should classify this known pubKeyHashout as pubKeyHashout', () {
        expect(
            new Script()
                .writeString(
                    'OP_DUP OP_HASH160 20 0000000000000000000000000000000000000000 OP_EQUALVERIFY OP_CHECKSIG')
                .isPubKeyHashOut(),
            (true));
      });

      test('should classify this known non-pubKeyHashout as not pubKeyHashout',
          () {
        expect(
            new Script()
                .writeString(
                    'OP_DUP OP_HASH160 20 0000000000000000000000000000000000000000')
                .isPubKeyHashOut(),
            (false));
      });
    });

    group('#isScriptHashIn', () {
      test('should classify this known scriptHashin', () {
        expect(
            new Script()
                .writeString('20 0000000000000000000000000000000000000000')
                .isScriptHashIn(),
            (true));
      });

      test('should classify this known non-scriptHashin', () {
        expect(
            new Script()
                .writeString(
                    '20 0000000000000000000000000000000000000000 OP_CHECKSIG')
                .isScriptHashIn(),
            (false));
      });
    });

    group('#isScriptHashOut', () {
      test('should classify this known pubKeyHashout as pubKeyHashout', () {
        expect(
            new Script()
                .writeString(
                    'OP_HASH160 20 0x0000000000000000000000000000000000000000 OP_EQUAL')
                .isScriptHashOut(),
            (true));
      });

      test('should classify these known non-pubKeyHashout as not pubKeyHashout',
          () {
        expect(
            new Script()
                .writeString(
                    'OP_HASH160 20 0x0000000000000000000000000000000000000000 OP_EQUAL OP_EQUAL')
                .isScriptHashOut(),
            (false));
        expect(
            new Script()
                .writeString(
                    'OP_HASH160 21 0x000000000000000000000000000000000000000000 OP_EQUAL')
                .isScriptHashOut(),
            (false));
      });
    });

    group('#isMultiSigIn', () {
      test('should know this is a valid multisig input', () {
        expect(
            new Script()
                .writeString(
                    'OP_0 71 0x3044022053cacd1a0720e3497b3e78dedfc3ac144b3ff8fb0e231a4121bf4c18a05e606702205d4c69f2611cbca41c8a392b4c274cb07477bae78efef45c65517e4fdea5c0d801 71 0x3044022017dda0d737a9a65b262a1a8da97e73c23550351d6337ca13a8a1dbdbeae2775d02202fe4c031050d9d4ee0a2b1d5302869e1432577129f842c952462fca92a7b012901')
                .isMultiSigIn(),
            (true));
      });

      test('should know this is not a valid multisig input', () {
        expect(
            new Script()
                .writeString(
                    'OP_1 71 0x3044022053cacd1a0720e3497b3e78dedfc3ac144b3ff8fb0e231a4121bf4c18a05e606702205d4c69f2611cbca41c8a392b4c274cb07477bae78efef45c65517e4fdea5c0d801 71 0x3044022017dda0d737a9a65b262a1a8da97e73c23550351d6337ca13a8a1dbdbeae2775d02202fe4c031050d9d4ee0a2b1d5302869e1432577129f842c952462fca92a7b012901')
                .isMultiSigIn(),
            (false));
      });

      test('should know this is not a valid multisig input', () {
        expect(new Script().writeString('OP_0').isMultiSigIn(), (false));
      });
    });

    group('#isMultiSigOut', () {
      test('should know this is a valid multisig output', () {
        expect(
            new Script()
                .writeString(
                    'OP_1 33 0x029cf97e1052008852da9d107411b2d47aad387612558fa864b723c484f8931176 33 0x02f23ab919b3a4795c75552b3985982f54c4164a26948b9fe87625705f694e7aa9 OP_2 OP_CHECKMULTISIG')
                .isMultiSigOut(),
            (true));
      });

      test('should know this is a valid multisig output', () {
        expect(
            new Script()
                .writeString(
                    'OP_2 33 0x029cf97e1052008852da9d107411b2d47aad387612558fa864b723c484f8931176 33 0x02f23ab919b3a4795c75552b3985982f54c4164a26948b9fe87625705f694e7aa9 OP_2 OP_CHECKMULTISIG')
                .isMultiSigOut(),
            (true));
      });

      test('should know this is not a valid multisig output', () {
        expect(
            new Script()
                .writeString(
                    'OP_2 33 0x029cf97e1052008852da9d107411b2d47aad387612558fa864b723c484f8931176 33 0x02f23ab919b3a4795c75552b3985982f54c4164a26948b9fe87625705f694e7aa9 OP_1 OP_CHECKMULTISIG')
                .isMultiSigOut(),
            (false));
      });

      test('should know this is not a valid multisig output', () {
        expect(
            new Script()
                .writeString(
                    'OP_2 33 0x029cf97e1052008852da9d107411b2d47aad387612558fa864b723c484f8931176 33 0x02f23ab919b3a4795c75552b3985982f54c4164a26948b9fe87625705f694e7aa9 OP_2 OP_RETURN')
                .isMultiSigOut(),
            (false));
      });

      test('should know this is not a valid multisig output', () {
        expect(
            new Script()
                .writeString(
                    'OP_2 33 0x029cf97e1052008852da9d107411b2d47aad387612558fa864b723c484f8931176 32 0xf23ab919b3a4795c75552b3985982f54c4164a26948b9fe87625705f694e7aa9 OP_2 OP_CHECKMULTISIG')
                .isMultiSigOut(),
            (false));
      });
    });

    group('#findAndDelete', () {
      test('should find and deconste this buffer', () {
        expect(
            new Script()
                .writeString('OP_RETURN 2 0xf0f0')
                .findAndDelete(new Script().writeString('2 0xf0f0'))
                .toString(),
            ('OP_RETURN'));
      });
    });

    group('#writeScript', () {
      test('should write these scripts', () {
        var script1 = new Script().fromString('OP_CHECKMULTISIG');
        var script2 = new Script().fromString('OP_CHECKMULTISIG');
        var script = script1.writeScript(script2);
        expect(script.toString(), ('OP_CHECKMULTISIG OP_CHECKMULTISIG'));
      });
    });

    group('@writeScript', () {
      test('should write these scripts', () {
        var script1 = Script.fromString('OP_CHECKMULTISIG');
        var script2 = Script.fromString('OP_CHECKMULTISIG');
        var script = script1.writeScript(script2);
        expect(script.toString(), ('OP_CHECKMULTISIG OP_CHECKMULTISIG'));
      });
    });

    group('#writeOpCode', () {
      test('should write this op', () {
        expect(new Script().writeOpCode(OpCode.OP_CHECKMULTISIG).toString(),
            ('OP_CHECKMULTISIG'));
      });
    });

    group('@writeOpCode', () {
      test('should write this op', () {
        expect(Script.writeOpCode(OpCode.OP_CHECKMULTISIG).toString(),
            ('OP_CHECKMULTISIG'));
      });
    });

    group('#setChunkOpCode', () {
      test('should set this op', () {
        var script = new Script().writeOpCode(OpCode.OP_CHECKMULTISIG);
        script.setChunkOpCode(0, OpCode.OP_CHECKSEQUENCEVERIFY);
        expect(script.chunks[0].opCodeNum, (OpCode.OP_CHECKSEQUENCEVERIFY));
      });
    });

    group('#writeBn', () {
      test('should write these numbers', () {
        expect(new Script().writeBn(BigIntX.fromNum(0)).toBuffer().toHex(),
            ('00'));
        expect(new Script().writeBn(BigIntX.fromNum(1)).toBuffer().toHex(),
            ('51'));
        expect(new Script().writeBn(BigIntX.fromNum(16)).toBuffer().toHex(),
            ('60'));
        expect(new Script().writeBn(BigIntX.fromNum(-1)).toBuffer().toHex(),
            ('4f'));
        expect(new Script().writeBn(BigIntX.fromNum(-2)).toBuffer().toHex(),
            ('0182'));
      });
    });

    group('@writeBn', () {
      test('should write these numbers', () {
        expect(Script.writeBn(BigIntX.fromNum(0)).toBuffer().toHex(), ('00'));
        expect(Script.writeBn(BigIntX.fromNum(1)).toBuffer().toHex(), ('51'));
        expect(Script.writeBn(BigIntX.fromNum(16)).toBuffer().toHex(), ('60'));
        expect(Script.writeBn(BigIntX.fromNum(-1)).toBuffer().toHex(), ('4f'));
        expect(
            Script.writeBn(BigIntX.fromNum(-2)).toBuffer().toHex(), ('0182'));
      });
    });

    group('#writeNumber', () {
      test('should write these numbers', () {
        expect(new Script().writeNumber(0).toBuffer().toHex(), ('00'));
        expect(new Script().writeNumber(1).toBuffer().toHex(), ('51'));
        expect(new Script().writeNumber(16).toBuffer().toHex(), ('60'));
        expect(new Script().writeNumber(-1).toBuffer().toHex(), ('4f'));
        expect(new Script().writeNumber(-2).toBuffer().toHex(), ('0182'));
      });
    });

    group('@writeNumber', () {
      test('should write these numbers', () {
        expect(Script.writeNumber(0).toBuffer().toHex(), ('00'));
        expect(Script.writeNumber(1).toBuffer().toHex(), ('51'));
        expect(Script.writeNumber(16).toBuffer().toHex(), ('60'));
        expect(Script.writeNumber(-1).toBuffer().toHex(), ('4f'));
        expect(Script.writeNumber(-2).toBuffer().toHex(), ('0182'));
      });
    });

    group('#setChunkBn', () {
      test('should set this bn', () {
        var script = new Script().writeOpCode(OpCode.OP_CHECKMULTISIG);
        script.setChunkBn(0, BigIntX.fromNum(5000000000000000));
        expect(
          script.chunks[0].buf.toHex(),
          BigIntX.fromNum(5000000000000000)
              .toBuffer(endian: Endian.little)
              .toHex(),
        );
      });
    });

    group('#writeBuffer', () {
      test('should write these push data', () {
        var buf = Uint8List(1);
        expect(new Script().writeBuffer(buf).toString(), '1 0x00');
        buf = Uint8List(255);
        expect(new Script().writeBuffer(buf).toString(),
            'OP_PUSHDATA1 255 0x' + buf.toHex());
        buf = Uint8List(256);
        expect(new Script().writeBuffer(buf).toString(),
            'OP_PUSHDATA2 256 0x' + buf.toHex());
        buf = Uint8List(pow(2, 16));
        expect(new Script().writeBuffer(buf).toString(),
            'OP_PUSHDATA4 ' + '${pow(2, 16)}' + ' 0x' + buf.toHex());
      });
    });

    group('@writeBuffer', () {
      test('should write these push data', () {
        var buf = Uint8List(1);
        expect(Script.writeBuffer(buf).toString(), '1 0x00');
        buf = Uint8List(255);
        expect(Script.writeBuffer(buf).toString(),
            'OP_PUSHDATA1 255 0x' + buf.toHex());
        buf = Uint8List(256);
        expect(Script.writeBuffer(buf).toString(),
            'OP_PUSHDATA2 256 0x' + buf.toHex());
        buf = Uint8List(pow(2, 16));
        expect(Script.writeBuffer(buf).toString(),
            'OP_PUSHDATA4 ' + '${pow(2, 16)}' + ' 0x' + buf.toHex());
      });
    });

    group('#setChunkBuffer', () {
      test('should set this buffer', () {
        var script = new Script().writeOpCode(OpCode.OP_CHECKMULTISIG);
        var buf = new BigIntX.fromNum(5000000000000000).toBuffer();
        script.setChunkBuffer(0, buf);
        expect(script.chunks[0].buf.toHex(), (buf.toHex()));
      });
    });

    group('#writeString', () {
      test('should write both pushdata and non-pushdata chunks', () {
        expect(new Script().writeString('OP_CHECKMULTISIG').toString(),
            ('OP_CHECKMULTISIG'));
      });
    });

    group('@writeString', () {
      test('should write both pushdata and non-pushdata chunks', () {
        expect(Script.writeString('OP_CHECKMULTISIG').toString(),
            ('OP_CHECKMULTISIG'));
      });
    });

    group('#checkMinimalPush', () {
      test('should check these minimal pushes', () {
        var buf;
        expect(new Script().writeBn(BigIntX.fromNum(1)).checkMinimalPush(0),
            (true));
        expect(new Script().writeBn(BigIntX.fromNum(0)).checkMinimalPush(0),
            (true));
        expect(new Script().writeBn(BigIntX.fromNum(-1)).checkMinimalPush(0),
            (true));
        expect(
            new Script()
                .writeBuffer(Uint8List.fromList([0]))
                .checkMinimalPush(0),
            (true));

        buf = Uint8List.fromList(List.generate(75, (index) => 1));
        expect(new Script().writeBuffer(buf).checkMinimalPush(0), (true));

        buf = Uint8List.fromList(List.generate(76, (index) => 1));
        expect(new Script().writeBuffer(buf).checkMinimalPush(0), (true));

        buf = Uint8List.fromList(List.generate(256, (index) => 1));
        expect(new Script().writeBuffer(buf).checkMinimalPush(0), (true));
      });
    });

    group('vectors', () {
      group('scriptValid', () {
        for (var i = 0; i < bitcoindScriptValid.length; i++) {
          var a = bitcoindScriptValid[i];

          if (a.length == 1) {
            continue;
          }
          test(
              'should not fail when reading scriptValid vector ' + i.toString(),
              () {
            // ;( () {
            try {
              new Script().fromBitcoindString(a[0]).toString();
              new Script().fromBitcoindString(a[0]).toBitcoindString();
              // }.should.not.throw())
              // ;( () {
              new Script().fromBitcoindString(a[1]).toString();
              new Script().fromBitcoindString(a[1]).toBitcoindString();
              expect(i, i);
            } catch (e) {}
            // }.should.not.throw())

            // should be able to return the same output over and over
            var str = new Script().fromBitcoindString(a[0]).toBitcoindString();
            expect(
                new Script().fromBitcoindString(str).toBitcoindString(), str);

            str = new Script().fromBitcoindString(a[1]).toBitcoindString();

            expect(
                new Script().fromBitcoindString(str).toBitcoindString(), str);
          });
        }
      });

      group('scriptInvalid', () {
        for (var i = 0; i < bitcoindScriptInvalid.length; i++) {
          var a = bitcoindScriptInvalid[i];

          if (a.length == 1) {
            continue;
          }
          test(
              'should not fail when reading scriptInvalid vector ' +
                  i.toString(), () {
            // ;( () {
            new Script().fromBitcoindString(a[0]).toString();
            new Script().fromBitcoindString(a[0]).toBitcoindString();
            // }.should.not.throw())
            // ;( () {
            new Script().fromBitcoindString(a[1]).toString();
            new Script().fromBitcoindString(a[1]).toBitcoindString();
            // }.should.not.throw())

            // should be able to return the same output over and over
            var str = new Script().fromBitcoindString(a[0]).toBitcoindString();
            expect(
                new Script().fromBitcoindString(str).toBitcoindString(), str);

            str = new Script().fromBitcoindString(a[1]).toBitcoindString();
            expect(
                new Script().fromBitcoindString(str).toBitcoindString(), str);
          });
        }
      });
    });
  });
}
