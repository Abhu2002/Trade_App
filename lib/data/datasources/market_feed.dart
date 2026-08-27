import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/price.dart';

class MarketFeed extends ChangeNotifier {
  MarketFeed() {
    _prices = {
      for (final symbol in stocks)
        symbol: Price(initialPrices[symbol]!, initialPrices[symbol]!),
    };
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _tick(),
    );
  }

  late Map<String, Price> _prices;
  late Timer _timer;
  final _random = Random();

  Map<String, Price> get prices => _prices;
  Price price(String symbol) => _prices[symbol]!;

  void _tick() {
    final next = Map<String, Price>.from(_prices);
    for (final symbol in stocks) {
      final old = _prices[symbol]!;
      final movement = old.ltp * ((_random.nextDouble() - .49) * .0008);
      next[symbol] = Price(max(1, old.ltp + movement), old.ltp);
    }
    _prices = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
