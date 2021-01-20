extension MyList<T> on List<T> {
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
}
