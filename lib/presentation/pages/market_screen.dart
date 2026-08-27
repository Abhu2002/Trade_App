import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/datasources/market_feed.dart';
import '../providers/app_store.dart';
import '../widgets/header.dart';
import '../widgets/metric.dart';
import '../widgets/stock_tile.dart';
import 'ticket_screen.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key, required this.store, required this.feed});

  final AppStore store;
  final MarketFeed feed;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: feed,
        builder: (_, __) => Scaffold(
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const Header('Markets', subtitle: 'Live prices • NSE'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Metric(
                        label: 'NIFTY 50',
                        value: '24,862.10',
                        change: '+0.42%',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Metric(
                        label: 'SENSEX',
                        value: '81,983.46',
                        change: '+0.35%',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'All instruments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (final symbol in stocks)
                      StockTile(
                        symbol: symbol,
                        price: feed.price(symbol),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketScreen(
                              store: store,
                              symbol: symbol,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
