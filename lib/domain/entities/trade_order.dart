class TradeOrder {
  TradeOrder({
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.time,
  });

  final String symbol;
  final String side;
  final int quantity;
  final double price;
  final DateTime time;

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'side': side,
        'quantity': quantity,
        'price': price,
        'time': time.toIso8601String(),
      };

  factory TradeOrder.fromJson(Map<String, dynamic> json) => TradeOrder(
        symbol: json['symbol'] as String,
        side: json['side'] as String,
        quantity: json['quantity'] as int,
        price: (json['price'] as num).toDouble(),
        time: DateTime.parse(json['time'] as String),
      );
}
