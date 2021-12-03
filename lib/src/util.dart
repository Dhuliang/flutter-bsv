class Util {
  static bool checkToBool(dynamic result) {
    if (result is String) {
      return result.isNotEmpty;
    }

    if (result is bool) {
      return result;
    }

    if (result is int) {
      return result != 0;
    }

    throw 'not implemented';
  }
}
