import 'package:bsv/src/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("constant", () {
    test("verify constant", () {
      expect(Globals.network is MainnetConstants, true);

      Globals.setNetworkType(NetworkType.Regtest);

      expect(Globals.network is RegtestConstants, true);
    });
  });
}
