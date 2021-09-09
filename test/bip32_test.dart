import 'package:bsv/bip32.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:convert/convert.dart';
import 'package:bs58check/bs58check.dart' as Base58Check;
import 'package:bsv/extentsions/list.dart';

void main() {
  group('Bip32', () {
    test('should satisfy these basic API features', () {
      expect(
        Bip32.fromRandom().toString().substring(0, 4),
        'xprv',
      );
      expect(
        Bip32.fromRandom().toPublic().toString().substring(0, 4),
        'xpub',
      );
      expect(
        Bip32.Testnet().fromRandom().toString().substring(0, 4),
        'tprv',
      );
      expect(
        Bip32.Testnet().fromRandom().toPublic().toString().substring(0, 4),
        'tpub',
      );

      // List.generate(100, (index) {
      //   print(Bip32.fromRandom().toString());
      //   print(Bip32.fromRandom().toPublic().toString());
      //   print(Bip32.Testnet().fromRandom().toString());
      //   print(Bip32.Testnet().fromRandom().toPublic().toString());
      // });
    });

    // test vectors: https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki
    var vector1master = '000102030405060708090a0b0c0d0e0f';
    var vector1mPublic =
        'xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8';
    var vector1mPrivate =
        'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi';
    var vector1m0hPublic =
        'xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw';
    var vector1m0hPrivate =
        'xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7';
    var vector1m0h1Public =
        'xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ';
    var vector1m0h1Private =
        'xprv9wTYmMFdV23N2TdNG573QoEsfRrWKQgWeibmLntzniatZvR9BmLnvSxqu53Kw1UmYPxLgboyZQaXwTCg8MSY3H2EU4pWcQDnRnrVA1xe8fs';
    var vector1m0h12hPublic =
        'xpub6D4BDPcP2GT577Vvch3R8wDkScZWzQzMMUm3PWbmWvVJrZwQY4VUNgqFJPMM3No2dFDFGTsxxpG5uJh7n7epu4trkrX7x7DogT5Uv6fcLW5';
    var vector1m0h12hPrivate =
        'xprv9z4pot5VBttmtdRTWfWQmoH1taj2axGVzFqSb8C9xaxKymcFzXBDptWmT7FwuEzG3ryjH4ktypQSAewRiNMjANTtpgP4mLTj34bhnZX7UiM';
    var vector1m0h12h2Public =
        'xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV';
    var vector1m0h12h2Private =
        'xprvA2JDeKCSNNZky6uBCviVfJSKyQ1mDYahRjijr5idH2WwLsEd4Hsb2Tyh8RfQMuPh7f7RtyzTtdrbdqqsunu5Mm3wDvUAKRHSC34sJ7in334';
    var vector1m0h12h21000000000Public =
        'xpub6H1LXWLaKsWFhvm6RVpEL9P4KfRZSW7abD2ttkWP3SSQvnyA8FSVqNTEcYFgJS2UaFcxupHiYkro49S8yGasTvXEYBVPamhGW6cFJodrTHy';
    var vector1m0h12h21000000000Private =
        'xprvA41z7zogVVwxVSgdKUHDy1SKmdb533PjDz7J6N6mV6uS3ze1ai8FHa8kmHScGpWmj4WggLyQjgPie1rFSruoUihUZREPSL39UNdE3BBDu76';
    var vector2master =
        'fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542';
    var vector2mPublic =
        'xpub661MyMwAqRbcFW31YEwpkMuc5THy2PSt5bDMsktWQcFF8syAmRUapSCGu8ED9W6oDMSgv6Zz8idoc4a6mr8BDzTJY47LJhkJ8UB7WEGuduB';
    var vector2mPrivate =
        'xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U';
    var vector2m0Public =
        'xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH';
    var vector2m0Private =
        'xprv9vHkqa6EV4sPZHYqZznhT2NPtPCjKuDKGY38FBWLvgaDx45zo9WQRUT3dKYnjwih2yJD9mkrocEZXo1ex8G81dwSM1fwqWpWkeS3v86pgKt';
    var vector2m02147483647hPublic =
        'xpub6ASAVgeehLbnwdqV6UKMHVzgqAG8Gr6riv3Fxxpj8ksbH9ebxaEyBLZ85ySDhKiLDBrQSARLq1uNRts8RuJiHjaDMBU4Zn9h8LZNnBC5y4a';
    var vector2m02147483647hPrivate =
        'xprv9wSp6B7kry3Vj9m1zSnLvN3xH8RdsPP1Mh7fAaR7aRLcQMKTR2vidYEeEg2mUCTAwCd6vnxVrcjfy2kRgVsFawNzmjuHc2YmYRmagcEPdU9';
    var vector2m02147483647h1Public =
        'xpub6DF8uhdarytz3FWdA8TvFSvvAh8dP3283MY7p2V4SeE2wyWmG5mg5EwVvmdMVCQcoNJxGoWaU9DCWh89LojfZ537wTfunKau47EL2dhHKon';
    var vector2m02147483647h1Private =
        'xprv9zFnWC6h2cLgpmSA46vutJzBcfJ8yaJGg8cX1e5StJh45BBciYTRXSd25UEPVuesF9yog62tGAQtHjXajPPdbRCHuWS6T8XA2ECKADdw4Ef';
    var vector2m02147483647h12147483646hPublic =
        'xpub6ERApfZwUNrhLCkDtcHTcxd75RbzS1ed54G1LkBUHQVHQKqhMkhgbmJbZRkrgZw4koxb5JaHWkY4ALHY2grBGRjaDMzQLcgJvLJuZZvRcEL';
    var vector2m02147483647h12147483646hPrivate =
        'xprvA1RpRA33e1JQ7ifknakTFpgNXPmW2YvmhqLQYMmrj4xJXXWYpDPS3xz7iAxn8L39njGVyuoseXzU6rcxFLJ8HFsTjSyQbLYnMpCqE2VbFWc';
    var vector2m02147483647h12147483646h2Public =
        'xpub6FnCn6nSzZAw5Tw7cgR9bi15UV96gLZhjDstkXXxvCLsUXBGXPdSnLFbdpq8p9HmGsApME5hQTZ3emM2rnY5agb9rXpVGyy3bdW6EEgAtqt';
    var vector2m02147483647h12147483646h2Private =
        'xprvA2nrNbFZABcdryreWet9Ea4LvTJcGsqrMzxHx98MMrotbir7yrKCEXw7nadnHM8Dq38EGfSh6dqA9QWTyefMLEcBYJUuekgW4BYPJcr9E7j';

    test('should make a new a bip32', () {
      expect(
          new Bip32().fromString(vector1mPrivate).toString(), vector1mPrivate);
      expect(
          new Bip32().fromString(vector1mPrivate).toString(), vector1mPrivate);
      expect(
        new Bip32()
            .fromString(new Bip32().fromString(vector1mPrivate).toString())
            .toString(),
        vector1mPrivate,
      );
    });

    test('should initialize test vector 1 from the extended public key', () {
      var bip32 = new Bip32().fromString(vector1mPublic);
      // expect(bip32 != null, true);
      expect(bip32.pubKey != null, true);
    });

    test('should initialize test vector 1 from the extended private key', () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      // expect(bip32 != null, true);
      expect(bip32.privKey != null, true);
    });

    test(
        'should get the extended public key from the extended private key for test vector 1',
        () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      expect(bip32.toPublic().toString(), vector1mPublic);
    });

    test("should get m/0' ext. private key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'");
      // expect(child != null, true);
      expect(child.toString(), vector1m0hPrivate);
    });

//   test("should asynchronously get m/0' ext. private key from test vector 1", async () {
//     var bip32 = new Bip32().fromString(vector1mPrivate)
//     var child = await bip32.asyncDerive("m/0'")
//     expect(child != null, true);
//     child.toString().should.equal(vector1m0hPrivate)
//   })

    test("should get m/0' ext. public key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'");
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector1m0hPublic);
    });

    test("should get m/0'/1 ext. private key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1");
      // expect(child != null, true);
      expect(child.toString(), vector1m0h1Private);
    });

    test("should get m/0'/1 ext. public key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1");
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector1m0h1Public);
    });

    test(
        "should get m/0'/1 ext. public key from m/0' public key from test vector 1",
        () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'");
      var childPub = new Bip32().fromString(child.toPublic().toString());
      var child2 = childPub.derive('m/1');
      // expect(child2 != null, true);
      expect(child2.toPublic().toString(), vector1m0h1Public);
    });

//   test("should asynchronously get m/0'/1 ext. public key from m/0' public key from test vector 1", async () {
//     var bip32 = new Bip32().fromString(vector1mPrivate)
//     var child = bip32.derive("m/0'")
//     var childPub = new Bip32().fromString(child.toPublic().toString())
//     var child2 = await childPub.asyncDerive('m/1')
// expect(child2 != null, true);
//     child2
//       .toPublic()
//       .toString()
//       .should.equal(vector1m0h1Public)
//   })

    test("should get m/0'/1/2h ext. private key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'");
      // expect(child != null, true);
      expect(child.toString(), vector1m0h12hPrivate);
    });

    test("should get m/0'/1/2h ext. public key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'");
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector1m0h12hPublic);
    });

    test("should get m/0'/1/2h/2 ext. private key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'/2");
      // expect(child != null, true);
      expect(child.toString(), vector1m0h12h2Private);
    });

    test(
        "should get m/0'/1/2'/2 ext. public key from m/0'/1/2' public key from test vector 1",
        () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'");
      var childPub = new Bip32().fromString(child.toPublic().toString());
      var child2 = childPub.derive('m/2');
      // expect(child2 != null, true);
      expect(child2.toPublic().toString(), vector1m0h12h2Public);
    });

    test("should get m/0'/1/2h/2 ext. public key from test vector 1", () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'/2");
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector1m0h12h2Public);
    });

    test(
        "should get m/0'/1/2h/2/1000000000 ext. private key from test vector 1",
        () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'/2/1000000000");
      // expect(child != null, true);

      expect(child.toString(), vector1m0h12h21000000000Private);
    });

    test("should get m/0'/1/2h/2/1000000000 ext. public key from test vector 1",
        () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'/2/1000000000");
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector1m0h12h21000000000Public);
    });

    test(
        "should get m/0'/1/2'/2/1000000000 ext. public key from m/0'/1/2'/2 public key from test vector 1",
        () {
      var bip32 = new Bip32().fromString(vector1mPrivate);
      var child = bip32.derive("m/0'/1/2'/2");
      var childPub = new Bip32().fromString(child.toPublic().toString());
      var child2 = childPub.derive('m/1000000000');
      // expect(child2 != null, true);
      expect(child2.toPublic().toString(), vector1m0h12h21000000000Public);
    });

    test('should initialize test vector 2 from the extended public key', () {
      var bip32 = new Bip32().fromString(vector2mPublic);
      // expect(bip32 != null, true);
      expect(bip32.pubKey != null, true);
    });

    test('should initialize test vector 2 from the extended private key', () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      // expect(bip32 != null, true);
      expect(bip32.privKey != null, true);
    });

    test(
        'should get the extended public key from the extended private key for test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      expect(bip32.toPublic().toString(), vector2mPublic);
    });

    test('should get m/0 ext. private key from test vector 2', () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive('m/0');
      // expect(child != null, true);
      expect(child.toString(), vector2m0Private);
    });

    test('should get m/0 ext. public key from test vector 2', () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive('m/0');
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector2m0Public);
    });

    test('should get m/0 ext. public key from m public key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive('m');
      var childPub = new Bip32().fromString(child.toPublic().toString());
      var child2 = childPub.derive('m/0');
      // expect(child2 != null, true);
      expect(child2.toPublic().toString(), vector2m0Public);
    });

    test('should get m/0/2147483647h ext. private key from test vector 2', () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'");
      // expect(child != null, true);
      expect(child.toString(), vector2m02147483647hPrivate);
    });

    test('should get m/0/2147483647h ext. public key from test vector 2', () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'");
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector2m02147483647hPublic);
    });

    test('should get m/0/2147483647h/1 ext. private key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'/1");
      // expect(child != null, true);
      expect(child.toString(), vector2m02147483647h1Private);
    });

    test('should get m/0/2147483647h/1 ext. public key from test vector 2', () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'/1");
      // expect(child != null, true);
      expect(child.toPublic().toString(), vector2m02147483647h1Public);
    });

    test(
        'should get m/0/2147483647h/1 ext. public key from m/0/2147483647h public key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'");
      var childPub = new Bip32().fromString(child.toPublic().toString());
      var child2 = childPub.derive('m/1');
      // expect(child2 != null, true);
      expect(child2.toPublic().toString(), vector2m02147483647h1Public);
    });

    test(
        'should get m/0/2147483647h/1/2147483646h ext. private key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'/1/2147483646'");
      // expect(child != null, true);
      expect(child.toString(), vector2m02147483647h12147483646hPrivate);
    });

    test(
        'should get m/0/2147483647h/1/2147483646h ext. public key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'/1/2147483646'");
      // expect(child != null, true);
      expect(
          child.toPublic().toString(), vector2m02147483647h12147483646hPublic);
    });

    test(
        'should get m/0/2147483647h/1/2147483646h/2 ext. private key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'/1/2147483646'/2");
      // expect(child != null, true);
      expect(child.toString(), vector2m02147483647h12147483646h2Private);
    });

    test(
        'should get m/0/2147483647h/1/2147483646h/2 ext. public key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'/1/2147483646'/2");
      // expect(child != null, true);
      expect(
          child.toPublic().toString(), vector2m02147483647h12147483646h2Public);
    });

    test(
        'should get m/0/2147483647h/1/2147483646h/2 ext. public key from m/0/2147483647h/2147483646h public key from test vector 2',
        () {
      var bip32 = new Bip32().fromString(vector2mPrivate);
      var child = bip32.derive("m/0/2147483647'/1/2147483646'");
      var childPub = new Bip32().fromString(child.toPublic().toString());
      var child2 = childPub.derive('m/2');
      // expect(child2 != null, true);
      expect(child2.toPublic().toString(),
          vector2m02147483647h12147483646h2Public);
    });

    group('testnet', () {
      test('should initialize a new Bip32 correctly from a random Bip32', () {
        var b1 = new Bip32.Testnet();
        b1.fromRandom();
        // ;(b1.privKey instanceof PrivKey.Testnet).should.equal(true)
        var b2 = new Bip32.Testnet().fromString(b1.toPublic().toString());
        expect(b2.toPublic().toString(), b1.toPublic().toString());
      });

      test('should generate valid ext pub key for testnet', () {
        var b = new Bip32.Testnet();
        b.fromRandom();
        // ;(b.privKey instanceof PrivKey.Testnet).should.equal(true)
        expect(b.toPublic().toString().substring(0, 4), 'tpub');
      });
    });

    group('#fromObject', () {
      test('should set this bip32', () {
        var bip32 = new Bip32().fromString(vector1mPrivate);
        var bip322 = new Bip32(
          versionBytesNum: bip32.versionBytesNum,
          depth: bip32.depth,
          parentFingerPrint: bip32.parentFingerPrint,
          childIndex: bip32.childIndex,
          chainCode: bip32.chainCode,
          privKey: bip32.privKey,
          pubKey: bip32.pubKey,
          // hasPrivKey: bip32.hasPrivKey,
        );

        expect(bip322.toString(), bip32.toString());
      });
    });

    group('#fromRandom', () {
      test('should not return the same one twice', () {
        var bip32a = new Bip32().fromRandom();
        var bip32b = new Bip32().fromRandom();
        expect(bip32a.toString() != bip32b.toString(), true);
      });
    });

    group('@fromRandom', () {
      test('should not return the same one twice', () {
        var bip32a = Bip32.fromRandom();
        var bip32b = Bip32.fromRandom();
        expect(bip32a.toString() != bip32b.toString(), true);
      });
    });

    group('#fromSeed', () {
      test('should initialize a new Bip32 correctly from test vector 1 seed',
          () {
        var hexStr = vector1master;
        var bip32 = new Bip32().fromSeed(hex.decode(hexStr));
        // should.exist(bip32)
        expect(bip32.toString(), vector1mPrivate);
        expect(bip32.toPublic().toString(), vector1mPublic);
      });

      test('should initialize a new Bip32 correctly from test vector 2 seed',
          () {
        var hexStr = vector2master;
        var bip32 = new Bip32().fromSeed(hex.decode(hexStr));
        // should.exist(bip32)
        expect(bip32.toString(), vector2mPrivate);
        expect(bip32.toPublic().toString(), vector2mPublic);
      });
    });

    group('@fromSeed', () {
      test('should initialize a new Bip32 correctly from test vector 1 seed',
          () {
        var hexStr = vector1master;
        var bip32 = new Bip32.fromSeed(hex.decode(hexStr));
        // should.exist(bip32)
        expect(bip32.toString(), vector1mPrivate);
        expect(bip32.toPublic().toString(), vector1mPublic);
      });

      test('should initialize a new Bip32 correctly from test vector 2 seed',
          () {
        var hexStr = vector2master;
        var bip32 = new Bip32.fromSeed(hex.decode(hexStr));
        // should.exist(bip32)
        expect(bip32.toString(), vector2mPrivate);
        expect(bip32.toPublic().toString(), vector2mPublic);
      });
    });

//   group('#asyncFromSeed', () {
//     test('should initialize a new Bip32 correctly from test vector 1 seed', async () {
//       var hex = vector1master
//       var bip32 = await new Bip32().asyncFromSeed(
//         Buffer.from(hex, 'hex'),
//         'mainnet'
//       )
//       should.exist(bip32)
//       bip32.toString().should.equal(vector1mPrivate)
//       bip32
//         .toPublic()
//         .toString()
//         .should.equal(vector1mPublic)
//     })

//     test('should initialize a new Bip32 correctly from test vector 2 seed', async () {
//       var hex = vector2master
//       var bip32 = await new Bip32().asyncFromSeed(
//         Buffer.from(hex, 'hex'),
//         'mainnet'
//       )
//       should.exist(bip32)
//       bip32.toString().should.equal(vector2mPrivate)
//       bip32
//         .toPublic()
//         .toString()
//         .should.equal(vector2mPublic)
//     })
//   })

//   group('@asyncFromSeed', () {
//     test('should initialize a new Bip32 correctly from test vector 1 seed', async () {
//       var hex = vector1master
//       var bip32 = await Bip32.asyncFromSeed(Buffer.from(hex, 'hex'), 'mainnet')
//       should.exist(bip32)
//       bip32.toString().should.equal(vector1mPrivate)
//       bip32
//         .toPublic()
//         .toString()
//         .should.equal(vector1mPublic)
//     })

//     test('should initialize a new Bip32 correctly from test vector 2 seed', async () {
//       var hex = vector2master
//       var bip32 = await Bip32.asyncFromSeed(Buffer.from(hex, 'hex'), 'mainnet')
//       should.exist(bip32)
//       bip32.toString().should.equal(vector2mPrivate)
//       bip32
//         .toPublic()
//         .toString()
//         .should.equal(vector2mPublic)
//     })
//   })

    group('#fromHex', () {
      test('should make a bip32 from a hex string', () {
        var str =
            'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi';
        var buf = Base58Check.decode(str);
        var hex = buf.toHex();
        var bip32 = new Bip32().fromHex(hex);
        // should.exist(bip32)
        expect(bip32.toString(), str);
        bip32 = bip32.toPublic();
        var xpub = bip32.toString();
        bip32 = new Bip32().fromHex(bip32.toHex());
        expect(bip32.toString(), xpub);
      });
    });

    group('#fromBuffer', () {
      test('should make a bip32 from a buffer', () {
        var str =
            'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi';
        var buf = Base58Check.decode(str);
        var bip32 = new Bip32().fromBuffer(buf);
        // should.exist(bip32)
        expect(bip32.toString(), str);
        bip32 = bip32.toPublic();
        var xpub = bip32.toString();
        bip32 = new Bip32().fromBuffer(bip32.toBuffer());
        expect(bip32.toString(), xpub);
      });
    });

    group('#toHex', () {
      test('should return a bip32 hex string', () {
        var str =
            'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi';
        var hex = Base58Check.decode(str).toHex();
        var bip32 = new Bip32().fromString(str);
        expect(bip32.toHex(), hex);
      });
    });

    group('#toBuffer', () {
      test('should return a bip32 buffer', () {
        var str =
            'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi';
        var buf = Base58Check.decode(str);
        var bip32 = new Bip32().fromString(str);
        expect(bip32.toBuffer().toHex(), buf.toHex());
      });
    });

    group('#fromString', () {
      test('should make a bip32 from a string', () {
        var str =
            'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi';
        var bip32 = new Bip32().fromString(str);
        // should.exist(bip32)
        expect(bip32.toString(), str);
      });
    });

//   group('#asyncFromString', () {
//     test('should make a bip32 from a string asynchronously', async () {
//       var str =
//         'xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi'
//       var bip32 = new Bip32().fromString(str)
//       should.exist(bip32)
//       var bip32b = await new Bip32().asyncFromString(str)
//       bip32.toString().should.equal(str)
//       bip32.toString().should.equal(bip32b.toString())
//     })
//   })

    group('#toString', () {
      var bip32 = new Bip32();
      bip32.fromRandom();
      var tip32 = new Bip32.Testnet();
      tip32.fromRandom();

      test('should return an xprv string', () {
        expect(bip32.toString().substring(0, 4), 'xprv');
      });

      test('should return an xpub string', () {
        expect(bip32.toPublic().toString().substring(0, 4), 'xpub');
      });

      test('should return a tprv string', () {
        expect(tip32.toString().substring(0, 4), 'tprv');
        // ;(tip32.privKey instanceof PrivKey.Testnet) , true)
      });

      test('should return a tpub string', () {
        expect(tip32.toPublic().toString().substring(0, 4), 'tpub');
      });
    });

//   group('#asyncToString', () {
//     test('should convert to a string same as toString', async () {
//       var bip32 = new Bip32().fromRandom()
//       var str1 = bip32.toString()
//       var str2 = await bip32.asyncToString()
//       str1.should.equal(str2)
//     })
//   })

//   group('#toJSON', () {
//     test('should be the same as toFastHex', () {
//       var bip32 = Bip32.fromRandom()
//       bip32.toJSON().should.equal(bip32.toFastHex())
//     })
//   })

//   group('#fromJSON', () {
//     test('should be the same as fromFastHex', () {
//       var bip32 = Bip32.fromRandom()
//       var hex = bip32.toHex()
//       var bip32a = new Bip32().fromJSON(hex)
//       var bip32b = new Bip32().fromFastHex(hex)
//       bip32a.toString().should.equal(bip32b.toString())
//     })
//   })

//   group('@fromJSON', () {
//     test('should be the same as fromFastHex', () {
//       var bip32 = Bip32.fromRandom()
//       var hex = bip32.toHex()
//       var bip32a = Bip32.fromJSON(hex)
//       var bip32b = Bip32.fromFastHex(hex)
//       bip32a.toString().should.equal(bip32b.toString())
//     })
//   })

    group('#isPrivate', () {
      test('should know if this bip32 is private', () {
        var bip32priv = new Bip32().fromRandom();
        var bip32pub = bip32priv.toPublic();
        expect(bip32priv.isPrivate(), true);
        expect(bip32pub.isPrivate(), false);
      });
    });
  });
}
