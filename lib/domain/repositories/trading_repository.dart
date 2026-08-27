import '../entities/trading_state.dart';

abstract interface class TradingRepository {
  Future<TradingState> load();
  Future<void> save(TradingState state);
}
