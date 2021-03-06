/*
 * OpCode
 * ======
 *
 * An opCode is one of the operations in the bitcoin scripting language. Each
 * operation is just a number from 0-255, and it has a corresponding string,
 * e.g. "OP_RETURN", which comes from the name of that constant in the bitcoind
 * source code. The way you probably want to use this is with
 * new OpCode(str).toNumber() or new OpCode(num).toString()
 */
class OpCode {
  late int number;

  static const INVALID_OP_CODE_REPRESENTATION =
      'OpCode does not have a string representation';

  static const INVALID_OP_CODE_STR = 'Invalid opCodeStr';

  OpCode({required int number}) {
    this.number = number;
  }

  OpCode fromNumber(int number) {
    this.number = number;
    return this;
  }

  factory OpCode.fromNumber(int number) {
    // return new OpCode(number: number).fromNumber(number);
    return new OpCode(number: number);
  }

  factory OpCode.fromString(String str) {
    var number = map[str];
    if (number == null) {
      throw INVALID_OP_CODE_STR;
    }
    return OpCode(number: number);
    // return new OpCode().fromString(str);
  }

  // OpCode fromString(String str) {
  //   var number = map[str];
  //   if (number == null) {
  //     throw INVALID_OP_CODE_STR;
  //   }
  //   this.number = number;
  //   return this;
  // }

  @override
  String toString() {
    var str = OpCode.str[this.number];
    if (str == null) {
      if (this.number > 0 && this.number < OpCode.OP_PUSHDATA1) {
        return this.number.toString();
      }
      throw INVALID_OP_CODE_REPRESENTATION;
    }
    return str;
  }

  int toNumber() {
    return this.number;
  }

  static const str = {
    // 0x00: "OP_FALSE",
    0x00: "OP_0",
    0x4c: "OP_PUSHDATA1",
    0x4d: "OP_PUSHDATA2",
    0x4e: "OP_PUSHDATA4",
    0x4f: "OP_1NEGATE",
    0x50: "OP_RESERVED",
    // 0x51: "OP_TRUE",
    0x51: "OP_1",
    0x52: "OP_2",
    0x53: "OP_3",
    0x54: "OP_4",
    0x55: "OP_5",
    0x56: "OP_6",
    0x57: "OP_7",
    0x58: "OP_8",
    0x59: "OP_9",
    0x5a: "OP_10",
    0x5b: "OP_11",
    0x5c: "OP_12",
    0x5d: "OP_13",
    0x5e: "OP_14",
    0x5f: "OP_15",
    0x60: "OP_16",
    0x61: "OP_NOP",
    0x62: "OP_VER",
    0x63: "OP_IF",
    0x64: "OP_NOTIF",
    0x65: "OP_VERIF",
    0x66: "OP_VERNOTIF",
    0x67: "OP_ELSE",
    0x68: "OP_ENDIF",
    0x69: "OP_VERIFY",
    0x6a: "OP_RETURN",
    0x6b: "OP_TOALTSTACK",
    0x6c: "OP_FROMALTSTACK",
    0x6d: "OP_2DROP",
    0x6e: "OP_2DUP",
    0x6f: "OP_3DUP",
    0x70: "OP_2OVER",
    0x71: "OP_2ROT",
    0x72: "OP_2SWAP",
    0x73: "OP_IFDUP",
    0x74: "OP_DEPTH",
    0x75: "OP_DROP",
    0x76: "OP_DUP",
    0x77: "OP_NIP",
    0x78: "OP_OVER",
    0x79: "OP_PICK",
    0x7a: "OP_ROLL",
    0x7b: "OP_ROT",
    0x7c: "OP_SWAP",
    0x7d: "OP_TUCK",
    0x7e: "OP_CAT",
    0x7f: "OP_SPLIT",
    0x80: "OP_NUM2BIN",
    0x81: "OP_BIN2NUM",
    0x82: "OP_SIZE",
    0x83: "OP_INVERT",
    0x84: "OP_AND",
    0x85: "OP_OR",
    0x86: "OP_XOR",
    0x87: "OP_EQUAL",
    0x88: "OP_EQUALVERIFY",
    0x89: "OP_RESERVED1",
    0x8a: "OP_RESERVED2",
    0x8b: "OP_1ADD",
    0x8c: "OP_1SUB",
    0x8d: "OP_2MUL",
    0x8e: "OP_2DIV",
    0x8f: "OP_NEGATE",
    0x90: "OP_ABS",
    0x91: "OP_NOT",
    0x92: "OP_0NOTEQUAL",
    0x93: "OP_ADD",
    0x94: "OP_SUB",
    0x95: "OP_MUL",
    0x96: "OP_DIV",
    0x97: "OP_MOD",
    0x98: "OP_LSHIFT",
    0x99: "OP_RSHIFT",
    0x9a: "OP_BOOLAND",
    0x9b: "OP_BOOLOR",
    0x9c: "OP_NUMEQUAL",
    0x9d: "OP_NUMEQUALVERIFY",
    0x9e: "OP_NUMNOTEQUAL",
    0x9f: "OP_LESSTHAN",
    0xa0: "OP_GREATERTHAN",
    0xa1: "OP_LESSTHANOREQUAL",
    0xa2: "OP_GREATERTHANOREQUAL",
    0xa3: "OP_MIN",
    0xa4: "OP_MAX",
    0xa5: "OP_WITHIN",
    0xa6: "OP_RIPEMD160",
    0xa7: "OP_SHA1",
    0xa8: "OP_SHA256",
    0xa9: "OP_HASH160",
    0xaa: "OP_HASH256",
    0xab: "OP_CODESEPARATOR",
    0xac: "OP_CHECKSIG",
    0xad: "OP_CHECKSIGVERIFY",
    0xae: "OP_CHECKMULTISIG",
    0xaf: "OP_CHECKMULTISIGVERIFY",
    0xb0: "OP_NOP1",
    // 0xb1: "OP_NOP2",
    0xb1: "OP_CHECKLOCKTIMEVERIFY",
    // 0xb2: "OP_NOP3",
    0xb2: "OP_CHECKSEQUENCEVERIFY",
    0xb3: "OP_NOP4",
    0xb4: "OP_NOP5",
    0xb5: "OP_NOP6",
    0xb6: "OP_NOP7",
    0xb7: "OP_NOP8",
    0xb8: "OP_NOP9",
    0xb9: "OP_NOP10",
    0xf9: "OP_SMALLDATA",
    0xfa: "OP_SMALLINTEGER",
    0xfb: "OP_PUBKEYS",
    0xfd: "OP_PUBKEYHASH",
    0xfe: "OP_PUBKEY",
    0xf: "OP_INVALIDOPCODE",
  };

  static const map = {
    // push value
    "OP_FALSE": 0x00,
    "OP_0": 0x00,
    "OP_PUSHDATA1": 0x4c,
    "OP_PUSHDATA2": 0x4d,
    "OP_PUSHDATA4": 0x4e,
    "OP_1NEGATE": 0x4f,
    "OP_RESERVED": 0x50,
    "OP_TRUE": 0x51,
    "OP_1": 0x51,
    "OP_2": 0x52,
    "OP_3": 0x53,
    "OP_4": 0x54,
    "OP_5": 0x55,
    "OP_6": 0x56,
    "OP_7": 0x57,
    "OP_8": 0x58,
    "OP_9": 0x59,
    "OP_10": 0x5a,
    "OP_11": 0x5b,
    "OP_12": 0x5c,
    "OP_13": 0x5d,
    "OP_14": 0x5e,
    "OP_15": 0x5f,
    "OP_16": 0x60,

    // control
    "OP_NOP": 0x61,
    "OP_VER": 0x62,
    "OP_IF": 0x63,
    "OP_NOTIF": 0x64,
    "OP_VERIF": 0x65,
    "OP_VERNOTIF": 0x66,
    "OP_ELSE": 0x67,
    "OP_ENDIF": 0x68,
    "OP_VERIFY": 0x69,
    "OP_RETURN": 0x6a,

    // stack ops
    "OP_TOALTSTACK": 0x6b,
    "OP_FROMALTSTACK": 0x6c,
    "OP_2DROP": 0x6d,
    "OP_2DUP": 0x6e,
    "OP_3DUP": 0x6f,
    "OP_2OVER": 0x70,
    "OP_2ROT": 0x71,
    "OP_2SWAP": 0x72,
    "OP_IFDUP": 0x73,
    "OP_DEPTH": 0x74,
    "OP_DROP": 0x75,
    "OP_DUP": 0x76,
    "OP_NIP": 0x77,
    "OP_OVER": 0x78,
    "OP_PICK": 0x79,
    "OP_ROLL": 0x7a,
    "OP_ROT": 0x7b,
    "OP_SWAP": 0x7c,
    "OP_TUCK": 0x7d,

    // data manipulation ops
    "OP_CAT": 0x7e,
    "OP_SUBSTR": 0x7f, // Replaced in BSV
    "OP_SPLIT": 0x7f,
    "OP_LEFT": 0x80, // Replaced in BSV
    "OP_NUM2BIN": 0x80,
    "OP_RIGHT": 0x81, // Replaced in BSV
    "OP_BIN2NUM": 0x81,
    "OP_SIZE": 0x82,

    // bit logic
    "OP_INVERT": 0x83,
    "OP_AND": 0x84,
    "OP_OR": 0x85,
    "OP_XOR": 0x86,
    "OP_EQUAL": 0x87,
    "OP_EQUALVERIFY": 0x88,
    "OP_RESERVED1": 0x89,
    "OP_RESERVED2": 0x8a,

    // numeric
    "OP_1ADD": 0x8b,
    "OP_1SUB": 0x8c,
    "OP_2MUL": 0x8d,
    "OP_2DIV": 0x8e,
    "OP_NEGATE": 0x8f,
    "OP_ABS": 0x90,
    "OP_NOT": 0x91,
    "OP_0NOTEQUAL": 0x92,

    "OP_ADD": 0x93,
    "OP_SUB": 0x94,
    "OP_MUL": 0x95,
    "OP_DIV": 0x96,
    "OP_MOD": 0x97,
    "OP_LSHIFT": 0x98,
    "OP_RSHIFT": 0x99,

    "OP_BOOLAND": 0x9a,
    "OP_BOOLOR": 0x9b,
    "OP_NUMEQUAL": 0x9c,
    "OP_NUMEQUALVERIFY": 0x9d,
    "OP_NUMNOTEQUAL": 0x9e,
    "OP_LESSTHAN": 0x9f,
    "OP_GREATERTHAN": 0xa0,
    "OP_LESSTHANOREQUAL": 0xa1,
    "OP_GREATERTHANOREQUAL": 0xa2,
    "OP_MIN": 0xa3,
    "OP_MAX": 0xa4,

    "OP_WITHIN": 0xa5,

    // crypto
    "OP_RIPEMD160": 0xa6,
    "OP_SHA1": 0xa7,
    "OP_SHA256": 0xa8,
    "OP_HASH160": 0xa9,
    "OP_HASH256": 0xaa,
    "OP_CODESEPARATOR": 0xab,
    "OP_CHECKSIG": 0xac,
    "OP_CHECKSIGVERIFY": 0xad,
    "OP_CHECKMULTISIG": 0xae,
    "OP_CHECKMULTISIGVERIFY": 0xaf,

    // expansion
    "OP_NOP1": 0xb0,
    "OP_NOP2": 0xb1,
    "OP_CHECKLOCKTIMEVERIFY": 0xb1,
    "OP_NOP3": 0xb2,
    "OP_CHECKSEQUENCEVERIFY": 0xb2,
    "OP_NOP4": 0xb3,
    "OP_NOP5": 0xb4,
    "OP_NOP6": 0xb5,
    "OP_NOP7": 0xb6,
    "OP_NOP8": 0xb7,
    "OP_NOP9": 0xb8,
    "OP_NOP10": 0xb9,

    // template matching params
    "OP_SMALLDATA": 0xf9,
    "OP_SMALLINTEGER": 0xfa,
    "OP_PUBKEYS": 0xfb,
    "OP_PUBKEYHASH": 0xfd,
    "OP_PUBKEY": 0xfe,

    "OP_INVALIDOPCODE": 0xff
  };

  // push value
  static const int OP_FALSE = 0x00;
  static const int OP_0 = 0x00;
  static const int OP_PUSHDATA1 = 0x4c;
  static const int OP_PUSHDATA2 = 0x4d;
  static const int OP_PUSHDATA4 = 0x4e;
  static const int OP_1NEGATE = 0x4f;
  static const int OP_RESERVED = 0x50;
  static const int OP_TRUE = 0x51;
  static const int OP_1 = 0x51;
  static const int OP_2 = 0x52;
  static const int OP_3 = 0x53;
  static const int OP_4 = 0x54;
  static const int OP_5 = 0x55;
  static const int OP_6 = 0x56;
  static const int OP_7 = 0x57;
  static const int OP_8 = 0x58;
  static const int OP_9 = 0x59;
  static const int OP_10 = 0x5a;
  static const int OP_11 = 0x5b;
  static const int OP_12 = 0x5c;
  static const int OP_13 = 0x5d;
  static const int OP_14 = 0x5e;
  static const int OP_15 = 0x5f;
  static const int OP_16 = 0x60;

  // control
  static const int OP_NOP = 0x61;
  static const int OP_VER = 0x62;
  static const int OP_IF = 0x63;
  static const int OP_NOTIF = 0x64;
  static const int OP_VERIF = 0x65;
  static const int OP_VERNOTIF = 0x66;
  static const int OP_ELSE = 0x67;
  static const int OP_ENDIF = 0x68;
  static const int OP_VERIFY = 0x69;
  static const int OP_RETURN = 0x6a;

  // stack ops
  static const int OP_TOALTSTACK = 0x6b;
  static const int OP_FROMALTSTACK = 0x6c;
  static const int OP_2DROP = 0x6d;
  static const int OP_2DUP = 0x6e;
  static const int OP_3DUP = 0x6f;
  static const int OP_2OVER = 0x70;
  static const int OP_2ROT = 0x71;
  static const int OP_2SWAP = 0x72;
  static const int OP_IFDUP = 0x73;
  static const int OP_DEPTH = 0x74;
  static const int OP_DROP = 0x75;
  static const int OP_DUP = 0x76;
  static const int OP_NIP = 0x77;
  static const int OP_OVER = 0x78;
  static const int OP_PICK = 0x79;
  static const int OP_ROLL = 0x7a;
  static const int OP_ROT = 0x7b;
  static const int OP_SWAP = 0x7c;
  static const int OP_TUCK = 0x7d;

  // data manipulation ops
  static const int OP_CAT = 0x7e;
  static const int OP_SUBSTR = 0x7f; // Replaced in BS
  static const int OP_SPLIT = 0x7f;
  static const int OP_LEFT = 0x80; // Replaced in BS
  static const int OP_NUM2BIN = 0x80;
  static const int OP_RIGHT = 0x81; // Replaced in BS
  static const int OP_BIN2NUM = 0x81;
  static const int OP_SIZE = 0x82;

  // bit logic
  static const int OP_INVERT = 0x83;
  static const int OP_AND = 0x84;
  static const int OP_OR = 0x85;
  static const int OP_XOR = 0x86;
  static const int OP_EQUAL = 0x87;
  static const int OP_EQUALVERIFY = 0x88;
  static const int OP_RESERVED1 = 0x89;
  static const int OP_RESERVED2 = 0x8a;

  // numeric
  static const int OP_1ADD = 0x8b;
  static const int OP_1SUB = 0x8c;
  static const int OP_2MUL = 0x8d;
  static const int OP_2DIV = 0x8e;
  static const int OP_NEGATE = 0x8f;
  static const int OP_ABS = 0x90;
  static const int OP_NOT = 0x91;
  static const int OP_0NOTEQUAL = 0x92;

  static const int OP_ADD = 0x93;
  static const int OP_SUB = 0x94;
  static const int OP_MUL = 0x95;
  static const int OP_DIV = 0x96;
  static const int OP_MOD = 0x97;
  static const int OP_LSHIFT = 0x98;
  static const int OP_RSHIFT = 0x99;

  static const int OP_BOOLAND = 0x9a;
  static const int OP_BOOLOR = 0x9b;
  static const int OP_NUMEQUAL = 0x9c;
  static const int OP_NUMEQUALVERIFY = 0x9d;
  static const int OP_NUMNOTEQUAL = 0x9e;
  static const int OP_LESSTHAN = 0x9f;
  static const int OP_GREATERTHAN = 0xa0;
  static const int OP_LESSTHANOREQUAL = 0xa1;
  static const int OP_GREATERTHANOREQUAL = 0xa2;
  static const int OP_MIN = 0xa3;
  static const int OP_MAX = 0xa4;

  static const int OP_WITHIN = 0xa5;

  // crypto
  static const int OP_RIPEMD160 = 0xa6;
  static const int OP_SHA1 = 0xa7;
  static const int OP_SHA256 = 0xa8;
  static const int OP_HASH160 = 0xa9;
  static const int OP_HASH256 = 0xaa;
  static const int OP_CODESEPARATOR = 0xab;
  static const int OP_CHECKSIG = 0xac;
  static const int OP_CHECKSIGVERIFY = 0xad;
  static const int OP_CHECKMULTISIG = 0xae;
  static const int OP_CHECKMULTISIGVERIFY = 0xaf;

  // expansion
  static const int OP_NOP1 = 0xb0;
  static const int OP_NOP2 = 0xb1;
  static const int OP_CHECKLOCKTIMEVERIFY = 0xb1;
  static const int OP_NOP3 = 0xb2;
  static const int OP_CHECKSEQUENCEVERIFY = 0xb2;
  static const int OP_NOP4 = 0xb3;
  static const int OP_NOP5 = 0xb4;
  static const int OP_NOP6 = 0xb5;
  static const int OP_NOP7 = 0xb6;
  static const int OP_NOP8 = 0xb7;
  static const int OP_NOP9 = 0xb8;
  static const int OP_NOP10 = 0xb9;

  // template matching params
  static const int OP_SMALLDATA = 0xf9;
  static const int OP_SMALLINTEGER = 0xfa;
  static const int OP_PUBKEYS = 0xfb;
  static const int OP_PUBKEYHASH = 0xfd;
  static const int OP_PUBKEY = 0xfe;

  static const int OP_INVALIDOPCODE = 0xf;
}
