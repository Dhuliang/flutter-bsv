import 'dart:math';
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bw', () {
    group('base constructor', () {
      test('set bufs', () {
        var buf1 = Uint8List.fromList([0]);
        var buf2 = Uint8List.fromList([1]);
        var bufs = [buf1, buf2];
        var bw = new Bw(bufs: bufs);
        expect(bw.toHex(), '0001');
      });
    });

    group('#getLength', () {
      test('should compute length correctly of two 2 byte buffers', () {
        var buf1 = Uint8List.fromList(hex.decode('0000'));
        var buf2 = Uint8List.fromList(hex.decode('0000'));
        var bw = new Bw().write(buf1).write(buf2);
        expect(bw.getLength(), 4);
      });
    });

    group('#toBuffer', () {
      test('should concat these two bufs', () {
        var buf1 = Uint8List.fromList([0]);
        var buf2 = Uint8List.fromList([1]);
        var bufs = [buf1, buf2];

        var bw = new Bw(bufs: bufs);
        expect(bw.toHex(), '0001');
      });
    });

    group('#write', () {
      test('should write a buffer', () {
        var buf = Uint8List.fromList([0]);
        var bw = new Bw();
        bw.write(buf);
        expect(bw.toHex(), '00');
      });
    });

    group('#writeReverse', () {
      test('should write a buffer in reverse', () {
        var buf = Uint8List.fromList([0, 1]);
        var bw = new Bw();
        bw.writeReverse(buf);
        expect(bw.toHex(), '0100');
      });
    });

    group('#writeUInt8', () {
      test('should write 1', () {
        var bw = new Bw();
        expect(bw.writeUInt8(1).toHex(), '01');
      });
    });

    group('#writeInt8', () {
      test('should write 1', () {
        var bw = new Bw();

        expect(bw.writeInt8(1).toHex(), '01');
        expect(new Bw().writeInt8(-1).toHex(), 'ff');
      });
    });

    group('#writeUInt16BE', () {
      test('should write 1', () {
        var bw = new Bw();
        expect(bw.writeUInt16BE(1).toHex(), '0001');
      });
    });

    group('#writeInt16BE', () {
      test('should write 1', () {
        var bw = new Bw();
        expect(bw.writeInt16BE(1).toHex(), '0001');
        expect(new Bw().writeInt16BE(-1).toHex(), 'ffff');
      });
    });

    group('#writeUInt16LE', () {
      test('should write 1', () {
        var bw = new Bw();
        expect(bw.writeUInt16LE(1).toHex(), '0100');
      });
    });

    group('#writeInt16LE', () {
      test('should write 1', () {
        var bw = new Bw();
        expect(bw.writeInt16LE(1).toHex(), '0100');
        expect(new Bw().writeInt16LE(-1).toHex(), 'ffff');
      });
    });

    group('#writeUInt32BE', () {
      test('should write 1', () {
        var bw = new Bw();

        expect(bw.writeUInt32BE(1).toHex(), '00000001');
      });
    });

    group('#writeInt32BE', () {
      test('should write 1', () {
        var bw = new Bw();

        expect(bw.writeInt32BE(1).toHex(), '00000001');
        expect(new Bw().writeInt32BE(-1).toHex(), 'ffffffff');
      });
    });

    group('#writeUInt32LE', () {
      test('should write 1', () {
        var bw = new Bw();

        expect(bw.writeUInt32LE(1).toHex(), '01000000');
      });
    });

    group('#writeInt32LE', () {
      test('should write 1', () {
        var bw = new Bw();
        expect(bw.writeInt32LE(1).toHex(), '01000000');
        expect(new Bw().writeInt32LE(-1).toHex(), 'ffffffff');
      });
    });

    group('#writeUInt64BEBn', () {
      test('should write 1', () {
        var bw = new Bw();

        expect(bw.writeUInt64BEBn(BigIntX.one).toHex(), '0000000000000001');
      });
    });

    group('#writeUInt64LEBn', () {
      test('should write 1', () {
        var bw = new Bw();
        expect(bw.writeUInt64LEBn(BigIntX.one).toHex(), '0100000000000000');
      });
    });

    group('#writeVarInt', () {
      test('should write a 1 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntNum(1);
        expect(bw.toBuffer().length, 1);
      });

      test('should write a 3 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntNum(1000);
        expect(bw.toBuffer().length, 3);
      });

      test('should write a 5 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntNum(pow(2, 16 + 1) as int);
        expect(bw.toBuffer().length, 5);
      });

      test('should write a 9 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntNum(pow(2, 32 + 1) as int);
        expect(bw.toBuffer().length, 9);
      });

      test('should read back the same value it wrote for a 9 byte varInt', () {
        var bw = new Bw();
        var n = pow(2, 63) - 1;
        bw.writeVarIntNum(n as int);
        var br = new Br(buf: Uint8List.fromList(bw.toBuffer()));
        expect(br.readVarIntBn().toNumber(), n);
      });
    });

    group('#writeVarIntBn', () {
      test('should write a 1 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntBn(BigIntX.one);
        expect(bw.toBuffer().length, 1);
      });

      test('should write a 3 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntBn(BigIntX.fromNum(1000));
        expect(bw.toBuffer().length, 3);
      });

      test('should write a 5 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntBn(BigIntX.fromNum(pow(2, 16 + 1)));
        expect(bw.toBuffer().length, 5);
      });

      test('should write a 9 byte varInt', () {
        var bw = new Bw();
        bw.writeVarIntBn(BigIntX.fromNum(pow(2, 32 + 1)));
        expect(bw.toBuffer().length, 9);
      });
    });
  });
}
