import 'package:bsv/tx_out.dart';
import 'package:bsv/extentsions/list.dart';

// ignore: slash_for_doc_comments
/**
 * Transaction Output Map
 * ======================
 *
 * A map from a transaction hash and output number to that particular output.
 * Note that the map is from the transaction *hash*, which is the value that
 * occurs in the blockchain, not the id, which is the reverse of the hash. The
 * TxOutMap is necessary when signing a transction to get the script and value
 * of that output which is plugged into the sighash algorithm.
 */

class TxOutMap {
  Map map;
  TxOutMap({
    Map map,
  }) {
    this.map = map;
  }

  Map toJSON() {
    Map json = {};
    this.map.forEach((key, value) {
      json[key] = value.toHex();
    });
    // this.map.forEach((txOut, label) => {json[label] = txOut.toHex()});
    return json;
  }

  TxOutMap fromJSON(Map json) {
    json.forEach((key, value) {
      this.map[key] = TxOut.fromHex(json[key]);
    });
    return this;
  }

  TxOutMap set(List<int> txHashBuf, txOutNum, txOut) {
    var label = txHashBuf.toHex() + ':' + txOutNum;
    this.map[label] = txOut;
    return this;
  }

  dynamic get(txHashBuf, txOutNum) {
    var label = txHashBuf.toHex() + ':' + txOutNum;
    return this.map[label];
  }

  TxOutMap setTx(tx) {
    var txhashhex = tx.hash().toString('hex');
    tx.txOuts.forEach((txOut, index) {
      var label = txhashhex + ':' + index;
      this.map[label] = txOut;
    });
    return this;
  }
}
