var bitcoindScriptValid = [
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
    "DEPTH 0 EQUAL",
    "P2SH,STRICTENC",
    "Test the test: we should have an empty stack after scriptSig evaluation"
  ],
  [
    "  ",
    "DEPTH 0 EQUAL",
    "P2SH,STRICTENC",
    "and multiple spaces should not change that."
  ],
  ["   ", "DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  ["    ", "DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  [
    "1 2",
    "2 EQUALVERIFY 1 EQUAL",
    "P2SH,STRICTENC",
    "Similarly whitespace around and between symbols"
  ],
  ["1  2", "2 EQUALVERIFY 1 EQUAL", "P2SH,STRICTENC"],
  ["  1  2", "2 EQUALVERIFY 1 EQUAL", "P2SH,STRICTENC"],
  ["1  2  ", "2 EQUALVERIFY 1 EQUAL", "P2SH,STRICTENC"],
  ["  1  2  ", "2 EQUALVERIFY 1 EQUAL", "P2SH,STRICTENC"],
  ["1", "", "P2SH,STRICTENC"],
  [
    "0x02 0x01 0x00",
    "",
    "P2SH,STRICTENC",
    "all bytes are significant, not only the last one"
  ],
  [
    "0x09 0x00000000 0x00000000 0x10",
    "",
    "P2SH,STRICTENC",
    "equals zero when cast to Int64"
  ],
  ["0x01 0x0b", "11 EQUAL", "P2SH,STRICTENC", "push 1 byte"],
  ["0x02 0x417a", "'Az' EQUAL", "P2SH,STRICTENC"],
  [
    "0x4b 0x417a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a",
    "'Azzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz' EQUAL",
    "P2SH,STRICTENC",
    "push 75 bytes"
  ],
  ["0x4c 0x01 0x07", "7 EQUAL", "P2SH,STRICTENC", "0x4c is OP_PUSHDATA1"],
  ["0x4d 0x0100 0x08", "8 EQUAL", "P2SH,STRICTENC", "0x4d is OP_PUSHDATA2"],
  ["0x4e 0x01000000 0x09", "9 EQUAL", "P2SH,STRICTENC", "0x4e is OP_PUSHDATA4"],
  ["0x4c 0x00", "0 EQUAL", "P2SH,STRICTENC"],
  ["0x4d 0x0000", "0 EQUAL", "P2SH,STRICTENC"],
  ["0x4e 0x00000000", "0 EQUAL", "P2SH,STRICTENC"],
  ["0x4f 1000 ADD", "999 EQUAL", "P2SH,STRICTENC"],
  [
    "0",
    "IF 0x50 ENDIF 1",
    "P2SH,STRICTENC",
    "0x50 is reserved (ok if not executed)"
  ],
  [
    "0x51",
    "0x5f ADD 0x60 EQUAL",
    "P2SH,STRICTENC",
    "0x51 through 0x60 push 1 through 16 onto stack"
  ],
  ["1", "NOP", "P2SH,STRICTENC"],
  [
    "0",
    "IF VER ELSE 1 ENDIF",
    "P2SH,STRICTENC",
    "VER non-functional (ok if not executed)"
  ],
  [
    "0",
    "IF RESERVED RESERVED1 RESERVED2 ELSE 1 ENDIF",
    "P2SH,STRICTENC",
    "RESERVED ok in un-executed IF"
  ],
  ["1", "DUP IF ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "DUP IF ELSE ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 1 ELSE ENDIF", "P2SH,STRICTENC"],
  ["0", "IF ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1 1", "IF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  ["1 0", "IF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  [
    "1 1",
    "IF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  [
    "0 0",
    "IF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  ["1 0", "NOTIF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  ["1 1", "NOTIF IF 1 ELSE 0 ENDIF ENDIF", "P2SH,STRICTENC"],
  [
    "1 0",
    "NOTIF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  [
    "0 1",
    "NOTIF IF 1 ELSE 0 ENDIF ELSE IF 0 ELSE 1 ENDIF ENDIF",
    "P2SH,STRICTENC"
  ],
  [
    "0",
    "IF 0 ELSE 1 ELSE 0 ENDIF",
    "P2SH,STRICTENC",
    "Multiple ELSE's are valid and executed inverts on each ELSE encountered"
  ],
  ["1", "IF 1 ELSE 0 ELSE ENDIF", "P2SH,STRICTENC"],
  ["1", "IF ELSE 0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["1", "IF 1 ELSE 0 ELSE 1 ENDIF ADD 2 EQUAL", "P2SH,STRICTENC"],
  [
    "'' 1",
    "IF SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ENDIF 0x14 0x68ca4fec736264c13b859bac43d5173df6871682 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "1",
    "NOTIF 0 ELSE 1 ELSE 0 ENDIF",
    "P2SH,STRICTENC",
    "Multiple ELSE's are valid and execution inverts on each ELSE encountered"
  ],
  ["0", "NOTIF 1 ELSE 0 ELSE ENDIF", "P2SH,STRICTENC"],
  ["0", "NOTIF ELSE 0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "NOTIF 1 ELSE 0 ELSE 1 ENDIF ADD 2 EQUAL", "P2SH,STRICTENC"],
  [
    "'' 0",
    "NOTIF SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ELSE ELSE SHA1 ENDIF 0x14 0x68ca4fec736264c13b859bac43d5173df6871682 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "0",
    "IF 1 IF RETURN ELSE RETURN ELSE RETURN ENDIF ELSE 1 IF 1 ELSE RETURN ELSE 1 ENDIF ELSE RETURN ENDIF ADD 2 EQUAL",
    "P2SH,STRICTENC",
    "Nested ELSE ELSE"
  ],
  [
    "1",
    "NOTIF 0 NOTIF RETURN ELSE RETURN ELSE RETURN ENDIF ELSE 0 NOTIF 1 ELSE RETURN ELSE 1 ENDIF ELSE RETURN ENDIF ADD 2 EQUAL",
    "P2SH,STRICTENC"
  ],
  ["0", "IF RETURN ENDIF 1", "P2SH,STRICTENC", "RETURN only works if executed"],
  ["1 1", "VERIFY", "P2SH,STRICTENC"],
  [
    "1 0x05 0x01 0x00 0x00 0x00 0x00",
    "VERIFY",
    "P2SH,STRICTENC",
    "values >4 bytes can be cast to boolean"
  ],
  ["1 0x01 0x80", "IF 0 ENDIF", "P2SH,STRICTENC", "negative 0 is false"],
  ["10 0 11 TOALTSTACK DROP FROMALTSTACK", "ADD 21 EQUAL", "P2SH,STRICTENC"],
  [
    "'gavin_was_here' TOALTSTACK 11 FROMALTSTACK",
    "'gavin_was_here' EQUALVERIFY 11 EQUAL",
    "P2SH,STRICTENC"
  ],
  ["0 IFDUP", "DEPTH 1 EQUALVERIFY 0 EQUAL", "P2SH,STRICTENC"],
  ["1 IFDUP", "DEPTH 2 EQUALVERIFY 1 EQUALVERIFY 1 EQUAL", "P2SH,STRICTENC"],
  [
    "0x05 0x0100000000 IFDUP",
    "DEPTH 2 EQUALVERIFY 0x05 0x0100000000 EQUAL",
    "P2SH,STRICTENC",
    "IFDUP dups non ints"
  ],
  ["0 DROP", "DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  ["0", "DUP 1 ADD 1 EQUALVERIFY 0 EQUAL", "P2SH,STRICTENC"],
  ["0 1", "NIP", "P2SH,STRICTENC"],
  ["1 0", "OVER DEPTH 3 EQUALVERIFY", "P2SH,STRICTENC"],
  ["22 21 20", "0 PICK 20 EQUALVERIFY DEPTH 3 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "1 PICK 21 EQUALVERIFY DEPTH 3 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "2 PICK 22 EQUALVERIFY DEPTH 3 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "0 ROLL 20 EQUALVERIFY DEPTH 2 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "1 ROLL 21 EQUALVERIFY DEPTH 2 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "2 ROLL 22 EQUALVERIFY DEPTH 2 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "ROT 22 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "ROT DROP 20 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "ROT DROP DROP 21 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "ROT ROT 21 EQUAL", "P2SH,STRICTENC"],
  ["22 21 20", "ROT ROT ROT 20 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT 24 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT DROP 25 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT 2DROP 20 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT 2DROP DROP 21 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT 2DROP 2DROP 22 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT 2DROP 2DROP DROP 23 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT 2ROT 22 EQUAL", "P2SH,STRICTENC"],
  ["25 24 23 22 21 20", "2ROT 2ROT 2ROT 20 EQUAL", "P2SH,STRICTENC"],
  ["1 0", "SWAP 1 EQUALVERIFY 0 EQUAL", "P2SH,STRICTENC"],
  ["0 1", "TUCK DEPTH 3 EQUALVERIFY SWAP 2DROP", "P2SH,STRICTENC"],
  ["13 14", "2DUP ROT EQUALVERIFY EQUAL", "P2SH,STRICTENC"],
  [
    "-1 0 1 2",
    "3DUP DEPTH 7 EQUALVERIFY ADD ADD 3 EQUALVERIFY 2DROP 0 EQUALVERIFY",
    "P2SH,STRICTENC"
  ],
  ["1 2 3 5", "2OVER ADD ADD 8 EQUALVERIFY ADD ADD 6 EQUAL", "P2SH,STRICTENC"],
  ["1 3 5 7", "2SWAP ADD 4 EQUALVERIFY ADD 12 EQUAL", "P2SH,STRICTENC"],
  ["0", "SIZE 0 EQUAL", "P2SH,STRICTENC"],
  ["1", "SIZE 1 EQUAL", "P2SH,STRICTENC"],
  ["127", "SIZE 1 EQUAL", "P2SH,STRICTENC"],
  ["128", "SIZE 2 EQUAL", "P2SH,STRICTENC"],
  ["32767", "SIZE 2 EQUAL", "P2SH,STRICTENC"],
  ["32768", "SIZE 3 EQUAL", "P2SH,STRICTENC"],
  ["8388607", "SIZE 3 EQUAL", "P2SH,STRICTENC"],
  ["8388608", "SIZE 4 EQUAL", "P2SH,STRICTENC"],
  ["2147483647", "SIZE 4 EQUAL", "P2SH,STRICTENC"],
  ["2147483648", "SIZE 5 EQUAL", "P2SH,STRICTENC"],
  ["549755813887", "SIZE 5 EQUAL", "P2SH,STRICTENC"],
  ["549755813888", "SIZE 6 EQUAL", "P2SH,STRICTENC"],
  ["9223372036854775807", "SIZE 8 EQUAL", "P2SH,STRICTENC"],
  ["-1", "SIZE 1 EQUAL", "P2SH,STRICTENC"],
  ["-127", "SIZE 1 EQUAL", "P2SH,STRICTENC"],
  ["-128", "SIZE 2 EQUAL", "P2SH,STRICTENC"],
  ["-32767", "SIZE 2 EQUAL", "P2SH,STRICTENC"],
  ["-32768", "SIZE 3 EQUAL", "P2SH,STRICTENC"],
  ["-8388607", "SIZE 3 EQUAL", "P2SH,STRICTENC"],
  ["-8388608", "SIZE 4 EQUAL", "P2SH,STRICTENC"],
  ["-2147483647", "SIZE 4 EQUAL", "P2SH,STRICTENC"],
  ["-2147483648", "SIZE 5 EQUAL", "P2SH,STRICTENC"],
  ["-549755813887", "SIZE 5 EQUAL", "P2SH,STRICTENC"],
  ["-549755813888", "SIZE 6 EQUAL", "P2SH,STRICTENC"],
  ["-9223372036854775807", "SIZE 8 EQUAL", "P2SH,STRICTENC"],
  ["'abcdefghijklmnopqrstuvwxyz'", "SIZE 26 EQUAL", "P2SH,STRICTENC"],
  [
    "42",
    "SIZE 1 EQUALVERIFY 42 EQUAL",
    "P2SH,STRICTENC",
    "SIZE does not consume argument"
  ],
  ["2 -2 ADD", "0 EQUAL", "P2SH,STRICTENC"],
  ["2147483647 -2147483647 ADD", "0 EQUAL", "P2SH,STRICTENC"],
  ["-1 -1 ADD", "-2 EQUAL", "P2SH,STRICTENC"],
  ["0 0", "EQUAL", "P2SH,STRICTENC"],
  ["1 1 ADD", "2 EQUAL", "P2SH,STRICTENC"],
  ["1 1ADD", "2 EQUAL", "P2SH,STRICTENC"],
  ["111 1SUB", "110 EQUAL", "P2SH,STRICTENC"],
  ["111 1 ADD 12 SUB", "100 EQUAL", "P2SH,STRICTENC"],
  ["0 ABS", "0 EQUAL", "P2SH,STRICTENC"],
  ["16 ABS", "16 EQUAL", "P2SH,STRICTENC"],
  ["-16 ABS", "-16 NEGATE EQUAL", "P2SH,STRICTENC"],
  ["0 NOT", "NOP", "P2SH,STRICTENC"],
  ["1 NOT", "0 EQUAL", "P2SH,STRICTENC"],
  ["11 NOT", "0 EQUAL", "P2SH,STRICTENC"],
  ["0 0NOTEQUAL", "0 EQUAL", "P2SH,STRICTENC"],
  ["1 0NOTEQUAL", "1 EQUAL", "P2SH,STRICTENC"],
  ["111 0NOTEQUAL", "1 EQUAL", "P2SH,STRICTENC"],
  ["-111 0NOTEQUAL", "1 EQUAL", "P2SH,STRICTENC"],
  ["1 1 BOOLAND", "NOP", "P2SH,STRICTENC"],
  ["1 0 BOOLAND", "NOT", "P2SH,STRICTENC"],
  ["0 1 BOOLAND", "NOT", "P2SH,STRICTENC"],
  ["0 0 BOOLAND", "NOT", "P2SH,STRICTENC"],
  ["16 17 BOOLAND", "NOP", "P2SH,STRICTENC"],
  ["1 1 BOOLOR", "NOP", "P2SH,STRICTENC"],
  ["1 0 BOOLOR", "NOP", "P2SH,STRICTENC"],
  ["0 1 BOOLOR", "NOP", "P2SH,STRICTENC"],
  ["0 0 BOOLOR", "NOT", "P2SH,STRICTENC"],
  ["16 17 BOOLOR", "NOP", "P2SH,STRICTENC"],
  ["11 10 1 ADD", "NUMEQUAL", "P2SH,STRICTENC"],
  ["11 10 1 ADD", "NUMEQUALVERIFY 1", "P2SH,STRICTENC"],
  ["11 10 1 ADD", "NUMNOTEQUAL NOT", "P2SH,STRICTENC"],
  ["111 10 1 ADD", "NUMNOTEQUAL", "P2SH,STRICTENC"],
  ["11 10", "LESSTHAN NOT", "P2SH,STRICTENC"],
  ["4 4", "LESSTHAN NOT", "P2SH,STRICTENC"],
  ["10 11", "LESSTHAN", "P2SH,STRICTENC"],
  ["-11 11", "LESSTHAN", "P2SH,STRICTENC"],
  ["-11 -10", "LESSTHAN", "P2SH,STRICTENC"],
  ["11 10", "GREATERTHAN", "P2SH,STRICTENC"],
  ["4 4", "GREATERTHAN NOT", "P2SH,STRICTENC"],
  ["10 11", "GREATERTHAN NOT", "P2SH,STRICTENC"],
  ["-11 11", "GREATERTHAN NOT", "P2SH,STRICTENC"],
  ["-11 -10", "GREATERTHAN NOT", "P2SH,STRICTENC"],
  ["11 10", "LESSTHANOREQUAL NOT", "P2SH,STRICTENC"],
  ["4 4", "LESSTHANOREQUAL", "P2SH,STRICTENC"],
  ["10 11", "LESSTHANOREQUAL", "P2SH,STRICTENC"],
  ["-11 11", "LESSTHANOREQUAL", "P2SH,STRICTENC"],
  ["-11 -10", "LESSTHANOREQUAL", "P2SH,STRICTENC"],
  ["11 10", "GREATERTHANOREQUAL", "P2SH,STRICTENC"],
  ["4 4", "GREATERTHANOREQUAL", "P2SH,STRICTENC"],
  ["10 11", "GREATERTHANOREQUAL NOT", "P2SH,STRICTENC"],
  ["-11 11", "GREATERTHANOREQUAL NOT", "P2SH,STRICTENC"],
  ["-11 -10", "GREATERTHANOREQUAL NOT", "P2SH,STRICTENC"],
  ["1 0 MIN", "0 NUMEQUAL", "P2SH,STRICTENC"],
  ["0 1 MIN", "0 NUMEQUAL", "P2SH,STRICTENC"],
  ["-1 0 MIN", "-1 NUMEQUAL", "P2SH,STRICTENC"],
  ["0 -2147483647 MIN", "-2147483647 NUMEQUAL", "P2SH,STRICTENC"],
  ["2147483647 0 MAX", "2147483647 NUMEQUAL", "P2SH,STRICTENC"],
  ["0 100 MAX", "100 NUMEQUAL", "P2SH,STRICTENC"],
  ["-100 0 MAX", "0 NUMEQUAL", "P2SH,STRICTENC"],
  ["0 -2147483647 MAX", "0 NUMEQUAL", "P2SH,STRICTENC"],
  ["0 0 1", "WITHIN", "P2SH,STRICTENC"],
  ["1 0 1", "WITHIN NOT", "P2SH,STRICTENC"],
  ["0 -2147483647 2147483647", "WITHIN", "P2SH,STRICTENC"],
  ["-1 -100 100", "WITHIN", "P2SH,STRICTENC"],
  ["11 -100 100", "WITHIN", "P2SH,STRICTENC"],
  ["-2147483647 -100 100", "WITHIN NOT", "P2SH,STRICTENC"],
  ["2147483647 -100 100", "WITHIN NOT", "P2SH,STRICTENC"],
  ["2147483647 2147483647 SUB", "0 EQUAL", "P2SH,STRICTENC"],
  [
    "2147483647 DUP ADD",
    "4294967294 EQUAL",
    "P2SH,STRICTENC",
    ">32 bit EQUAL is valid"
  ],
  ["2147483647 NEGATE DUP ADD", "-4294967294 EQUAL", "P2SH,STRICTENC"],
  [
    "''",
    "RIPEMD160 0x14 0x9c1185a5c5e9fc54612808977ee8f548b2258d31 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'a'",
    "RIPEMD160 0x14 0x0bdc9d2d256b3ee9daae347be6f4dc835a467ffe EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'abcdefghijklmnopqrstuvwxyz'",
    "RIPEMD160 0x14 0xf71c27109c692c1b56bbdceb5b9d2865b3708dbc EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "''",
    "SHA1 0x14 0xda39a3ee5e6b4b0d3255bfef95601890afd80709 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'a'",
    "SHA1 0x14 0x86f7e437faa5a7fce15d1ddcb9eaeaea377667b8 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'abcdefghijklmnopqrstuvwxyz'",
    "SHA1 0x14 0x32d10c7b8cf96570ca04ce37f2a19d84240d3a89 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "''",
    "SHA256 0x20 0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'a'",
    "SHA256 0x20 0xca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'abcdefghijklmnopqrstuvwxyz'",
    "SHA256 0x20 0x71c480df93d6ae2f1efad1447c66c9525e316218cf51fc8d9ed832f2daf18b73 EQUAL",
    "P2SH,STRICTENC"
  ],
  ["''", "DUP HASH160 SWAP SHA256 RIPEMD160 EQUAL", "P2SH,STRICTENC"],
  ["''", "DUP HASH256 SWAP SHA256 SHA256 EQUAL", "P2SH,STRICTENC"],
  [
    "''",
    "NOP HASH160 0x14 0xb472a266d0bd89c13706a4132ccfb16f7c3b9fcb EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'a'",
    "HASH160 NOP 0x14 0x994355199e516ff76c4fa4aab39337b9d84cf12b EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'abcdefghijklmnopqrstuvwxyz'",
    "HASH160 0x4c 0x14 0xc286a1af0947f58d1ad787385b1c2c4a976f9e71 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "''",
    "HASH256 0x20 0x5df6e0e2761359d30a8275058e299fcc0381534545f55cf43e41983f5d4c9456 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'a'",
    "HASH256 0x20 0xbf5d3affb73efd2ec6c36ad3112dd933efed63c4e1cbffcfa88e2759c144f2d8 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'abcdefghijklmnopqrstuvwxyz'",
    "HASH256 0x4c 0x20 0xca139bc10c2f660da42666f72e89a225936fc60f193c161124a672050c434671 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "1",
    "NOP1 CHECKLOCKTIMEVERIFY NOP3 NOP4 NOP5 NOP6 NOP7 NOP8 NOP9 NOP10 1 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "'NOP_1_to_10' NOP1 CHECKLOCKTIMEVERIFY NOP3 NOP4 NOP5 NOP6 NOP7 NOP8 NOP9 NOP10",
    "'NOP_1_to_10' EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "1",
    "NOP",
    "P2SH,STRICTENC,DISCOURAGE_UPGRADABLE_NOPS",
    "Discourage NOPx flag allows OP_NOP"
  ],
  [
    "0",
    "IF NOP10 ENDIF 1",
    "P2SH,STRICTENC,DISCOURAGE_UPGRADABLE_NOPS",
    "Discouraged NOPs are allowed if not executed"
  ],
  [
    "0",
    "IF 0xba ELSE 1 ENDIF",
    "P2SH,STRICTENC",
    "opcodes above NOP10 invalid if executed"
  ],
  ["0", "IF 0xbb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xbc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xbd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xbe ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xbf ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xc9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xca ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xcb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xcc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xcd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xce ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xcf ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xd9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xda ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xdb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xdc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xdd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xde ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xdf ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xe9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xea ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xeb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xec ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xed ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xee ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xef ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf0 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf1 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf2 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf3 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf4 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf5 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf6 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf7 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf8 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xf9 ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xfa ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xfb ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xfc ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xfd ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xfe ELSE 1 ENDIF", "P2SH,STRICTENC"],
  ["0", "IF 0xff ELSE 1 ENDIF", "P2SH,STRICTENC"],
  [
    "NOP",
    "'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'",
    "P2SH,STRICTENC",
    "520 byte push"
  ],
  [
    "1",
    "0x616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161",
    "P2SH,STRICTENC",
    "201 opcodes executed. 0x61 is NOP"
  ],
  [
    "1 2 3 4 5 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "1 2 3 4 5 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "P2SH,STRICTENC",
    "1,000 stack size (0x6f is 3DUP)"
  ],
  [
    "1 TOALTSTACK 2 TOALTSTACK 3 4 5 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "1 2 3 4 5 6 7 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "P2SH,STRICTENC",
    "1,000 stack size (altstack cleared between scriptSig/scriptPubKey)"
  ],
  [
    "'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f",
    "'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 0x6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f 2DUP 0x616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161",
    "P2SH,STRICTENC",
    "Max-size (10,000-byte), max-push(520 bytes), max-opcodes(201), max stack size(1,000 items). 0x6f is 3DUP, 0x61 is NOP"
  ],
  [
    "0",
    "IF 0x5050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050 ENDIF 1",
    "P2SH,STRICTENC",
    ">201 opcodes, but RESERVED (0x50) doesn't count towards opcode limit."
  ],
  ["NOP", "1", "P2SH,STRICTENC"],
  [
    "1",
    "0x01 0x01 EQUAL",
    "P2SH,STRICTENC",
    "The following is useful for checking implementations of BN_bn2mpi"
  ],
  ["127", "0x01 0x7F EQUAL", "P2SH,STRICTENC"],
  ["128", "0x02 0x8000 EQUAL", "P2SH,STRICTENC", "Leave room for the sign bit"],
  ["32767", "0x02 0xFF7F EQUAL", "P2SH,STRICTENC"],
  ["32768", "0x03 0x008000 EQUAL", "P2SH,STRICTENC"],
  ["8388607", "0x03 0xFFFF7F EQUAL", "P2SH,STRICTENC"],
  ["8388608", "0x04 0x00008000 EQUAL", "P2SH,STRICTENC"],
  ["2147483647", "0x04 0xFFFFFF7F EQUAL", "P2SH,STRICTENC"],
  ["2147483648", "0x05 0x0000008000 EQUAL", "P2SH,STRICTENC"],
  ["549755813887", "0x05 0xFFFFFFFF7F EQUAL", "P2SH,STRICTENC"],
  ["549755813888", "0x06 0xFFFFFFFF7F EQUAL", "P2SH,STRICTENC"],
  ["9223372036854775807", "0x08 0xFFFFFFFFFFFFFF7F EQUAL", "P2SH,STRICTENC"],
  [
    "-1",
    "0x01 0x81 EQUAL",
    "P2SH,STRICTENC",
    "Numbers are little-endian with the MSB being a sign bit"
  ],
  ["-127", "0x01 0xFF EQUAL", "P2SH,STRICTENC"],
  ["-128", "0x02 0x8080 EQUAL", "P2SH,STRICTENC"],
  ["-32767", "0x02 0xFFFF EQUAL", "P2SH,STRICTENC"],
  ["-32768", "0x03 0x008080 EQUAL", "P2SH,STRICTENC"],
  ["-8388607", "0x03 0xFFFFFF EQUAL", "P2SH,STRICTENC"],
  ["-8388608", "0x04 0x00008080 EQUAL", "P2SH,STRICTENC"],
  ["-2147483647", "0x04 0xFFFFFFFF EQUAL", "P2SH,STRICTENC"],
  ["-2147483648", "0x05 0x0000008080 EQUAL", "P2SH,STRICTENC"],
  ["-4294967295", "0x05 0xFFFFFFFF80 EQUAL", "P2SH,STRICTENC"],
  ["-549755813887", "0x05 0xFFFFFFFFFF EQUAL", "P2SH,STRICTENC"],
  ["-549755813888", "0x06 0x000000008080 EQUAL", "P2SH,STRICTENC"],
  ["-9223372036854775807", "0x08 0xFFFFFFFFFFFFFFFF EQUAL", "P2SH,STRICTENC"],
  [
    "2147483647",
    "1ADD 2147483648 EQUAL",
    "P2SH,STRICTENC",
    "We can do math on 4-byte integers, and compare 5-byte ones"
  ],
  ["2147483647", "1ADD 1", "P2SH,STRICTENC"],
  ["-2147483647", "1ADD 1", "P2SH,STRICTENC"],
  [
    "1",
    "0x02 0x0100 EQUAL NOT",
    "P2SH,STRICTENC",
    "Not the same byte array..."
  ],
  [
    "1",
    "0x02 0x0100 NUMEQUAL",
    "P2SH,STRICTENC",
    "... but they are numerically equal"
  ],
  ["11", "0x4c 0x03 0x0b0000 NUMEQUAL", "P2SH,STRICTENC"],
  ["0", "0x01 0x80 EQUAL NOT", "P2SH,STRICTENC"],
  [
    "0",
    "0x01 0x80 NUMEQUAL",
    "P2SH,STRICTENC",
    "Zero numerically equals negative zero"
  ],
  ["0", "0x02 0x0080 NUMEQUAL", "P2SH,STRICTENC"],
  ["0x03 0x000080", "0x04 0x00000080 NUMEQUAL", "P2SH,STRICTENC"],
  ["0x03 0x100080", "0x04 0x10000080 NUMEQUAL", "P2SH,STRICTENC"],
  ["0x03 0x100000", "0x04 0x10000000 NUMEQUAL", "P2SH,STRICTENC"],
  [
    "NOP",
    "NOP 1",
    "P2SH,STRICTENC",
    "The following tests check the if(stack.size() < N) tests in each opcode"
  ],
  [
    "1",
    "IF 1 ENDIF",
    "P2SH,STRICTENC",
    "They are here to catch copy-and-paste errors"
  ],
  [
    "0",
    "NOTIF 1 ENDIF",
    "P2SH,STRICTENC",
    "Most of them are duplicated elsewhere,"
  ],
  [
    "1",
    "VERIFY 1",
    "P2SH,STRICTENC",
    "but, hey, more is always better, right?"
  ],
  ["0", "TOALTSTACK 1", "P2SH,STRICTENC"],
  ["1", "TOALTSTACK FROMALTSTACK", "P2SH,STRICTENC"],
  ["0 0", "2DROP 1", "P2SH,STRICTENC"],
  ["0 1", "2DUP", "P2SH,STRICTENC"],
  ["0 0 1", "3DUP", "P2SH,STRICTENC"],
  ["0 1 0 0", "2OVER", "P2SH,STRICTENC"],
  ["0 1 0 0 0 0", "2ROT", "P2SH,STRICTENC"],
  ["0 1 0 0", "2SWAP", "P2SH,STRICTENC"],
  ["1", "IFDUP", "P2SH,STRICTENC"],
  ["NOP", "DEPTH 1", "P2SH,STRICTENC"],
  ["0", "DROP 1", "P2SH,STRICTENC"],
  ["1", "DUP", "P2SH,STRICTENC"],
  ["0 1", "NIP", "P2SH,STRICTENC"],
  ["1 0", "OVER", "P2SH,STRICTENC"],
  ["1 0 0 0 3", "PICK", "P2SH,STRICTENC"],
  ["1 0", "PICK", "P2SH,STRICTENC"],
  ["1 0 0 0 3", "ROLL", "P2SH,STRICTENC"],
  ["1 0", "ROLL", "P2SH,STRICTENC"],
  ["1 0 0", "ROT", "P2SH,STRICTENC"],
  ["1 0", "SWAP", "P2SH,STRICTENC"],
  ["0 1", "TUCK", "P2SH,STRICTENC"],
  ["1", "SIZE", "P2SH,STRICTENC"],
  ["0 0", "EQUAL", "P2SH,STRICTENC"],
  ["0 0", "EQUALVERIFY 1", "P2SH,STRICTENC"],
  [
    "0 0 1",
    "EQUAL EQUAL",
    "P2SH,STRICTENC",
    "OP_0 and bools must have identical byte representations"
  ],
  ["0", "1ADD", "P2SH,STRICTENC"],
  ["2", "1SUB", "P2SH,STRICTENC"],
  ["-1", "NEGATE", "P2SH,STRICTENC"],
  ["-1", "ABS", "P2SH,STRICTENC"],
  ["0", "NOT", "P2SH,STRICTENC"],
  ["-1", "0NOTEQUAL", "P2SH,STRICTENC"],
  ["1 0", "ADD", "P2SH,STRICTENC"],
  ["1 0", "SUB", "P2SH,STRICTENC"],
  ["-1 -1", "BOOLAND", "P2SH,STRICTENC"],
  ["-1 0", "BOOLOR", "P2SH,STRICTENC"],
  ["0 0", "NUMEQUAL", "P2SH,STRICTENC"],
  ["0 0", "NUMEQUALVERIFY 1", "P2SH,STRICTENC"],
  ["-1 0", "NUMNOTEQUAL", "P2SH,STRICTENC"],
  ["-1 0", "LESSTHAN", "P2SH,STRICTENC"],
  ["1 0", "GREATERTHAN", "P2SH,STRICTENC"],
  ["0 0", "LESSTHANOREQUAL", "P2SH,STRICTENC"],
  ["0 0", "GREATERTHANOREQUAL", "P2SH,STRICTENC"],
  ["-1 0", "MIN", "P2SH,STRICTENC"],
  ["1 0", "MAX", "P2SH,STRICTENC"],
  ["-1 -1 0", "WITHIN", "P2SH,STRICTENC"],
  ["0", "RIPEMD160", "P2SH,STRICTENC"],
  ["0", "SHA1", "P2SH,STRICTENC"],
  ["0", "SHA256", "P2SH,STRICTENC"],
  ["0", "HASH160", "P2SH,STRICTENC"],
  ["0", "HASH256", "P2SH,STRICTENC"],
  ["NOP", "CODESEPARATOR 1", "P2SH,STRICTENC"],
  ["NOP", "NOP1 1", "P2SH,STRICTENC"],
  ["NOP", "CHECKLOCKTIMEVERIFY 1", "P2SH,STRICTENC"],
  ["NOP", "NOP3 1", "P2SH,STRICTENC"],
  ["NOP", "NOP4 1", "P2SH,STRICTENC"],
  ["NOP", "NOP5 1", "P2SH,STRICTENC"],
  ["NOP", "NOP6 1", "P2SH,STRICTENC"],
  ["NOP", "NOP7 1", "P2SH,STRICTENC"],
  ["NOP", "NOP8 1", "P2SH,STRICTENC"],
  ["NOP", "NOP9 1", "P2SH,STRICTENC"],
  ["NOP", "NOP10 1", "P2SH,STRICTENC"],
  [
    "",
    "0 0 0 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC",
    "CHECKMULTISIG is allowed to have zero keys and/or sigs"
  ],
  ["", "0 0 0 CHECKMULTISIGVERIFY DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  [
    "",
    "0 0 0 1 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC",
    "Zero sigs means no sigs are checked"
  ],
  ["", "0 0 0 1 CHECKMULTISIGVERIFY DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  [
    "",
    "0 0 0 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC",
    "CHECKMULTISIG is allowed to have zero keys and/or sigs"
  ],
  ["", "0 0 0 CHECKMULTISIGVERIFY DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  [
    "",
    "0 0 0 1 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC",
    "Zero sigs means no sigs are checked"
  ],
  ["", "0 0 0 1 CHECKMULTISIGVERIFY DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  [
    "",
    "0 0 'a' 'b' 2 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC",
    "Test from up to 20 pubkeys, all not checked"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 3 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 4 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 5 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 6 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 7 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 8 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 9 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 10 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 11 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 12 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 13 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 14 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 15 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 16 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 17 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 18 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 19 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG VERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  ["", "0 0 'a' 1 CHECKMULTISIGVERIFY DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  ["", "0 0 'a' 'b' 2 CHECKMULTISIGVERIFY DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  ["", "0 0 'a' 'b' 'c' 3 CHECKMULTISIGVERIFY DEPTH 0 EQUAL", "P2SH,STRICTENC"],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 4 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 5 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 6 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 7 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 8 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 9 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 10 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 11 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 12 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 13 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 14 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 15 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 16 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 17 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 18 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 19 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY DEPTH 0 EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "0 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG 0 0 CHECKMULTISIG",
    "P2SH,STRICTENC",
    "nOpCount is incremented by the number of keys evaluated in addition to the usual one op per op. In this case we have zero keys, so we can execute 201 CHECKMULTISIGS"
  ],
  [
    "1",
    "0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY 0 0 0 CHECKMULTISIGVERIFY",
    "P2SH,STRICTENC"
  ],
  [
    "",
    "NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIG",
    "P2SH,STRICTENC",
    "Even though there are no signatures being checked nOpCount is incremented by the number of keys."
  ],
  [
    "1",
    "NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 CHECKMULTISIGVERIFY",
    "P2SH,STRICTENC"
  ],
  [
    "0 0x01 1",
    "HASH160 0x14 0xda1745e9b549bd0bfa1a569971c77eba30cd5a4b EQUAL",
    "P2SH,STRICTENC",
    "Very basic P2SH"
  ],
  [
    "0x4c 0 0x01 1",
    "HASH160 0x14 0xda1745e9b549bd0bfa1a569971c77eba30cd5a4b EQUAL",
    "P2SH,STRICTENC"
  ],
  [
    "0x40 0x42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242",
    "0x4d 0x4000 0x42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242 EQUAL",
    "P2SH,STRICTENC",
    "Basic PUSH signedness check"
  ],
  [
    "0x4c 0x40 0x42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242",
    "0x4d 0x4000 0x42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242 EQUAL",
    "P2SH,STRICTENC",
    "Basic PUSHDATA1 signedness check"
  ],
  ["all PUSHDATA forms are equivalent"],
  [
    "0x4c 0x4b 0x111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
    "0x4b 0x111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111 EQUAL",
    "",
    "PUSHDATA1 of 75 bytes equals direct push of it"
  ],
  [
    "0x4d 0xFF00 0x111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
    "0x4c 0xFF 0x111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111 EQUAL",
    "",
    "PUSHDATA2 of 255 bytes equals PUSHDATA1 of it"
  ],
  ["0x00", "SIZE 0 EQUAL", "P2SH,STRICTENC", "Basic OP_0 execution"],
  ["Numeric pushes"],
  ["0x01 0x81", "0x4f EQUAL", "", "OP1_NEGATE pushes 0x81"],
  ["0x01 0x01", "0x51 EQUAL", "", "OP_1  pushes 0x01"],
  ["0x01 0x02", "0x52 EQUAL", "", "OP_2  pushes 0x02"],
  ["0x01 0x03", "0x53 EQUAL", "", "OP_3  pushes 0x03"],
  ["0x01 0x04", "0x54 EQUAL", "", "OP_4  pushes 0x04"],
  ["0x01 0x05", "0x55 EQUAL", "", "OP_5  pushes 0x05"],
  ["0x01 0x06", "0x56 EQUAL", "", "OP_6  pushes 0x06"],
  ["0x01 0x07", "0x57 EQUAL", "", "OP_7  pushes 0x07"],
  ["0x01 0x08", "0x58 EQUAL", "", "OP_8  pushes 0x08"],
  ["0x01 0x09", "0x59 EQUAL", "", "OP_9  pushes 0x09"],
  ["0x01 0x0a", "0x5a EQUAL", "", "OP_10 pushes 0x0a"],
  ["0x01 0x0b", "0x5b EQUAL", "", "OP_11 pushes 0x0b"],
  ["0x01 0x0c", "0x5c EQUAL", "", "OP_12 pushes 0x0c"],
  ["0x01 0x0d", "0x5d EQUAL", "", "OP_13 pushes 0x0d"],
  ["0x01 0x0e", "0x5e EQUAL", "", "OP_14 pushes 0x0e"],
  ["0x01 0x0f", "0x5f EQUAL", "", "OP_15 pushes 0x0f"],
  ["0x01 0x10", "0x60 EQUAL", "", "OP_16 pushes 0x10"],
  ["Equivalency of different numeric encodings"],
  ["0x02 0x8000", "128 NUMEQUAL", "", "0x8000 equals 128"],
  ["0x01 0x00", "0 NUMEQUAL", "", "0x00 numequals 0"],
  ["0x01 0x80", "0 NUMEQUAL", "", "0x80 (negative zero) numequals 0"],
  ["0x02 0x0080", "0 NUMEQUAL", "", "0x0080 numequals 0"],
  ["0x02 0x0500", "5 NUMEQUAL", "", "0x0500 numequals 5"],
  ["0x03 0xff7f80", "0x02 0xffff NUMEQUAL", "", ""],
  ["0x03 0xff7f00", "0x02 0xff7f NUMEQUAL", "", ""],
  ["0x04 0xffff7f80", "0x03 0xffffff NUMEQUAL", "", ""],
  ["0x04 0xffff7f00", "0x03 0xffff7f NUMEQUAL", "", ""],
  ["Unevaluated non-minimal pushes are ignored"],
  [
    "0 IF 0x4c 0x00 ENDIF 1",
    "",
    "MINIMALDATA",
    "non-minimal PUSHDATA1 ignored"
  ],
  [
    "0 IF 0x4d 0x0000 ENDIF 1",
    "",
    "MINIMALDATA",
    "non-minimal PUSHDATA2 ignored"
  ],
  [
    "0 IF 0x4c 0x00000000 ENDIF 1",
    "",
    "MINIMALDATA",
    "non-minimal PUSHDATA4 ignored"
  ],
  ["0 IF 0x01 0x81 ENDIF 1", "", "MINIMALDATA", "1NEGATE equiv"],
  ["0 IF 0x01 0x01 ENDIF 1", "", "MINIMALDATA", "OP_1  equiv"],
  ["0 IF 0x01 0x02 ENDIF 1", "", "MINIMALDATA", "OP_2  equiv"],
  ["0 IF 0x01 0x03 ENDIF 1", "", "MINIMALDATA", "OP_3  equiv"],
  ["0 IF 0x01 0x04 ENDIF 1", "", "MINIMALDATA", "OP_4  equiv"],
  ["0 IF 0x01 0x05 ENDIF 1", "", "MINIMALDATA", "OP_5  equiv"],
  ["0 IF 0x01 0x06 ENDIF 1", "", "MINIMALDATA", "OP_6  equiv"],
  ["0 IF 0x01 0x07 ENDIF 1", "", "MINIMALDATA", "OP_7  equiv"],
  ["0 IF 0x01 0x08 ENDIF 1", "", "MINIMALDATA", "OP_8  equiv"],
  ["0 IF 0x01 0x09 ENDIF 1", "", "MINIMALDATA", "OP_9  equiv"],
  ["0 IF 0x01 0x0a ENDIF 1", "", "MINIMALDATA", "OP_10 equiv"],
  ["0 IF 0x01 0x0b ENDIF 1", "", "MINIMALDATA", "OP_11 equiv"],
  ["0 IF 0x01 0x0c ENDIF 1", "", "MINIMALDATA", "OP_12 equiv"],
  ["0 IF 0x01 0x0d ENDIF 1", "", "MINIMALDATA", "OP_13 equiv"],
  ["0 IF 0x01 0x0e ENDIF 1", "", "MINIMALDATA", "OP_14 equiv"],
  ["0 IF 0x01 0x0f ENDIF 1", "", "MINIMALDATA", "OP_15 equiv"],
  ["0 IF 0x01 0x10 ENDIF 1", "", "MINIMALDATA", "OP_16 equiv"],
  [
    "Numeric minimaldata rules are only applied when a stack item is numerically evaluated; the push itself is allowed"
  ],
  ["0x01 0x00", "1", "MINIMALDATA"],
  ["0x01 0x80", "1", "MINIMALDATA"],
  ["0x02 0x0180", "1", "MINIMALDATA"],
  ["0x02 0x0100", "1", "MINIMALDATA"],
  ["0x02 0x0200", "1", "MINIMALDATA"],
  ["0x02 0x0300", "1", "MINIMALDATA"],
  ["0x02 0x0400", "1", "MINIMALDATA"],
  ["0x02 0x0500", "1", "MINIMALDATA"],
  ["0x02 0x0600", "1", "MINIMALDATA"],
  ["0x02 0x0700", "1", "MINIMALDATA"],
  ["0x02 0x0800", "1", "MINIMALDATA"],
  ["0x02 0x0900", "1", "MINIMALDATA"],
  ["0x02 0x0a00", "1", "MINIMALDATA"],
  ["0x02 0x0b00", "1", "MINIMALDATA"],
  ["0x02 0x0c00", "1", "MINIMALDATA"],
  ["0x02 0x0d00", "1", "MINIMALDATA"],
  ["0x02 0x0e00", "1", "MINIMALDATA"],
  ["0x02 0x0f00", "1", "MINIMALDATA"],
  ["0x02 0x1000", "1", "MINIMALDATA"],
  [
    "Valid version of the 'Test every numeric-accepting opcode for correct handling of the numeric minimal encoding rule' script_invalid test"
  ],
  ["1 0x02 0x0000", "PICK DROP", ""],
  ["1 0x02 0x0000", "ROLL DROP 1", ""],
  ["0x02 0x0000", "1ADD DROP 1", ""],
  ["0x02 0x0000", "1SUB DROP 1", ""],
  ["0x02 0x0000", "NEGATE DROP 1", ""],
  ["0x02 0x0000", "ABS DROP 1", ""],
  ["0x02 0x0000", "NOT DROP 1", ""],
  ["0x02 0x0000", "0NOTEQUAL DROP 1", ""],
  ["0 0x02 0x0000", "ADD DROP 1", ""],
  ["0x02 0x0000 0", "ADD DROP 1", ""],
  ["0 0x02 0x0000", "SUB DROP 1", ""],
  ["0x02 0x0000 0", "SUB DROP 1", ""],
  ["0 0x02 0x0000", "BOOLAND DROP 1", ""],
  ["0x02 0x0000 0", "BOOLAND DROP 1", ""],
  ["0 0x02 0x0000", "BOOLOR DROP 1", ""],
  ["0x02 0x0000 0", "BOOLOR DROP 1", ""],
  ["0 0x02 0x0000", "NUMEQUAL DROP 1", ""],
  ["0x02 0x0000 1", "NUMEQUAL DROP 1", ""],
  ["0 0x02 0x0000", "NUMEQUALVERIFY 1", ""],
  ["0x02 0x0000 0", "NUMEQUALVERIFY 1", ""],
  ["0 0x02 0x0000", "NUMNOTEQUAL DROP 1", ""],
  ["0x02 0x0000 0", "NUMNOTEQUAL DROP 1", ""],
  ["0 0x02 0x0000", "LESSTHAN DROP 1", ""],
  ["0x02 0x0000 0", "LESSTHAN DROP 1", ""],
  ["0 0x02 0x0000", "GREATERTHAN DROP 1", ""],
  ["0x02 0x0000 0", "GREATERTHAN DROP 1", ""],
  ["0 0x02 0x0000", "LESSTHANOREQUAL DROP 1", ""],
  ["0x02 0x0000 0", "LESSTHANOREQUAL DROP 1", ""],
  ["0 0x02 0x0000", "GREATERTHANOREQUAL DROP 1", ""],
  ["0x02 0x0000 0", "GREATERTHANOREQUAL DROP 1", ""],
  ["0 0x02 0x0000", "MIN DROP 1", ""],
  ["0x02 0x0000 0", "MIN DROP 1", ""],
  ["0 0x02 0x0000", "MAX DROP 1", ""],
  ["0x02 0x0000 0", "MAX DROP 1", ""],
  ["0x02 0x0000 0 0", "WITHIN DROP 1", ""],
  ["0 0x02 0x0000 0", "WITHIN DROP 1", ""],
  ["0 0 0x02 0x0000", "WITHIN DROP 1", ""],
  ["0 0 0x02 0x0000", "CHECKMULTISIG DROP 1", ""],
  ["0 0x02 0x0000 0", "CHECKMULTISIG DROP 1", ""],
  ["0 0x02 0x0000 0 1", "CHECKMULTISIG DROP 1", ""],
  ["0 0 0x02 0x0000", "CHECKMULTISIGVERIFY 1", ""],
  ["0 0x02 0x0000 0", "CHECKMULTISIGVERIFY 1", ""],
  ["While not really correctly DER encoded, the empty signature is allowed by"],
  [
    "STRICTENC to provide a compact way to provide a delibrately invalid signature."
  ],
  [
    "0",
    "0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 CHECKSIG NOT",
    "STRICTENC"
  ],
  [
    "0 0",
    "1 0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 1 CHECKMULTISIG NOT",
    "STRICTENC"
  ],
  [
    "CHECKMULTISIG evaluation order tests. CHECKMULTISIG evaluates signatures and"
  ],
  [
    "pubkeys in a specific order, and will exit early if the number of signatures"
  ],
  [
    "left to check is greater than the number of keys left. As STRICTENC fails the"
  ],
  [
    "script when it reaches an invalidly encoded signature or pubkey, we can use it"
  ],
  ["to test the exact order in which signatures and pubkeys are evaluated by"],
  [
    "distinguishing CHECKMULTISIG returning false on the stack and the script as a"
  ],
  ["whole failing."],
  [
    "See also the corresponding inverted versions of these tests in script_invalid.json"
  ],
  [
    "0 0x47 0x3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501 0x47 0x3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501",
    "2 0 0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 2 CHECKMULTISIG NOT",
    "STRICTENC",
    "2-of-2 CHECKMULTISIG NOT with the second pubkey invalid, and both signatures validly encoded. Valid pubkey fails, and CHECKMULTISIG exits early, prior to evaluation of second invalid pubkey."
  ],
  [
    "0 0 0x47 0x3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501",
    "2 0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 0x21 0x02865c40293a680cb9c020e7b1e106d8c1916d3cef99aa431a56d253e69256dac0 2 CHECKMULTISIG NOT",
    "STRICTENC",
    "2-of-2 CHECKMULTISIG NOT with both pubkeys valid, but second signature invalid. Valid pubkey fails, and CHECKMULTISIG exits early, prior to evaluation of second invalid signature."
  ],
  ["Increase test coverage for DERSIG"],
  [
    "0x4a 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "0 CHECKSIG NOT",
    "",
    "Overly long signature is correctly encoded"
  ],
  [
    "0x25 0x30220220000000000000000000000000000000000000000000000000000000000000000000",
    "0 CHECKSIG NOT",
    "",
    "Missing S is correctly encoded"
  ],
  [
    "0x27 0x3024021077777777777777777777777777777777020a7777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "",
    "S with invalid S length is correctly encoded"
  ],
  [
    "0x27 0x302403107777777777777777777777777777777702107777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "",
    "Non-integer R is correctly encoded"
  ],
  [
    "0x27 0x302402107777777777777777777777777777777703107777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "",
    "Non-integer S is correctly encoded"
  ],
  [
    "0x17 0x3014020002107777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "",
    "Zero-length R is correctly encoded"
  ],
  [
    "0x17 0x3014021077777777777777777777777777777777020001",
    "0 CHECKSIG NOT",
    "",
    "Zero-length S is correctly encoded for DERSIG"
  ],
  [
    "0x27 0x302402107777777777777777777777777777777702108777777777777777777777777777777701",
    "0 CHECKSIG NOT",
    "",
    "Negative S is correctly encoded"
  ],
  ["Automatically generated test cases"],
  [
    "0x47 0x304402200a5c6163f07b8d3b013c4d1d6dba25e780b39658d79ba37af7057a3b7f15ffa102201fd9b4eaa9943f734928b99a83592c2e7bf342ea2680f6a2bb705167966b742001",
    "0x41 0x0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG",
    "",
    "P2PK"
  ],
  [
    "0x47 0x304402206e05a6fe23c59196ffe176c9ddc31e73a9885638f9d1328d47c0c703863b8876022076feb53811aa5b04e0e79f938eb19906cc5e67548bc555a8e8b8b0fc603d840c01 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508",
    "DUP HASH160 0x14 0x1018853670f9f3b0582c5b9ee8ce93764ac32b93 EQUALVERIFY CHECKSIG",
    "",
    "P2PKH"
  ],
  [
    "0x47 0x304402204710a85181663b32d25c70ec2bbd14adff5ddfff6cb50d09e155ef5f541fc86c0220056b0cc949be9386ecc5f6c2ac0493269031dbb185781db90171b54ac127790281",
    "0x41 0x048282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f5150811f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf CHECKSIG",
    "",
    "P2PK anyonecanpay"
  ],
  [
    "0x47 0x3044022003fef42ed6c7be8917441218f525a60e2431be978e28b7aca4d7a532cc413ae8022067a1f82c74e8d69291b90d148778405c6257bbcfc2353cc38a3e1f22bf44254601 0x23 0x210279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798ac",
    "HASH160 0x14 0x23b0ad3477f2178bc0b3eed26e4e6316f4e83aa1 EQUAL",
    "P2SH",
    "P2SH(P2PK)"
  ],
  [
    "0x47 0x304402204e2eb034be7b089534ac9e798cf6a2c79f38bcb34d1b179efd6f2de0841735db022071461beb056b5a7be1819da6a3e3ce3662831ecc298419ca101eb6887b5dd6a401 0x19 0x76a9147cf9c846cd4882efec4bf07e44ebdad495c94f4b88ac",
    "HASH160 0x14 0x2df519943d5acc0ef5222091f9dfe3543f489a82 EQUAL",
    "",
    "P2SH(P2PKH), bad sig but no VERIFY_P2SH"
  ],
  [
    "0 0x47 0x3044022051254b9fb476a52d85530792b578f86fea70ec1ffb4393e661bcccb23d8d63d3022076505f94a403c86097841944e044c70c2045ce90e36de51f7e9d3828db98a07501 0x47 0x304402200a358f750934b3feb822f1966bfcd8bbec9eeaa3a8ca941e11ee5960e181fa01022050bf6b5a8e7750f70354ae041cb68a7bade67ec6c3ab19eb359638974410626e01 0x47 0x304402200955d031fff71d8653221e85e36c3c85533d2312fc3045314b19650b7ae2f81002202a6bb8505e36201909d0921f01abff390ae6b7ff97bbf959f98aedeb0a56730901",
    "3 0x21 0x0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 3 CHECKMULTISIG",
    "",
    "3-of-3"
  ],
  [
    "0 0x47 0x304402205b7d2c2f177ae76cfbbf14d589c113b0b35db753d305d5562dd0b61cbf366cfb02202e56f93c4f08a27f986cd424ffc48a462c3202c4902104d4d0ff98ed28f4bf8001 0x47 0x30440220563e5b3b1fc11662a84bc5ea2a32cc3819703254060ba30d639a1aaf2d5068ad0220601c1f47ddc76d93284dd9ed68f7c9974c4a0ea7cbe8a247d6bc3878567a5fca01 0x4c69 0x52210279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f8179821038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f515082103363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff464053ae",
    "HASH160 0x14 0xc9e4a896d149702d0d1695434feddd52e24ad78d EQUAL",
    "P2SH",
    "P2SH(2-of-3)"
  ],
  [
    "0x47 0x304402200060558477337b9022e70534f1fea71a318caf836812465a2509931c5e7c4987022078ec32bd50ac9e03a349ba953dfd9fe1c8d2dd8bdb1d38ddca844d3d5c78c11801",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "",
    "P2PK with too much R padding but no DERSIG"
  ],
  [
    "0x48 0x304502202de8c03fc525285c9c535631019a5f2af7c6454fa9eb392a3756a4917c420edd02210046130bf2baf7cfc065067c8b9e33a066d9c15edcea9feb0ca2d233e3597925b401",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "",
    "P2PK with too much S padding but no DERSIG"
  ],
  [
    "0x47 0x30440220d7a0417c3f6d1a15094d1cf2a3378ca0503eb8a57630953a9e2987e21ddd0a6502207a6266d686c99090920249991d3d42065b6d43eb70187b219c0db82e4f94d1a201",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "",
    "P2PK with too little R padding but no DERSIG"
  ],
  [
    "0x47 0x30440220005ece1335e7f757a1a1f476a7fb5bd90964e8a022489f890614a04acfb734c002206c12b8294a6513c7710e8c82d3c23d75cdbfe83200eb7efb495701958501a5d601",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG NOT",
    "",
    "P2PK NOT with bad sig with too much R padding but no DERSIG"
  ],
  [
    "0x47 0x30440220d7a0417c3f6d1a15094d1cf2a3378ca0503eb8a57630953a9e2987e21ddd0a6502207a6266d686c99090920249991d3d42065b6d43eb70187b219c0db82e4f94d1a201",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG",
    "",
    "BIP66 example 1, without DERSIG"
  ],
  [
    "0",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG NOT",
    "",
    "BIP66 example 4, without DERSIG"
  ],
  [
    "0",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG NOT",
    "DERSIG",
    "BIP66 example 4, with DERSIG"
  ],
  [
    "1",
    "0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 CHECKSIG NOT",
    "",
    "BIP66 example 6, without DERSIG"
  ],
  [
    "0 0x47 0x30440220cae00b1444babfbf6071b0ba8707f6bd373da3df494d6e74119b0430c5db810502205d5231b8c5939c8ff0c82242656d6e06edb073d42af336c99fe8837c36ea39d501 0x47 0x3044022027c2714269ca5aeecc4d70edc88ba5ee0e3da4986e9216028f489ab4f1b8efce022022bd545b4951215267e4c5ceabd4c5350331b2e4a0b6494c56f361fa5a57a1a201",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG",
    "",
    "BIP66 example 7, without DERSIG"
  ],
  [
    "0 0 0x47 0x30440220da6f441dc3b4b2c84cfa8db0cd5b34ed92c9e01686de5a800d40498b70c0dcac02207c2cf91b0c32b860c4cd4994be36cfb84caf8bb7c3a8e4d96a31b2022c5299c501",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG NOT",
    "",
    "BIP66 example 10, without DERSIG"
  ],
  [
    "0 0x47 0x30440220b119d67d389315308d1745f734a51ff3ec72e06081e84e236fdf9dc2f5d2a64802204b04e3bc38674c4422ea317231d642b56dc09d214a1ecbbf16ecca01ed996e2201 0",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG NOT",
    "",
    "BIP66 example 12, without DERSIG"
  ],
  [
    "0 0x47 0x30440220b119d67d389315308d1745f734a51ff3ec72e06081e84e236fdf9dc2f5d2a64802204b04e3bc38674c4422ea317231d642b56dc09d214a1ecbbf16ecca01ed996e2201 0",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 2 CHECKMULTISIG NOT",
    "DERSIG",
    "BIP66 example 12, with DERSIG"
  ],
  [
    "0x48 0x304402203e4516da7253cf068effec6b95c41221c0cf3a8e6ccb8cbf1725b562e9afde2c022054e1c258c2981cdfba5df1f46661fb6541c44f77ca0092f3600331abfffb12510101",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG",
    "",
    "P2PK with multi-byte hashtype, without DERSIG"
  ],
  [
    "0x48 0x304502203e4516da7253cf068effec6b95c41221c0cf3a8e6ccb8cbf1725b562e9afde2c022100ab1e3da73d67e32045a20e0b999e049978ea8d6ee5480d485fcf2ce0d03b2ef001",
    "0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 CHECKSIG",
    "",
    "P2PK with high S but no LOW_S"
  ],
  [
    "0x47 0x3044022057292e2d4dfe775becdd0a9e6547997c728cdf35390f6a017da56d654d374e4902206b643be2fc53763b4e284845bfea2c597d2dc7759941dce937636c9d341b71ed01",
    "0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG",
    "",
    "P2PK with hybrid pubkey but no STRICTENC"
  ],
  [
    "0x47 0x30440220035d554e3153c04950c9993f41c496607a8e24093db0595be7bf875cf64fcf1f02204731c8c4e5daf15e706cec19cdd8f2c5b1d05490e11dab8465ed426569b6e92101",
    "0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG NOT",
    "",
    "P2PK NOT with invalid hybrid pubkey but no STRICTENC"
  ],
  [
    "0 0x47 0x304402202e79441ad1baf5a07fb86bae3753184f6717d9692680947ea8b6e8b777c69af1022079a262e13d868bb5a0964fefe3ba26942e1b0669af1afb55ef3344bc9d4fc4c401",
    "1 0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 2 CHECKMULTISIG",
    "",
    "1-of-2 with the second 1 hybrid pubkey and no STRICTENC"
  ],
  [
    "0 0x47 0x304402202e79441ad1baf5a07fb86bae3753184f6717d9692680947ea8b6e8b777c69af1022079a262e13d868bb5a0964fefe3ba26942e1b0669af1afb55ef3344bc9d4fc4c401",
    "1 0x41 0x0679be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 2 CHECKMULTISIG",
    "STRICTENC",
    "1-of-2 with the second 1 hybrid pubkey"
  ],
  [
    "0x47 0x304402206177d513ec2cda444c021a1f4f656fc4c72ba108ae063e157eb86dc3575784940220666fc66702815d0e5413bb9b1df22aed44f5f1efb8b99d41dd5dc9a5be6d205205",
    "0x41 0x048282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f5150811f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf CHECKSIG",
    "",
    "P2PK with undefined hashtype but no STRICTENC"
  ],
  [
    "0x47 0x304402207409b5b320296e5e2136a7b281a7f803028ca4ca44e2b83eebd46932677725de02202d4eea1c8d3c98e6f42614f54764e6e5e6542e213eb4d079737e9a8b6e9812ec05",
    "0x41 0x048282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f5150811f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf CHECKSIG NOT",
    "",
    "P2PK NOT with invalid sig and undefined hashtype but no STRICTENC"
  ],
  [
    "1 0x47 0x3044022051254b9fb476a52d85530792b578f86fea70ec1ffb4393e661bcccb23d8d63d3022076505f94a403c86097841944e044c70c2045ce90e36de51f7e9d3828db98a07501 0x47 0x304402200a358f750934b3feb822f1966bfcd8bbec9eeaa3a8ca941e11ee5960e181fa01022050bf6b5a8e7750f70354ae041cb68a7bade67ec6c3ab19eb359638974410626e01 0x47 0x304402200955d031fff71d8653221e85e36c3c85533d2312fc3045314b19650b7ae2f81002202a6bb8505e36201909d0921f01abff390ae6b7ff97bbf959f98aedeb0a56730901",
    "3 0x21 0x0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 3 CHECKMULTISIG",
    "",
    "3-of-3 with nonzero dummy but no NULLDUMMY"
  ],
  [
    "1 0x47 0x304402201bb2edab700a5d020236df174fefed78087697143731f659bea59642c759c16d022061f42cdbae5bcd3e8790f20bf76687443436e94a634321c16a72aa54cbc7c2ea01 0x47 0x304402204bb4a64f2a6e5c7fb2f07fef85ee56fde5e6da234c6a984262307a20e99842d702206f8303aaba5e625d223897e2ffd3f88ef1bcffef55f38dc3768e5f2e94c923f901 0x47 0x3044022040c2809b71fffb155ec8b82fe7a27f666bd97f941207be4e14ade85a1249dd4d02204d56c85ec525dd18e29a0533d5ddf61b6b1bb32980c2f63edf951aebf7a27bfe01",
    "3 0x21 0x0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x03363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640 3 CHECKMULTISIG NOT",
    "",
    "3-of-3 NOT with invalid sig and nonzero dummy but no NULLDUMMY"
  ],
  [
    "0 0x47 0x304402200abeb4bd07f84222f474aed558cfbdfc0b4e96cde3c2935ba7098b1ff0bd74c302204a04c1ca67b2a20abee210cf9a21023edccbbf8024b988812634233115c6b73901 DUP",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 2 CHECKMULTISIG",
    "",
    "2-of-2 with two identical keys and sigs pushed using OP_DUP but no SIGPUSHONLY"
  ],
  [
    "0 0x47 0x304402200abeb4bd07f84222f474aed558cfbdfc0b4e96cde3c2935ba7098b1ff0bd74c302204a04c1ca67b2a20abee210cf9a21023edccbbf8024b988812634233115c6b73901 0x47 0x304402200abeb4bd07f84222f474aed558cfbdfc0b4e96cde3c2935ba7098b1ff0bd74c302204a04c1ca67b2a20abee210cf9a21023edccbbf8024b988812634233115c6b73901",
    "2 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 0x21 0x038282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508 2 CHECKMULTISIG",
    "SIGPUSHONLY",
    "2-of-2 with two identical keys and sigs pushed"
  ],
  [
    "11 0x47 0x304402200a5c6163f07b8d3b013c4d1d6dba25e780b39658d79ba37af7057a3b7f15ffa102201fd9b4eaa9943f734928b99a83592c2e7bf342ea2680f6a2bb705167966b742001",
    "0x41 0x0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8 CHECKSIG",
    "P2SH",
    "P2PK with unnecessary input but no CLEANSTACK"
  ],
  [
    "11 0x47 0x304402202f7505132be14872581f35d74b759212d9da40482653f1ffa3116c3294a4a51702206adbf347a2240ca41c66522b1a22a41693610b76a8e7770645dc721d1635854f01 0x43 0x410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8ac",
    "HASH160 0x14 0x31edc23bdafda4639e669f89ad6b2318dd79d032 EQUAL",
    "P2SH",
    "P2SH with unnecessary input but no CLEANSTACK"
  ],
  [
    "0x47 0x304402202f7505132be14872581f35d74b759212d9da40482653f1ffa3116c3294a4a51702206adbf347a2240ca41c66522b1a22a41693610b76a8e7770645dc721d1635854f01 0x43 0x410479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8ac",
    "HASH160 0x14 0x31edc23bdafda4639e669f89ad6b2318dd79d032 EQUAL",
    "CLEANSTACK,P2SH",
    "P2SH with CLEANSTACK"
  ],
  ["The End"]
];
