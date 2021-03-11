import 'package:flutter/services.dart';

// ignore: slash_for_doc_comments
/**
 * Bitcoin Address
 * ===============
 *
 * A bitcoin address. Normal use cases:
 * var address = new Address().fromPubKey(pubKey)
 * var address = new Address().fromString(string)
 * var string = address.toString()
 * var script = address.toTxOutScript()
 * var isValid = Address.isValid(string)
 *
 * Can also do testnet:
 * var address = Address.Testnet()
 *
 * Note that an Address and an Addr are two completely different things. An
 * Address is what you send bitcoin to. An Addr is an ip address and port that
 * you connect to over the internet.
 */

class Address {
  int pubKeyHash;
  int versionByteNum;

  static const INVALID_ADDRESS_LENGTH =
      'address buffers must be exactly 21 bytes';

  static const INVALID_ADDRESS_VERSION_BYTE_NUM_BYTE =
      'address: invalid versionByteNum byte';

  static const INVALID_ADDRESS_HASH_BUF =
      'hashBuf must be a buffer of 20 bytes';

  static const INVALID_ADDRESS_VERSION_BYTE_NUM = 'invalid versionByteNum';

  // ignore: non_constant_identifier_names
  // factory PrivKey.Testnet({BigIntX bn, bool compressed}) {
  //   return PrivKey(
  //     bn: bn,
  //     compressed: compressed,
  //     privKeyVersionByteNum: Constants.Testnet.privKeyVersionByteNum,
  //   );
  // }

  // // ignore: non_constant_identifier_names
  // factory PrivKey.Mainnet({BigIntX bn, bool compressed}) {
  //   return PrivKey(
  //     bn: bn,
  //     compressed: compressed,
  //     privKeyVersionByteNum: Constants.Mainnet.privKeyVersionByteNum,
  //   );
  // }

  Address() {
    // var writer = ByteDataWriter();
  }
}
