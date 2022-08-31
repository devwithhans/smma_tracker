class Ticker {
  const Ticker();
  Stream<int> tick(int start) {
    return Stream.periodic(Duration(seconds: 1), (x) => x + 1 + start);
  }
}
