import 'package:bsv/src/bn.dart';
import 'package:bsv/src/sig.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bsv/src/extentsions/list.dart';
import 'package:bsv/src/extentsions/string.dart';

import 'vectors/sig.dart';

void main() {
  group('Sig', () {
    // test('should make a blank signature', () {
    // var sig = new Sig();
    // should.exist(sig)
    // });

    test('should work with conveniently setting r, s', () {
      var r = BigIntX.zero;
      var s = BigIntX.zero;
      var sig = new Sig(r: r, s: s);
      expect(sig.r.toString(), r.toString());
      expect(sig.s.toString(), s.toString());
    });

    // group('#fromObject',  () {
    //   test('should set compressed',  () {
    //     should.exist(new Sig().fromObject({ compressed: true }))
    //   })
    // })

    group('#fromHex', () {
      test('should parse this known signature and rebuild it', () {
        var hex =
            '3044022007415aa37ce7eaa6146001ac8bdefca0ddcba0e37c5dc08c4ac99392124ebac802207d382307fd53f65778b07b9c63b6e196edeadf0be719130c5db21ff1e700d67501';
        var sig = new Sig().fromHex(hex);
        expect(sig.toHex(), hex);
      });

      test('should create a signature from a compressed signature', () {
        var blank = List.generate(32, (index) => 0);

        var compressed = List<int>.from([
          ...[0 + 27 + 4],
          ...blank,
          ...blank
        ]);
        var sig = new Sig();
        sig.fromHex(compressed.toHex());
        expect(sig.r!.cmp(0), (0));
        expect(sig.s!.cmp(0), (0));
      });

      test('should parse this DER format signature', () {
        var buf = hex.decode(
          '3044022075fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e62770220729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
        );
        var sig = new Sig();
        sig.fromHex(buf.toHex());
        expect(
          sig.r!.toBuffer(size: 32).toHex(),
          '75fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e6277',
        );

        expect(
          sig.s!.toBuffer(size: 32).toHex(),
          '729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
        );
      });

      test('should parse this known signature and rebuild it', () {
        var hex =
            '3044022007415aa37ce7eaa6146001ac8bdefca0ddcba0e37c5dc08c4ac99392124ebac802207d382307fd53f65778b07b9c63b6e196edeadf0be719130c5db21ff1e700d67501';
        var sig = new Sig().fromHex(hex);
        expect(sig.toTxFormat().toHex(), hex);
      });
    });

    group('#fromBuffer', () {
      test('should create a signature from a compressed signature', () {
        var blank = List.generate(32, (index) => 0);

        var compressed = List<int>.from([
          ...[0 + 27 + 4],
          ...blank,
          ...blank
        ]);

        var sig = new Sig();
        sig.fromBuffer(compressed);
        expect(sig.r!.cmp(0), (0));
        expect(sig.s!.cmp(0), (0));
      });

      test('should parse this DER format signature', () {
        var buf = hex.decode(
          '3044022075fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e62770220729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
        );
        var sig = new Sig();
        sig.fromBuffer(buf);
        expect(
          sig.r!.toBuffer(size: 32).toHex(),
          '75fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e6277',
        );

        expect(
          sig.s!.toBuffer(size: 32).toHex(),
          '729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
        );
      });

      test('should parse this known signature and rebuild it', () {
        var str =
            '3044022007415aa37ce7eaa6146001ac8bdefca0ddcba0e37c5dc08c4ac99392124ebac802207d382307fd53f65778b07b9c63b6e196edeadf0be719130c5db21ff1e700d67501';
        var buf = hex.decode(str);
        var sig = new Sig().fromBuffer(buf);
        expect(sig.toTxFormat().toHex(), str);
      });
    });

    group('#fromCompact', () {
      test('should create a signature from a compressed signature', () {
        var blank = List.generate(32, (index) => 0);

        var compact = List<int>.from([
          ...[0 + 27 + 4],
          ...blank,
          ...blank
        ]);

        var sig = new Sig();
        sig.fromCompact(compact);
        expect(sig.compressed, (true));
        expect(sig.r!.cmp(0), (0));
        expect(sig.s!.cmp(0), (0));
      });
    });

    group('@fromCompact', () {
      test('should create a signature from a compressed signature', () {
        var blank = List.generate(32, (index) => 0);

        var compact = List<int>.from([
          ...[0 + 27 + 4],
          ...blank,
          ...blank
        ]);

        var sig = Sig.fromCompact(compact);
        expect(sig.compressed, (true));
        expect(sig.r!.cmp(0), (0));
        expect(sig.s!.cmp(0), (0));
      });
    });

    group('#fromDer', () {
      var buf = hex.decode(
        '3044022075fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e62770220729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
      );

      test('should parse this DER format signature', () {
        var sig = new Sig();
        sig.fromDer(buf);

        expect(
          sig.r!.toBuffer(size: 32).toHex(),
          '75fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e6277',
        );

        expect(
          sig.s!.toBuffer(size: 32).toHex(),
          '729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
        );
      });
    });

    group('@fromDer', () {
      var buf = hex.decode(
        '3044022075fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e62770220729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
      );

      test('should parse this DER format signature', () {
        var sig = Sig.fromDer(buf);

        expect(
          sig.r!.toBuffer(size: 32).toHex(),
          '75fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e6277',
        );

        expect(
          sig.s!.toBuffer(size: 32).toHex(),
          '729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
        );
      });
    });

    group('#fromTxFormat', () {
      test('should convert from this known tx-format buffer', () {
        var buf = hex.decode(
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e7201',
        );

        var sig = new Sig().fromTxFormat(buf);
        expect(
          sig.r.toString(),
          '63173831029936981022572627018246571655303050627048489594159321588908385378810',
        );

        expect(
          sig.s.toString(),
          '4331694221846364448463828256391194279133231453999942381442030409253074198130',
        );

        expect(sig.nHashType, (Sig.SIGHASH_ALL));
      });

      test('should parse this known signature and rebuild it', () {
        var str =
            '3044022007415aa37ce7eaa6146001ac8bdefca0ddcba0e37c5dc08c4ac99392124ebac802207d382307fd53f65778b07b9c63b6e196edeadf0be719130c5db21ff1e700d67501';
        var buf = hex.decode(str);
        var sig = new Sig().fromTxFormat(buf);
        expect(sig.toTxFormat().toHex(), str);
      });
    });

    group('@fromTxFormat', () {
      test('should convert from this known tx-format buffer', () {
        var buf = hex.decode(
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e7201',
        );

        var sig = Sig.fromTxFormat(buf);
        expect(
          sig.r.toString(),
          '63173831029936981022572627018246571655303050627048489594159321588908385378810',
        );

        expect(
          sig.s.toString(),
          '4331694221846364448463828256391194279133231453999942381442030409253074198130',
        );

        expect(sig.nHashType, (Sig.SIGHASH_ALL));
      });

      test('should parse this known signature and rebuild it', () {
        var str =
            '3044022007415aa37ce7eaa6146001ac8bdefca0ddcba0e37c5dc08c4ac99392124ebac802207d382307fd53f65778b07b9c63b6e196edeadf0be719130c5db21ff1e700d67501';
        var buf = hex.decode(str);
        var sig = Sig.fromTxFormat(buf);
        expect(sig.toTxFormat().toHex(), str);
      });
    });

    group('#fromString', () {
      var buf = hex.decode(
        '3044022075fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e62770220729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
      );

      test('should parse this DER format signature in hex', () {
        var sig = new Sig();
        sig.fromString(buf.toHex());

        expect(
          sig.r!.toBuffer(size: 32).toHex(),
          '75fc517e541bd54769c080b64397e32161c850f6c1b2b67a5c433affbb3e6277',
        );

        expect(
          sig.s!.toBuffer(size: 32).toHex(),
          '729e85cc46ffab881065ec07694220e71d4df9b2b8c8fd12c3122cf3a5efbcf2',
        );
      });
    });

    group('#parseDer', () {
      test('should parse this signature generated in node', () {
        var sighex =
            '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72';
        var sig = sighex.toBuffer();
        var parsed = Sig.parseDer(sig);
        expect(parsed['header'], (0x30));
        expect(parsed['length'], (69));
        expect(parsed['rlength'], (33));
        expect(parsed['rneg'], (true));
        expect(
          hex.encode(parsed['rbuf']),
          '008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa',
        );
        expect(
          parsed['r'].toString(),
          '63173831029936981022572627018246571655303050627048489594159321588908385378810',
        );

        expect(parsed['slength'], (32));
        expect(parsed['sneg'], (false));

        expect(
          hex.encode(parsed['sbuf']),
          '0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        expect(
          parsed['s'].toString(),
          '4331694221846364448463828256391194279133231453999942381442030409253074198130',
        );
      });

      test('should parse this 69 byte signature', () {
        var sighex =
            '3043021f59e4705959cc78acbfcf8bd0114e9cc1b389a4287fb33152b73a38c319b50302202f7428a27284c757e409bf41506183e9e49dfb54d5063796dfa0d403a4deccfa';
        var sig = sighex.toBuffer();
        var parsed = Sig.parseDer(sig);
        expect(parsed['header'], (0x30));
        expect(parsed['length'], (67));
        expect(parsed['rlength'], (31));
        expect(parsed['rneg'], (false));

        expect(
          hex.encode(parsed['rbuf']),
          '59e4705959cc78acbfcf8bd0114e9cc1b389a4287fb33152b73a38c319b503',
        );

        expect(
          parsed['r'].toString(),
          '158826015856106182499128681792325160381907915189052224498209222621383996675',
        );

        expect(parsed['slength'], (32));
        expect(parsed['sneg'], (false));

        expect(
          hex.encode(parsed['sbuf']),
          '2f7428a27284c757e409bf41506183e9e49dfb54d5063796dfa0d403a4deccfa',
        );

        expect(
          parsed['s'].toString(),
          '21463938592353267769710297084836796652964571266930856168996063301532842380538',
        );
      });

      test('should parse this 68 byte signature', () {
        var sighex =
            '3042021e17cfe77536c3fb0526bd1a72d7a8e0973f463add210be14063c8a9c37632022061bfa677f825ded82ba0863fb0c46ca1388dd3e647f6a93c038168b59d131a51';
        var sig = sighex.toBuffer();
        var parsed = Sig.parseDer(sig);
        expect(parsed['header'], (0x30));
        expect(parsed['length'], (66));
        expect(parsed['rlength'], (30));
        expect(parsed['rneg'], (false));

        expect(
          hex.encode(parsed['rbuf']),
          '17cfe77536c3fb0526bd1a72d7a8e0973f463add210be14063c8a9c37632',
        );

        expect(
          parsed['r'].toString(),
          '164345250294671732127776123343329699648286106708464198588053542748255794',
        );

        expect(parsed['slength'], (32));
        expect(parsed['sneg'], (false));

        expect(
          hex.encode(parsed['sbuf']),
          '61bfa677f825ded82ba0863fb0c46ca1388dd3e647f6a93c038168b59d131a51',
        );

        expect(
          parsed['s'].toString(),
          '44212963026209759051804639008236126356702363229859210154760104982946304432721',
        );
      });
    });

    group('@IsTxDer', () {
      test('should know this is a DER signature', () {
        var sighex =
            '3042021e17cfe77536c3fb0526bd1a72d7a8e0973f463add210be14063c8a9c37632022061bfa677f825ded82ba0863fb0c46ca1388dd3e647f6a93c038168b59d131a5101';
        var sigbuf = sighex.toBuffer();
        expect(Sig.IsTxDer(sigbuf), true);
      });

      test('should know this is not a DER signature', () {
        // for more extensive tests, see the script interpreter
        var sighex =
            '3042021e17cfe77536c3fb0526bd1a72d7a8e0973f463add210be14063c8a9c37632022061bfa677f825ded82ba0863fb0c46ca1388dd3e647f6a93c038168b59d131a5101';
        var sigbuf = sighex.toBuffer();
        sigbuf[0] = 0x31;
        expect(Sig.IsTxDer(sigbuf), false);
      });
    });

    group('#toHex', () {
      test('should convert these known r and s values into a known signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');
        var sig = new Sig(r: r, s: s);
        expect(
          sig.toHex(),
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );
      });

      test(
          'should convert these known r, s, nHashType values into a known signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');
        var nHashType = Sig.SIGHASH_ALL;
        var sig = new Sig(r: r, s: s, nHashType: nHashType);

        expect(
          sig.toHex(),
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e7201',
        );
      });

      test(
          'should convert these known r and s values and guessed i values into signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var sig = Sig(r: r, s: s, recovery: 0);
        expect(
          sig.toHex(),
          '1f8bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 1);
        expect(
          sig.toHex(),
          '208bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 2);

        expect(
          sig.toHex(),
          '218bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 3);

        expect(
          sig.toHex(),
          '228bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );
      });
    });

    group('#toBuffer', () {
      test('should convert these known r and s values into a known signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var sig = Sig(r: r, s: s);
        var der = sig.toBuffer();
        expect(
          der.toHex(),
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );
      });

      test(
          'should convert these known r, s, nHashType values into a known signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var nHashType = Sig.SIGHASH_ALL;
        var sig = new Sig(r: r, s: s, nHashType: nHashType);
        var buf = sig.toBuffer();
        expect(
          buf.toHex(),
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e7201',
        );
      });

      test(
          'should convert these known r and s values and guessed recovery values into signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var sig = Sig(r: r, s: s, recovery: 0);

        expect(
          sig.toBuffer().toHex(),
          '1f8bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 1);

        expect(
          sig.toBuffer().toHex(),
          '208bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 2);
        expect(
          sig.toBuffer().toHex(),
          '218bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 3);

        expect(
          sig.toBuffer().toHex(),
          '228bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );
      });
    });

    group('#toCompact', () {
      test(
          'should convert these known r and s values and guessed i values into signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var sig = Sig(r: r, s: s, recovery: 0);
        expect(
          sig.toCompact().toHex(),
          '1f8bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );
        sig = Sig(r: r, s: s, recovery: 1);
        expect(
          sig.toCompact().toHex(),
          '208bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 2);
        expect(
          sig.toCompact().toHex(),
          '218bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );

        sig = Sig(r: r, s: s, recovery: 3);

        expect(
          sig.toCompact().toHex(),
          '228bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa0993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );
      });
    });

    group('#toDer', () {
      test('should convert these known r and s values into a known signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var sig = Sig(r: r, s: s);
        var der = sig.toDer();
        expect(
          der.toHex(),
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72',
        );
      });
    });

    group('#toTxFormat', () {
      test(
          'should convert these known r, s, nHashType values into a known signature',
          () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var nHashType = Sig.SIGHASH_ALL;
        var sig = new Sig(r: r, s: s, nHashType: nHashType);
        var buf = sig.toTxFormat();
        expect(
          buf.toHex(),
          '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e7201',
        );
      });
    });

    group('#toString', () {
      test('should convert this signature in to hex DER', () {
        var r = BigIntX.fromString(
            '63173831029936981022572627018246571655303050627048489594159321588908385378810');
        var s = BigIntX.fromString(
            '4331694221846364448463828256391194279133231453999942381442030409253074198130');

        var sig = Sig(r: r, s: s);
        var hexStr = sig.toString();
        expect(hexStr,
            '30450221008bab1f0a2ff2f9cb8992173d8ad73c229d31ea8e10b0f4d4ae1a0d8ed76021fa02200993a6ec81755b9111762fc2cf8e3ede73047515622792110867d12654275e72');
      });
    });

    group('vectors', () {
      // TODOS: These vectors were taken from BitcoinJS-lib during a debugging
      // expedition. I only took a subset relevant for the stuff I wanted to
      // test, but it would be valuable to revisit these test vectors and make
      // sure all of them pass.

      for (var i = 0; i < sigVector['valid'].length; i++) {
        var vector = sigVector['valid'][i];
        test('should pass this vector', () {
          var compact = vector['compact'];
          var sig = Sig.fromCompact(hex.decode(compact['hex']));
          expect(sig.recovery, (compact['i']));
          expect(sig.compressed, (compact['compressed']));
          expect(sig.toCompact().toHex(), (compact['hex']));
        });
      }

      for (var i = 0; i < sigVector['invalid']['compact'].length; i++) {
        var compact = sigVector['invalid']['compact'][i];
        test('should pass this vector', () {
          expect(
            () => Sig.fromCompact(hex.decode(compact['hex'])),
            throwsA((temp) => temp is String),
          );
        });
      }
    });
  });
}
