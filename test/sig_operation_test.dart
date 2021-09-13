import 'package:bsv/src/address.dart';
import 'package:bsv/src/key_pair.dart';
import 'package:bsv/src/priv_key.dart';
import 'package:bsv/src/sig.dart';
import 'package:bsv/src/sig_operation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SigOperations', () {
    var txHashBuf = List.filled(32, 0x01);

    var txOutNum = 5;
    var nScriptChunk = 0;
    var privKey = PrivKey.fromString(
        'L3uCzo4TtW3FX5b5L9S5dKDu21ypeRofiiNnVuYnxGs5YRQrUFP2');
    var keyPair = KeyPair.fromPrivKey(privKey);
    var pubKey = keyPair.pubKey!;
    var addressStr = Address.fromPubKey(pubKey).toString();
    var type = SigOperations.SigType;

    // test('should make a new sigOperations',  () {
    //   var sigOperations = new SigOperations();
    //   should.exist(sigOperations)
    //   should.exist(sigOperations.map)
    // });

    group('#setOne', () {
      test('should set this vector', () {
        var sigOperations = new SigOperations();
        sigOperations.setOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: type,
          addressStr: addressStr,
        );
        var arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];
        expect(obj['nScriptChunk'], nScriptChunk);
        expect(obj['nHashType'], Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID);
        expect(obj['addressStr'], addressStr);
      });

      test('should set this vector with type pubKey', () {
        var sigOperations = new SigOperations();
        var type = SigOperations.PubKeyType;
        sigOperations.setOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: type,
          addressStr: addressStr,
        );
        var arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];
        expect(obj['nScriptChunk'], nScriptChunk);
        expect(obj['type'], 'pubKey');
        expect(obj['nHashType'], Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID);
        expect(obj['addressStr'], addressStr);
      });

      test('should set this vector with a different nHashType', () {
        var sigOperations = new SigOperations();
        sigOperations.setOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: type,
          addressStr: addressStr,
          nHashType: Sig.SIGHASH_ALL,
        );

        var arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];
        expect(obj['nHashType'], Sig.SIGHASH_ALL);
        expect(obj['nHashType'] == Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID, false);
      });
    });

    group('#setMany', () {
      test('should set this vector', () {
        var sigOperations = new SigOperations();
        List<Map<dynamic, dynamic>> arr = [
          {"nScriptChunk": nScriptChunk, "addressStr": addressStr}
        ];
        sigOperations.setMany(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          arr: arr,
        );
        arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];

        expect(obj['nScriptChunk'], nScriptChunk);
        expect(obj['nHashType'] != null, true);
        expect(obj['addressStr'], addressStr);
      });
    });

    group('#addOne', () {
      test('should add this vector', () {
        var sigOperations = new SigOperations();

        sigOperations.addOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: type,
          addressStr: addressStr,
        );
        var arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];
        expect(obj['nScriptChunk'], nScriptChunk);
        expect(obj['nHashType'], Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID);
        expect(obj['addressStr'], addressStr);
      });

      test('should add two vectors', () {
        var sigOperations = new SigOperations();
        sigOperations.addOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: type,
          addressStr: addressStr,
        );
        var arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];
        expect(obj['nScriptChunk'], nScriptChunk);
        expect(obj['addressStr'], addressStr);

        var nScriptChunk2 = 2;
        var addressStr2 =
            Address.fromPubKey(KeyPair.fromRandom().pubKey!).toString();
        sigOperations.addOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk2,
          type: type,
          addressStr: addressStr2,
        );
        arr = sigOperations.get(txHashBuf, txOutNum);
        obj = arr[1];

        expect(obj['nScriptChunk'], nScriptChunk2);
        expect(obj['addressStr'], addressStr2);
      });

      test('should add two vectors where one has type pubKey', () {
        var sigOperations = new SigOperations();
        sigOperations.addOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: SigOperations.PubKeyType,
          addressStr: addressStr,
        );
        var arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];
        expect(obj['type'], SigOperations.PubKeyType);
        expect(obj['nScriptChunk'], nScriptChunk);
        expect(obj['addressStr'], addressStr);

        var nScriptChunk2 = 2;
        var addressStr2 =
            Address.fromPubKey(KeyPair.fromRandom().pubKey!).toString();
        sigOperations.addOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk2,
          type: type,
          addressStr: addressStr2,
        );
        arr = sigOperations.get(txHashBuf, txOutNum);
        obj = arr[1];

        expect(obj['nScriptChunk'], nScriptChunk2);
        expect(obj['addressStr'], addressStr2);
      });
    });

    group('#get', () {
      test('should get this vector', () {
        var sigOperations = new SigOperations();
        sigOperations.setOne(
          txHashBuf: txHashBuf,
          txOutNum: txOutNum,
          nScriptChunk: nScriptChunk,
          type: type,
          addressStr: addressStr,
        );
        var arr = sigOperations.get(txHashBuf, txOutNum);
        var obj = arr[0];
        expect(obj['nScriptChunk'], nScriptChunk);
        expect(obj['addressStr'], addressStr);

        var txHashBuf2 = List.generate(32, (index) => 05);
        var txOutNum2 = 9;
        var nScriptChunk2 = 2;
        var addressStr2 =
            Address.fromPubKey(KeyPair.fromRandom().pubKey!).toString();
        sigOperations.setOne(
          txHashBuf: txHashBuf2,
          txOutNum: txOutNum2,
          nScriptChunk: nScriptChunk2,
          type: type,
          addressStr: addressStr2,
        );
        arr = sigOperations.get(txHashBuf2, txOutNum2);
        obj = arr[0];

        expect(obj['nScriptChunk'], nScriptChunk2);
        expect(obj['addressStr'], addressStr2);
      });

      test('should return empty list when no sig operation was registered', () {
        var sigOperations = new SigOperations();
        var txHashBuf = List.filled(32, 1);
        var result = sigOperations.get(txHashBuf, 0);
        expect(result, []);
      });
    });
  });
}
