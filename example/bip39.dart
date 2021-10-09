import 'package:bsv/src/bip39.dart';

void main() {
  var mnemonic =
      "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about";
  var bip39 = Bip39.fromString(mnemonic);
  print(bip39.mnemonic);

  print(Bip39.fromRandom(32 * 8));

  print(Bip39.fromRandom());
}
