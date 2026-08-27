import 'package:flutter/material.dart';

import 'data/datasources/market_feed.dart';
import 'presentation/providers/app_store.dart';
import 'presentation/trade_app.dart';

export 'core/constants/app_constants.dart';
export 'core/utils/formatters.dart';
export 'data/datasources/market_feed.dart';
export 'domain/entities/holding.dart';
export 'domain/entities/price.dart';
export 'domain/entities/trade_order.dart';
export 'presentation/pages/confirmation_screen.dart';
export 'presentation/pages/holdings_screen.dart';
export 'presentation/pages/market_screen.dart';
export 'presentation/pages/ticket_screen.dart';
export 'presentation/pages/watchlists_screen.dart';
export 'presentation/providers/app_store.dart';
export 'presentation/trade_app.dart';

void main() {
  final feed = MarketFeed();
  final store = AppStore(feed);
  runApp(TradeApp(store: store, feed: feed));
}
