import 'package:bsv/extentsions/list.dart';
import 'package:bsv/sig.dart';

// ignore: slash_for_doc_comments
/**
 * PubKey Map
 * ==========
 *
 * A map from (transaction hash, output number) to (script chunk index, pubKey).
 * Whening signing a bitcoin transaction, we need to be able to sign an input
 * with the correct key and also we need to know where to put signature when we
 * get it. This mapping allows us to find the key for an associated input (which
 * is identified by tx output hash and number) with which to sign the
 * transaction and then also to know where to insert the signature into the
 * input script. This gets us the public key, and we need a different method to
 * get the private key. That is because we often know the public key to be used
 * but may not have access to the private key until the entire tx is sent to
 * where the private keys are.
 */
class SigOperations {
  static const SigType = 'sig';
  static const PubKeyType = 'pubKey';

  Map map = Map();

  SigOperations({Map map}) {
    this.map = map ?? Map();
  }

  Map toJSON() {
    var json = {};
    this.map.forEach((arr, label) => {
          json[label] = arr.map((obj) => {
                "nScriptChunk": obj.nScriptChunk,
                "type": obj.type, // 'sig' or 'pubKey'
                "addressStr": obj.addressStr,
                "nHashType": obj.nHashType,
                "log": obj.log
              })
        });
    return json;
  }

  SigOperations fromJSON(Map json) {
    json.keys.toList().forEach((label) => {
          this.map[label] = json[label].map((obj) => ({
                "nScriptChunk": obj.nScriptChunk,
                "type": obj.type,
                "addressStr": obj.addressStr,
                "nHashType": obj.nHashType,
                "log": obj.log
              }))
        });
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
   * Set an address to in the map for use with single-sig.
   *
   * @param {Buffer} txHashBuf The hash of a transsaction. Note that this is
   * *not* the reversed transaction id, but is the raw hash.
   * @param {Number} txOutNum The output number, a.k.a. the "vout".
   * @param {Number} nScriptChunk The index of the chunk of the script where
   * we are going to place the signature.
   * @param {String} addressStr The addressStr coresponding to this (txHashBuf,
   * txOutNum, nScriptChunk) where we are going to sign and insert the
   * signature or public key.
   * @param {Number} nHashType Usually = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID
   */
  setOne({
    List<int> txHashBuf,
    int txOutNum,
    int nScriptChunk,
    String type = SigOperations.SigType,
    String addressStr,
    int nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID,
  }) {
    var label = "${txHashBuf.toHex()}:$txOutNum";
    var obj = {
      "nScriptChunk": nScriptChunk,
      "type": type,
      "addressStr": addressStr,
      "nHashType": nHashType,
    };
    this.map[label] = [obj];
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
   * Set a bunch of addresses for signing an input such as for use with multi-sig.
   *
   * @param {Buffer} txHashBuf The hash of a transsaction. Note that this is
   * *not* the reversed transaction id, but is the raw hash.
   * @param {Number} txOutNum The output number, a.k.a. the "vout".
   * @param {Array} arr Must take the form of [{nScriptChunk, type, addressStr, nHashType}, ...]
   */
  SigOperations setMany({
    List<int> txHashBuf,
    int txOutNum,
    List arr,
  }) {
    var label = "${txHashBuf.toHex()}:$txOutNum";
    arr = arr
        .map((obj) => ({
              "type": obj['type'] ?? SigOperations.SigType,
              "nHashType":
                  obj['nHashType'] ?? Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID,
              ...obj
            }))
        .toList();
    this.map[label] = arr;
    return this;
  }

  SigOperations addOne({
    List<int> txHashBuf,
    int txOutNum,
    int nScriptChunk,
    String type = SigOperations.SigType,
    String addressStr,
    int nHashType = Sig.SIGHASH_ALL | Sig.SIGHASH_FORKID,
  }) {
    var arr = this.get(txHashBuf, txOutNum) ?? List();

    arr.add({
      "nScriptChunk": nScriptChunk,
      "type": type,
      "addressStr": addressStr,
      "nHashType": nHashType,
    });
    this.setMany(txHashBuf: txHashBuf, txOutNum: txOutNum, arr: arr);
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
   * Get an address from the map
   *
   * @param {Buffer} txHashBuf The hash of a transction. Note that this is *not*
   * the reversed transaction id, but is the raw hash.
   * @param {Number} txOutNum The output number, a.k.a. the "vout".
   * @param {Number} nScriptChunk The index of the chunk of the script where
   * we are going to place the signature.
   * @returns {PubKey}
   */
  dynamic get(List<int> txHashBuf, int txOutNum) {
    var label = "${txHashBuf.toHex()}:$txOutNum";
    return this.map[label] ?? [];
  }
}
