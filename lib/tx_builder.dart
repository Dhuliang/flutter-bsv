// ignore: slash_for_doc_comments
import 'package:bsv/constants.dart';
import 'package:bsv/hash_cache.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_in.dart';
import 'package:bsv/tx_out.dart';
import 'package:bsv/tx_out_map.dart';

/**
 * Transaction Builder
 * ===================
 */
class TxBuilder {
  Tx tx = new Tx();
  List<TxIn> txIns = [];
  List<TxOut> txOuts = [];

  // TxOutMap uTxOutMap = new TxOutMap();
  // sigOperations = new SigOperations();
  // changeScript,
  // changeAmountBn,
  // feeAmountBn,
  // feePerKbNum = Constants.feePerKbNum,
  // nLockTime = 0,
  // versionBytesNum = 1,
  // sigsPerInput = 1,
  // dust = Constants.dust,
  // dustChangeToFees = false,
  // hashCache = new HashCache()

}
