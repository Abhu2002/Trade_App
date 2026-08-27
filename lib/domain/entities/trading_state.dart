import 'holding.dart';
import 'trade_order.dart';

class TradingState {
  TradingState({
    required this.wallet,
    required this.holdings,
    required this.orders,
    required this.watchlists,
  });

  final double wallet;
  final Map<String, Holding> holdings;
  final List<TradeOrder> orders;
  final Map<String, List<String>> watchlists;
}
