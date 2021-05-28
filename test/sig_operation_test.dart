// import 'package:bsv/priv_key.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {

// group('SigOperations',  () {
//   var txHashBuf = List.filled(32, 0x01);

//   var txOutNum = 5;
//   var nScriptChunk = 0;
//   var privKey = PrivKey.fromString('L3uCzo4TtW3FX5b5L9S5dKDu21ypeRofiiNnVuYnxGs5YRQrUFP2');
//   var keyPair = KeyPair.fromPrivKey(privKey);
//   var pubKey = keyPair.pubKey;
//   var addressStr = Address.fromPubKey(pubKey).toString();
//   var type = 'sig';

//   test('should make a new sigOperations',  () {
//     var sigOperations = new SigOperations()
//     should.exist(sigOperations)
//     should.exist(sigOperations.map)
//   })

//   group('#setOne',  () {
//     test('should set this vector',  () {
//       var sigOperations = new SigOperations()
//       sigOperations.setOne(txHashBuf, txOutNum, nScriptChunk, type, addressStr)
//       var arr = sigOperations.get(txHashBuf, txOutNum)
//       var obj = arr[0]
//       obj.nScriptChunk.should.equal(nScriptChunk)
//       obj.nHashType.should.equal(Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID)
//       obj.addressStr.should.equal(addressStr)
//     })

//     test('should set this vector with type pubKey',  () {
//       var sigOperations = new SigOperations()
//       var type = 'pubKey'
//       sigOperations.setOne(txHashBuf, txOutNum, nScriptChunk, type, addressStr)
//       var arr = sigOperations.get(txHashBuf, txOutNum)
//       var obj = arr[0]
//       obj.nScriptChunk.should.equal(nScriptChunk)
//       obj.type.should.equal('pubKey')
//       obj.nHashType.should.equal(Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID)
//       obj.addressStr.should.equal(addressStr)
//     })

//     test('should set this vector with a different nHashType',  () {
//       var sigOperations = new SigOperations()
//       sigOperations.setOne(txHashBuf, txOutNum, nScriptChunk, type, addressStr, Sig.SIGHASH_ALL)
//       var arr = sigOperations.get(txHashBuf, txOutNum)
//       var obj = arr[0]
//       obj.nHashType.should.equal(Sig.SIGHASH_ALL)
//       obj.nHashType.should.not.equal(Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID)
//     })
//   })

//   group('#setMany',  () {
//     test('should set this vector',  () {
//       var sigOperations = new SigOperations()
//       let arr = [
//         { nScriptChunk, addressStr }
//       ]
//       sigOperations.setMany(txHashBuf, txOutNum, arr)
//       arr = sigOperations.get(txHashBuf, txOutNum)
//       var obj = arr[0]
//       obj.nScriptChunk.should.equal(nScriptChunk)
//       should.exist(obj.nHashType)
//       obj.addressStr.should.equal(addressStr)
//     })
//   })

//   group('#addOne',  () {
//     test('should add this vector',  () {
//       var sigOperations = new SigOperations()
//       sigOperations.addOne(txHashBuf, txOutNum, nScriptChunk, type, addressStr)
//       var arr = sigOperations.get(txHashBuf, txOutNum)
//       var obj = arr[0]
//       obj.nScriptChunk.should.equal(nScriptChunk)
//       obj.nHashType.should.equal(Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID)
//       obj.addressStr.should.equal(addressStr)
//     })

//     test('should add two vectors',  () {
//       var sigOperations = new SigOperations()
//       sigOperations.addOne(txHashBuf, txOutNum, nScriptChunk, type, addressStr)
//       let arr = sigOperations.get(txHashBuf, txOutNum)
//       let obj = arr[0]
//       obj.nScriptChunk.should.equal(nScriptChunk)
//       obj.addressStr.should.equal(addressStr)

//       var nScriptChunk2 = 2
//       var addressStr2 = Address.fromPubKey(KeyPair.fromRandom().pubKey).toString()
//       sigOperations.addOne(txHashBuf, txOutNum, nScriptChunk2, type, addressStr2)
//       arr = sigOperations.get(txHashBuf, txOutNum)
//       obj = arr[1]
//       obj.nScriptChunk.should.equal(nScriptChunk2)
//       obj.addressStr.should.equal(addressStr2.toString())
//     })

//     test('should add two vectors where one has type pubKey',  () {
//       var sigOperations = new SigOperations()
//       sigOperations.addOne(txHashBuf, txOutNum, nScriptChunk, 'pubKey', addressStr)
//       let arr = sigOperations.get(txHashBuf, txOutNum)
//       let obj = arr[0]
//       obj.type.should.equal('pubKey')
//       obj.nScriptChunk.should.equal(nScriptChunk)
//       obj.addressStr.should.equal(addressStr)

//       var nScriptChunk2 = 2
//       var addressStr2 = Address.fromPubKey(KeyPair.fromRandom().pubKey).toString()
//       sigOperations.addOne(txHashBuf, txOutNum, nScriptChunk2, type, addressStr2)
//       arr = sigOperations.get(txHashBuf, txOutNum)
//       obj = arr[1]
//       obj.nScriptChunk.should.equal(nScriptChunk2)
//       obj.addressStr.should.equal(addressStr2.toString())
//     })
//   })

//   group('#get',  () {
//     test('should get this vector',  () {
//       var sigOperations = new SigOperations()
//       sigOperations.setOne(txHashBuf, txOutNum, nScriptChunk, type, addressStr)
//       let arr = sigOperations.get(txHashBuf, txOutNum)
//       let obj = arr[0]
//       obj.nScriptChunk.should.equal(nScriptChunk)
//       obj.addressStr.should.equal(addressStr)

//       var txHashBuf2 = '05'.repeat(32)
//       var txOutNum2 = 9
//       var nScriptChunk2 = 2
//       var addressStr2 = Address.fromPubKey(KeyPair.fromRandom().pubKey).toString()
//       sigOperations.setOne(txHashBuf2, txOutNum2, nScriptChunk2, type, addressStr2)
//       arr = sigOperations.get(txHashBuf2, txOutNum2)
//       obj = arr[0]
//       obj.nScriptChunk.should.equal(nScriptChunk2)
//       obj.addressStr.should.equal(addressStr2.toString())
//     })

//     test('should return empty list when no sig operation was registered',  () {
//       var sigOperations = new SigOperations()
//       var txHashBuf = Buffer.alloc(32).fill(1)
//       var result = sigOperations.get(txHashBuf, 0)
//       should(result).be.eql([])
//     })
//   })
// });

// }
