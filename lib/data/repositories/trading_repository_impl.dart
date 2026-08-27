import 'dart:convert';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/holding.dart';
import '../../domain/entities/trade_order.dart';
import '../../domain/entities/trading_state.dart';
import '../../domain/repositories/trading_repository.dart';
import '../datasources/local_storage_datasource.dart';

class TradingRepositoryImpl implements TradingRepository {
  TradingRepositoryImpl(this._storage);

  final LocalStorageDataSource _storage;

  @override
  Future<TradingState> load() async {
    var wallet = initialWallet;
    final watchlists = <String, List<String>>{
      for (final entry in initialWatchlists.entries)
        entry.key: List<String>.from(entry.value),
    };
    final holdings = <String, Holding>{};
    final orders = <TradeOrder>[];

    wallet = await _storage.getDouble('wallet') ?? wallet;

    final savedLists = await _storage.getString('watchlists');
    if (savedLists != null) {
      watchlists
        ..clear()
        ..addAll(
          (jsonDecode(savedLists) as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ),
        );
    }

    final savedHoldings = await _storage.getString('holdings');
    if (savedHoldings != null) {
      for (final item in jsonDecode(savedHoldings) as List) {
        final holding =
            Holding.fromJson(Map<String, dynamic>.from(item as Map));
        holdings[holding.symbol] = holding;
      }
    }

    final savedOrders = await _storage.getString('orders');
    if (savedOrders != null) {
      for (final item in jsonDecode(savedOrders) as List) {
        orders.add(
          TradeOrder.fromJson(Map<String, dynamic>.from(item as Map)),
        );
      }
    }

    return TradingState(
      wallet: wallet,
      holdings: holdings,
      orders: orders,
      watchlists: watchlists,
    );
  }

  @override
  Future<void> save(TradingState state) async {
    await Future.wait([
      _storage.setDouble('wallet', state.wallet),
      _storage.setString('watchlists', jsonEncode(state.watchlists)),
      _storage.setString(
        'holdings',
        jsonEncode(
            state.holdings.values.map((holding) => holding.toJson()).toList()),
      ),
      _storage.setString(
        'orders',
        jsonEncode(state.orders.map((order) => order.toJson()).toList()),
      ),
    ]);
  }
}
