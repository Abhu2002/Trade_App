import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../data/datasources/market_feed.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../data/repositories/trading_repository_impl.dart';
import '../../domain/entities/holding.dart';
import '../../domain/entities/trade_order.dart';
import '../../domain/entities/trading_state.dart';
import '../../domain/repositories/trading_repository.dart';

class AppStore extends ChangeNotifier {
  AppStore(
    this.feed, {
    TradingRepository? repository,
  }) : _repository =
            repository ?? TradingRepositoryImpl(LocalStorageDataSource());

  final MarketFeed feed;
  final TradingRepository _repository;

  double wallet = initialWallet;
  final holdings = <String, Holding>{};
  final orders = <TradeOrder>[];
  final watchlists = <String, List<String>>{
    for (final entry in initialWatchlists.entries)
      entry.key: List<String>.from(entry.value),
  };
  bool _persistenceReady = false;

  Future<void> load() async {
    final state = await _repository.load();
    wallet = state.wallet;
    watchlists
      ..clear()
      ..addAll(state.watchlists);
    holdings
      ..clear()
      ..addAll(state.holdings);
    orders
      ..clear()
      ..addAll(state.orders);
    _persistenceReady = true;
    notifyListeners();
  }

  Future<void> _save() async {
    if (!_persistenceReady) return;
    await _repository.save(
      TradingState(
        wallet: wallet,
        holdings: holdings,
        orders: orders,
        watchlists: watchlists,
      ),
    );
  }

  Future<String?> execute(String symbol, String side, int quantity) async {
    final executionPrice = feed.price(symbol).ltp;
    final value = executionPrice * quantity;
    if (quantity <= 0) return 'Quantity must be a positive whole number.';
    final existing = holdings[symbol];
    if (side == 'BUY' && value > wallet) {
      return 'Insufficient wallet balance.';
    }
    if (side == 'SELL' && (existing == null || quantity > existing.quantity)) {
      return 'You do not hold enough shares.';
    }
    if (side == 'BUY') {
      wallet -= value;
      if (existing == null) {
        holdings[symbol] = Holding(
          symbol: symbol,
          quantity: quantity,
          averageCost: executionPrice,
        );
      } else {
        final total = existing.averageCost * existing.quantity + value;
        existing.quantity += quantity;
        existing.averageCost = total / existing.quantity;
      }
    } else {
      wallet += value;
      existing!.quantity -= quantity;
      if (existing.quantity == 0) holdings.remove(symbol);
    }
    orders.insert(
      0,
      TradeOrder(
        symbol: symbol,
        side: side,
        quantity: quantity,
        price: executionPrice,
        time: DateTime.now(),
      ),
    );
    await _save();
    notifyListeners();
    return null;
  }

  Future<void> addWatchlist(String name) async {
    watchlists[name] = [];
    await _save();
    notifyListeners();
  }

  Future<void> renameWatchlist(String oldName, String name) async {
    final items = watchlists.remove(oldName)!;
    watchlists[name] = items;
    await _save();
    notifyListeners();
  }

  Future<void> deleteWatchlist(String name) async {
    watchlists.remove(name);
    await _save();
    notifyListeners();
  }

  Future<void> updateList(String name, List<String> values) async {
    watchlists[name] = values;
    await _save();
    notifyListeners();
  }
}
