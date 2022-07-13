extension StatusCode on int {
  bool isValid() => toString().startsWith("2");
  bool notFound() => toString().contains("404") || toString().contains("410");
}
