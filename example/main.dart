import 'package:bsv/src/address.dart';
import 'package:bsv/src/priv_key.dart';
import 'package:bsv/src/pub_key.dart';

void main() {
  var privKey = PrivKey.fromRandom();
  var pubKey = new PubKey().fromPrivKey(privKey);
  var address = new Address().fromPrivKey(privKey);
  print(privKey.toString());
  print(pubKey.toString());
  print(address.toString());
}
