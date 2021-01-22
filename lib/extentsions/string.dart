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
}
