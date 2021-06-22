// ignore: slash_for_doc_comments
/**
 * Script Interpreter
 * ==================
 *
 * Bitcoin transactions contain scripts. Each input has a script called the
 * scriptSig, and each output has a script called the scriptPubKey. To validate
 * an input, the ScriptSig is executed, then with the same stack, the
 * scriptPubKey from the output corresponding to that input is run. The primary
 * way to use this class is via the verify function:
 *
 * new Interp().verify( ... )
 *
 * In some ways, the script interpreter is one of the most poorly architected
 * components of Yours Bitcoin because of the giant switch statement in step(). But
 * that is deliberately so to make it similar to bitcoin core, and thus easier
 * to audit.
 */

class Interp {
  static const MAX_SCRIPT_ELEMENT_SIZE = 520;
  static const LOCKTIME_THRESHOLD = 500000000; // Tue Nov  5 00:53:20 1985 UTC
  static const SCRIPT_VERIFY_NONE = 0;
  static const SCRIPT_VERIFY_P2SH = 1 << 0;
  static const SCRIPT_VERIFY_STRICTENC = 1 << 1;
  static const SCRIPT_VERIFY_DERSIG = 1 << 2;
  static const SCRIPT_VERIFY_LOW_S = 1 << 3;
  static const SCRIPT_VERIFY_NULLDUMMY = 1 << 4;
  static const SCRIPT_VERIFY_SIGPUSHONLY = 1 << 5;
  static const SCRIPT_VERIFY_MINIMALDATA = 1 << 6;
  static const SCRIPT_VERIFY_DISCOURAGE_UPGRADABLE_NOPS = 1 << 7;
  static const SCRIPT_VERIFY_CLEANSTACK = 1 << 8;
  static const SCRIPT_VERIFY_CHECKLOCKTIMEVERIFY = 1 << 9;
  static const SCRIPT_VERIFY_CHECKSEQUENCEVERIFY = 1 << 10;
  static const SCRIPT_ENABLE_SIGHASH_FORKID = 1 << 16;
  static const defaultFlags =
      Interp.SCRIPT_VERIFY_P2SH | Interp.SCRIPT_VERIFY_CHECKLOCKTIMEVERIFY;
}
