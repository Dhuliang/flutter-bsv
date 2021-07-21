import 'dart:convert';
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/cmp.dart';
import 'package:bsv/hash.dart';
import 'package:bsv/op_code.dart';
import 'package:bsv/pub_key.dart';
import 'package:bsv/script.dart';
import 'package:bsv/sig.dart';
import 'package:bsv/tx.dart';
import 'package:bsv/tx_in.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:convert/convert.dart';
import 'package:flutter/services.dart';

// ignore: slash_for_doc_comments
/**
 * Script Interpreter
 * ==================
 *
 * Bitcoin transactions contain scripts. Each input has a script called the
 * scriptSig, and each output has a script called the scriptPubKey. To validate
 * an input, the ScriptSig is executed, then with the same stack, the
 * scriptPubKey from the output corresponding to that input is run. The primary
 * way to use this class is via the verify:
 *
 * new Interp().verify( ... )
 *
 * In some ways, the script interpreter is one of the most poorly architected
 * components of Yours Bitcoin because of the giant switch statement in step(). But
 * that is deliberately so to make it similar to bitcoin core, and thus easier
 * to audit.
 */

class Interp {
  static const List<int> TRUE = [1];
  static const List<int> FALSE = [];
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

  Script script;
  Tx tx;
  int nIn;
  List<List<int>> stack = [];
  List<List<int>> altStack = [];
  // List<String> stack;
  // List<String> altStack;
  int pc = 0;
  int pBeginCodeHash = 0;
  int nOpCount = 0;
  List<bool> ifStack = [];
  String errStr = '';
  int flags = Interp.defaultFlags;
  BigIntX valueBn = BigIntX.zero;

  Interp({
    Script script,
    Tx tx,
    int nIn,
    List<List<int>> stack,
    List<List<int>> altStack,
    int pc = 0,
    int pBeginCodeHash = 0,
    int nOpCount = 0,
    List<bool> ifStack,
    String errStr = '',
    int flags,
    BigIntX valueBn,
  }) {
    this.script = script;
    this.tx = tx;
    this.nIn = nIn;
    this.stack = stack ?? [];
    this.altStack = altStack ?? [];
    this.pc = pc;
    this.pBeginCodeHash = pBeginCodeHash;
    this.nOpCount = nOpCount;
    this.ifStack = ifStack ?? [];
    this.errStr = errStr ?? '';
    this.flags = flags ?? Interp.defaultFlags;
    this.valueBn = valueBn ?? BigIntX.zero;
  }

  Interp fromBr(Br br) {
    var jsonNoTxBufLEn = br.readVarIntNum();
    var jsonNoTxBuf = br.read(jsonNoTxBufLEn);
    // utf8.decode(jsonNoTxBuf)
    // this.fromJSONNoTx(json.decode(jsonNoTxBuf.toString()));
    this.fromJSONNoTx(json.decode(utf8.decode(jsonNoTxBuf)));
    var txbuflen = br.readVarIntNum();
    if (txbuflen > 0) {
      var txbuf = br.read(txbuflen);
      this.tx = new Tx().fromBuffer(txbuf);
    }
    return this;
  }

  Interp fromHex(String str) {
    return this.fromBr(Br(buf: hex.decode(str)));
  }

  factory Interp.fromHex(String str) {
    return Interp().fromBr(Br(buf: hex.decode(str)));
  }

  Interp fromBuffer(List<int> buf) {
    return this.fromBr(Br(buf: buf.asUint8List()));
  }

  List<int> toBuffer() {
    return this.toBw().toBuffer();
  }

  Interp initialize() {
    this.script = new Script();
    this.stack = [];
    this.altStack = [];
    this.pc = 0;
    this.pBeginCodeHash = 0;
    this.nOpCount = 0;
    this.ifStack = [];
    this.errStr = '';
    this.flags = Interp.defaultFlags;
    return this;
  }

  Interp fromJSON(Map json) {
    this.fromJSONNoTx(json);
    this.tx = json['tx'] != null ? new Tx().fromJSON(json['tx']) : null;
    return this;
  }

  // ignore: slash_for_doc_comments
  /**
   * Convert JSON containing everything but the tx to an interp object.
   */
  Interp fromJSONNoTx(Map json) {
    // var interp = Interp(
    //   script:
    //       json['script'] != null ? new Script().fromJSON(json['script']) : null,
    //   nIn: json['nIn'],
    // );
    this.script =
        json['script'] != null ? new Script().fromJSON(json['script']) : null;
    this.nIn = json['nIn'];

    this.stack = [];
    json['stack'].forEach((str) {
      this.stack.add(hex.decode(str));
    });
    this.altStack = [];
    json['altStack'].forEach((str) {
      this.altStack.add(hex.decode(str));
    });

    this.pc = json['pc'];
    this.pBeginCodeHash = json['pBeginCodeHash'];
    this.nOpCount = json['nOpCount'];
    this.ifStack = List<bool>.from(json['ifStack']);
    this.errStr = json['errStr'];
    this.flags = json['flags'];

    return this;
  }

  Map<String, dynamic> toJSON() {
    var json = this.toJSONNoTx();
    json['tx'] = this.tx != null ? this.tx.toJSON() : null;
    return json;
  }

  // /**
  //  * Convert everything but the tx to JSON.
  //  */
  toJSONNoTx() {
    var stack = [];
    this.stack.forEach((buf) {
      stack.add(hex.encode(buf));
    });
    var altStack = [];
    this.altStack.forEach((buf) {
      altStack.add(hex.encode(buf));
    });
    return {
      "script": this.script != null ? this.script.toJSON() : null,
      "nIn": this.nIn,
      "stack": stack,
      "altStack": altStack,
      "pc": this.pc,
      "pBeginCodeHash": this.pBeginCodeHash,
      "nOpCount": this.nOpCount,
      "ifStack": this.ifStack,
      "errStr": this.errStr,
      "flags": this.flags
    };
  }

  Bw toBw([Bw bw]) {
    if (bw == null) {
      bw = new Bw();
    }
    var jsonNoTxBuf = utf8.encode(json.encode(this.toJSONNoTx()));
    bw.writeVarIntNum(jsonNoTxBuf.length);
    bw.write(jsonNoTxBuf);
    if (this.tx != null) {
      var txbuf = this.tx.toBuffer();
      bw.writeVarIntNum(txbuf.length);
      bw.write(txbuf.asUint8List());
    } else {
      bw.writeVarIntNum(0);
    }
    return bw;
  }

  // ignore: slash_for_doc_comments
  /**
   * In order to make auduting the script interpreter easier, we use the same
   * constants as bitcoin core, including the flags, which customize the
   * operation of the interpreter.
   */
  static int getFlags(String flagstr) {
    var flags = 0;
    if (flagstr.indexOf('NONE') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_NONE;
    }
    if (flagstr.indexOf('P2SH') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_P2SH;
    }
    if (flagstr.indexOf('STRICTENC') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_STRICTENC;
    }
    if (flagstr.indexOf('DERSIG') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_DERSIG;
    }
    if (flagstr.indexOf('LOW_S') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_LOW_S;
    }
    if (flagstr.indexOf('NULLDUMMY') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_NULLDUMMY;
    }
    if (flagstr.indexOf('SIGPUSHONLY') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_SIGPUSHONLY;
    }
    if (flagstr.indexOf('MINIMALDATA') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_MINIMALDATA;
    }
    if (flagstr.indexOf('DISCOURAGE_UPGRADABLE_NOPS') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_DISCOURAGE_UPGRADABLE_NOPS;
    }
    if (flagstr.indexOf('CLEANSTACK') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_CLEANSTACK;
    }
    if (flagstr.indexOf('CHECKLOCKTIMEVERIFY') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_CHECKLOCKTIMEVERIFY;
    }
    if (flagstr.indexOf('CHECKSEQUENCEVERIFY') != -1) {
      flags = flags | Interp.SCRIPT_VERIFY_CHECKSEQUENCEVERIFY;
    }
    if (flagstr.indexOf('SIGHASH_FORKID') != -1) {
      flags = flags | Interp.SCRIPT_ENABLE_SIGHASH_FORKID;
    }
    return flags;
  }

  static bool castToBool(List<int> buf) {
    for (var i = 0; i < buf.length; i++) {
      if (buf[i] != 0) {
        // can be negative zero
        if (i == buf.length - 1 && buf[i] == 0x80) {
          return false;
        }
        return true;
      }
    }
    return false;
  }

  // ignore: slash_for_doc_comments
  /**
   * Translated from bitcoin core's CheckSigEncoding
   */
  bool checkSigEncoding(List<int> buf) {
    // Empty signature. Not strictly DER encoded, but allowed to provide a
    // compact way to provide an invalid signature for use with CHECK(MULTI)SIG
    if (buf.length == 0) {
      return true;
    }
    // bool a = (this.flags &
    //             (Interp.SCRIPT_VERIFY_DERSIG |
    //                 Interp.SCRIPT_VERIFY_LOW_S |
    //                 Interp.SCRIPT_VERIFY_STRICTENC)) !=
    //         0 &&
    //     !Sig.IsTxDer(buf);
    // bool a1 = (Interp.SCRIPT_VERIFY_DERSIG |Interp.SCRIPT_VERIFY_LOW_S |Interp.SCRIPT_VERIFY_STRICTENC) != 0;
    // (this.flags & (Interp.SCRIPT_VERIFY_DERSIG |Interp.SCRIPT_VERIFY_LOW_S | Interp.SCRIPT_VERIFY_STRICTENC)) !=0
    // print(a);

    if ((this.flags &
                (Interp.SCRIPT_VERIFY_DERSIG |
                    Interp.SCRIPT_VERIFY_LOW_S |
                    Interp.SCRIPT_VERIFY_STRICTENC)) !=
            0 &&
        !Sig.IsTxDer(buf)) {
      this.errStr = 'SCRIPT_ERR_SIG_DER';
      return false;
    } else if ((this.flags & Interp.SCRIPT_VERIFY_LOW_S) != 0) {
      var sig = new Sig().fromTxFormat(buf);
      if (!sig.hasLowS()) {
        this.errStr = 'SCRIPT_ERR_SIG_DER';
        return false;
      }
    } else if ((this.flags & Interp.SCRIPT_VERIFY_STRICTENC) != 0) {
      var sig = new Sig().fromTxFormat(buf);
      if (!sig.hasDefinedHashType()) {
        this.errStr = 'SCRIPT_ERR_SIG_HASHTYPE';
        return false;
      }
    }
    return true;
  }

  // ignore: slash_for_doc_comments
  /**
   * Translated from bitcoin core's CheckPubKeyEncoding
   */
  bool checkPubKeyEncoding(buf) {
    if ((this.flags & Interp.SCRIPT_VERIFY_STRICTENC) != 0 &&
        !PubKey.isCompressedOrUncompressed(buf)) {
      this.errStr = 'SCRIPT_ERR_PUBKEYTYPE';
      return false;
    }
    return true;
  }

  // ignore: slash_for_doc_comments
  /**
   * Translated from bitcoin core's CheckLockTime
   */
  bool checkLockTime(int nLockTime) {
    // There are two kinds of nLockTime: lock-by-blockheight
    // and lock-by-blocktime, distinguished by whether
    // nLockTime < LOCKTIME_THRESHOLD.
    //
    // We want to compare apples to apples, so fail the script
    // unless the type of nLockTime being tested is the same as
    // the nLockTime in the transaction.
    if (!((this.tx.nLockTime < Interp.LOCKTIME_THRESHOLD &&
            nLockTime < Interp.LOCKTIME_THRESHOLD) ||
        (this.tx.nLockTime >= Interp.LOCKTIME_THRESHOLD &&
            nLockTime >= Interp.LOCKTIME_THRESHOLD))) {
      return false;
    }

    // Now that we know we're comparing apples-to-apples, the
    // comparison is a simple numeric one.
    if (nLockTime > this.tx.nLockTime) {
      return false;
    }

    // Finally the nLockTime feature can be disabled and thus
    // CHECKLOCKTIMEVERIFY bypassed if every txIn has been
    // finalized by setting nSequence to maxint. The
    // transaction would be allowed into the blockchain, making
    // the opCode ineffective.
    //
    // Testing if this vin is not final is sufficient to
    // prevent this condition. Alternatively we could test all
    // inputs, but testing just this input minimizes the data
    // required to prove correct CHECKLOCKTIMEVERIFY execution.
    if (TxIn.SEQUENCE_FINAL == this.tx.txIns[this.nIn].nSequence) {
      return false;
    }

    return true;
  }

  // ignore: slash_for_doc_comments
  /**
   * Translated from bitcoin core's CheckSequence.
   */
  bool checkSequence(nSequence) {
    // Relative lock times are supported by comparing the passed
    // in operand to the sequence number of the input.
    var txToSequence = this.tx.txIns[this.nIn].nSequence;

    // Fail if the transaction's version number is not set high
    // enough to trigger Bip 68 rules.
    if (this.tx.versionBytesNum < 2) {
      return false;
    }

    // Sequence numbers with their most significant bit set are not
    // consensus constrained. Testing that the transaction's sequence
    // number do not have this bit set prevents using this property
    // to get around a CHECKSEQUENCEVERIFY check.
    if (txToSequence & TxIn.SEQUENCE_LOCKTIME_DISABLE_FLAG != 0) {
      return false;
    }

    // Mask off any bits that do not have consensus-enforced meaning
    // before doing the integer comparisons
    var nLockTimeMask =
        TxIn.SEQUENCE_LOCKTIME_TYPE_FLAG | TxIn.SEQUENCE_LOCKTIME_MASK;
    var txToSequenceMasked = txToSequence & nLockTimeMask;
    var nSequenceMasked = nSequence & nLockTimeMask;

    // There are two kinds of nSequence: lock-by-blockheight
    // and lock-by-blocktime, distinguished by whether
    // nSequenceMasked < CTxIn::SEQUENCE_LOCKTIME_TYPE_FLAG.
    //
    // We want to compare apples to apples, so fail the script
    // unless the type of nSequenceMasked being tested is the same as
    // the nSequenceMasked in the transaction.
    if (!((txToSequenceMasked < TxIn.SEQUENCE_LOCKTIME_TYPE_FLAG &&
            nSequenceMasked < TxIn.SEQUENCE_LOCKTIME_TYPE_FLAG) ||
        (txToSequenceMasked >= TxIn.SEQUENCE_LOCKTIME_TYPE_FLAG &&
            nSequenceMasked >= TxIn.SEQUENCE_LOCKTIME_TYPE_FLAG))) {
      return false;
    }

    // Now that we know we're comparing apples-to-apples, the
    // comparison is a simple numeric one.
    if (nSequenceMasked > txToSequenceMasked) {
      return false;
    }

    return true;
  }

  // ignore: slash_for_doc_comments
  /**
   * Based on bitcoin core's EvalScript, with the inner loop moved to
   * Interp.prototype.step()
   * bitcoin core commit: b5d1b1092998bc95313856d535c632ea5a8f9104
   */
  Stream<bool> eval() async* {
    if (this.script.toBuffer().length > 10000) {
      this.errStr = 'SCRIPT_ERR_SCRIPT_SIZE';
      yield false;
    }

    try {
      print("${this.pc}${this.script.chunks.length}");
      while (this.pc < this.script.chunks.length) {
        var fSuccess = this.step();
        if (!fSuccess) {
          yield false;
        } else {
          yield fSuccess;
        }
      }

      // Size limits
      if (this.stack.length + this.altStack.length > 1000) {
        this.errStr = 'SCRIPT_ERR_STACK_SIZE';
        yield false;
      }
    } catch (e) {
      if (e is String) {
        this.errStr = 'SCRIPT_ERR_UNKNOWN_ERROR: $e';
        yield false;
      } else if (e is Exception) {
        this.errStr = 'SCRIPT_ERR_UNKNOWN_ERROR: ${e.toString()}';
        yield false;
      } else {
        print(e?.stackTrace);
        throw e;
      }
    }

    if (this.ifStack.length > 0) {
      this.errStr = 'SCRIPT_ERR_UNBALANCED_CONDITIONAL';
      yield false;
    }

    yield true;
  }

  // ignore: slash_for_doc_comments
  /**
   * Based on the inner loop of bitcoin core's EvalScript
   */
  bool step() {
    var fRequireMinimal = (this.flags & Interp.SCRIPT_VERIFY_MINIMALDATA) != 0;

    var fExec = !((this.ifStack.indexOf(false) + 1) != 0);

    //
    // Read instruction
    //
    var chunk = this.script.chunks[this.pc];
    this.pc++;
    print("pc============${this.pc}");
    var opCodeNum = chunk.opCodeNum;
    // chunk.opCodeNum.toRadixString(16);
    // print("%d")
    var str = OpCode.str[opCodeNum];
    print(str);
    if (opCodeNum == null) {
      this.errStr = 'SCRIPT_ERR_BAD_OPCODE';
      return false;
    }
    if (chunk.buf != null &&
        chunk.buf.length > Interp.MAX_SCRIPT_ELEMENT_SIZE) {
      this.errStr = 'SCRIPT_ERR_PUSH_SIZE';
      return false;
    }

    // Note how OpCode.OP_RESERVED does not count towards the opCode limit.
    if (opCodeNum > OpCode.OP_16 && ++this.nOpCount > 201) {
      this.errStr = 'SCRIPT_ERR_OP_COUNT';
      return false;
    }

    if (opCodeNum == OpCode.OP_LEFT ||
        opCodeNum == OpCode.OP_RIGHT ||
        opCodeNum == OpCode.OP_2MUL ||
        opCodeNum == OpCode.OP_2DIV) {
      this.errStr = 'SCRIPT_ERR_DISABLED_OPCODE';
      return false;
    }

    if (fExec && opCodeNum >= 0 && opCodeNum <= OpCode.OP_PUSHDATA4) {
      print('============');
      if (fRequireMinimal && !this.script.checkMinimalPush(this.pc - 1)) {
        this.errStr = 'SCRIPT_ERR_MINIMALDATA';
        return false;
      }
      if (chunk.buf == null) {
        this.stack.add(Interp.FALSE);
      } else if (chunk.len != chunk.buf.length) {
        throw ('LEngth of push value not equal to length of data');
      } else {
        this.stack.add(chunk.buf);
      }
    } else if (fExec ||
        (OpCode.OP_IF <= opCodeNum && opCodeNum <= OpCode.OP_ENDIF)) {
      switch (opCodeNum) {
        //
        // Push value
        //
        case OpCode.OP_1NEGATE:
        case OpCode.OP_1:
        case OpCode.OP_2:
        case OpCode.OP_3:
        case OpCode.OP_4:
        case OpCode.OP_5:
        case OpCode.OP_6:
        case OpCode.OP_7:
        case OpCode.OP_8:
        case OpCode.OP_9:
        case OpCode.OP_10:
        case OpCode.OP_11:
        case OpCode.OP_12:
        case OpCode.OP_13:
        case OpCode.OP_14:
        case OpCode.OP_15:
        case OpCode.OP_16:
          {
            // ( -- value)
            // ScriptNum BigIntX((int)opCode - (int)(OpCode.OP_1 - 1))
            var n = opCodeNum - (OpCode.OP_1 - 1);
            var buf = new BigIntX.fromNum(n).toScriptNumBuffer();
            this.stack.add(buf);
            // The result of these opCodes should always be the minimal way to push the data
            // they push, so no need for a CheckMinimalPush here.
          }
          break;

        //
        // Control
        //
        case OpCode.OP_NOP:
          break;

        case OpCode.OP_CHECKLOCKTIMEVERIFY:
          {
            if (!(this.flags & Interp.SCRIPT_VERIFY_CHECKLOCKTIMEVERIFY != 0)) {
              // not enabled; treat as a NOP2
              if (this.flags &
                      Interp.SCRIPT_VERIFY_DISCOURAGE_UPGRADABLE_NOPS !=
                  0) {
                this.errStr = 'SCRIPT_ERR_DISCOURAGE_UPGRADABLE_NOPS';
                return false;
              }
              break;
            }

            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }

            // Note that elsewhere numeric opCodes are limited to
            // operands in the range -2**31+1 to 2**31-1, however it is
            // legal for opCodes to produce results exceeding that
            // range. This limitation is implemented by CScriptNum's
            // default 4-byte limit.
            //
            // If we kept to that limit we'd have a year 2038 problem,
            // even though the nLockTime field in transactions
            // themselves is uint32 which only becomes meaningless
            // after the year 2106.
            //
            // Thus as a special case we tell CScriptNum to accept up
            // to 5-byte bignums, which are good until 2**39-1, well
            // beyond the 2**32-1 limit of the nLockTime field itself.
            var nLockTimebuf = this.stack[this.stack.length - 1];
            var nLockTimebn = new BigIntX.fromScriptNumBuffer(
              buf: nLockTimebuf,
              fRequireMinimal: fRequireMinimal,
              nMaxNumSize: 5,
            );
            var nLockTime = nLockTimebn.toNumber();

            // In the rare event that the argument may be < 0 due to
            // some arithmetic being done first, you can always use
            // 0 MAX CHECKLOCKTIMEVERIFY.
            if (nLockTime < 0) {
              this.errStr = 'SCRIPT_ERR_NEGATIVE_LOCKTIME';
              return false;
            }

            // Actually compare the specified lock time with the transaction.
            if (!this.checkLockTime(nLockTime)) {
              this.errStr = 'SCRIPT_ERR_UNSATISFIED_LOCKTIME';
              return false;
            }
          }
          break;

        case OpCode.OP_CHECKSEQUENCEVERIFY:
          {
            if (!(this.flags & Interp.SCRIPT_VERIFY_CHECKSEQUENCEVERIFY != 0)) {
              // not enabled; treat as a NOP3
              if (this.flags &
                      Interp.SCRIPT_VERIFY_DISCOURAGE_UPGRADABLE_NOPS !=
                  0) {
                this.errStr = 'SCRIPT_ERR_DISCOURAGE_UPGRADABLE_NOPS';
                return false;
              }
              break;
            }

            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }

            // nSequence, like nLockTime, is a 32-bit unsigned integer
            // field. See the comment in CHECKLOCKTIMEVERIFY regarding
            // 5-byte numeric operands.
            var nSequencebuf = this.stack[this.stack.length - 1];
            var nSequencebn = new BigIntX.fromScriptNumBuffer(
              buf: nSequencebuf,
              fRequireMinimal: fRequireMinimal,
              nMaxNumSize: 5,
            );
            var nSequence = nSequencebn.toNumber();

            // In the rare event that the argument may be < 0 due to
            // some arithmetic being done first, you can always use
            // 0 MAX CHECKSEQUENCEVERIFY.
            if (nSequence < 0) {
              this.errStr = 'SCRIPT_ERR_NEGATIVE_LOCKTIME';
              return false;
            }

            // To provide for future soft-fork extensibility, if the
            // operand has the disabled lock-time flag set,
            // CHECKSEQUENCEVERIFY behaves as a NOP.
            if ((nSequence & TxIn.SEQUENCE_LOCKTIME_DISABLE_FLAG) != 0) {
              break;
            }

            // Compare the specified sequence number with the input.
            if (!this.checkSequence(nSequence)) {
              this.errStr = 'SCRIPT_ERR_UNSATISFIED_LOCKTIME';
              return false;
            }
          }
          break;

        case OpCode.OP_NOP1:
        case OpCode.OP_NOP3:
        case OpCode.OP_NOP4:
        case OpCode.OP_NOP5:
        case OpCode.OP_NOP6:
        case OpCode.OP_NOP7:
        case OpCode.OP_NOP8:
        case OpCode.OP_NOP9:
        case OpCode.OP_NOP10:
          if (this.flags & Interp.SCRIPT_VERIFY_DISCOURAGE_UPGRADABLE_NOPS !=
              0) {
            this.errStr = 'SCRIPT_ERR_DISCOURAGE_UPGRADABLE_NOPS';
            return false;
          }
          break;

        case OpCode.OP_IF:
        case OpCode.OP_NOTIF:
          {
            // <expression> if [statements] [else [statements]] endif
            // bool fValue = false
            var fValue = false;
            if (fExec) {
              if (this.stack.length < 1) {
                this.errStr = 'SCRIPT_ERR_UNBALANCED_CONDITIONAL';
                return false;
              }

              var buf = this.stack.removeLast();
              fValue = Interp.castToBool(buf);
              if (opCodeNum == OpCode.OP_NOTIF) {
                fValue = !fValue;
              }
            }
            this.ifStack.add(fValue);
          }
          break;

        case OpCode.OP_ELSE:
          if (this.ifStack.length == 0) {
            this.errStr = 'SCRIPT_ERR_UNBALANCED_CONDITIONAL';
            return false;
          }
          this.ifStack[this.ifStack.length - 1] =
              !this.ifStack[this.ifStack.length - 1];
          break;

        case OpCode.OP_ENDIF:
          if (this.ifStack.length == 0) {
            this.errStr = 'SCRIPT_ERR_UNBALANCED_CONDITIONAL';
            return false;
          }
          this.ifStack.removeLast();
          break;

        case OpCode.OP_VERIFY:
          {
            // (true -- ) or
            // (false -- false) and return
            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf = this.stack[this.stack.length - 1];
            var fValue = Interp.castToBool(buf);
            if (fValue) {
              this.stack.removeLast();
            } else {
              this.errStr = 'SCRIPT_ERR_VERIFY';
              return false;
            }
          }
          break;

        case OpCode.OP_RETURN:
          {
            this.errStr = 'SCRIPT_ERR_OP_RETURN';
            return false;
          }
        // unreachable code: break

        //
        // Stack ops
        //
        case OpCode.OP_TOALTSTACK:
          if (this.stack.length < 1) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          this.altStack.add(this.stack.removeLast());
          break;

        case OpCode.OP_FROMALTSTACK:
          if (this.altStack.length < 1) {
            this.errStr = 'SCRIPT_ERR_INVALID_ALTSTACK_OPERATION';
            return false;
          }
          this.stack.add(this.altStack.removeLast());
          break;

        case OpCode.OP_2DROP:
          // (x1 x2 -- )
          if (this.stack.length < 2) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          this.stack.removeLast();
          this.stack.removeLast();
          break;

        case OpCode.OP_2DUP:
          {
            // (x1 x2 -- x1 x2 x1 x2)
            if (this.stack.length < 2) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf1 = this.stack[this.stack.length - 2];
            var buf2 = this.stack[this.stack.length - 1];
            this.stack.add(buf1);
            this.stack.add(buf2);
          }
          break;

        case OpCode.OP_3DUP:
          {
            // (x1 x2 x3 -- x1 x2 x3 x1 x2 x3)
            if (this.stack.length < 3) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf1 = this.stack[this.stack.length - 3];
            var buf2 = this.stack[this.stack.length - 2];
            var buf3 = this.stack[this.stack.length - 1];
            this.stack.add(buf1);
            this.stack.add(buf2);
            this.stack.add(buf3);
          }
          break;

        case OpCode.OP_2OVER:
          {
            // (x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2)
            if (this.stack.length < 4) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf1 = this.stack[this.stack.length - 4];
            var buf2 = this.stack[this.stack.length - 3];
            this.stack.add(buf1);
            this.stack.add(buf2);
          }
          break;

        case OpCode.OP_2ROT:
          {
            // (x1 x2 x3 x4 x5 x6 -- x3 x4 x5 x6 x1 x2)
            if (this.stack.length < 6) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var spliced = this.stack.splice(this.stack.length - 6, 2);
            this.stack.add(spliced[0]);
            this.stack.add(spliced[1]);
          }
          break;

        case OpCode.OP_2SWAP:
          {
            // (x1 x2 x3 x4 -- x3 x4 x1 x2)
            if (this.stack.length < 4) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var spliced = this.stack.splice(this.stack.length - 4, 2);
            this.stack.add(spliced[0]);
            this.stack.add(spliced[1]);
          }
          break;

        case OpCode.OP_IFDUP:
          {
            // (x - 0 | x x)
            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf = this.stack[this.stack.length - 1];
            var fValue = Interp.castToBool(buf);
            if (fValue) {
              this.stack.add(buf);
            }
          }
          break;

        case OpCode.OP_DEPTH:
          {
            // -- stacksize
            var buf =
                new BigIntX.fromNum(this.stack.length).toScriptNumBuffer();
            this.stack.add(buf);
          }
          break;

        case OpCode.OP_DROP:
          // (x -- )
          if (this.stack.length < 1) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          this.stack.removeLast();
          break;

        case OpCode.OP_DUP:
          // (x -- x x)
          if (this.stack.length < 1) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          this.stack.add(this.stack[this.stack.length - 1]);
          break;

        case OpCode.OP_NIP:
          // (x1 x2 -- x2)
          if (this.stack.length < 2) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          this.stack.splice(this.stack.length - 2, 1);
          break;

        case OpCode.OP_OVER:
          // (x1 x2 -- x1 x2 x1)
          if (this.stack.length < 2) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          this.stack.add(this.stack[this.stack.length - 2]);
          break;

        case OpCode.OP_PICK:
        case OpCode.OP_ROLL:
          {
            // (xn ... x2 x1 x0 n - xn ... x2 x1 x0 xn)
            // (xn ... x2 x1 x0 n - ... x2 x1 x0 xn)
            if (this.stack.length < 2) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf = this.stack[this.stack.length - 1];
            var bn = new BigIntX.fromScriptNumBuffer(
              buf: buf,
              fRequireMinimal: fRequireMinimal,
            );
            var n = bn.toNumber();
            this.stack.removeLast();
            if (n < 0 || n >= this.stack.length) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            buf = this.stack[this.stack.length - n - 1];
            if (opCodeNum == OpCode.OP_ROLL) {
              this.stack.splice(this.stack.length - n - 1, 1);
            }
            this.stack.add(buf);
          }
          break;

        case OpCode.OP_ROT:
          {
            // (x1 x2 x3 -- x2 x3 x1)
            //  x2 x1 x3  after first swap
            //  x2 x3 x1  after second swap
            if (this.stack.length < 3) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var x1 = this.stack[this.stack.length - 3];
            var x2 = this.stack[this.stack.length - 2];
            var x3 = this.stack[this.stack.length - 1];
            this.stack[this.stack.length - 3] = x2;
            this.stack[this.stack.length - 2] = x3;
            this.stack[this.stack.length - 1] = x1;
          }
          break;

        case OpCode.OP_SWAP:
          {
            // (x1 x2 -- x2 x1)
            if (this.stack.length < 2) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var x1 = this.stack[this.stack.length - 2];
            var x2 = this.stack[this.stack.length - 1];
            this.stack[this.stack.length - 2] = x2;
            this.stack[this.stack.length - 1] = x1;
          }
          break;

        case OpCode.OP_TUCK:
          // (x1 x2 -- x2 x1 x2)
          if (this.stack.length < 2) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          this.stack.splice(
                this.stack.length - 2,
                0,
                this.stack[this.stack.length - 1],
              );
          break;

        case OpCode.OP_SIZE:
          {
            // (in -- in size)
            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var bn =
                new BigIntX.fromNum(this.stack[this.stack.length - 1].length);
            this.stack.add(bn.toScriptNumBuffer());
          }
          break;

        //
        // Bitwise logic
        //
        case OpCode.OP_OR:
        case OpCode.OP_AND:
        case OpCode.OP_XOR:
          // (x1 x2 -- out)
          if (this.stack.length < 2) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          var buf1 = this.stack[this.stack.length - 2];
          var buf2 = this.stack[this.stack.length - 1];

          if (buf1.length != buf2.length) {
            this.errStr = 'SCRIPT_ERR_INVALID_OPERAND_SIZE';
            return false;
          }

          switch (opCodeNum) {
            case OpCode.OP_AND:
              for (var i = 0; i < buf1.length; i++) {
                buf1[i] &= buf2[i];
              }
              break;
            case OpCode.OP_OR:
              for (var i = 0; i < buf1.length; i++) {
                buf1[i] |= buf2[i];
              }
              break;
            case OpCode.OP_XOR:
              for (var i = 0; i < buf1.length; i++) {
                buf1[i] ^= buf2[i];
              }
              break;
          }

          // pop out buf2
          this.stack.removeLast();
          break;
        case OpCode.OP_INVERT:
          // (x -- out)
          if (this.stack.length < 1) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }
          var buf = this.stack[this.stack.length - 1];
          for (var i = 0; i < buf.length; i++) {
            buf[i] = ~buf[i];
          }
          break;
        case OpCode.OP_LSHIFT:
        case OpCode.OP_RSHIFT:
          // (x n -- out)
          {
            if (this.stack.length < 2) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }

            var buf1 = this.stack[this.stack.length - 2];
            var value = new BigIntX.fromBuffer(buf1);
            var n = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - 1],
              fRequireMinimal: fRequireMinimal,
            ).toNumber();
            if (n < 0) {
              this.errStr = 'SCRIPT_ERR_INVALID_NUMBER_RANGE';
              return false;
            }

            this.stack.removeLast();
            this.stack.removeLast();

            switch (opCodeNum) {
              case OpCode.OP_LSHIFT:
                value = value.ushln(n);
                break;
              case OpCode.OP_RSHIFT:
                value = value.ushrn(n);
                break;
            }

            var buf2 = value.toBuffer().slice(-buf1.length);
            if (buf2.length < buf1.length) {
              // buf2 = List<int>.from(
              //     [...List<int>(buf1.length - buf2.length), ...buf2]);
              buf2 = List<int>.from([
                ...List<int>.filled(buf1.length - buf2.length, 0),
                ...buf2,
              ]);
            }

            this.stack.add(buf2);
            break;
          }
        case OpCode.OP_EQUAL:
        case OpCode.OP_EQUALVERIFY:
          // case OpCode.OP_NOTEQUAL: // use OpCode.OP_NUMNOTEQUAL
          {
            // (x1 x2 - bool)
            if (this.stack.length < 2) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf1 = this.stack[this.stack.length - 2];
            var buf2 = this.stack[this.stack.length - 1];
            var fEqual = cmp(buf1.asUint8List(), buf2.asUint8List());
            // OpCode.OP_NOTEQUAL is disabled because it would be too easy to say
            // something like n != 1 and have some wiseguy pass in 1 with extra
            // zero bytes after it (numerically, 0x01 == 0x0001 == 0x000001)
            // if (opCode == OpCode.OP_NOTEQUAL)
            //  fEqual = !fEqual
            this.stack = [...this.stack.getRange(0, this.stack.length - 1)];
            this.stack = [...this.stack.getRange(0, this.stack.length - 1)];
            // this.stack.removeLast();
            // this.stack.removeLast();
            this.stack.add(fEqual ? Interp.TRUE : Interp.FALSE);
            if (opCodeNum == OpCode.OP_EQUALVERIFY) {
              if (fEqual) {
                this.stack.removeLast();
              } else {
                this.errStr = 'SCRIPT_ERR_EQUALVERIFY';
                return false;
              }
            }
          }
          break;

        //
        // Numeric
        //
        case OpCode.OP_1ADD:
        case OpCode.OP_1SUB:
        case OpCode.OP_NEGATE:
        case OpCode.OP_ABS:
        case OpCode.OP_NOT:
        case OpCode.OP_0NOTEQUAL:
          {
            // (in -- out)
            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf = this.stack[this.stack.length - 1];
            var bn = new BigIntX.fromScriptNumBuffer(
              buf: buf,
              fRequireMinimal: fRequireMinimal,
            );
            switch (opCodeNum) {
              case OpCode.OP_1ADD:
                bn = bn.add(BigIntX.one);
                break;
              case OpCode.OP_1SUB:
                bn = bn.sub(BigIntX.one);
                break;
              case OpCode.OP_NEGATE:
                bn = bn.neg();
                break;
              case OpCode.OP_ABS:
                if (bn.lt(0)) bn = bn.neg();
                break;
              case OpCode.OP_NOT:
                int v = bn.eq(0) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              case OpCode.OP_0NOTEQUAL:
                int v = bn.neq(0) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              // default:      assert(!"invalid opCode"); break;; // TODO: does this ever occur?
            }
            this.stack.removeLast();
            this.stack.add(bn.toScriptNumBuffer());
          }
          break;

        case OpCode.OP_ADD:
        case OpCode.OP_SUB:
        case OpCode.OP_MUL:
        case OpCode.OP_DIV:
        case OpCode.OP_MOD:
        case OpCode.OP_BOOLAND:
        case OpCode.OP_BOOLOR:
        case OpCode.OP_NUMEQUAL:
        case OpCode.OP_NUMEQUALVERIFY:
        case OpCode.OP_NUMNOTEQUAL:
        case OpCode.OP_LESSTHAN:
        case OpCode.OP_GREATERTHAN:
        case OpCode.OP_LESSTHANOREQUAL:
        case OpCode.OP_GREATERTHANOREQUAL:
        case OpCode.OP_MIN:
        case OpCode.OP_MAX:
          {
            // (x1 x2 -- out)
            if (this.stack.length < 2) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var bn1 = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - 2],
              fRequireMinimal: fRequireMinimal,
            );
            var bn2 = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - 1],
              fRequireMinimal: fRequireMinimal,
            );
            var bn = BigIntX.zero;

            switch (opCodeNum) {
              case OpCode.OP_ADD:
                bn = bn1.add(bn2);
                break;

              case OpCode.OP_SUB:
                bn = bn1.sub(bn2);
                break;

              case OpCode.OP_MUL:
                bn = bn1.mul(bn2);
                break;

              case OpCode.OP_DIV:
                if (bn2.toNumber() == 0) {
                  this.errStr = "SCRIPT_ERR_DIV_BY_ZERO";
                  return false;
                }
                bn = bn1.div(bn2);
                break;

              case OpCode.OP_MOD:
                if (bn2.toNumber() == 0) {
                  this.errStr = "SCRIPT_ERR_DIV_BY_ZERO";
                  return false;
                }
                bn = bn1.mod(bn2);
                break;

              // case OpCode.OP_BOOLAND:       bn = (bn1 != bnZero && bn2 != bnZero); break;
              case OpCode.OP_BOOLAND:
                int v = (bn1.neq(0) && bn2.neq(0)) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_BOOLOR:        bn = (bn1 != bnZero || bn2 != bnZero); break;
              case OpCode.OP_BOOLOR:
                int v = (bn1.neq(0) || bn2.neq(0)) ? 1 : 0;

                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_NUMEQUAL:      bn = (bn1 == bn2); break;
              case OpCode.OP_NUMEQUAL:
                int v = bn1.eq(bn2) ? 1 : 0;

                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_NUMEQUALVERIFY:    bn = (bn1 == bn2); break;
              case OpCode.OP_NUMEQUALVERIFY:
                int v = bn1.eq(bn2) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_NUMNOTEQUAL:     bn = (bn1 != bn2); break;
              case OpCode.OP_NUMNOTEQUAL:
                int v = bn1.neq(bn2) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_LESSTHAN:      bn = (bn1 < bn2); break;
              case OpCode.OP_LESSTHAN:
                int v = bn1.lt(bn2) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_GREATERTHAN:     bn = (bn1 > bn2); break;
              case OpCode.OP_GREATERTHAN:
                int v = bn1.gt(bn2) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_LESSTHANOREQUAL:   bn = (bn1 <= bn2); break;
              case OpCode.OP_LESSTHANOREQUAL:
                int v = bn1.leq(bn2) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              // case OpCode.OP_GREATERTHANOREQUAL:  bn = (bn1 >= bn2); break;
              case OpCode.OP_GREATERTHANOREQUAL:
                int v = bn1.geq(bn2) ? 1 : 0;
                bn = new BigIntX.fromNum(v + 0);
                break;
              case OpCode.OP_MIN:
                bn = bn1.lt(bn2) ? bn1 : bn2;
                break;
              case OpCode.OP_MAX:
                bn = bn1.gt(bn2) ? bn1 : bn2;
                break;
              // default:           assert(!"invalid opCode"); break;; //TODO: does this ever occur?
            }
            this.stack.removeLast();
            this.stack.removeLast();
            this.stack.add(bn.toScriptNumBuffer());

            if (opCodeNum == OpCode.OP_NUMEQUALVERIFY) {
              // if (CastToBool(stacktop(-1)))
              if (Interp.castToBool(this.stack[this.stack.length - 1])) {
                this.stack.removeLast();
              } else {
                this.errStr = 'SCRIPT_ERR_NUMEQUALVERIFY';
                return false;
              }
            }
          }
          break;

        case OpCode.OP_WITHIN:
          {
            // (x min max -- out)
            if (this.stack.length < 3) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var bn1 = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - 3],
              fRequireMinimal: fRequireMinimal,
            );
            var bn2 = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - 2],
              fRequireMinimal: fRequireMinimal,
            );
            var bn3 = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - 1],
              fRequireMinimal: fRequireMinimal,
            );
            // bool fValue = (bn2 <= bn1 && bn1 < bn3)
            var fValue = bn2.leq(bn1) && bn1.lt(bn3);
            this.stack.removeLast();
            this.stack.removeLast();
            this.stack.removeLast();
            this.stack.add(fValue ? Interp.TRUE : Interp.FALSE);
          }
          break;

        //
        // Crypto
        //
        case OpCode.OP_RIPEMD160:
        case OpCode.OP_SHA1:
        case OpCode.OP_SHA256:
        case OpCode.OP_HASH160:
        case OpCode.OP_HASH256:
          {
            // (in -- hash)
            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            var buf = this.stack[this.stack.length - 1];
            // valtype vchnew Hash((opCode == OpCode.OP_RIPEMD160 || opCode == OpCode.OP_SHA1 || opCode == OpCode.OP_HASH160) ? 20 : 32)
            var bufHash;
            if (opCodeNum == OpCode.OP_RIPEMD160) {
              bufHash = Hash.ripemd160(buf.asUint8List()).data.toList();
            } else if (opCodeNum == OpCode.OP_SHA1) {
              bufHash = Hash.sha1(buf.asUint8List()).data.toList();
            } else if (opCodeNum == OpCode.OP_SHA256) {
              bufHash = Hash.sha256(buf.asUint8List()).data.toList();
            } else if (opCodeNum == OpCode.OP_HASH160) {
              bufHash = Hash.sha256Ripemd160(buf.asUint8List()).data.toList();
            } else if (opCodeNum == OpCode.OP_HASH256) {
              bufHash = Hash.sha256Sha256(buf.asUint8List()).data.toList();
            }
            this.stack.removeLast();
            this.stack.add(bufHash);
          }
          break;

        case OpCode.OP_CODESEPARATOR:
          // Hash starts after the code separator
          this.pBeginCodeHash = this.pc;
          break;

        case OpCode.OP_CHECKSIG:
        case OpCode.OP_CHECKSIGVERIFY:
          {
            // (sig pubKey -- bool)
            if (this.stack.length < 2) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }

            var bufSig = this.stack[this.stack.length - 2];
            var bufPubKey = this.stack[this.stack.length - 1];

            // Subset of script starting at the most recent codeseparator
            // CScript scriptCode(pBeginCodeHash, pend)
            var subScript = new Script(
              chunks: this.script.chunks.slice(this.pBeginCodeHash),
            );

            // https://github.com/Bitcoin-UAHF/spec/blob/master/replay-protected-sighash.md

            var nHashType =
                // bufSig.length > 0 ? bufSig.readUInt8(bufSig.length - 1) : 0;
                bufSig.length > 0
                    ? ByteData.view(Uint8List.fromList(bufSig).buffer)
                        .getUint8(bufSig.length - 1)
                    : 0;
            if (nHashType & Sig.SIGHASH_FORKID != 0) {
              if (!(this.flags & Interp.SCRIPT_ENABLE_SIGHASH_FORKID != 0)) {
                this.errStr = 'SCRIPT_ERR_ILLEGAL_FORKID';
                return false;
              }
            } else {
              subScript.findAndDelete(
                  new Script().writeBuffer(bufSig.asUint8List()));
            }

            if (!this.checkSigEncoding(bufSig) ||
                !this.checkPubKeyEncoding(bufPubKey)) {
              // serror is set
              return false;
            }

            var fSuccess;
            try {
              var sig = new Sig().fromTxFormat(bufSig);
              var pubKey = new PubKey().fromBuffer(bufPubKey, false);
              print('verify');
              fSuccess = this.tx.verify(
                    sig: sig,
                    pubKey: pubKey,
                    nIn: this.nIn,
                    subScript: subScript,
                    enforceLowS: (this.flags & Interp.SCRIPT_VERIFY_LOW_S) != 0,
                    valueBn: this.valueBn,
                    flags: this.flags,
                  );
            } catch (e) {
              print(e);
              // invalid sig or pubKey
              fSuccess = false;
            }

            this.stack = [...this.stack.getRange(0, this.stack.length - 1)];
            this.stack = [...this.stack.getRange(0, this.stack.length - 1)];
            // this.stack.removeLast();
            // this.stack.removeLast();
            // stack.push_back(fSuccess ? vchTrue : vchFalse)
            this.stack.add(fSuccess ? Interp.TRUE : Interp.FALSE);
            if (opCodeNum == OpCode.OP_CHECKSIGVERIFY) {
              if (fSuccess) {
                this.stack.removeLast();
              } else {
                this.errStr = 'SCRIPT_ERR_CHECKSIGVERIFY';
                return false;
              }
            }
          }
          break;

        case OpCode.OP_CHECKMULTISIG:
        case OpCode.OP_CHECKMULTISIGVERIFY:
          {
            // ([sig ...] num_of_signatures [pubKey ...] num_of_pubKeys -- bool)

            var i = 1;
            if (this.stack.length < i) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }

            var nKeysCount = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - i],
              fRequireMinimal: fRequireMinimal,
            ).toNumber();
            if (nKeysCount < 0 || nKeysCount > 20) {
              this.errStr = 'SCRIPT_ERR_PUBKEY_COUNT';
              return false;
            }
            this.nOpCount += nKeysCount;
            if (this.nOpCount > 201) {
              this.errStr = 'SCRIPT_ERR_OP_COUNT';
              return false;
            }
            // int ikey = ++i
            var ikey = ++i;
            i += nKeysCount;
            if (this.stack.length < i) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }

            var nSigsCount = new BigIntX.fromScriptNumBuffer(
              buf: this.stack[this.stack.length - i],
              fRequireMinimal: fRequireMinimal,
            ).toNumber();
            if (nSigsCount < 0 || nSigsCount > nKeysCount) {
              this.errStr = 'SCRIPT_ERR_SIG_COUNT';
              return false;
            }
            // int isig = ++i
            var isig = ++i;
            i += nSigsCount;
            if (this.stack.length < i) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }

            // Subset of script starting at the most recent codeseparator
            var subScript = new Script(
                chunks: this.script.chunks.slice(this.pBeginCodeHash));

            for (var k = 0; k < nSigsCount; k++) {
              var bufSig = this.stack[this.stack.length - isig - k];

              // https://github.com/Bitcoin-UAHF/spec/blob/master/replay-protected-sighash.md
              var nHashType = bufSig.length > 0
                  ? ByteData.view(Uint8List.fromList(bufSig).buffer)
                      .getUint8(bufSig.length - 1)
                  : 0;
              if (nHashType & Sig.SIGHASH_FORKID != 0) {
                if (!(this.flags & Interp.SCRIPT_ENABLE_SIGHASH_FORKID != 0)) {
                  this.errStr = 'SCRIPT_ERR_ILLEGAL_FORKID';
                  return false;
                }
              } else {
                // Drop the signature, since there's no way for a signature to sign itself
                subScript.findAndDelete(
                    new Script().writeBuffer(bufSig.asUint8List()));
              }
            }

            var fSuccess = true;
            while (fSuccess && nSigsCount > 0) {
              // valtype& vchSig  = stacktop(-isig)
              var bufSig = this.stack[this.stack.length - isig];
              // valtype& vchPubKey = stacktop(-ikey)
              var bufPubKey = this.stack[this.stack.length - ikey];

              if (!this.checkSigEncoding(bufSig) ||
                  !this.checkPubKeyEncoding(bufPubKey)) {
                // serror is set
                return false;
              }

              var fOk;
              try {
                var sig = new Sig().fromTxFormat(bufSig);
                var pubKey = new PubKey().fromBuffer(bufPubKey, false);
                fOk = this.tx.verify(
                      sig: sig,
                      pubKey: pubKey,
                      nIn: this.nIn,
                      subScript: subScript,
                      enforceLowS:
                          (this.flags & Interp.SCRIPT_VERIFY_LOW_S) != 0,
                      valueBn: this.valueBn,
                      flags: this.flags,
                    );
              } catch (e) {
                // invalid sig or pubKey
                fOk = false;
              }

              if (fOk) {
                isig++;
                nSigsCount--;
              }
              ikey++;
              nKeysCount--;

              // If there are more signatures left than keys left,
              // then too many signatures have failed
              if (nSigsCount > nKeysCount) {
                fSuccess = false;
              }
            }

            // Clean up stack of actual arguments
            while (i-- > 1) {
              this.stack.removeLast();
            }

            // A bug causes CHECKMULTISIG to consume one extra argument
            // whose contents were not checked in any way.
            //
            // Unfortunately this is a potential source of mutability,
            // so optionally verify it is exactly equal to zero prior
            // to removing it from the stack.
            if (this.stack.length < 1) {
              this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
              return false;
            }
            if ((this.flags & Interp.SCRIPT_VERIFY_NULLDUMMY != 0) &&
                (this.stack[this.stack.length - 1].length != 0)) {
              this.errStr = 'SCRIPT_ERR_SIG_NULLDUMMY';
              return false;
            }
            this.stack.removeLast();

            // stack.push_back(fSuccess ? vchTrue : vchFalse)
            this.stack.add(fSuccess ? Interp.TRUE : Interp.FALSE);

            if (opCodeNum == OpCode.OP_CHECKMULTISIGVERIFY) {
              if (fSuccess) {
                this.stack.removeLast();
              } else {
                this.errStr = 'SCRIPT_ERR_CHECKMULTISIGVERIFY';
                return false;
              }
            }
          }
          break;

        //
        // Byte string operations
        //
        case OpCode.OP_CAT:
          if (this.stack.length < 2) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }

          var vch1 = this.stack[this.stack.length - 2];
          var vch2 = this.stack[this.stack.length - 1];

          this.stack[this.stack.length - 2] =
              List<int>.from([...vch1, ...vch2]);
          this.stack.removeLast();
          break;

        case OpCode.OP_SPLIT:
          if (this.stack.length < 2) {
            this.errStr = 'SCRIPT_ERR_INVALID_STACK_OPERATION';
            return false;
          }

          var data = this.stack[this.stack.length - 2];
          var position = new BigIntX.fromScriptNumBuffer(
            buf: this.stack[this.stack.length - 1],
            fRequireMinimal: fRequireMinimal,
          );

          if (position.lt(0) || position.gt(data.length)) {
            this.errStr = 'SCRIPT_ERR_INVALID_SPLIT_RANGE';
            return false;
          }

          var n1 = data.slice(0, position.toInt());
          var n2 = data.slice(position.toInt());

          this.stack.removeLast();
          this.stack.removeLast();

          this.stack.add(n1);
          this.stack.add(n2);

          break;

        default:
          this.errStr = 'SCRIPT_ERR_BAD_OPCODE';
          return false;
      }
    }

    return true;
  }

  // /**
  //  * This has the same interface as bitcoin core's VerifyScript and is
  //  * the you want to use to know if a particular input in a
  //  * transaction is valid or not. It simply iterates over the results generated
  //  * by the results method.
  //  */
  // verify (scriptSig, scriptPubKey, tx, nIn, flags, valueBn) {
  Future<bool> verify({
    Script scriptSig,
    Script scriptPubKey,
    Tx tx,
    int nIn,
    int flags,
    BigIntX valueBn,
  }) async {
    var results = this.results(
      scriptSig: scriptSig,
      scriptPubKey: scriptPubKey,
      tx: tx,
      nIn: nIn,
      flags: flags,
      valueBn: valueBn,
    );

    var result = true;
    await for (var success in results) {
      print("one of results is $success");
      if (!success) {
        // return false;
        print(this.errStr);
        result = false;
        break;
      }
    }

    // return true;
    return result;
  }

  // ignore: slash_for_doc_comments
  /**
   * Gives you the results of the execution each operation of the scripSig and
   * scriptPubKey corresponding to a particular input (nIn) for the concerned
   * transaction (tx). Each result can be either true or false. If true, then
   * the operation did not invalidate the transaction. If false, then the
   * operation has invalidated the script, and the transaction is not valid.
   * flags is a number that can pass in some special flags, such as whether or
   * not to execute the redeemScript in a p2sh transaction.
   *
   * This method is translated from bitcoin core's VerifyScript.  This
   * is a generator, thus you can and need to iterate through it.  To
   * automatically return true or false, use the verify method.
   */
  Stream<bool> results({
    Script scriptSig,
    Script scriptPubKey,
    Tx tx,
    int nIn,
    int flags,
    BigIntX valueBn,
  }) async* {
    List<List<int>> stackCopy;

    this.script = scriptSig ?? this.script;
    this.tx = tx ?? this.tx;
    this.nIn = nIn ?? this.nIn;
    this.flags = flags ?? this.flags;
    this.valueBn = valueBn ?? this.valueBn;

    if (((flags ?? 0) & Interp.SCRIPT_VERIFY_SIGPUSHONLY) != 0 &&
        !scriptSig.isPushOnly()) {
      this.errStr =
          this.errStr.isNotEmpty ? this.errStr : 'SCRIPT_ERR_SIG_PUSHONLY';
      yield false;
    }

    yield* this.eval();

    if ((flags ?? 0) & Interp.SCRIPT_VERIFY_P2SH != 0) {
      stackCopy = List<List<int>>.from(this.stack);
    }

    var stack = this.stack;
    this.initialize();
    this.script = scriptPubKey ?? this.script;
    this.stack = [...stack] ?? this.stack;
    this.tx = tx ?? this.tx;
    this.nIn = nIn ?? this.nIn;
    this.flags = flags ?? this.flags;
    this.valueBn = valueBn ?? this.valueBn;

    yield* this.eval();

    if (this.stack.length == 0) {
      this.errStr =
          this.errStr.isNotEmpty ? this.errStr : 'SCRIPT_ERR_EVAL_FALSE';
      yield false;
      return;
    }

    // var buf = this.stack[this.stack.length - 1];
    var buf = this.stack.last;
    if (!Interp.castToBool(buf)) {
      this.errStr =
          this.errStr.isNotEmpty ? this.errStr : 'SCRIPT_ERR_EVAL_FALSE';
      yield false;
    }

    // Additional validation for spend-to-script-hash transactions:
    if (((flags ?? 0) & Interp.SCRIPT_VERIFY_P2SH != 0) &&
        scriptPubKey.isScriptHashOut()) {
      // scriptSig must be literals-only or validation fails
      if (!scriptSig.isPushOnly()) {
        this.errStr =
            this.errStr.isNotEmpty ? this.errStr : 'SCRIPT_ERR_SIG_PUSHONLY';
        yield false;
      }

      // Restore stack.
      var tmp = stack;
      stack = stackCopy;
      stackCopy = tmp;

      // stack cannot be empty here, because if it was the
      // P2SH  HASH <> EQUAL  scriptPubKey would be evaluated with
      // an empty stack and the EvalScript above would yield false.
      if (stack.length == 0) {
        throw ('internal error - stack copy empty');
      }

      var pubKeySerialized = stack[stack.length - 1];
      var scriptPubKey2 = new Script().fromBuffer(pubKeySerialized);
      stack.removeLast();

      this.initialize();
      // this.fromObject({
      this.script = scriptPubKey2;
      this.stack = stack;
      this.tx = tx;
      this.nIn = nIn;
      this.flags = flags;
      this.valueBn = valueBn;
      // })

      yield* this.eval();

      if (stack.length == 0) {
        this.errStr =
            this.errStr.isNotEmpty ? this.errStr : 'SCRIPT_ERR_EVAL_FALSE';
        yield false;
      }

      if (!Interp.castToBool(stack[stack.length - 1])) {
        this.errStr =
            this.errStr.isNotEmpty ? this.errStr : 'SCRIPT_ERR_EVAL_FALSE';
        yield false;
      } else {
        yield true;
      }
    }

    // The CLEANSTACK check is only performed after potential P2SH evaluation,
    // as the non-P2SH evaluation of a P2SH script will obviously not result in
    // a clean stack (the P2SH inputs remain).
    if (((flags ?? 0) & Interp.SCRIPT_VERIFY_CLEANSTACK) != 0) {
      // Disallow CLEANSTACK without P2SH, as otherwise a switch
      // CLEANSTACK->P2SH+CLEANSTACK would be possible, which is not a softfork
      // (and P2SH should be one).
      if (!((flags ?? 0) & Interp.SCRIPT_VERIFY_P2SH != 0)) {
        throw ('cannot use CLEANSTACK without P2SH');
      }
      if (this.stack.length != 1) {
        this.errStr =
            this.errStr.isNotEmpty ? this.errStr : 'SCRIPT_ERR_CLEANSTACK';
        yield false;
      }
    }

    yield true;
  }

  // ignore: slash_for_doc_comments
  /**
   * If the script has failed, this methods returns valuable debug
   * information about exactly where the script failed. It is a
   * JSON-compatible object so it can be easily stringified. pc refers to the
   * currently executing opcode.
   */
  Map<String, Object> getDebugObject() {
    var pc = this.pc - 1; // pc is incremented immediately after getting
    return {
      "errStr": this.errStr,
      "scriptStr":
          this.script != null ? this.script.toString() : 'no script found',
      "pc": pc,
      "stack": this.stack.map((buf) => hex.encode(buf)).toList(),
      "altStack": this.altStack.map((buf) => hex.encode(buf)).toList(),
      "opCodeStr": this.script != null
          ? OpCode.fromNumber(this.script.chunks[pc].opCodeNum).toString()
          : 'no script found'
    };
  }

  String getDebugString() {
    // return json.encode(this.getDebugObject(), null, 2)
    return json.encode(this.getDebugObject());
  }
}
