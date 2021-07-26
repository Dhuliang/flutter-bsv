import 'package:convert/convert.dart';

extension StringX on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }

  String padLeft0() {
    return this.length.isEven ? this : this.padLeft(this.length + 1, '0');
  }

  List<int> toBuffer() {
    return hex.decode(this);
  }

  String slice(int start, [int end]) {
    var s = this;
    var sLen = s.length;
    var startI = start;
    var endI = sLen;

    if (end != null) {
      endI = end;
    }
    if (startI < 0) {
      startI += sLen;
      if (startI < 0) {
        startI = 0;
      }
    } else {
      if (startI > sLen) {
        return '';
      }
    }
    if (endI < 0) {
      endI += sLen;
      if (endI < 0) {
        return '';
      }
    } else {
      if (endI > sLen) {
        endI = sLen;
      }
    }
    if (endI <= startI) {
      return '';
    }
    return this.substring(startI, endI);
  }
}
