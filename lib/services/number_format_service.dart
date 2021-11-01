String getRidOfZero(String value) {
  if (value.contains('.0')) {
    return value.substring(0, value.indexOf('.'));
  }
  return value;
}