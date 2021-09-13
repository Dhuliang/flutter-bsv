import 'package:bsv/src/op_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OpCode', () {
    test('should create a new OpCode', () {
      var opCode = new OpCode(number: 5);
      // ignore: unnecessary_null_comparison
      expect(opCode.number != null, true);
    });

    test('should have 124 opCodes', () {
      var i = 0;
      for (var item in OpCode.map.entries) {
        if (item.key.indexOf('OP_') != -1) {
          i++;
        }
      }
      expect(i, 124);
    });

    test('should convert to a string with this handy syntax', () {
      expect(new OpCode(number: 0).toString(), 'OP_0');
      expect(new OpCode(number: 96).toString(), 'OP_16');
      expect(new OpCode(number: 97).toString(), 'OP_NOP');
    });

    test('should convert to a number with this handy syntax', () {
      expect(new OpCode.fromString('OP_0').toNumber(), 0);

      expect(new OpCode.fromString('OP_16').toNumber(), 96);

      expect(new OpCode.fromString('OP_NOP').toNumber(), 97);
    });

    group('#fromNumber', () {
      test('should work for 0', () {
        expect(OpCode.fromNumber(0).number, 0);
      });
    });

    group('#toNumber', () {
      test('should work for 0', () {
        expect(OpCode.fromNumber(0).toNumber(), 0);
      });
    });

    group('#fromString', () {
      test('should work for OP_0', () {
        expect(OpCode.fromString('OP_0').number, 0);
      });
    });

    group('#toString', () {
      test('should work for OP_0', () {
        expect(OpCode.fromString('OP_0').toString(), 'OP_0');
      });
    });

    group('@str', () {
      test('should exist and have op 185', () {
        expect(OpCode.str.entries.length > 0, true);
        expect(OpCode.str[185], 'OP_NOP10');
      });
    });
  });
}
