import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/var_int.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  group('VarInt', () {
    test('should make a new varInt', () {
      var buf = hex.decode('00');
      var varInt = new VarInt(buf: buf);

      expect(varInt.buf.toHex(), ('00'));

      varInt = new VarInt(buf: buf);

      // varInts can have multiple buffer representations
      expect(
        VarInt.fromNumber(0).toNumber(),
        VarInt(buf: List<int>.from([0xfd, 0, 0])).toNumber(),
      );

      expect(
        VarInt.fromNumber(0).toBuffer().toHex() ==
            VarInt()
                .fromBuffer(List<int>.from([0xfd, 0, 0]))
                .toBuffer()
                .toHex(),
        false,
      );
    });

    // group('#fromObject',  () {
    //   test('should set a buffer',  () {
    //     var buf = Buffer.from('00', 'hex')
    //     var varInt = new VarInt().fromObject({ buf: buf })
    //     varInt.buf.toString('hex').should.equal('00')
    //     varInt.fromObject({})
    //     varInt.buf.toString('hex').should.equal('00')
    //   })
    // })

    group('#fromJSON', () {
      test('should set a buffer', () {
        var buf = new Bw().writeVarIntNum(5).toBuffer();
        var varInt = new VarInt().fromJSON(buf.toHex());
        expect(varInt.toNumber(), 5);
      });
    });

    group('#toJSON', () {
      test('should return a buffer', () {
        var buf = new Bw().writeVarIntNum(5).toBuffer();
        var varInt = new VarInt().fromJSON(buf.toHex());
        expect(varInt.toJSON(), '05');
      });
    });

    group('#fromBuffer', () {
      test('should set a buffer', () {
        var buf = new Bw().writeVarIntNum(5).toBuffer();
        var varInt = new VarInt().fromBuffer(buf);
        expect(varInt.toNumber(), 5);
      });
    });

    group('#fromBr', () {
      test('should set a buffer reader', () {
        var buf = new Bw().writeVarIntNum(5).toBuffer();
        var br = new Br(buf: buf.asUint8List());
        var varInt = new VarInt().fromBr(br);
        expect(varInt.toNumber(), 5);
      });
    });

    group('#fromBn', () {
      test('should set a number', () {
        var varInt = new VarInt().fromBn(new BigIntX.fromNum(5));
        expect(varInt.toNumber(), 5);
      });
    });

    group('@fromBn', () {
      test('should set a number', () {
        var varInt = VarInt.fromBn(new BigIntX.fromNum(5));
        expect(varInt.toNumber(), 5);
      });
    });

    group('#fromNumber', () {
      test('should set a number', () {
        var varInt = new VarInt().fromNumber(5);
        expect(varInt.toNumber(), 5);
      });
    });

    group('@fromNumber', () {
      test('should set a number', () {
        var varInt = VarInt.fromNumber(5);
        expect(varInt.toNumber(), 5);
      });
    });

    group('#toBuffer', () {
      test('should return a buffer', () {
        var buf = new Bw().writeVarIntNum(5).toBuffer();
        var varInt = new VarInt(buf: buf);
        expect(varInt.toBuffer().toHex(), buf.toHex());
      });
    });

    group('#toBn', () {
      test('should return a buffer', () {
        var varInt = VarInt.fromNumber(5);
        expect(varInt.toBn().toString(), BigIntX.fromNum(5).toString());
      });
    });

    group('#toNumber', () {
      test('should return a buffer', () {
        var varInt = VarInt.fromNumber(5);
        expect(varInt.toNumber(), 5);
      });
    });
  });
}
