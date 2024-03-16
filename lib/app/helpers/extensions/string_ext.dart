extension StringExt on String {
  bool get toBoolean {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    } else {
      throw FormatException("'$this' is not a valid boolean value");
    }
  }
}
