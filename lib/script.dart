// ignore: slash_for_doc_comments
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bsv/bn.dart';
import 'package:bsv/br.dart';
import 'package:bsv/bw.dart';
import 'package:bsv/cmp.dart';
import 'package:bsv/op_code.dart';
import 'package:bsv/pub_key.dart';
import 'package:convert/convert.dart';

import 'package:bsv/extentsions/list.dart';

// ignore: slash_for_doc_comments
/**
 * Script
 * ====
 *
 * Script is the scripting language built into bitcoin. The Script class vars
 * you create an instance of a script, e.g. for a scriptSig or a scriptPubKey.
 * It understands both the binary format, as well as two different string
 * formats. The default string format, to/fromString, is a custom format only
 * used by Yours Bitcoin because it is isomorphic to the binary format (or as
 * isomorphic as it can be ... since OP_0 and OP_FALSE have the same byte
 * value, and so do OP_1 and OP_TRUE). The bitcoind string format is also
 * support, but that format is not isomorphic (i.e., if you pull in a string
 * and then write it again, you are likely to get back a different string, even
 * if you don't use OP_0, OP_FALSE, OP_1, or OP_TRUE).
 */

class ScriptChunk {
  Uint8List buf;
  int len;
  int opCodeNum;

  ScriptChunk({
    this.buf,
    this.len,
    this.opCodeNum,
  });
}

class Script {
  List<ScriptChunk> chunks;

  static const ERROR_INVALID_SCRIPT = 'Invalid script';

  static const ERROR_INVALID_PUSHDATA_DATA = 'Pushdata data must start with 0x';

  static const ERROR_INVALID_SCRIPT_TYPE =
      'Could not determine type of script value';

  static const ERROR_PUSH_TOO_MUCH_DATA = "You can't push that much data";

  static const ERROR_INVALIDA_HEX_STRING = "invalid hex string in script";

  static const ERROR_UNRECOGNIZED_SCRIPT =
      "Unrecognized script type to get data from";

  static const ERROR_HASHBUF_MUST_BE_20 = "hashBuf must be a 20 byte buffer";

  Script({List<ScriptChunk> chunks}) {
    this.chunks = chunks ?? [];
  }

  factory Script.fromBitcoindString(String str) {
    return new Script().fromBitcoindString(str);
  }

  factory Script.fromAsmString(String str) {
    return new Script().fromAsmString(str);
  }

  factory Script.fromOpReturnData(Uint8List dataBuf) {
    return new Script().fromOpReturnData(dataBuf);
  }

  factory Script.fromSafeData(Uint8List dataBuf) {
    return new Script().fromSafeData(dataBuf);
  }

  factory Script.fromSafeDataArray(List<Uint8List> dataBuf) {
    return new Script().fromSafeDataArray(dataBuf);
  }

  factory Script.fromPubKeyHash(Uint8List dataBuf) {
    return new Script().fromPubKeyHash(dataBuf);
  }

  factory Script.fromPubKeys(int m, List<PubKey> pubKeys, [bool sort]) {
    return new Script().fromPubKeys(m, pubKeys, sort);
  }

  factory Script.writeScript(Script script) {
    return new Script().writeScript(script);
  }

  factory Script.writeString(String str) {
    return new Script().writeString(str);
  }

  factory Script.writeBn(BigIntX bn) {
    return new Script().writeBn(bn);
  }

  factory Script.writeNumber(int number) {
    return new Script().writeNumber(number);
  }

  factory Script.writeBuffer(Uint8List buf) {
    return new Script().writeBuffer(buf);
  }

  factory Script.fromHex(String hexStr) {
    return new Script().fromHex(hexStr);
  }

  factory Script.fromString(String str) {
    return new Script().fromString(str);
  }

  factory Script.writeOpCode(int opCodeNum) {
    return new Script().writeOpCode(opCodeNum);
  }

  factory Script.fromBuffer(Uint8List buf) {
    return new Script().fromBuffer(buf);
  }

  Script fromJSON(json) {
    return this.fromString(json);
  }

  String toJSON() {
    return this.toString();
  }

  Script fromHex(String hexStr) {
    this.fromBuffer(Uint8List.fromList(hex.decode(hexStr)));
    return this;
  }

  Script fromBuffer(Uint8List buf) {
    this.chunks = List<ScriptChunk>.from([]);

    var br = new Br(buf: buf);
    while (!br.eof()) {
      var opCodeNum = br.readUInt8();

      var len = 0;
      var buf = Uint8List.fromList([]);
      if (opCodeNum > 0 && opCodeNum < OpCode.OP_PUSHDATA1) {
        len = opCodeNum;
        buf = br.read(len);
        this.add(ScriptChunk(
          buf: buf,
          len: len,
          opCodeNum: opCodeNum,
        ));
      } else if (opCodeNum == OpCode.OP_PUSHDATA1) {
        try {
          len = br.readUInt8();
          buf = br.read(len);
        } catch (err) {
          br.read();
        }
        this.add(ScriptChunk(
          buf: buf,
          len: len,
          opCodeNum: opCodeNum,
        ));
      } else if (opCodeNum == OpCode.OP_PUSHDATA2) {
        try {
          len = br.readUInt16LE();
          buf = br.read(len);
        } catch (err) {
          br.read();
        }
        this.add(ScriptChunk(
          buf: buf,
          len: len,
          opCodeNum: opCodeNum,
        ));
      } else if (opCodeNum == OpCode.OP_PUSHDATA4) {
        print('OP_PUSHDATA4');
        try {
          len = br.readUInt32LE();
          buf = br.read(len);
        } catch (err) {
          br.read();
        }
        this.add(ScriptChunk(
          buf: buf,
          len: len,
          opCodeNum: opCodeNum,
        ));
      } else {
        // print('add 0');
        this.add(ScriptChunk(
          opCodeNum: opCodeNum,
        ));
      }
    }

    return this;
  }

  List<int> toBuffer() {
    var bw = new Bw();

    for (var i = 0; i < this.chunks.length; i++) {
      var chunk = this.chunks[i];
      var opCodeNum = chunk.opCodeNum;
      bw.writeUInt8(opCodeNum);
      if (chunk.buf != null) {
        if (opCodeNum < OpCode.OP_PUSHDATA1) {
          bw.write(chunk.buf);
        } else if (opCodeNum == OpCode.OP_PUSHDATA1) {
          bw.writeUInt8(chunk.len);
          bw.write(chunk.buf);
        } else if (opCodeNum == OpCode.OP_PUSHDATA2) {
          bw.writeUInt16LE(chunk.len);
          bw.write(chunk.buf);
        } else if (opCodeNum == OpCode.OP_PUSHDATA4) {
          bw.writeUInt32LE(chunk.len);
          bw.write(chunk.buf);
        }
      }
    }

    return bw.toBuffer();
  }

  String toHex() {
    return this.toBuffer().toHex();
  }

  Script add(ScriptChunk chunk) {
    this.chunks = List<ScriptChunk>.from([
      ...this.chunks,
      chunk,
    ]);
    return this;
  }

  Script fromString(String str) {
    this.chunks = List<ScriptChunk>.from([]);
    if (str == '' || str == null) {
      return this;
    }

    var tokens = str.split(' ');
    var i = 0;
    while (i < tokens.length) {
      var token = tokens[i];
      var opCodeNum;
      try {
        var opCode = new OpCode().fromString(token);
        opCodeNum = opCode.toNumber();
      } catch (err) {}

      if (opCodeNum == null) {
        opCodeNum = int.tryParse(token, radix: 10);
        if (opCodeNum > 0 && opCodeNum < OpCode.OP_PUSHDATA1) {
          var buf = Uint8List.fromList(hex.decode(tokens[i + 1].substring(2)));
          this.add(ScriptChunk(
            buf: buf,
            len: opCodeNum,
            opCodeNum: opCodeNum,
          ));
          i = i + 2;
        } else if (opCodeNum == 0) {
          this.add(ScriptChunk(
            opCodeNum: 0,
          ));
          i = i + 1;
        } else {
          throw ERROR_INVALID_SCRIPT;
        }
      } else if (opCodeNum == OpCode.OP_PUSHDATA1 ||
          opCodeNum == OpCode.OP_PUSHDATA2 ||
          opCodeNum == OpCode.OP_PUSHDATA4) {
        if (tokens[i + 2].substring(0, 2) != '0x') {
          throw ERROR_INVALID_PUSHDATA_DATA;
        }
        var buf = Uint8List.fromList(hex.decode(tokens[i + 2].substring(2)));
        this.add(ScriptChunk(
          buf: buf,
          len: int.tryParse(tokens[i + 1], radix: 10),
          opCodeNum: opCodeNum,
        ));

        i = i + 3;
      } else {
        this.add(ScriptChunk(
          opCodeNum: opCodeNum,
        ));
        i = i + 1;
      }
    }
    return this;
  }

  String toString() {
    var str = '';

    for (var i = 0; i < this.chunks.length; i++) {
      var chunk = this.chunks[i];
      var opCodeNum = chunk.opCodeNum;
      if (chunk.buf == null) {
        if (OpCode.str[opCodeNum] != null) {
          str = str + ' ' + new OpCode(number: opCodeNum).toString();
        } else {
          str = str + ' ' + '0x' + opCodeNum.toRadixString(16);
        }
      } else {
        if (opCodeNum == OpCode.OP_PUSHDATA1 ||
            opCodeNum == OpCode.OP_PUSHDATA2 ||
            opCodeNum == OpCode.OP_PUSHDATA4) {
          str = str + ' ' + new OpCode(number: opCodeNum).toString();
        }
        str = str + ' ' + "${chunk.len}";
        str = str + ' ' + '0x' + hex.encode(chunk.buf);
      }
    }

    return str.isEmpty ? str : str.substring(1);
  }

  // ignore: slash_for_doc_comments
  /**
   * Input the script from the script string format used in bitcoind data tests
   */
  Script fromBitcoindString(str) {
    var bw = new Bw();
    var tokens = str.split(' ');
    var i;
    for (i = 0; i < tokens.length; i++) {
      String token = tokens[i];
      if (token == '') {
        continue;
      }

      if (token[0] == '0' && token.length >= 2 && token[1] == 'x') {
        var hexStr = token.substring(2);
        bw.write(Uint8List.fromList(hex.decode(hexStr)));
      } else if (token[0] == "'") {
        var tstr = token.substring(1, token.length - 1);
        // var t = utf8.encode(tstr);
        // var cbuf = Uint8List.fromList(hex.decode(tstr));
        var cbuf = Uint8List.fromList(utf8.encode(tstr));
        var tbuf =
            Uint8List.fromList(new Script().writeBuffer(cbuf).toBuffer());
        bw.write(tbuf);
      } else if (OpCode.map['OP_' + token] != null) {
        var opstr = 'OP_' + token;
        var opCodeNum = OpCode.map[opstr];
        bw.writeUInt8(opCodeNum);
      } else if (OpCode.map[token] is int) {
        var opstr = token;
        var opCodeNum = OpCode.map[opstr];
        bw.writeUInt8(opCodeNum);
      } else if (int.tryParse(token, radix: 10) is int) {
        var bn = new BigIntX.fromNum(int.tryParse(token));
        var script = new Script().writeBn(bn);
        var tbuf = Uint8List.fromList(script.toBuffer());
        bw.write(tbuf);
      } else {
        throw ERROR_INVALID_SCRIPT_TYPE;
      }
    }
    var buf = bw.toBuffer();
    return this.fromBuffer(Uint8List.fromList(buf));
  }

  // ignore: slash_for_doc_comments
  /**
   * Output the script to the script string format used in bitcoind data tests.
   */
  String toBitcoindString() {
    var str = '';
    for (var i = 0; i < this.chunks.length; i++) {
      var chunk = this.chunks[i];
      if (chunk.buf != null) {
        var buf = new Script(chunks: [chunk]).toBuffer();
        var hexStr = hex.encode(buf);
        str = str + ' ' + '0x' + hexStr;
      } else if (OpCode.str[chunk.opCodeNum] != null) {
        var ostr = new OpCode(number: chunk.opCodeNum).toString();
        str = str + ' ' + ostr.substring(3); // remove OP_
      } else {
        str = str + ' ' + '0x' + chunk.opCodeNum.toRadixString(16);
      }
    }
    return str.isNotEmpty ? str.substring(1) : str;
  }

  // ignore: slash_for_doc_comments
  /**
   * Input the script from the script string format used in bitcoind data tests
   */
  Script fromAsmString(String str) {
    this.chunks = List<ScriptChunk>.from([]);

    var tokens = str.split(' ');
    var i = 0;
    while (i < tokens.length) {
      var token = tokens[i];
      var opCode, opCodeNum;
      try {
        opCode = OpCode.fromString(token);
        opCodeNum = opCode.toNumber();
      } catch (err) {
        opCode = null;
        opCodeNum = null;
      }

      // we start with two special cases, 0 and -1, which are handled specially in
      // toASM. see _chunkToString.
      if (token == '0') {
        opCodeNum = 0;
        this.add(ScriptChunk(opCodeNum: opCodeNum));
        i = i + 1;
      } else if (token == '-1') {
        opCodeNum = OpCode.OP_1NEGATE;
        this.add(ScriptChunk(opCodeNum: opCodeNum));
        i = i + 1;
      } else if (opCode == null) {
        var hexStr = tokens[i];
        var buf = hex.decode(hexStr);

        if (hex.encode(buf) != hexStr) {
          throw ERROR_INVALIDA_HEX_STRING;
        }
        var len = buf.length;
        if (len >= 0 && len < OpCode.OP_PUSHDATA1) {
          opCodeNum = len;
        } else if (len < pow(2, 8)) {
          opCodeNum = OpCode.OP_PUSHDATA1;
        } else if (len < pow(2, 16)) {
          opCodeNum = OpCode.OP_PUSHDATA2;
        } else if (len < pow(2, 32)) {
          opCodeNum = OpCode.OP_PUSHDATA4;
        }

        this.add(ScriptChunk(
          buf: buf,
          len: buf.length,
          opCodeNum: opCodeNum,
        ));
        i = i + 1;
      } else {
        this.add(ScriptChunk(opCodeNum: opCodeNum));
        i = i + 1;
      }
    }
    return this;
  }

  // /**
  //    * Output the script to the script string format used in bitcoind data tests.
  //    */
  String toAsmString() {
    var str = '';
    for (var i = 0; i < this.chunks.length; i++) {
      var chunk = this.chunks[i];
      str += this._chunkToString(chunk);
    }

    return str.substring(1);
  }

  String _chunkToString(ScriptChunk chunk) {
    var opCodeNum = chunk.opCodeNum;
    var str = '';
    if (chunk.buf == null) {
      // no data chunk
      if (OpCode.str[opCodeNum] != null) {
        // A few cases where the opcode name differs from reverseMap
        // aside from 1 to 16 data pushes.
        if (opCodeNum == 0) {
          // OP_0 -> 0
          str = str + ' 0';
        } else if (opCodeNum == 79) {
          // OP_1NEGATE -> 1
          str = str + ' -1';
        } else {
          str = str + ' ' + new OpCode(number: opCodeNum).toString();
        }
      } else {
        var numstr = opCodeNum.toRadixString(16);
        if (numstr.length % 2 != 0) {
          numstr = '0' + numstr;
        }
        str = str + ' ' + numstr;
      }
    } else {
      // data chunk
      if (chunk.len != null && chunk.len > 0) {
        str = str + ' ' + hex.encode(chunk.buf);
      }
    }
    return str;
  }

  fromOpReturnData(Uint8List dataBuf) {
    this.writeOpCode(OpCode.OP_RETURN);
    this.writeBuffer(dataBuf);
    return this;
  }

  Script fromSafeData(Uint8List dataBuf) {
    this.writeOpCode(OpCode.OP_FALSE);
    this.writeOpCode(OpCode.OP_RETURN);
    this.writeBuffer(dataBuf);
    return this;
  }

  fromSafeDataArray(List<Uint8List> dataBufs) {
    this.writeOpCode(OpCode.OP_FALSE);
    this.writeOpCode(OpCode.OP_RETURN);
    for (var i in dataBufs) {
      var dataBuf = i;
      this.writeBuffer(dataBuf);
    }
    return this;
  }

  List<Uint8List> getData() {
    if (this.isSafeDataOut()) {
      var chunks = this.chunks.sublist(2);
      var buffers = chunks.map((chunk) => chunk.buf).toList();
      return buffers;
    }
    if (this.isOpReturn()) {
      var chunks = this.chunks.sublist(1);
      var buffers = chunks.map((chunk) => chunk.buf).toList();
      return buffers;
    }
    throw ERROR_UNRECOGNIZED_SCRIPT;
  }

  // ignore: slash_for_doc_comments
  /**
   * Turn script into a standard pubKeyHash output script
   */
  Script fromPubKeyHash(Uint8List hashBuf) {
    if (hashBuf.length != 20) {
      throw ERROR_HASHBUF_MUST_BE_20;
    }
    this.writeOpCode(OpCode.OP_DUP);
    this.writeOpCode(OpCode.OP_HASH160);
    this.writeBuffer(hashBuf);
    this.writeOpCode(OpCode.OP_EQUALVERIFY);
    this.writeOpCode(OpCode.OP_CHECKSIG);
    return this;
  }

  static List<PubKey> sortPubKeys(List<PubKey> pubKeys) {
    pubKeys.sort((pubKey1, pubKey2) {
      var buf1 = pubKey1.toBuffer();
      var buf2 = pubKey2.toBuffer();
      var len = max(buf1.length, buf2.length);
      for (var i = 0; i <= len; i++) {
        if (i >= buf1.length) {
          return -1; // shorter strings come first
        }
        if (i >= buf2.length) {
          return 1;
        }
        if (buf1[i] < buf2[i]) {
          return -1;
        }
        if (buf1[i] > buf2[i]) {
          return 1;
        } else {
          continue;
        }
      }
      return 0;
    });
    return pubKeys;
  }

  // ignore: slash_for_doc_comments
  /**
   * Generate a multisig output script from a list of public keys. sort
   * defaults to true. If sort is true, the pubKeys are sorted
   * lexicographically.
   */
  Script fromPubKeys(int m, List<PubKey> pubKeys, [sort = true]) {
    if (sort == true) {
      pubKeys = Script.sortPubKeys(pubKeys);
    }
    this.writeOpCode(m + OpCode.OP_1 - 1);
    for (var i in pubKeys) {
      this.writeBuffer(Uint8List.fromList(i.toBuffer()));
    }
    this.writeOpCode(pubKeys.length + OpCode.OP_1 - 1);
    this.writeOpCode(OpCode.OP_CHECKMULTISIG);
    return this;
  }

  Script removeCodeseparators() {
    List<ScriptChunk> chunks = [];
    for (var i = 0; i < this.chunks.length; i++) {
      if (this.chunks[i].opCodeNum != OpCode.OP_CODESEPARATOR) {
        chunks.add(this.chunks[i]);
      }
    }
    this.chunks = chunks;
    return this;
  }

  bool isPushOnly() {
    for (var i = 0; i < this.chunks.length; i++) {
      var chunk = this.chunks[i];
      var opCodeNum = chunk.opCodeNum;
      if (opCodeNum > OpCode.OP_16) {
        return false;
      }
    }
    return true;
  }

  bool isOpReturn() {
    if (this.chunks[0].opCodeNum == OpCode.OP_RETURN &&
        this.chunks.where((chunk) => chunk.buf is Uint8List).length ==
            this.chunks.sublist(1).length) {
      return true;
    } else {
      return false;
    }
  }

  bool isSafeDataOut() {
    if (this.chunks.length < 2) {
      return false;
    }
    if (this.chunks[0].opCodeNum != OpCode.OP_FALSE) {
      return false;
    }
    var chunks = this.chunks.sublist(1);
    var script2 = new Script(chunks: chunks);
    return script2.isOpReturn();
  }

  bool isPubKeyHashOut() {
    if (this.chunks.length > 0 &&
        this.chunks[0] != null &&
        this.chunks[0].opCodeNum == OpCode.OP_DUP &&
        this.chunks.length > 1 &&
        this.chunks[1] != null &&
        this.chunks[1].opCodeNum == OpCode.OP_HASH160 &&
        this.chunks.length > 2 &&
        this.chunks[2].buf != null &&
        this.chunks.length > 3 &&
        this.chunks[3] != null &&
        this.chunks[3].opCodeNum == OpCode.OP_EQUALVERIFY &&
        this.chunks.length > 4 &&
        this.chunks[4] != null &&
        this.chunks[4].opCodeNum == OpCode.OP_CHECKSIG) {
      return true;
    } else {
      return false;
    }
  }

  // ignore: slash_for_doc_comments
  /**
   * A pubKeyHash input should consist of two push operations. The first push
   * operation may be OP_0, which means the signature is missing, which is true
   * for some partially signed (and invalid) transactions.
   */
  bool isPubKeyHashIn() {
    if (this.chunks.length == 2 &&
        (this.chunks[0].buf != null ||
            this.chunks[0].opCodeNum == OpCode.OP_0) &&
        (this.chunks[1].buf != null ||
            this.chunks[0].opCodeNum == OpCode.OP_0)) {
      return true;
    } else {
      return false;
    }
  }

  bool isScriptHashOut() {
    var buf = this.toBuffer();
    return (buf.length == 23 &&
        buf[0] == OpCode.OP_HASH160 &&
        buf[1] == 0x14 &&
        buf[22] == OpCode.OP_EQUAL);
  }

  // ignore: slash_for_doc_comments
  /**
   * Note that these are frequently indistinguishable from pubKeyHashin
   */
  bool isScriptHashIn() {
    if (!this.isPushOnly()) {
      return false;
    }
    try {
      new Script().fromBuffer(this.chunks[this.chunks.length - 1].buf);
    } catch (err) {
      return false;
    }
    return true;
  }

  bool isMultiSigOut() {
    var m = this.chunks[0].opCodeNum - OpCode.OP_1 + 1;
    if (!(m >= 1 && m <= 16)) {
      return false;
    }
    var pubKeychunks = this.chunks.slice(1, this.chunks.length - 2);
    if (!pubKeychunks.every((chunk) {
      try {
        var buf = chunk.buf;
        var pubKey = new PubKey().fromDer(buf);
        pubKey.validate();
        return true;
      } catch (err) {
        return false;
      }
    })) {
      return false;
    }
    var n = this.chunks[this.chunks.length - 2].opCodeNum - OpCode.OP_1 + 1;
    if (!(n >= m && n <= 16)) {
      return false;
    }
    if (this.chunks[1 + n + 1].opCodeNum != OpCode.OP_CHECKMULTISIG) {
      return false;
    }
    return true;
  }

  bool isMultiSigIn() {
    if (this.chunks[0].opCodeNum != OpCode.OP_0) {
      return false;
    }
    var remaining = this.chunks.sublist(1);
    if (remaining.length < 1) {
      return false;
    }
    return remaining
        // .every((chunk) => chunk.buf is Uint8List && Sig.IsTxDer(chunk.buf));
        .every((chunk) => chunk.buf is Uint8List && true);
  }

  // ignore: slash_for_doc_comments
  /**
     * Analagous to bitcoind's findAndDelete Find and devare equivalent chunks,
     * typically used with push data chunks.  Note that this will find and devare
     * not just the same data, but the same data with the same push data op as
     * produced by default. i.e., if a pushdata in a tx does not use the minimal
     * pushdata op, then when you try to remove the data it is pushing, it will not
     * be removed, because they do not use the same pushdata op.
     */
  Script findAndDelete(Script script) {
    var buf = Uint8List.fromList(script.toBuffer());
    for (var i = 0; i < this.chunks.length; i++) {
      var script2 = new Script(chunks: [this.chunks[i]]);
      var buf2 = Uint8List.fromList(script2.toBuffer());
      if (cmp(buf, buf2)) {
        // this.chunks.slice(i, 1);
        this.chunks.removeAt(i);
      }
    }
    return this;
  }

  Script writeScript(Script script) {
    this.chunks = [
      ...this.chunks,
      ...script.chunks,
    ];
    return this;
  }

  Script writeString(String str) {
    var script = new Script().fromString(str);
    this.chunks = [
      ...this.chunks,
      ...script.chunks,
    ];
    return this;
  }

  Script writeOpCode(int opCodeNum) {
    this.add(ScriptChunk(opCodeNum: opCodeNum));
    return this;
  }

  Script setChunkOpCode(int i, int opCodeNum) {
    this.chunks[i] = ScriptChunk(opCodeNum: opCodeNum);
    return this;
  }

  // // write a big number in the minimal way
  Script writeBn(BigIntX bn) {
    if (bn.cmp(0) == OpCode.OP_0) {
      this.add(ScriptChunk(opCodeNum: OpCode.OP_0));
    } else if (bn.cmp(-1) == 0) {
      this.add(ScriptChunk(opCodeNum: OpCode.OP_1NEGATE));
    } else if (bn.cmp(1) >= 0 && bn.cmp(16) <= 0) {
      // see OP_1 - OP_16
      this.add(ScriptChunk(opCodeNum: bn.toNumber() + OpCode.OP_1 - 1));
    } else {
      var buf = bn.toSm(endian: Endian.little).asUint8List();
      this.writeBuffer(buf);
    }
    return this;
  }

  Script writeNumber(int number) {
    this.writeBn(new BigIntX.fromNum(number));
    return this;
  }

  Script setChunkBn(int i, BigIntX bn) {
    this.chunks[i] = new Script().writeBn(bn).chunks[0];
    return this;
  }

  // note: this does not necessarily write buffers in the minimal way
  // to write numbers in the minimal way, see writeBn
  Script writeBuffer(Uint8List buf) {
    var opCodeNum;
    var len = buf.length;
    if (buf.length > 0 && buf.length < OpCode.OP_PUSHDATA1) {
      opCodeNum = buf.length;
    } else if (buf.length == 0) {
      opCodeNum = OpCode.OP_0;
    } else if (buf.length < pow(2, 8)) {
      opCodeNum = OpCode.OP_PUSHDATA1;
    } else if (buf.length < pow(2, 16)) {
      opCodeNum = OpCode.OP_PUSHDATA2;
    } else if (buf.length < pow(2, 32)) {
      opCodeNum = OpCode.OP_PUSHDATA4;
    } else {
      throw ERROR_PUSH_TOO_MUCH_DATA;
    }
    this.add(ScriptChunk(
      buf: buf,
      len: len,
      opCodeNum: opCodeNum,
    ));
    return this;
  }

  Script setChunkBuffer(int i, Uint8List buf) {
    this.chunks[i] = new Script().writeBuffer(buf).chunks[0];
    return this;
  }

  // make sure a push is the smallest way to push that particular data
  // comes from bitcoind's script interpreter CheckMinimalPush function
  bool checkMinimalPush(int i) {
    var chunk = this.chunks[i];
    var buf = chunk.buf;
    var opCodeNum = chunk.opCodeNum;
    if (buf == null) {
      return true;
    }
    if (buf.length == 0) {
      // Could have used OP_0.
      return opCodeNum == OpCode.OP_0;
    } else if (buf.length == 1 && buf[0] >= 1 && buf[0] <= 16) {
      // Could have used OP_1 .. OP_16.
      return opCodeNum == OpCode.OP_1 + (buf[0] - 1);
    } else if (buf.length == 1 && buf[0] == 0x81) {
      // Could have used OP_1NEGATE.
      return opCodeNum == OpCode.OP_1NEGATE;
    } else if (buf.length <= 75) {
      // Could have used a direct push (opCode indicating number of bytes pushed + those bytes).
      return opCodeNum == buf.length;
    } else if (buf.length <= 255) {
      // Could have used OP_PUSHDATA.
      return opCodeNum == OpCode.OP_PUSHDATA1;
    } else if (buf.length <= 65535) {
      // Could have used OP_PUSHDATA2.
      return opCodeNum == OpCode.OP_PUSHDATA2;
    }
    return true;
  }
}
