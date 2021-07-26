import 'package:flutter_test/flutter_test.dart';
import 'package:bsv/extentsions/list.dart';
import 'package:bsv/extentsions/string.dart';

void main() {
  test('list slice', () {
    var list = List.generate(10, (index) => index);

    print(list.slice(2));
    print(list.slice(2, 4));
    print(list.slice(9, 10));
    print(list.slice(11));

    expect(list.slice(11).length, 0);

    expect(list.slice(-1), [9]);
  });

  test("string slice", () {
    const str = 'The quick brown fox jumps over the lazy dog.';

    expect(str.slice(31), "the lazy dog.");
    // expected output: "the lazy dog."

    expect(str.slice(4, 19), "quick brown fox");
    // expected output: "quick brown fox"

    expect(str.slice(-4), "dog.");
    // expected output: "dog."

    expect(str.slice(-9, -5), "lazy");
    // expected output: "lazy"
  });
}
