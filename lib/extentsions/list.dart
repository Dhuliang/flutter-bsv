import 'dart:math';

extension ListX<T> on List<T> {
  int get doubleLength => length * 2;
  List<T> operator -() => reversed.toList();
  List<List<T>> split(int at) => <List<T>>[sublist(0, at), sublist(at)];

  String intList2hex() {
    return (this as List<int>)
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static List<dynamic> combine2list(List list1, List list2) {
    var pairs = [list1, list2];
    var flattened = pairs.expand((element) => element).toList();

    return List.from(flattened);
  }

  String toHex() {
    return (this as List<int>)
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  List<T> slice(int begin, [int end]) {
    var i, cloned = <T>[], size, len = this.length;

    var start = begin ?? 0;
    end = end ?? len;

    var upTo = end != null ? min(end, len) : len;

    if (end < 0) {
      upTo = len + end;
    }

    size = upTo - start;

    if (size > 0) {
      cloned = List<T>(size);
      for (i = 0; i < size; i++) {
        cloned[i] = this[start + i];
      }
    }

    return cloned;
  }
}
