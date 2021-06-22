import 'package:bsv/extentsions/list.dart';

class Tx {
  static const int MAX_MONEY = 2100000000000000;

// This is defined on Interp, but Tx cannot depend on Interp - must redefine here
  static const int SCRIPT_ENABLE_SIGHASH_FORKID = 1 << 16;
}
