class Constants {
  // ignore: non_constant_identifier_names
  static NetworkConstants Mainnet = MainnetConstants();

  // ignore: non_constant_identifier_names
  static NetworkConstants Testnet = TestnetConstants();

  // ignore: non_constant_identifier_names
  static NetworkConstants Regtest = RegtestConstants();

  // ignore: non_constant_identifier_names
  static NetworkConstants STN = STNConstants();
}

abstract class NetworkConstants {
  // base net is mainnet
  int maxSize = 0x02000000;
  int port = 8333;

  int addressPubKeyHash = 0x00;
  int addressPayToScriptHash = 0x05;

  int bip32PubKey = 0x0488b21e;
  int bip32PrivKey = 0x0488ade4;

  int blockMaxNBits = 0x1d00ffff;
  int blockMagicNum = 0xe3e1f3e8;

  int msgMagicNum = 0xe3e1f3e8;
  // as of Bitcoin SV v1.0.5
  int msgVersionBytesNum = 70015;

  int privKeyVersionByteNum = 0x80;

  // number of satoshis that an output can't be less than
  int txBuilderDust = 546;
  double txBuilderFeePerKbNum = 0.00000500e8;
}

class MainnetConstants extends NetworkConstants {}

class TestnetConstants extends NetworkConstants {
  int maxSize = 0x02000000;
  int port = 18333;

  int addressPubKeyHash = 0x6f;
  int addressPayToScriptHash = 0xc4;

  int bip32PubKey = 0x043587cf;
  int bip32PrivKey = 0x04358394;

  int blockMaxNBits = 0x1d00ffff;
  int blockMagicNum = 0xf4e5f3f4;

  int msgMagicNum = 0xf4e5f3f4;
  // as of Bitcoin SV v1.0.5
  int msgVersionBytesNum = 70015;

  int privKeyVersionByteNum = 0xef;

  // number of satoshis that an output can't be less than
  int txBuilderDust = 546;
  double txBuilderFeePerKbNum = 0.00000500e8;
}

class RegtestConstants extends NetworkConstants {
  int maxSize = 0x02000000;
  int port = 18444;

  int addressPubKeyHash = 0x6f;
  int addressPayToScriptHash = 0xc4;

  int bip32PubKey = 0x043587cf;
  int bip32PrivKey = 0x04358394;

  int blockMaxNBits = 0x207fffff;
  int blockMagicNum = 0xdab5bffa;

  int msgMagicNum = 0xdab5bffa;
  int msgVersionBytesNum = 70015;

  int privKeyVersionByteNum = 0xef;

  int txBuilderDust = 546;
  double txBuilderFeePerKbNum = 0.00000500e8;
}

class STNConstants extends NetworkConstants {
  int maxSize = 0x02000000;
  int port = 9333;

  int addressPubKeyHash = 0x6f;
  int addressPayToScriptHash = 0xc4;

  int bip32PubKey = 0x043587cf;
  int bip32PrivKey = 0x04358394;

  int blockMaxNBits = 0x1d00ffff;
  int blockMagicNum = 0xfbcec4f9;

  int msgMagicNum = 0xfbcec4f9;
  int msgVersionBytesNum = 70015;

  int privKeyVersionByteNum = 0xef;

  int txBuilderDust = 546;
  double txBuilderFeePerKbNum = 0.00000500e8;
}

enum NetworkType { Mainnet, Testnet, Regtest, STN }

class Globals {
  static NetworkConstants network = MainnetConstants();

  static void setNetworkType(NetworkType networkType) {
    switch (networkType) {
      case NetworkType.Mainnet:
        Globals.network = MainnetConstants();
        break;
      case NetworkType.Testnet:
        Globals.network = TestnetConstants();
        break;
      case NetworkType.Regtest:
        Globals.network = RegtestConstants();
        break;
      case NetworkType.STN:
        Globals.network = STNConstants();
        break;
      default:
        Globals.network = MainnetConstants();
    }
  }
}
