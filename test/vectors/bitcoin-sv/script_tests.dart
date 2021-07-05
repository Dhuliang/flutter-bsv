var bitcoinSVScriptTests = [
  ["Copyright (c) 2018-2019 Bitcoin Association"],
  [
    "Distributed under the Open BSV software license, see the accompanying file LICENSE."
  ],
  [
    "Presumably there is an earlier copyright from the Bitcoin Core developers and/or the Bitcoin ABC developers but it was not listed"
  ],
  [
    "Format is: [[wit..., amount]?, scriptSig, scriptPubKey, flags, expected_scripterror, ... comments]"
  ],
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
    "For Moneybutton/bsv devs, this only contains a subset of the scripts in scripts.json"
  ],
  ["Feel free to add missing ones as needed."],
  ["Bitwise opcodes"],
  ["AND"],
  ["0 0", "AND 0 EQUAL", "P2SH,STRICTENC", "OK", "AND, empty parameters"],
  [
    "0x01 0x00 0x01 0x00",
    "AND 0x01 0x00 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "AND, simple and"
  ],
  [
    "1 0x01 0x00",
    "AND 0x01 0x00 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "AND, simple and"
  ],
  [
    "0x01 0x00 1",
    "AND 0x01 0x00 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "AND, simple and"
  ],
  ["1 1", "AND 1 EQUAL", "P2SH,STRICTENC", "OK", "AND, simple and"],
  [
    "0",
    "AND 0 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "AND, invalid parameter count"
  ],
  [
    "",
    "AND 0 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "AND, empty stack"
  ],
  [
    "0 1",
    "AND 1 EQUAL",
    "P2SH,STRICTENC",
    "OPERAND_SIZE",
    "AND, different operand size"
  ],
  [
    "0x01 0xab 0x01 0xcd",
    "AND 0x01 0x89 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "AND, more complex operands"
  ],
  ["OR"],
  ["0 0", "OR 0 EQUAL", "P2SH,STRICTENC", "OK", "OR, empty parameters"],
  [
    "0x01 0x00 0x01 0x00",
    "OR 0x01 0x00 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "OR, simple and"
  ],
  ["1 0x01 0x00", "OR 1 EQUAL", "P2SH,STRICTENC", "OK", "OR, simple and"],
  ["0x01 0x00 1", "OR 1 EQUAL", "P2SH,STRICTENC", "OK", "OR, simple and"],
  ["1 1", "OR 1 EQUAL", "P2SH,STRICTENC", "OK", "OR, simple and"],
  [
    "0",
    "OR 0 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "OR, invalid parameter count"
  ],
  [
    "",
    "OR 0 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "OR, empty stack"
  ],
  [
    "0 1",
    "OR 1 EQUAL",
    "P2SH,STRICTENC",
    "OPERAND_SIZE",
    "OR, different operand size"
  ],
  [
    "0x01 0xab 0x01 0xcd",
    "OR 0x01 0xef EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "XOR, more complex operands"
  ],
  ["XOR"],
  ["0 0", "XOR 0 EQUAL", "P2SH,STRICTENC", "OK", "XOR, empty parameters"],
  [
    "0x01 0x00 0x01 0x00",
    "XOR 0x01 0x00 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "XOR, simple and"
  ],
  ["1 0x01 0x00", "XOR 1 EQUAL", "P2SH,STRICTENC", "OK", "XOR, simple and"],
  ["0x01 0x00 1", "XOR 1 EQUAL", "P2SH,STRICTENC", "OK", "XOR, simple and"],
  ["1 1", "XOR 0x01 0x00 EQUAL", "P2SH,STRICTENC", "OK", "XOR, simple and"],
  [
    "0",
    "XOR 0 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "XOR, invalid parameter count"
  ],
  [
    "",
    "XOR 0 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "XOR, empty stack"
  ],
  [
    "0 1",
    "XOR 1 EQUAL",
    "P2SH,STRICTENC",
    "OPERAND_SIZE",
    "XOR, different operand size"
  ],
  [
    "0x01 0xab 0x01 0xcd",
    "XOR 0x01 0x66 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "XOR, more complex operands"
  ],
  ["INVERT"],
  [
    "",
    "INVERT",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "INVERT, invalid parameter count"
  ],
  ["0x0100", "INVERT 0x01FF EQUAL", "P2SH,STRICTENC", "OK", "INVERT, simple"],
  ["0x01FF", "INVERT 0x0100 EQUAL", "P2SH,STRICTENC", "OK", "INVERT, simple"],
  ["0x00", "INVERT 0x00 EQUAL", "P2SH,STRICTENC", "OK", "INVERT, empty"],
  [
    "0x020F0F",
    "INVERT 0x02F0F0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "INVERT, 2 bytes"
  ],
  [
    "0x03FF0000",
    "INVERT 0x0300FFFF EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "INVERT, 3 bytes"
  ],
  [
    "0x0300FFFF",
    "INVERT 0x03FF0000 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "INVERT, 3 bytes"
  ],
  [
    "0x03FFFFFF",
    "INVERT 0x03000000 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "INVERT, 3 bytes"
  ],
  [
    "0x03801234",
    "INVERT 0x037FEDCB EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "INVERT, 3 bytes"
  ],
  [
    "0x088012348012341234",
    "INVERT 0x087FEDCB7FEDCBEDCB EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "INVERT, 8 bytes"
  ],
  ["LSHIFT"],
  [
    "2 LSHIFT",
    "8 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "LSHIFT, invalid parameter count"
  ],
  [
    "2 -1 LSHIFT",
    "8 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_NUMBER_RANGE",
    "LSHIFT, n must be >= 0"
  ],
  ["2 2 LSHIFT", "8 EQUAL", "P2SH,STRICTENC", "OK", "simple LSHIFT"],
  ["24 0 LSHIFT", "24 EQUAL", "P2SH,STRICTENC", "OK", "LSHIFT, n = 0"],
  [
    "0x01FF 0 LSHIFT",
    "0x01FF EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 0"
  ],
  [
    "0x01FF 1 LSHIFT",
    "0x01FE EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 1"
  ],
  [
    "0x01FF 2 LSHIFT",
    "0x01FC EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 2"
  ],
  [
    "0x01FF 3 LSHIFT",
    "0x01F8 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 3"
  ],
  [
    "0x01FF 4 LSHIFT",
    "0x01F0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 4"
  ],
  [
    "0x01FF 5 LSHIFT",
    "0x01E0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 5"
  ],
  [
    "0x01FF 6 LSHIFT",
    "0x01C0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 6"
  ],
  [
    "0x01FF 7 LSHIFT",
    "0x0180 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 7"
  ],
  [
    "0x01FF 8 LSHIFT",
    "0x0100 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT 8 bit value by 8"
  ],
  [
    "0x020080 1 LSHIFT",
    "0x020100 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT over byte boundary"
  ],
  [
    "0x03008000 1 LSHIFT",
    "0x03010000 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT over byte boundary"
  ],
  [
    "0x03000080 1 LSHIFT",
    "0x03000100 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT over byte boundary"
  ],
  [
    "0x03800000 1 LSHIFT",
    "0x03000000 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT over byte boundary"
  ],
  [
    "0x085462725AFE7647D2 2 LSHIFT",
    "0x085189C96BF9D91F48 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT, 8 bytes long"
  ],
  [
    "0x0131 0x010A LSHIFT",
    "0x0100 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "LSHIFT, n > len(x)"
  ],
  ["RSHIFT"],
  [
    "2 RSHIFT",
    "1 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "RSHIFT, invalid parameter count"
  ],
  [
    "2 -1 RSHIFT",
    "8 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_NUMBER_RANGE",
    "RSHIFT, n must be >= 0"
  ],
  ["2 1 RSHIFT", "1 EQUAL", "P2SH,STRICTENC", "OK", "simple RSHIFT"],
  ["24 0 RSHIFT", "24 EQUAL", "P2SH,STRICTENC", "OK", "RSHIFT, n = 0"],
  [
    "0x01FF 0 RSHIFT",
    "0x01FF EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 0"
  ],
  [
    "0x01FF 1 RSHIFT",
    "0x017F EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 1"
  ],
  [
    "0x01FF 2 RSHIFT",
    "0x013F EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 2"
  ],
  [
    "0x01FF 3 RSHIFT",
    "0x011F EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 3"
  ],
  [
    "0x01FF 4 RSHIFT",
    "0x010F EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 4"
  ],
  [
    "0x01FF 5 RSHIFT",
    "0x0107 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 5"
  ],
  [
    "0x01FF 6 RSHIFT",
    "0x0103 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 6"
  ],
  [
    "0x01FF 7 RSHIFT",
    "0x0101 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 7"
  ],
  [
    "0x01FF 8 RSHIFT",
    "0x0100 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT 8 bit value by 8"
  ],
  [
    "0x020100 1 RSHIFT",
    "0x020080 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT over byte boundary"
  ],
  [
    "0x03010000 1 RSHIFT",
    "0x03008000 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT over byte boundary"
  ],
  [
    "0x03000100 1 RSHIFT",
    "0x03000080 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT over byte boundary"
  ],
  [
    "0x03000001 1 RSHIFT",
    "0x03000000 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT over byte boundary"
  ],
  [
    "0x085462725AFE7647D2 2 RSHIFT",
    "0x0815189C96BF9D91F4 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT, 8 bytes long"
  ],
  [
    "0x0131 0x010A RSHIFT",
    "0x0100 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "RSHIFT, n > len(x)"
  ],
  ["Arithmetic Opcodes"],
  ["MUL"],
  [
    "MUL",
    "4 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "no parameters"
  ],
  [
    "2 MUL",
    "4 EQUAL",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "not enough parameters"
  ],
  [
    "0x051234567890 2 MUL",
    "0 EQUAL",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "invalid param first"
  ],
  [
    "2 0x051234567890 MUL",
    "0 EQUAL",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "invalid param second"
  ],
  [
    "0x051234567890 0x051234567890 MUL",
    "0 EQUAL",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "both invalid param"
  ],
  [
    "0x03FF0000 2 MUL",
    "0x02FE01 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "non-minimally encoded param"
  ],
  [
    "0x03FF0000 2 MUL",
    "0x02FE01 EQUAL",
    "P2SH,STRICTENC,MINIMALDATA",
    "SCRIPTNUM_MINENCODE",
    "non-minimally encoded param"
  ],
  ["2 2 MUL", "4 EQUAL", "P2SH,STRICTENC", "OK", "single byte operands"],
  [
    "2 0x025624 MUL",
    "0x02AC48 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "single & double byte operands"
  ],
  [
    "0x025624 2 MUL",
    "0x02AC48 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "single & double byte operands"
  ],
  [
    "2 0x03563412 MUL",
    "0x03AC6824 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "single & triple byte operands"
  ],
  [
    "0x03563412 2 MUL",
    "0x03AC6824 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "single & triple byte operands"
  ],
  [
    "2 0x0478563412 MUL",
    "0x04F0AC6824 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "single & quad byte operands"
  ],
  [
    "0x0478563412 2 MUL",
    "0x04F0AC6824 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "single & quad byte operands"
  ],
  [
    "0x0478563412 0x0478563412 MUL",
    "0x0840D8F41DDC664B01 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "overflow"
  ],
  [
    "0x04FFFFFF7F 0x04FFFFFF7F MUL",
    "0x0801000000FFFFFF3F EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "largest pos possible"
  ],
  [
    "0x04FFFFFFFF 0x04FFFFFFFF MUL",
    "0x0801000000FFFFFF3F EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "largest neg possible"
  ],
  [
    "0x04FFFFFF7F 0x04FFFFFFFF MUL",
    "0x0801000000FFFFFFBF EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "largest pos * largest neg"
  ],
  ["0 478 MUL", "0 EQUAL", "P2SH,STRICTENC", "OK", "0 * anyvalue = 0"],
  ["478 0 MUL", "0 EQUAL", "P2SH,STRICTENC", "OK", "anyvalue * 0 = 0"],
  ["0 0 MUL", "0 EQUAL", "P2SH,STRICTENC", "OK", "0 * 0 = 0"],
  [
    "0x0180 478 MUL",
    "0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "(neg 0) * anyvalue = 0"
  ],
  ["1 478 MUL", "478 EQUAL", "P2SH,STRICTENC", "OK", "1 * anyvalue = anyvalue"],
  ["478 1 MUL", "478 EQUAL", "P2SH,STRICTENC", "OK", "anyvalue * 1 = anyvalue"],
  ["1 1 MUL", "1 EQUAL", "P2SH,STRICTENC", "OK", "1 * 1 = 1"],
  [
    "-1 478 MUL",
    "-478 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "-1 * anyvalue = -anyvalue"
  ],
  ["4 -8 MUL", "-32 EQUAL", "P2SH,STRICTENC", "OK", "neg value second"],
  ["-4 8 MUL", "-32 EQUAL", "P2SH,STRICTENC", "OK", "neg value first"],
  ["-4 -8 MUL", "32 EQUAL", "P2SH,STRICTENC", "OK", "two neg value"],
  ["DIV"],
  ["1 1", "DIV 1 EQUAL", "P2SH,STRICTENC", "OK"],
  ["1 -1", "DIV -1 EQUAL", "P2SH,STRICTENC", "OK"],
  ["-1 1", "DIV -1 EQUAL", "P2SH,STRICTENC", "OK"],
  ["-1 -1", "DIV 1 EQUAL", "P2SH,STRICTENC", "OK"],
  ["28 21", "DIV 1 EQUAL", "P2SH,STRICTENC", "OK", "Round towards zero"],
  ["12 -7", "DIV -1 EQUAL", "P2SH,STRICTENC", "OK", "Round towards zero"],
  ["-32 29", "DIV -1 EQUAL", "P2SH,STRICTENC", "OK", "Round towards zero"],
  ["-42 -27", "DIV 1 EQUAL", "P2SH,STRICTENC", "OK", "Round towards zero"],
  ["0 123", "DIV 0 EQUAL", "P2SH,STRICTENC", "OK"],
  ["511 0", "DIV", "P2SH,STRICTENC", "DIV_BY_ZERO", "DIV, divide by zero"],
  ["1 1", "DIV DEPTH 1 EQUAL", "P2SH,STRICTENC", "OK", "Stack depth correct"],
  [
    "1",
    "DIV",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "Not enough operands"
  ],
  [
    "0",
    "DIV",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "Not enough operands"
  ],
  [
    "2147483647 1",
    "DIV 2147483647 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "1 2147483647",
    "DIV 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483647 2147483647",
    "DIV 1 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 1",
    "DIV -2147483647 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-1 2147483647",
    "DIV 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 2147483647",
    "DIV -1 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483647 -1",
    "DIV -2147483647 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "1 -2147483647",
    "DIV 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483647 -2147483647",
    "DIV -1 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 -1",
    "DIV 2147483647 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-1 -2147483647",
    "DIV 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 -2147483647",
    "DIV 1 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483648 1",
    "DIV",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  [
    "1 2147483648",
    "DIV",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  [
    "-2147483648 1",
    "DIV",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  [
    "1 -2147483648",
    "DIV",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  ["MOD"],
  ["1 1", "MOD 0 EQUAL", "P2SH,STRICTENC", "OK"],
  ["-1 1", "MOD 0 EQUAL", "P2SH,STRICTENC", "OK"],
  ["1 -1", "MOD 0 EQUAL", "P2SH,STRICTENC", "OK"],
  ["-1 -1", "MOD 0 EQUAL", "P2SH,STRICTENC", "OK"],
  ["82 23", "MOD 13 EQUAL", "P2SH,STRICTENC", "OK"],
  ["8 -3", "MOD 2 EQUAL", "P2SH,STRICTENC", "OK"],
  ["-71 13", "MOD -6 EQUAL", "P2SH,STRICTENC", "OK"],
  ["-110 -31", "MOD -17 EQUAL", "P2SH,STRICTENC", "OK"],
  ["0 1", "MOD 0 EQUAL", "P2SH,STRICTENC", "OK"],
  ["1 0", "MOD", "P2SH,STRICTENC", "MOD_BY_ZERO", "MOD, modulo by zero"],
  ["1 1", "MOD DEPTH 1 EQUAL", "P2SH,STRICTENC", "OK", "Stack depth correct"],
  [
    "1",
    "MOD",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "Not enough operands"
  ],
  [
    "0",
    "MOD",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "Not enough operands"
  ],
  [
    "2147483647 123",
    "MOD 79 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "123 2147483647",
    "MOD 123 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483647 2147483647",
    "MOD 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 123",
    "MOD -79 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-123 2147483647",
    "MOD -123 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 2147483647",
    "MOD 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483647 -123",
    "MOD 79 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "123 -2147483647",
    "MOD 123 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483647 -2147483647",
    "MOD 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 -123",
    "MOD -79 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-123 -2147483647",
    "MOD -123 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "-2147483647 -2147483647",
    "MOD 0 EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "Check boundary condition"
  ],
  [
    "2147483648 1",
    "MOD",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  [
    "1 2147483648",
    "MOD",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  [
    "-2147483648 1",
    "MOD",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  [
    "1 -2147483648",
    "MOD",
    "P2SH,STRICTENC",
    "SCRIPTNUM_OVERFLOW",
    "We cannot do math on 5-byte integers"
  ],
  ["CAT"],
  ["", "CAT", "P2SH,STRICTENC", "INVALID_STACK_OPERATION", "CAT, empty stack"],
  [
    "'a'",
    "CAT",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "CAT, one parameter"
  ],
  ["'abcd' 'efgh'", "CAT 'abcdefgh' EQUAL", "P2SH,STRICTENC", "OK"],
  ["'' ''", "CAT '' EQUAL", "P2SH,STRICTENC", "OK", "CAT two empty strings"],
  [
    "'abc' ''",
    "CAT 'abc' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "CAT with empty string"
  ],
  [
    "'' 'def'",
    "CAT 'def' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "CAT with empty string"
  ],
  [
    "'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxh' 'ataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh'",
    "CAT 'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "CAT, maximum length"
  ],
  [
    "'' 'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh'",
    "CAT 'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "CAT, maximum length with empty string"
  ],
  [
    "'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh' ''",
    "CAT 'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "CAT, maximum length with empty string"
  ],
  ["SPLIT"],
  [
    "",
    "SPLIT",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "SPLIT, empty stack"
  ],
  [
    "'a'",
    "SPLIT",
    "P2SH,STRICTENC",
    "INVALID_STACK_OPERATION",
    "SPLIT, one parameter"
  ],
  ["'abcdef' 3", "SPLIT 'def' EQUALVERIFY 'abc' EQUAL", "P2SH,STRICTENC", "OK"],
  [
    "'' 0",
    "SPLIT '' EQUALVERIFY '' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "SPLIT, empty string"
  ],
  [
    "'abc' 0",
    "SPLIT 'abc' EQUALVERIFY '' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "SPLIT, boundary condition"
  ],
  [
    "'abc' 3",
    "SPLIT '' EQUALVERIFY 'abc' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "SPLIT, boundary condition"
  ],
  ["'abc' 4", "SPLIT", "P2SH,STRICTENC", "SPLIT_RANGE", "SPLIT, out of bounds"],
  [
    "'abc' -1",
    "SPLIT",
    "P2SH,STRICTENC",
    "SPLIT_RANGE",
    "SPLIT, out of bounds"
  ],
  [
    "'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh'",
    "145 SPLIT 'ataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh' EQUALVERIFY 'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxh' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "SPLIT, maximum length"
  ],
  [
    "'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh'",
    "0 SPLIT 'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh' EQUALVERIFY '' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "SPLIT, maximum length with empty string"
  ],
  [
    "'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh'",
    "520 SPLIT '' EQUALVERIFY 'zngyivniryrgefgnvqwfwqplmramujzilzyrsdvinxfkfmuowdpuzycnzbupwwpzrfxsbyrhdlsyixyzysodseayvvrtbsfxtikrjwkbduulrjyjlwlaigomhyohsukawdwbrpuacdijzzgxhataguajvuopuktvtklwhsxqvzzfttpdgnxtnbpsiqecxurlczqmoxznlsuejvneiyejetcxlblzrydscnrbydnqytorstjtuzlbbtbyzfiniuehbisqnqhvexylhohjiyiknzgjowvobsrwcxyfowqcvakgdolwpltfcxtrhuysrrvtprzpsucgogsjapdkrbobpxccqgkdumskaleycwsbkabdkuukqiyizceduplmauszwjdzptvmthxocwrignxjogxsvrsjrrlecvdmazlpfkgmskiqqitrevuwiisvpxvkeypzaqjwwiozvmahmtvtjpbolwrymvzfstopzcexalirwbbcqgjvfjfuirrcnlgcfyqnafhh' EQUAL",
    "P2SH,STRICTENC",
    "OK",
    "SPLIT, maximum length with empty string"
  ],
  ["The End"]
];
