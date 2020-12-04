import 'dart:typed_data';

class CommonUtil {
  static String list2hex(List<int> list) {
    return list.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }

  static Uint8List combine2list(Uint8List list1, Uint8List list2) {
    var pairs = [list1, list2];
    var flattened = pairs.expand((element) => element).toList();
    return Uint8List.fromList(flattened);
  }
}
