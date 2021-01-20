class Constants {
  static MainnetConstants mainnet = MainnetConstants();

  static TestnetConstants testnet = TestnetConstants();

  static RegtestConstants regtest = RegtestConstants();

  static STNConstants stn = STNConstants();
}

class MainnetConstants {
  // MAX_SIZE
  static const int MaxSize = 0x02000000;
  static const int Port = 8333;

  static const int AddressPubKeyHash = 0x00;
  static const int AddressPayToScriptHash = 0x05;

  static const int Bip32PubKey = 0x0488b21e;
  static const int Bip32PrivKey = 0x0488ade4;

  static const int BlockMaxNBits = 0x1d00ffff;
  static const int BlockMagicNum = 0xe3e1f3e8;

  static const int MsgMagicNum = 0xe3e1f3e8;
  // as of Bitcoin SV v1.0.5
  static const int MsgVersionBytesNum = 70015;

  static const int PrivKeyVersionByteNum = 0x80;

  // number of satoshis that an output can't be less than
  static const int TxBuilderDust = 546;
  static const double TxBuilderFeePerKbNum = 0.00000500e8;
}

class TestnetConstants {
  // MAX_SIZE
  static const int MaxSize = 0x02000000;
  static const int Port = 18333;

  static const int AddressPubKeyHash = 0x6f;
  static const int AddressPayToScriptHash = 0xc4;

  static const int Bip32PubKey = 0x043587cf;
  static const int Bip32PrivKey = 0x04358394;

  static const int BlockMaxNBits = 0x1d00ffff;
  static const int BlockMagicNum = 0xf4e5f3f4;

  static const int MsgMagicNum = 0xf4e5f3f4;
  // as of Bitcoin SV v1.0.5
  static const int MsgVersionBytesNum = 70015;

  static const int PrivKeyVersionByteNum = 0xef;

  // number of satoshis that an output can't be less than
  static const int TxBuilderDust = 546;
  static const double TxBuilderFeePerKbNum = 0.00000500e8;
}

class RegtestConstants {
  // MAX_SIZE
  static const int MaxSize = 0x02000000;
  static const int Port = 18444;

  static const int AddressPubKeyHash = 0x6f;
  static const int AddressPayToScriptHash = 0xc4;

  static const int Bip32PubKey = 0x043587cf;
  static const int Bip32PrivKey = 0x04358394;

  static const int BlockMaxNBits = 0x207fffff;
  static const int BlockMagicNum = 0xdab5bffa;

  static const int MsgMagicNum = 0xdab5bffa;
  // as of Bitcoin SV v1.0.5
  static const int MsgVersionBytesNum = 70015;

  static const int PrivKeyVersionByteNum = 0xef;

  // number of satoshis that an output can't be less than
  static const int TxBuilderDust = 546;
  static const double TxBuilderFeePerKbNum = 0.00000500e8;
}

class STNConstants {
  // MAX_SIZE
  static const int MaxSize = 0x02000000;
  static const int Port = 9333;

  static const int AddressPubKeyHash = 0x6f;
  static const int AddressPayToScriptHash = 0xc4;

  static const int Bip32PubKey = 0x043587cf;
  static const int Bip32PrivKey = 0x04358394;

  static const int BlockMaxNBits = 0x1d00ffff;
  static const int BlockMagicNum = 0xfbcec4f9;

  static const int MsgMagicNum = 0xfbcec4f9;
  // as of Bitcoin SV v1.0.5
  static const int MsgVersionBytesNum = 70015;

  static const int PrivKeyVersionByteNum = 0xef;

  // number of satoshis that an output can't be less than
  static const int TxBuilderDust = 546;
  static const double TxBuilderFeePerKbNum = 0.00000500e8;
}
