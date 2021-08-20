extension StatusCode on int {
  bool isValid() => toString().startsWith("2");
}
