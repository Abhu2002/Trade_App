class Holding {
  Holding({
    required this.symbol,
    required this.quantity,
    required this.averageCost,
  });

  final String symbol;
  int quantity;
  double averageCost;

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'quantity': quantity,
        'averageCost': averageCost,
      };

  factory Holding.fromJson(Map<String, dynamic> json) => Holding(
        symbol: json['symbol'] as String,
        quantity: json['quantity'] as int,
        averageCost: (json['averageCost'] as num).toDouble(),
      );
}
