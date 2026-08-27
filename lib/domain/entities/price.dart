class Price {
  Price(this.ltp, this.previous);

  final double ltp;
  final double previous;

  double get change => ltp - previous;
  double get changePct => previous == 0 ? 0 : change / previous * 100;
}
