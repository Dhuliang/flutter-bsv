import 'dart:math';
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Br', () {
    // test('should make a new Br',  () {
    //   let br = new Br()
    //   should.exist(br)
    //   br = new Br()
    //   should.exist(br)
    // });

    // test('should create a new bufferreader with a buffer',  () {
    //   var buf = Buffer.alloc(0)
    //   var br = new Br(buf)
    //   should.exist(br)
    //   Buffer.isBuffer(br.buf).should.equal(true)
    // })

    // group('#fromObject',  () {
    //   test('should set pos',  () {
    //     should.exist(new Br().fromObject({ pos: 1 }).pos)
    //   })
    // })

    group('#eof', () {
      test('should return true for a blank br', () {
        var br = new Br();
        expect(br.eof(), true);
      });
    });

    group('#read', () {
      test('should return the same buffer', () {
        var buf = Uint8List.fromList([0]);
        var br = new Br(buf: buf);
        expect(hex.encode(br.read()), hex.encode(buf));
      });

      test('should return a buffer of this length', () {
        var buf = Uint8List.fromList(List.filled(10, 0));
        var br = new Br(buf: buf);
        var buf2 = br.read(2);
        expect(buf2.length, 2);
        expect(br.eof(), false);
        expect(br.pos, 2);
      });

      test('should be able to read 0 bytes', () {
        var buf = hex.decode('0101');
        expect(new Br(buf: buf as Uint8List?).read(0).length, 0);
      });
    });

    group('#readReverse', () {
      test('should reverse this [0, 1]', () {
        var buf = Uint8List.fromList([0, 1]);
        var br = new Br(buf: buf);

        expect(hex.encode(br.readReverse()), '0100');
      });

      test('should be able to read 0 bytes', () {
        var buf = Uint8List.fromList(hex.decode('0101'));
        expect(new Br(buf: buf).readReverse(0).length, 0);
      });
    });

    group('#readUInt8', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(1).buffer);
        view.setUint8(0, 1);
        var br = new Br.fromByteData(view);
        expect(br.readUInt8(), 1);
      });
    });

    group('#readInt8', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(1).buffer);
        view.setUint8(0, 1);
        var br = new Br.fromByteData(view);
        expect(br.readUInt8(), 1);
        expect(new Br(buf: hex.decode('ff') as Uint8List?).readInt8(), -1);
      });
    });

    group('#readUInt16BE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(2).buffer);
        view.setUint16(0, 1, Endian.big);
        var br = new Br.fromByteData(view);
        expect(br.readUInt16BE(), 1);
      });
    });

    group('#readInt16BE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(2).buffer);
        view.setInt16(0, 1, Endian.big);
        var br = new Br.fromByteData(view);
        expect(br.readUInt16BE(), 1);
        Br(buf: hex.decode('ffff') as Uint8List?).readInt16BE();
        expect(new Br(buf: hex.decode('ffff') as Uint8List?).readInt16BE(), -1);
      });
    });

    group('#readUInt16LE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(2).buffer);
        view.setInt16(0, 1, Endian.little);
        var br = new Br.fromByteData(view);
        expect(br.readUInt16LE(), 1);
      });
    });

    group('#readInt16LE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(2).buffer);
        view.setInt16(0, 1, Endian.little);
        var br = new Br.fromByteData(view);
        expect(br.readInt16LE(), 1);
        expect(new Br(buf: hex.decode('ffff') as Uint8List?).readInt16LE(), -1);
        // Uint8List.fromList(hex.decode('ffff')).buffer.asInt16List();
        // ByteData.view(Uint8List.fromList(hex.decode('ffff')).buffer)
        //     .getInt16(0, Endian.little);
        // ByteData.view(Uint8List.fromList(hex.decode('ffff')).buffer)
        //     .getInt16(0);
      });
    });

    group('#readUInt32BE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(4).buffer);
        view.setUint32(0, 1, Endian.big);
        var br = new Br.fromByteData(view);
        expect(br.readUInt32BE(), 1);
      });
    });

    group('#readInt32BE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(4).buffer);
        view.setInt32(0, 1, Endian.big);
        var br = new Br.fromByteData(view);
        expect(br.readInt32BE(), 1);
        expect(new Br(buf: hex.decode('ffffffff') as Uint8List?).readInt32BE(),
            -1);
      });
    });

    group('#readUInt32LE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(4).buffer);
        view.setUint32(0, 1, Endian.little);
        var br = new Br.fromByteData(view);
        expect(br.readUInt32LE(), 1);
      });
    });

    group('#readInt32LE', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(4).buffer);
        view.setInt32(0, 1, Endian.little);
        var br = new Br.fromByteData(view);
        expect(br.readInt32LE(), 1);
        expect(new Br(buf: hex.decode('ffffffff') as Uint8List?).readInt32LE(),
            -1);
      });
    });

    group('#readUInt64BEBn', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(8).buffer);
        view.setUint32(4, 1, Endian.big);

        var br = new Br.fromByteData(view);
        expect(br.readUInt64BEBn().toNumber(), 1);
      });

      test('should return 2^64', () {
        var view = ByteData.view(
            Uint8List.fromList(List.generate(8, (index) => 0xff)).buffer);
        var br = new Br.fromByteData(view);
        expect(
          br.readUInt64BEBn().bn == BigInt.parse('18446744073709551615'),
          true,
        );
      });
    });

    group('#readUInt64LEBn', () {
      test('should return 1', () {
        var view = ByteData.view(Uint8List(8).buffer);
        view.setUint32(0, 1, Endian.little);
        var br = new Br.fromByteData(view);

        expect(
          br.readUInt64LEBn().toNumber(),
          1,
        );
      });

      test('should return 2^30', () {
        var view = ByteData.view(Uint8List(8).buffer);
        view.setUint32(0, pow(2, 30) as int, Endian.little);
        var br = new Br.fromByteData(view);

        expect(
          br.readUInt64LEBn().toNumber(),
          pow(2, 30),
        );
      });

      test('should return 0', () {
        var view = ByteData.view(Uint8List(8).buffer);
        var br = new Br.fromByteData(view);
        expect(
          br.readUInt64LEBn().toNumber(),
          0,
        );
      });

      test('should return 2^64', () {
        var view = ByteData.view(
            Uint8List.fromList(List.generate(8, (index) => 0xff)).buffer);
        var br = new Br.fromByteData(view);
        expect(
          br.readUInt64LEBn().bn == BigInt.parse('18446744073709551615'),
          true,
        );
      });
    });

    group('#readVarIntBuf', () {
      test('should read a 1 byte varInt', () {
        var view = ByteData.view(Uint8List(50).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBuf().length, 1);
      });

      test('should read a 3 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([253, 253, 0]).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBuf().length, 3);
      });

      test('should read a 5 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([254, 0, 0, 0, 0]).buffer);
        view.setUint32(1, 50000, Endian.little);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBuf().length, 5);
      });

      test('should read a 9 byte varInt', () {
        var buf = Bw().writeVarIntBn(BigIntX.fromNum(pow(2, 54))).toBuffer();
        var view = ByteData.view(Uint8List.fromList(buf).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBuf().length, 9);
      });
    });

    group('#readVarIntNum', () {
      test('should read a 1 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([50]).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntNum(), 50);
      });

      test('should read a 3 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([253, 253, 0]).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntNum(), 253);
      });

      test('should read a 5 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([254, 0, 0, 0, 0]).buffer);
        view.setUint32(1, 50000, Endian.little);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntNum(), 50000);
      });

      test(
          'should throw an error on a 9 byte varInt over the javascript uint precision limit',
          () {
        var buf = Bw().writeVarIntBn(BigIntX.fromNum(pow(2, 54))).toBuffer();
        var view = ByteData.view(Uint8List.fromList(buf).buffer);
        var br = new Br.fromByteData(view);
        expect(
          () => br.readVarIntNum(),
          throwsA(Br.ERROR_NUMBER_TOO_LARGE),
        );
      });

      // test(
      //     'should not throw an error on a 9 byte varInt not over the javascript uint precision limit',
      //     () {
      //   var buf = Bw().writeVarIntBn(BigIntX.fromNum(pow(2, 53))).toBuffer();
      //   var view = ByteData.view(Uint8List.fromList(buf).buffer);
      //   var br = new Br.fromByteData(view);
      //   expect(
      //     () => br.readVarIntNum(),
      //     throwsA(Br.ERROR_NUMBER_TOO_LARGE),
      //   );
      // });
    });

    group('#readVarIntBn', () {
      test('should read a 1 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([50]).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBn().toNumber(), 50);
      });

      test('should read a 3 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([253, 253, 0]).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBn().toNumber(), 253);
      });

      test('should read a 5 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([254, 0, 0, 0, 0]).buffer);
        view.setUint32(1, 50000, Endian.little);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBn().toNumber(), 50000);
      });

      test('should read a 9 byte varInt', () {
        var view = ByteData.view(Uint8List.fromList([
          ...Uint8List.fromList([255]),
          ...hex.decode('ffffffffffffffff'),
        ]).buffer);
        var br = new Br.fromByteData(view);
        expect(br.readVarIntBn().bn, BigInt.parse('18446744073709551615'));
      });
    });
  });
}
