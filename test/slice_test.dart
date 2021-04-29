import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';

void main() {
  test('adds one to input values', () {
    var list = List.generate(10, (index) => index);

    print(list.slice(2));
    print(list.slice(2, 4));
    print(list.slice(9, 10));
    print(list.slice(11));

    expect(list.slice(11).length, 0);
  });
}
