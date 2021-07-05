var bitcoindScriptInvalid = [
  ["Format is: [scriptSig, scriptPubKey, flags, ... comments]"],
  [
    "It is evaluated as if there was a crediting coinbase transaction with two 0"
  ],
  ["pushes as scriptSig, and one output of 0 satoshi and given scriptPubKey,"],
  [
    "followed by a spending transaction which spends this output as only input (and"
  ],
  [
    "correct prevout hash), using the given scriptSig. All nLockTimes are 0, all"
  ],
  ["nSequences are max."],
  [
    "",
    "DEPTH",
    "P2SH,STRICTENC",
    "Test the test: we should have an empty stack after scriptSig evaluation"
  ],
  [
    "  ",
    "DEPTH",
    "P2SH,STRICTENC",
    "and multiple spaces should not change that."
  ],
  ["   ", "DEPTH", "P2SH,STRICTENC"],
  ["    ", "DEPTH", "P2SH,STRICTENC"],
  ["", "", "P2SH,STRICTENC"],
  ["", "NOP", "P2SH,STRICTENC"],
  ["", "NOP DEPTH", "P2SH,STRICTENC"],
  ["NOP", "", "P2SH,STRICTENC"],
  ["NOP", "DEPTH", "P2SH,STRICTENC"],
  ["NOP", "NOP", "P2SH,STRICTENC"],
  ["NOP", "NOP DEPTH", "P2SH,STRICTENC"],
  ["DEPTH", "", "P2SH,STRICTENC"],
  ["0x4c01", "0x01 NOP", "P2SH,STRICTENC", "PUSHDATA1 with not enough bytes"],
  [
    "0x4d0200ff",
    "0x01 NOP",
    "P2SH,STRICTENC",
    "PUSHDATA2 with not enough bytes"
  ],
  [
    "0x4e03000000ffff",
    "0x01 NOP",
    "P2SH,STRICTENC",
    "PUSHDATA4 with not enough bytes"
  ],
  ["1", "IF 0x50 ENDIF 1", "P2SH,STRICTENC", "0x50 is reserved"],
  [
    "0x52",
    "0x5f ADD 0x60 EQUAL",
    "P2SH,STRICTENC",
    "0x51 through 0x60 push 1 through 16 onto stack"
  ],
  ["0", "NOP", "P2SH,STRICTENC"],
  ["1", "IF VER ELSE 1 ENDIF", "P2SH,STRICTENC", "VER non-functional"],
  ["0", "IF VERIF ELSE 1 ENDIF", "P2SH,STRICTENC", "VERIF illegal everywhere"],
  [
    "0",
    "IF ELSE 1 ELSE VERIF ENDIF",
    "P2SH,STRICTENC",
    "VERIF illegal everywhere"
  ],
  [
    "0",
    "IF VERNOTIF ELSE 1 ENDIF",
    "P2SH,STRICTENC",
    "VERNOTIF illegal everywhere"
  ],
  [
    "0",
    "IF ELSE 1 ELSE VERNOTIF ENDIF",
    "P2SH,STRICTENC",
    "VERNOTIF illegal everywhere"
  ],
  [
    "1 IF",
    "1 ENDIF",
    "P2SH,STRICTENC",
    "IF/ENDIF can't span scriptSig/scriptPubKey"
  ],
  ["1 IF 0 ENDIF", "1 ENDIF", "P2SH,STRICTENC"],
  ["1 ELSE 0 ENDIF", "1", "P2SH,STRICTENC"],
  ["0 NOTIF", "123", "P2SH,STRICTENC"],
  ["0", "DUP IF ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "DUP IF ELSE ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 1 ELSE ENDIF", "P2SH,STRICTENC"],
  ["0", "NOTIF ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0 1", "IF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  ["0 0", "IF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  [
    "1 0",
    "IF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  [
    "0 1",
    "IF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  ["0 0", "NOTIF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  ["0 1", "NOTIF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  [
    "1 1",
    "NOTIF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  [
    "0 0",
    "NOTIF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  ["1", "IF RETURN ELSE ELSE 1 ENDIF", "P2SH,STRICTENC", "Multiple ELSEs"],
  ["1", "IF 1 ELSE ELSE RETURN ENDIF", "P2SH,STRICTENC"],
  ["1", "ENDIF", "P2SH,STRICTENC", "Malformed IF/ELSE/ENDIF sequence"],
  ["1", "ELSE ENDIF", "P2SH,STRICTENC"],
  ["1", "ENDIF ELSE", "P2SH,STRICTENC"],
  ["1", "ENDIF ELSE IF", "P2SH,STRICTENC"],
  ["1", "IF ELSE ENDIF ELSE", "P2SH,STRICTENC"],
  ["1", "IF ELSE ENDIF ELSE ENDIF", "P2SH,STRICTENC"],
  ["1", "IF ENDIF ENDIF", "P2SH,STRICTENC"],
  ["1", "IF ELSE ELSE ENDIF ENDIF", "P2SH,STRICTENC"],
  ["1", "RETURN", "P2SH,STRICTENC"],
  ["1", "DUP IF RETURN ENDIF", "P2SH,STRICTENC"],
  ["1", "RETURN 'data'", "P2SH,STRICTENC", "canonical prunable txout format"],
  [
    "0 IF",
    "RETURN ENDIF 1",
    "P2SH,STRICTENC",
    "still prunable because IF/ENDIF can't span scriptSig/scriptPubKey"
  ],
  ["0", "VERIFY 1", "P2SH,STRICTENC"],
  ["1", "VERIFY", "P2SH,STRICTENC"],
  ["1", "VERIFY 0", "P2SH,STRICTENC"],
  [
    "1 TOALTSTACK",
    "FROMALTSTACK 1",
    "P2SH,STRICTENC",
    "alt stack not shared between sig/pubkey"
  ],
  ["IFDUP", "DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  ["DROP", "DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  ["DUP", "DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  ["1", "DUP 1 ADD 2 EQUALVERIFY 0 EQUAL", "P2SH,STRICTENC"],
  ["NOP", "NIP", "P2SH,STRICTENC"],
  ["NOP", "1 NIP", "P2SH,STRICTENC"],
  ["NOP", "1 0 NIP", "P2SH,STRICTENC"],
  ["NOP", "OVER 1", "P2SH,STRICTENC"],
  ["1", "OVER", "P2SH,STRICTENC"],
  ["0 1", "OVER DEPTH 3 EQUALVERIFY", "P2SH,STRICTENC"],
  ["19 20 21", "PICK 19 EQUALVERIFY DEPTH 2 EQUAL", "P2SH,STRICTENC"],
  ["NOP", "0 PICK", "P2SH,STRICTENC"],
  ["1", "-1 PICK", "P2SH,STRICTENC"],
  ["19 20 21", "0 PICK 20 EQUALVERIFY DEPTH 3 EQUAL", "P2SH,STRICTENC"],
  ["19 20 21", "1 PICK 21 EQUALVERIFY DEPTH 3 EQUAL", "P2SH,STRICTENC"],
  ["19 20 21", "2 PICK 22 EQUALVERIFY DEPTH 3 EQUAL", "P2SH,STRICTENC"],
  ["NOP", "0 ROLL", "P2SH,STRICTENC"],
  ["1", "-1 ROLL", "P2SH,STRICTENC"],
  ["19 20 21", "0 ROLL 20 EQUALVERIFY DEPTH 2 EQUAL", "P2SH,STRICTENC"],
  ["19 20 21", "1 ROLL 21 EQUALVERIFY DEPTH 2 EQUAL", "P2SH,STRICTENC"],
  ["19 20 21", "2 ROLL 22 EQUALVERIFY DEPTH 2 EQUAL", "P2SH,STRICTENC"],
  ["NOP", "ROT 1", "P2SH,STRICTENC"],
  ["NOP", "1 ROT 1", "P2SH,STRICTENC"],
  ["NOP", "1 2 ROT 1", "P2SH,STRICTENC"],
  ["NOP", "0 1 2 ROT", "P2SH,STRICTENC"],
  ["NOP", "SWAP 1", "P2SH,STRICTENC"],
  ["1", "SWAP 1", "P2SH,STRICTENC"],
  ["0 1", "SWAP 1 EQUALVERIFY", "P2SH,STRICTENC"],
  ["NOP", "TUCK 1", "P2SH,STRICTENC"],
  ["1", "TUCK 1", "P2SH,STRICTENC"],
  ["1 0", "TUCK DEPTH 3 EQUALVERIFY SWAP 2DROP", "P2SH,STRICTENC"],
  ["NOP", "2DUP 1", "P2SH,STRICTENC"],
  ["1", "2DUP 1", "P2SH,STRICTENC"],
  ["NOP", "3DUP 1", "P2SH,STRICTENC"],
  ["1", "3DUP 1", "P2SH,STRICTENC"],
  ["1 2", "3DUP 1", "P2SH,STRICTENC"],
  ["NOP", "2OVER 1", "P2SH,STRICTENC"],
  ["1", "2 3 2OVER 1", "P2SH,STRICTENC"],
  ["NOP", "2SWAP 1", "P2SH,STRICTENC"],
  ["1", "2 3 2SWAP 1", "P2SH,STRICTENC"],
  ["'abc' 2 0", "IF LEFT ELSE 1 ENDIF", "P2SH,STRICTENC", "LEFT disabled"],
  ["'abc' 2 0", "IF RIGHT ELSE 1 ENDIF", "P2SH,STRICTENC", "RIGHT disabled"],
  ["NOP", "SIZE 1", "P2SH,STRICTENC"],
  ["'abc'", "IF INVERT ELSE 1 ENDIF", "P2SH,STRICTENC", "INVERT disabled"],
  ["2 0 IF 2MUL ELSE 1 ENDIF", "NOP", "P2SH,STRICTENC", "2MUL disabled"],
  ["2 0 IF 2DIV ELSE 1 ENDIF", "NOP", "P2SH,STRICTENC", "2DIV disabled"],
  [
    "",
    "EQUAL NOT",
    "P2SH,STRICTENC",
    "EQUAL must error when there are no stack items"
  ],
  [
    "0",
    "EQUAL NOT",
    "P2SH,STRICTENC",
    "EQUAL must error when there are not 2 stack items"
  ],
  ["0 1", "EQUAL", "P2SH,STRICTENC"],
  ["1 1 ADD", "0 EQUAL", "P2SH,STRICTENC"],
  ["11 1 ADD 12 SUB", "11 EQUAL", "P2SH,STRICTENC"],
  [
    "2147483648 0 ADD",
    "NOP",
    "P2SH,STRICTENC",
    "arithmetic operands must be in range [-2^31...2^31] "
  ],
  [
    "-2147483648 0 ADD",
    "NOP",
    "P2SH,STRICTENC",
    "arithmetic operands must be in range [-2^31...2^31] "
  ],
  [
    "2147483647 DUP ADD",
    "4294967294 NUMEQUAL",
    "P2SH,STRICTENC",
    "NUMEQUAL must be in numeric range"
  ],
  ["'abcdef' NOT", "0 EQUAL", "P2SH,STRICTENC", "NOT is an arithmetic operand"],
  ["2 2MUL", "4 EQUAL", "P2SH,STRICTENC", "disabled"],
  ["2 2DIV", "1 EQUAL", "P2SH,STRICTENC", "disabled"],
  [
    "1",
    "NOP1 CHECKLOCKTIMEVERIFY NOP3 NOP4 NOP5 NOP6 NOP7 NOP8 NOP9 NOP10 2 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'NOP_1_to_10' NOP1 CHECKLOCKTIMEVERIFY NOP3 NOP4 NOP5 NOP6 NOP7 NOP8 NOP9 NOP10",
    "'NOP_1_to_11' EQUAL",
    "P2SH,STRICTENC"
  ],
  ["Ensure 100% coverage of discouraged NOPS"],
  ["1", "NOP1", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "CHECKLOCKTIMEVERIFY", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP3", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP4", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP5", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP6", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP7", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP8", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP9", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  ["1", "NOP10", "P2SH,DISCOURAGE_UPGRADABLE_NOPS"],
  [
    "NOP10",
    "1",
    "P2SH,DISCOURAGE_UPGRADABLE_NOPS",
    "Discouraged NOP10 in scriptSig"
  ],
  [
    "1 0x01 0xb9",
    "HASH160 0x14 0x15727299b05b45fdaf9ac9ecf7565cfe27c3e567 EQUAL",
    "P2SH,DISCOURAGE_UPGRADABLE_NOPS",
    "Discouraged NOP10 in redeemScript"
  ],
  ["0x50", "1", "P2SH,STRICTENC", "opcode 0x50 is reserved"],
  [
    "1",
    "IF 0xba ELSE 1 ENDIF",
    "P2SH,STRICTENC",
    "opcodes above NOP10 invalid if executed"
  ],
  ["1", "IF 0xbb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xbc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xbd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xbe ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xbf ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xc9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xca ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xcb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xcc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xcd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xce ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xcf ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xd9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xda ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xdb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xdc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xdd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xde ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xdf ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xe9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xea ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xeb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xec ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xed ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xee ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xef ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xf9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xfa ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xfb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xfc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xfd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xfe ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 0xff ELSE 1 ENDIF", "P2SH,STRICTENC"],
  [
    "1 IF 1 ELSE",
    "0xff ENDIF",
    "P2SH,STRICTENC",
    "invalid because scriptSig and scriptPubKey are processed separately"
  ],
  ["NOP", "RIPEMD160", "P2SH,STRICTENC"],
  ["NOP", "SHA1", "P2SH,STRICTENC"],
  ["NOP", "SHA256", "P2SH,STRICTENC"],
  ["NOP", "HASH160", "P2SH,STRICTENC"],
  ["NOP", "HASH256", "P2SH,STRICTENC"],
  [
    "NOP",
    "'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'",
    "P2SH,STRICTENC",
    ">520 byte push"
  ],
  [
    "0",
    "IF 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' ENDIF 1",
    "P2SH,STRICTENC",
    ">520 byte push in non-executed IF branch"
  ],
  [
    "1",
    "0x61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161",
    "P2SH,STRICTENC",
    ">201 opcodes executed. 0x61 is NOP"
  ],
  [
    "0",
    "IF 0x6161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161 ENDIF 1",
    "P2SH,STRICTENC",
    ">201 opcodes including non-executed IF branch. 0x61 is NOP"
  ],
  [
    "1 2 3 4 5 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "1 2 3 4 5 6 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "P2SH,STRICTENC",
    ">1,000 stack size (0x6f is 3DUP)"
  ],
  [
    "1 2 3 4 5 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "1 TOALTSTACK 2 TOALTSTACK 3 4 5 6 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "P2SH,STRICTENC",
    ">1,000 stack+altstack size"
  ],
  [
    "NOP",
    "0 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f 2DUP 0x616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161",
    "P2SH,STRICTENC",
    "10,001-byte scriptPubKey"
  ],
  ["NOP1", "NOP10", "P2SH,STRICTENC"],
  ["1", "VER", "P2SH,STRICTENC", "OP_VER is reserved"],
  ["1", "VERIF", "P2SH,STRICTENC", "OP_VERIF is reserved"],
  ["1", "VERNOTIF", "P2SH,STRICTENC", "OP_VERNOTIF is reserved"],
  ["1", "RESERVED", "P2SH,STRICTENC", "OP_RESERVED is reserved"],
  ["1", "RESERVED1", "P2SH,STRICTENC", "OP_RESERVED1 is reserved"],
  ["1", "RESERVED2", "P2SH,STRICTENC", "OP_RESERVED2 is reserved"],
  ["1", "0xba", "P2SH,STRICTENC", "0xba == OP_NOP10 + 1"],
  [
    "2147483648",
    "1ADD 1",
    "P2SH,STRICTENC",
    "We cannot do math on 5-byte integers"
  ],
  [
    "2147483648",
    "NEGATE 1",
    "P2SH,STRICTENC",
    "We cannot do math on 5-byte integers"
  ],
  [
    "-2147483648",
    "1ADD 1",
    "P2SH,STRICTENC",
    "Because we use a sign bit, -2147483648 is also 5 bytes"
  ],
  [
    "2147483647",
    "1ADD 1SUB 1",
    "P2SH,STRICTENC",
    "We cannot do math on 5-byte integers, even if the result is 4-bytes"
  ],
  [
    "2147483648",
    "1SUB 1",
    "P2SH,STRICTENC",
    "We cannot do math on 5-byte integers, even if the result is 4-bytes"
  ],
  [
    "2147483648 1",
    "BOOLOR 1",
    "P2SH,STRICTENC",
    "We cannot do BOOLOR on 5-byte integers (but we can still do IF etc)"
  ],
  [
    "2147483648 1",
    "BOOLAND 1",
    "P2SH,STRICTENC",
    "We cannot do BOOLAND on 5-byte integers"
  ],
  ["1", "1 ENDIF", "P2SH,STRICTENC", "ENDIF without IF"],
  ["1", "IF 1", "P2SH,STRICTENC", "IF without ENDIF"],
  ["1 IF 1", "ENDIF", "P2SH,STRICTENC", "IFs don't carry over"],
  [
    "NOP",
    "IF 1 ENDIF",
    "P2SH,STRICTENC",
    "The following tests check the if(stack.size() < N) tests in each opcode"
  ],
  [
    "NOP",
    "NOTIF 1 ENDIF",
    "P2SH,STRICTENC",
    "They are here to catch copy-and-paste errors"
  ],
  [
    "NOP",
    "VERIFY 1",
    "P2SH,STRICTENC",
    "Most of them are duplicated elsewhere,"
  ],
  [
    "NOP",
    "TOALTSTACK 1",
    "P2SH,STRICTENC",
    "but, hey, more is always better, right?"
  ],
  ["1", "FROMALTSTACK", "P2SH,STRICTENC"],
  ["1", "2DROP 1", "P2SH,STRICTENC"],
  ["1", "2DUP", "P2SH,STRICTENC"],
  ["1 1", "3DUP", "P2SH,STRICTENC"],
  ["1 1 1", "2OVER", "P2SH,STRICTENC"],
  ["1 1 1 1 1", "2ROT", "P2SH,STRICTENC"],
  ["1 1 1", "2SWAP", "P2SH,STRICTENC"],
  ["NOP", "IFDUP 1", "P2SH,STRICTENC"],
  ["NOP", "DROP 1", "P2SH,STRICTENC"],
  ["NOP", "DUP 1", "P2SH,STRICTENC"],
  ["1", "NIP", "P2SH,STRICTENC"],
  ["1", "OVER", "P2SH,STRICTENC"],
  ["1 1 1 3", "PICK", "P2SH,STRICTENC"],
  ["0", "PICK 1", "P2SH,STRICTENC"],
  ["1 1 1 3", "ROLL", "P2SH,STRICTENC"],
  ["0", "ROLL 1", "P2SH,STRICTENC"],
  ["1 1", "ROT", "P2SH,STRICTENC"],
  ["1", "SWAP", "P2SH,STRICTENC"],
  ["1", "TUCK", "P2SH,STRICTENC"],
  ["NOP", "SIZE 1", "P2SH,STRICTENC"],
  ["1", "EQUAL 1", "P2SH,STRICTENC"],
  ["1", "EQUALVERIFY 1", "P2SH,STRICTENC"],
  ["NOP", "1ADD 1", "P2SH,STRICTENC"],
  ["NOP", "1SUB 1", "P2SH,STRICTENC"],
  ["NOP", "NEGATE 1", "P2SH,STRICTENC"],
  ["NOP", "ABS 1", "P2SH,STRICTENC"],
  ["NOP", "NOT 1", "P2SH,STRICTENC"],
  ["NOP", "0NOTEQUAL 1", "P2SH,STRICTENC"],
  ["1", "ADD", "P2SH,STRICTENC"],
  ["1", "SUB", "P2SH,STRICTENC"],
  ["1", "BOOLAND", "P2SH,STRICTENC"],
  ["1", "BOOLOR", "P2SH,STRICTENC"],
  ["1", "NUMEQUAL", "P2SH,STRICTENC"],
  ["1", "NUMEQUALVERIFY 1", "P2SH,STRICTENC"],
  ["1", "NUMNOTEQUAL", "P2SH,STRICTENC"],
  ["1", "LESSTHAN", "P2SH,STRICTENC"],
  ["1", "GREATERTHAN", "P2SH,STRICTENC"],
  ["1", "LESSTHANOREQUAL", "P2SH,STRICTENC"],
  ["1", "GREATERTHANOREQUAL", "P2SH,STRICTENC"],
  ["1", "MIN", "P2SH,STRICTENC"],
  ["1", "MAX", "P2SH,STRICTENC"],
  ["1 1", "WITHIN", "P2SH,STRICTENC"],
  ["NOP", "RIPEMD160 1", "P2SH,STRICTENC"],
  ["NOP", "SHA1 1", "P2SH,STRICTENC"],
  ["NOP", "SHA256 1", "P2SH,STRICTENC"],
  ["NOP", "HASH160 1", "P2SH,STRICTENC"],
  ["NOP", "HASH256 1", "P2SH,STRICTENC"],
  ["Increase CHECKSIG and CHECKMULTISIG negative test coverage"],
  [
    "",
    "CHECKSIG NOT",
    "STRICTENC",
    "CHECKSIG must error when there are no stack items"
  ],
  [
    "0",
    "CHECKSIG NOT",
    "STRICTENC",
    "CHECKSIG must error when there are not 2 stack items"
  ],
  [
    "",
    "CHECKMULTISIG NOT",
    "STRICTENC",
    "CHECKMULTISIG must error when there are no stack items"
  ],
  [
    "",
    "-1 CHECKMULTISIG NOT",
    "STRICTENC",
    "CHECKMULTISIG must error when the specified number of pubkeys is negative"
  ],
  [
    "",
    "1 CHECKMULTISIG NOT",
    "STRICTENC",
    "CHECKMULTISIG must error when there are not enough pubkeys on the stack"
  ],
  [
    "",
    "-1 0 CHECKMULTISIG NOT",
    "STRICTENC",
    "CHECKMULTISIG must error when the specified number of signatures is negative"
  ],
  [
    "",
    "1 'pk1' 1 CHECKMULTISIG NOT",
    "STRICTENC",
    "CHECKMULTISIG must error when there are not enough signatures on the stack"
  ],
  [
    "",
    "'dummy' 'sig1' 1 'pk1' 1 CHECKMULTISIG IF 1 ENDIF",
    "",
    "CHECKMULTISIG must push false to stack when signature is invalid when NOT in strict enc mode"
  ],
  [
    "",
    "0 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG",
    "P2SH,STRICTENC",
    "202 CHECKMULTISIGS, fails due to 201 op limit"
  ],
  [
    "1",
    "0 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY 0 0 CHECKMULTISIGVERIFY",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG",
    "P2SH,STRICTENC",
    "Fails due to 201 sig op limit"
  ],
  [
    "1",
    "NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY",
    "P2SH,STRICTENC"
  ],
  [
    "0 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21",
    "21 CHECKMULTISIG 1",
    "P2SH,STRICTENC",
    "nPubKeys > 20"
  ],
  ["0 'sig' 1 0", "CHECKMULTISIG 1", "P2SH,STRICTENC", "nSigs > nPubKeys"],
  [
    "NOP 0x01 1",
    "HASH160 0x14 0xda1745e9b549bd0bfa1a569971c77eba30cd5a4b EQUAL",
    "P2SH,STRICTENC",
    "Tests for Script.IsPushOnly()"
  ],
  [
    "NOP1 0x01 1",
    "HASH160 0x14 0xda1745e9b549bd0bfa1a569971c77eba30cd5a4b EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "0 0x01 0x50",
    "HASH160 0x14 0xece424a6bb6ddf4db592c0faed60685047a361b1 EQUAL",
    "P2SH,STRICTENC",
    "OP_RESERVED in P2SH should fail"
  ],
  [
    "0 0x01 VER",
    "HASH160 0x14 0x0f4d7845db968f2a81b530b6f3c1d6246d4c7e01 EQUAL",
    "P2SH,STRICTENC",
    "OP_VER in P2SH should fail"
  ],
  ["0x00", "'00' EQUAL", "P2SH,STRICTENC", "Basic OP_0 execution"],
  ["MINIMALDATA enforcement for PUSHDATAs"],
  [
    "0x4c 0x00",
    "DROP 1",
    "MINIMALDATA",
    "Empty vector minimally represented by OP_0"
  ],
  [
    "0x01 0x81",
    "DROP 1",
    "MINIMALDATA",
    "-1 minimally represented by OP_1NEGATE"
  ],
  [
    "0x01 0x01",
    "DROP 1",
    "MINIMALDATA",
    "1 to 16 minimally represented by OP_1 to OP_16"
  ],
  ["0x01 0x02", "DROP 1", "MINIMALDATA"],
  ["0x01 0x03", "DROP 1", "MINIMALDATA"],
  ["0x01 0x04", "DROP 1", "MINIMALDATA"],
  ["0x01 0x05", "DROP 1", "MINIMALDATA"],
  ["0x01 0x06", "DROP 1", "MINIMALDATA"],
  ["0x01 0x07", "DROP 1", "MINIMALDATA"],
  ["0x01 0x08", "DROP 1", "MINIMALDATA"],
  ["0x01 0x09", "DROP 1", "MINIMALDATA"],
  ["0x01 0x0a", "DROP 1", "MINIMALDATA"],
  ["0x01 0x0b", "DROP 1", "MINIMALDATA"],
  ["0x01 0x0c", "DROP 1", "MINIMALDATA"],
  ["0x01 0x0d", "DROP 1", "MINIMALDATA"],
  ["0x01 0x0e", "DROP 1", "MINIMALDATA"],
  ["0x01 0x0f", "DROP 1", "MINIMALDATA"],
  ["0x01 0x10", "DROP 1", "MINIMALDATA"],
  [
    "0x4c 0x48 0x111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
    "DROP 1",
    "MINIMALDATA",
    "PUSHDATA1 of 72 bytes minimally represented by direct push"
  ],
  [
    "0x4d 0xFF00 0x111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
    "DROP 1",
    "MINIMALDATA",
    "PUSHDATA2 of 255 bytes minimally represented by PUSHDATA1"
  ],
  [
    "0x4e 0x00010000 0x11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
    "DROP 1",
    "MINIMALDATA",
    "PUSHDATA4 of 256 bytes minimally represented by PUSHDATA2"
  ],
  ["MINIMALDATA enforcement for numeric arguments"],
  ["0x01 0x00", "NOT DROP 1", "MINIMALDATA", "numequals 0"],
  ["0x02 0x0000", "NOT DROP 1", "MINIMALDATA", "numequals 0"],
  [
    "0x01 0x80",
    "NOT DROP 1",
    "MINIMALDATA",
    "0x80 (negative zero) numequals 0"
  ],
  ["0x02 0x0080", "NOT DROP 1", "MINIMALDATA", "numequals 0"],
  ["0x02 0x0500", "NOT DROP 1", "MINIMALDATA", "numequals 5"],
  ["0x03 0x050000", "NOT DROP 1", "MINIMALDATA", "numequals 5"],
  ["0x02 0x0580", "NOT DROP 1", "MINIMALDATA", "numequals -5"],
  ["0x03 0x050080", "NOT DROP 1", "MINIMALDATA", "numequals -5"],
  ["0x03 0xff7f80", "NOT DROP 1", "MINIMALDATA", "Minimal encoding is 0xffff"],
  ["0x03 0xff7f00", "NOT DROP 1", "MINIMALDATA", "Minimal encoding is 0xff7f"],
  [
    "0x04 0xffff7f80",
    "NOT DROP 1",
    "MINIMALDATA",
    "Minimal encoding is 0xffffff"
  ],
  [
    "0x04 0xffff7f00",
    "NOT DROP 1",
    "MINIMALDATA",
    "Minimal encoding is 0xffff7f"
  ],
  [
    "Test every numeric-accepting opcode for correct handling of the numeric minimal encoding rule"
  ],
  ["1 0x02 0x0000", "PICK DROP", "MINIMALDATA"],
  ["1 0x02 0x0000", "ROLL DROP 1", "MINIMALDATA"],
  ["0x02 0x0000", "1ADD DROP 1", "MINIMALDATA"],
  ["0x02 0x0000", "1SUB DROP 1", "MINIMALDATA"],
  ["0x02 0x0000", "NEGATE DROP 1", "MINIMALDATA"],
  ["0x02 0x0000", "ABS DROP 1", "MINIMALDATA"],
  ["0x02 0x0000", "NOT DROP 1", "MINIMALDATA"],
  ["0x02 0x0000", "0NOTEQUAL DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "ADD DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "ADD DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "SUB DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "SUB DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "BOOLAND DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "BOOLAND DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "BOOLOR DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "BOOLOR DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "NUMEQUAL DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 1", "NUMEQUAL DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "NUMEQUALVERIFY 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "NUMEQUALVERIFY 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "NUMNOTEQUAL DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "NUMNOTEQUAL DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "LESSTHAN DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "LESSTHAN DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "GREATERTHAN DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "GREATERTHAN DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "LESSTHANOREQUAL DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "LESSTHANOREQUAL DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "GREATERTHANOREQUAL DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "GREATERTHANOREQUAL DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "MIN DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "MIN DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000", "MAX DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0", "MAX DROP 1", "MINIMALDATA"],
  ["0x02 0x0000 0 0", "WITHIN DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000 0", "WITHIN DROP 1", "MINIMALDATA"],
  ["0 0 0x02 0x0000", "WITHIN DROP 1", "MINIMALDATA"],
  ["0 0 0x02 0x0000", "CHECKMULTISIG DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000 0", "CHECKMULTISIG DROP 1", "MINIMALDATA"],
  ["0 0x02 0x0000 0 1", "CHECKMULTISIG DROP 1", "MINIMALDATA"],
  ["0 0 0x02 0x0000", "CHECKMULTISIGVERIFY 1", "MINIMALDATA"],
  ["0 0x02 0x0000 0", "CHECKMULTISIGVERIFY 1", "MINIMALDATA"],
  [
    "Order of CHECKMULTISIG evaluation tests, inverted by swapping the order of"
  ],
  [
    "pubkeys/signatures so they fail due to the STRICTENC rules on validly encoded"
  ],
  ["signatures and pubkeys."],
  [
    "0 0x47 0x3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501 0x47 0x3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501",
    "2 0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 0 2 CHECKMULTISIG NOT",
    "STRICTENC",
    "2-of-2 CHECKMULTISIG NOT with the first pubkey invalid, and both signatures validly encoded."
  ],
  [
    "0 0x47 0x3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501 1",
    "2 0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 2 CHECKMULTISIG NOT",
    "STRICTENC",
    "2-of-2 CHECKMULTISIG NOT with both pubkeys valid, but first signature invalid."
  ],
  ["Increase DERSIG test coverage"],
  [
    "0x4a 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "0 CHECKSIG NOT",
    "DERSIG",
    "Overly long signature is incorrectly encoded for DERSIG"
  ],
  [
    "0x25 0x30220220000000000000000000000000000000000000000000000000000000000000000000",
    "0 CHECKSIG NOT",
    "DERSIG",
    "Missing S is incorrectly encoded for DERSIG"
  ],
  [
    "0x27 0x3024021077777777777777777777777777777777020a7777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "DERSIG",
    "S with invalid S length is incorrectly encoded for DERSIG"
  ],
  [
    "0x27 0x302403107777777777777777777777777777777702107777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "DERSIG",
    "Non-integer R is incorrectly encoded for DERSIG"
  ],
  [
    "0x27 0x302402107777777777777777777777777777777703107777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "DERSIG",
    "Non-integer S is incorrectly encoded for DERSIG"
  ],
  [
    "0x17 0x3014020002107777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "DERSIG",
    "Zero-length R is incorrectly encoded for DERSIG"
  ],
  [
    "0x17 0x3014021077777777777777777777777777777777020001",
    "0 CHECKSIG NOT",
    "DERSIG",
    "Zero-length S is incorrectly encoded for DERSIG"
  ],
  [
    "0x27 0x302402107777777777777777777777777777777702108777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "DERSIG",
    "Negative S is incorrectly encoded for DERSIG"
  ],
  ["Automatically generated test cases"],
  [
    "0x47 0x304402200a5c6163f07b8c3b013c4d1d6dba25e780b39658d79ba37af7057a3b7f15ffa102201fd9b4eaa9943f734928b99a83592c2e7bf342ea2680f6a2bb705167966b742001",
    "0x41 0x0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG",
    "",
    "P2PK, bad sig"
  ],
  [
    "0x47 0x3044022034bb0494b50b8ef130e2185bb220265b9284ef5b4b8a8da4d8415df489c83b5102206259a26d9cc0a125ac26af6153b17c02956855ebe1467412f066e402f5f05d1201 0x21 0x03363d90d446b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640",
    "DUP HASH160 0x14 0xc0834c0c158f53be706d234c38fd52de7eece656 EQUALVERIFY CHECKSIG",
    "",
    "P2PKH, bad pubkey"
  ],
  [
    "0x47 0x304402204710a85181663b32d25c70ec2bbd14adff5ddfff6cb50d09e155ef5f541fc86c0220056b0cc949be9386ecc5f6c2ac0493269031dbb185781db90171b54ac127790201",
    "0x41 0x048282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f5150811f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf CHECKSIG",
    "",
    "P2PK anyonecanpay marked with normal hashtype"
  ],
  [
    "0x47 0x3044022003fef42ed6c7be8917441218f525a60e2431be978e28b7aca4d7a532cc413ae8022067a1f82c74e8d69291b90d148778405c6257bbcfc2353cc38a3e1f22bf44254601 0x23 0x210279be667ef9dcbbac54a06295ce870b07029bfcdb2dce28d959f2815b16f81798ac",
    "HASH160 0x14 0x23b0ad3477f2178bc0b3eed26e4e6316f4e83aa1 EQUAL",
    "P2SH",
    "P2SH(P2PK), bad redeemscript"
  ],
  [
    "0x47 0x304402204e2eb034be7b089534ac9e798cf6a2c79f38bcb34d1b179efd6f2de0841735db022071461beb056b5a7be1819da6a3e3ce3662831ecc298419ca101eb6887b5dd6a401 0x19 0x76a9147cf9c846cd4882efec4bf07e44ebdad495c94f4b88ac",
    "HASH160 0x14 0x2df519943d5acc0ef5222091f9dfe3543f489a82 EQUAL",
    "P2SH",
    "P2SH(P2PKH), bad sig"
  ],
  [
    "0 0x47 0x3044022051254b9fb476a52d85530792b578f86fea70ec1ffb4393e661bcccb23d8d63d3022076505f94a403c86097841944e044c70c2045ce90e36de51f7e9d3828db98a07501 0x47 0x304402200a358f750934b3feb822f1966bfcd8bbec9eeaa3a8ca941e11ee5960e181fa01022050bf6b5a8e7750f70354ae041cb68a7bade67ec6c3ab19eb359638974410626e01 0",
    "3 0x21 0x0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 3 CHECKMULTISIG",
    "",
    "3-of-3, 2 sigs"
  ],
  [
    "0 0x47 0x304402205b7d2c2f177ae76cfbbf14d589c113b0b35db753d305d5562dd0b61cbf366cfb02202e56f93c4f08a27f986cd424ffc48a462c3202c4902104d4d0ff98ed28f4bf8001 0 0x4c69 0x52210279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f8179821038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f515082103363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff464053ae",
    "HASH160 0x14 0xc9e4a896d149702d0d1695434feddd52e24ad78d EQUAL",
    "P2SH",
    "P2SH(2-of-3), 1 sig"
  ],
  [
    "0x47 0x304402200060558477337b9022e70534f1fea71a318caf836812465a2509931c5e7c4987022078ec32bd50ac9e03a349ba953dfd9fe1c8d2dd8bdb1d38ddca844d3d5c78c11801",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "DERSIG",
    "P2PK with too much R padding"
  ],
  [
    "0x48 0x304502202de8c03fc525285c9c535631019a5f2af7c6454fa9eb392a3756a4917c420edd02210046130bf2baf7cfc065067c8b9e33a066d9c15edcea9feb0ca2d233e3597925b401",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "DERSIG",
    "P2PK with too much S padding"
  ],
  [
    "0x47 0x30440220d7a0417c3f6d1a15094d1cf2a3378ca0503eb8a57630953a9e2987e21ddd0a6502207a6266d686c99090920249991d3d42065b6d43eb70187b219c0db82e4f94d1a201",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "DERSIG",
    "P2PK with too little R padding"
  ],
  [
    "0x47 0x30440220005ece1335e7f757a1a1f476a7fb5bd90964e8a022489f890614a04acfb734c002206c12b8294a6513c7710e8c82d3c23d75cdbfe83200eb7efb495701958501a5d601",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG NOT",
    "DERSIG",
    "P2PK NOT with bad sig with too much R padding"
  ],
  [
    "0x47 0x30440220005ece1335e7f657a1a1f476a7fb5bd90964e8a022489f890614a04acfb734c002206c12b8294a6513c7710e8c82d3c23d75cdbfe83200eb7efb495701958501a5d601",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG NOT",
    "",
    "P2PK NOT with too much R padding but no DERSIG"
  ],
  [
    "0x47 0x30440220005ece1335e7f657a1a1f476a7fb5bd90964e8a022489f890614a04acfb734c002206c12b8294a6513c7710e8c82d3c23d75cdbfe83200eb7efb495701958501a5d601",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG NOT",
    "DERSIG",
    "P2PK NOT with too much R padding"
  ],
  [
    "0x47 0x30440220d7a0417c3f6d1a15094d1cf2a3378ca0503eb8a57630953a9e2987e21ddd0a6502207a6266d686c99090920249991d3d42065b6d43eb70187b219c0db82e4f94d1a201",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "DERSIG",
    "BIP66 example 1, with DERSIG"
  ],
  [
    "0x47 0x304402208e43c0b91f7c1e5bc58e41c8185f8a6086e111b0090187968a86f2822462d3c902200a58f4076b1133b18ff1dc83ee51676e44c60cc608d9534e0df5ace0424fc0be01",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG NOT",
    "",
    "BIP66 example 2, without DERSIG"
  ],
  [
    "0x47 0x304402208e43c0b91f7c1e5bc58e41c8185f8a6086e111b0090187968a86f2822462d3c902200a58f4076b1133b18ff1dc83ee51676e44c60cc608d9534e0df5ace0424fc0be01",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG NOT",
    "DERSIG",
    "BIP66 example 2, with DERSIG"
  ],
  [
    "0",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "",
    "BIP66 example 3, without DERSIG"
  ],
  [
    "0",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "DERSIG",
    "BIP66 example 3, with DERSIG"
  ],
  [
    "1",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "",
    "BIP66 example 5, without DERSIG"
  ],
  [
    "1",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "DERSIG",
    "BIP66 example 5, with DERSIG"
  ],
  [
    "1",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG NOT",
    "DERSIG",
    "BIP66 example 6, with DERSIG"
  ],
  [
    "0 0x47 0x30440220cae00b1444babfbf6071b0ba8707f6bd373da3df494d6e74119b0430c5db810502205d5231b8c5939c8ff0c82242656d6e06edb073d42af336c99fe8837c36ea39d501 0x47 0x3044022027c2714269ca5aeecc4d70edc88ba5ee0e3da4986e9216028f489ab4f1b8efce022022bd545b4951215267e4c5ceabd4c5350331b2e4a0b6494c56f361fa5a57a1a201",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG",
    "DERSIG",
    "BIP66 example 7, with DERSIG"
  ],
  [
    "0 0x47 0x30440220b119d67d389315308d1745f734a51ff3ec72e06081e84e236fdf9dc2f5d2a64802204b04e3bc38674c4422ea317231d642b56dc09d214a1ecbbf16ecca01ed996e2201 0x47 0x3044022079ea80afd538d9ada421b5101febeb6bc874e01dde5bca108c1d0479aec339a4022004576db8f66130d1df686ccf00935703689d69cf539438da1edab208b0d63c4801",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG NOT",
    "",
    "BIP66 example 8, without DERSIG"
  ],
  [
    "0 0x47 0x30440220b119d67d389315308d1745f734a51ff3ec72e06081e84e236fdf9dc2f5d2a64802204b04e3bc38674c4422ea317231d642b56dc09d214a1ecbbf16ecca01ed996e2201 0x47 0x3044022079ea80afd538d9ada421b5101febeb6bc874e01dde5bca108c1d0479aec339a4022004576db8f66130d1df686ccf00935703689d69cf539438da1edab208b0d63c4801",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG NOT",
    "DERSIG",
    "BIP66 example 8, with DERSIG"
  ],
  [
    "0 0 0x47 0x3044022081aa9d436f2154e8b6d600516db03d78de71df685b585a9807ead4210bd883490220534bb6bdf318a419ac0749660b60e78d17d515558ef369bf872eff405b676b2e01",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG",
    "",
    "BIP66 example 9, without DERSIG"
  ],
  [
    "0 0 0x47 0x3044022081aa9d436f2154e8b6d600516db03d78de71df685b585a9807ead4210bd883490220534bb6bdf318a419ac0749660b60e78d17d515558ef369bf872eff405b676b2e01",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG",
    "DERSIG",
    "BIP66 example 9, with DERSIG"
  ],
  [
    "0 0 0x47 0x30440220da6f441dc3b4b2c84cfa8db0cd5b34ed92c9e01686de5a800d40498b70c0dcac02207c2cf91b0c32b860c4cd4994be36cfb84caf8bb7c3a8e4d96a31b2022c5299c501",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG NOT",
    "DERSIG",
    "BIP66 example 10, with DERSIG"
  ],
  [
    "0 0x47 0x30440220cae00b1444babfbf6071b0ba8707f6bd373da3df494d6e74119b0430c5db810502205d5231b8c5939c8ff0c82242656d6e06edb073d42af336c99fe8837c36ea39d501 0",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG",
    "",
    "BIP66 example 11, without DERSIG"
  ],
  [
    "0 0x47 0x30440220cae00b1444babfbf6071b0ba8707f6bd373da3df494d6e74119b0430c5db810502205d5231b8c5939c8ff0c82242656d6e06edb073d42af336c99fe8837c36ea39d501 0",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG",
    "DERSIG",
    "BIP66 example 11, with DERSIG"
  ],
  [
    "0x48 0x304402203e4516da7253cf068effec6b95c41221c0cf3a8e6ccb8cbf1725b562e9afde2c022054e1c258c2981cdfba5df1f46661fb6541c44f77ca0092f3600331abfffb12510101",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG",
    "DERSIG",
    "P2PK with multi-byte hashtype, with DERSIG"
  ],
  [
    "0x48 0x304502203e4516da7253cf068effec6b95c41221c0cf3a8e6ccb8cbf1725b562e9afde2c022100ab1e3da73d67e32045a20e0b999e049978ea8d6ee5480d485fcf2ce0d03b2ef001",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG",
    "LOW_S",
    "P2PK with high S"
  ],
  [
    "0x47 0x3044022057292e2d4dfe775becdd0a9e6547997c728cdf35390f6a017da56d654d374e4902206b643be2fc53763b4e284845bfea2c597d2dc7759941dce937636c9d341b71ed01",
    "0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG",
    "STRICTENC",
    "P2PK with hybrid pubkey"
  ],
  [
    "0x47 0x30440220035d554e3153c14950c9993f41c496607a8e24093db0595be7bf875cf64fcf1f02204731c8c4e5daf15e706cec19cdd8f2c5b1d05490e11dab8465ed426569b6e92101",
    "0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG NOT",
    "",
    "P2PK NOT with hybrid pubkey but no STRICTENC"
  ],
  [
    "0x47 0x30440220035d554e3153c14950c9993f41c496607a8e24093db0595be7bf875cf64fcf1f02204731c8c4e5daf15e706cec19cdd8f2c5b1d05490e11dab8465ed426569b6e92101",
    "0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG NOT",
    "STRICTENC",
    "P2PK NOT with hybrid pubkey"
  ],
  [
    "0x47 0x30440220035d554e3153c04950c9993f41c496607a8e24093db0595be7bf875cf64fcf1f02204731c8c4e5daf15e706cec19cdd8f2c5b1d05490e11dab8465ed426569b6e92101",
    "0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG NOT",
    "STRICTENC",
    "P2PK NOT with invalid hybrid pubkey"
  ],
  [
    "0 0x47 0x3044022079c7824d6c868e0e1a273484e28c2654a27d043c8a27f49f52cb72efed0759090220452bbbf7089574fa082095a4fc1b3a16bafcf97a3a34d745fafc922cce66b27201",
    "1 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 2 CHECKMULTISIG",
    "STRICTENC",
    "1-of-2 with the first 1 hybrid pubkey"
  ],
  [
    "0x47 0x304402206177d513ec2cda444c021a1f4f656fc4c72ba108ae063e157eb86dc3575784940220666fc66702815d0e5413bb9b1df22aed44f5f1efb8b99d41dd5dc9a5be6d205205",
    "0x41 0x048282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f5150811f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf CHECKSIG",
    "STRICTENC",
    "P2PK with undefined hashtype"
  ],
  [
    "0x47 0x304402207409b5b320296e5e2136a7b281a7f803028ca4ca44e2b83eebd46932677725de02202d4eea1c8d3c98e6f42614f54764e6e5e6542e213eb4d079737e9a8b6e9812ec05",
    "0x41 0x048282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f5150811f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf CHECKSIG NOT",
    "STRICTENC",
    "P2PK NOT with invalid sig and undefined hashtype"
  ],
  [
    "1 0x47 0x3044022051254b9fb476a52d85530792b578f86fea70ec1ffb4393e661bcccb23d8d63d3022076505f94a403c86097841944e044c70c2045ce90e36de51f7e9d3828db98a07501 0x47 0x304402200a358f750934b3feb822f1966bfcd8bbec9eeaa3a8ca941e11ee5960e181fa01022050bf6b5a8e7750f70354ae041cb68a7bade67ec6c3ab19eb359638974410626e01 0x47 0x304402200955d031fff71d8653221e85e36c3c85533d2312fc3045314b19650b7ae2f81002202a6bb8505e36201909d0921f01abff390ae6b7ff97bbf959f98aedeb0a56730901",
    "3 0x21 0x0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 3 CHECKMULTISIG",
    "NULLDUMMY",
    "3-of-3 with nonzero dummy"
  ],
  [
    "1 0x47 0x304402201bb2edab700a5d020236df174fefed78087697143731f659bea59642c759c16d022061f42cdbae5bcd3e8790f20bf76687443436e94a634321c16a72aa54cbc7c2ea01 0x47 0x304402204bb4a64f2a6e5c7fb2f07fef85ee56fde5e6da234c6a984262307a20e99842d702206f8303aaba5e625d223897e2ffd3f88ef1bcffef55f38dc3768e5f2e94c923f901 0x47 0x3044022040c2809b71fffb155ec8b82fe7a27f666bd97f941207be4e14ade85a1249dd4d02204d56c85ec525dd18e29a0533d5ddf61b6b1bb32980c2f63edf951aebf7a27bfe01",
    "3 0x21 0x0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 3 CHECKMULTISIG NOT",
    "NULLDUMMY",
    "3-of-3 NOT with invalid sig with nonzero dummy"
  ],
  [
    "0 0x47 0x304402200abeb4bd07f84222f474aed558cfbdfc0b4e96cde3c2935ba7098b1ff0bd74c302204a04c1ca67b2a20abee210cf9a21023edccbbf8024b988812634233115c6b73901 DUP",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 2 CHECKMULTISIG",
    "SIGPUSHONLY",
    "2-of-2 with two identical keys and sigs pushed using OP_DUP"
  ],
  [
    "0x47 0x304402203e4516da7253cf068effec6b95c41221c0cf3a8e6ccb8cbf1725b562e9afde2c022054e1c258c2981cdfba5df1f46661fb6541c44f77ca0092f3600331abfffb125101 0x23 0x2103363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640ac",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG",
    "",
    "P2SH(P2PK) with non-push scriptSig but no SIGPUSHONLY"
  ],
  [
    "0x47 0x304402203e4516da7253cf068effec6b95c41221c0cf3a8e6ccb8cbf1725b562e9afde2c022054e1c258c2981cdfba5df1f46661fb6541c44f77ca0092f3600331abfffb125101 0x23 0x2103363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640ac",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG",
    "SIGPUSHONLY",
    "P2SH(P2PK) with non-push scriptSig"
  ],
  [
    "0 0x47 0x304402205451ce65ad844dbb978b8bdedf5082e33b43cae8279c30f2c74d9e9ee49a94f802203fe95a7ccf74da7a232ee523ef4a53cb4d14bdd16289680cdb97a63819b8f42f01 0x46 0x304402205451ce65ad844dbb978b8bdedf5082e33b43cae8279c30f2c74d9e9ee49a94f802203fe95a7ccf74da7a232ee523ef4a53cb4d14bdd16289680cdb97a63819b8f42f",
    "2 0x21 0x02a673638cb9587cb68ea08dbef685c6f2d2a751a8b3c6f2a7e9a4999e6e4bfaf5 0x21 0x02a673638cb9587cb68ea08dbef685c6f2d2a751a8b3c6f2a7e9a4999e6e4bfaf5 0x21 0x02a673638cb9587cb68ea08dbef685c6f2d2a751a8b3c6f2a7e9a4999e6e4bfaf5 3 CHECKMULTISIG",
    "P2SH,STRICTENC",
    "2-of-3 with one valid and one invalid signature due to parse error, nSigs > validSigs"
  ],
  [
    "11 0x47 0x304402200a5c6163f07b8d3b013c4d1d6dba25e780b39658d79ba37af7057a3b7f15ffa102201fd9b4eaa9943f734928b99a83592c2e7bf342ea2680f6a2bb705167966b742001",
    "0x41 0x0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG",
    "CLEANSTACK,P2SH",
    "P2PK with unnecessary input"
  ],
  [
    "11 0x47 0x304402202f7505132be14872581f35d74b759212d9da40482653f1ffa3116c3294a4a51702206adbf347a2240ca41c66522b1a22a41693610b76a8e7770645dc721d1635854f01 0x43 0x410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8ac",
    "HASH160 0x14 0x31edc23bdafda4639e669f89ad6b2318dd79d032 EQUAL",
    "CLEANSTACK,P2SH",
    "P2SH with unnecessary input"
  ],
  ["The End"]
];
