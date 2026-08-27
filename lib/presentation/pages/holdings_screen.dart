import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../data/datasources/market_feed.dart';
import '../providers/app_store.dart';
import '../widgets/header.dart';
import '../widgets/holding_tile.dart';
import '../widgets/summary.dart';
import 'ticket_screen.dart';

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key, required this.store, required this.feed});

  final AppStore store;
  final MarketFeed feed;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge([store, feed]),
        builder: (_, __) {
          final values = store.holdings.values.toList()
            ..sort(
              (a, b) =>
                  ((feed.price(b.symbol).ltp - b.averageCost) * b.quantity)
                      .compareTo(
                (feed.price(a.symbol).ltp - a.averageCost) * a.quantity,
              ),
            );
          final invested = store.holdings.values.fold<double>(
            0,
            (value, holding) => value + holding.averageCost * holding.quantity,
          );
          final current = store.holdings.values.fold<double>(
            0,
            (value, holding) =>
                value + feed.price(holding.symbol).ltp * holding.quantity,
          );
          final pnl = current - invested;
          final pnlPct = invested == 0 ? 0.0 : pnl / invested * 100;
          return Scaffold(
            body: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const Header('Portfolio',
                    subtitle: 'Your holdings at a glance'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current value',
                            style: TextStyle(color: Colors.blueGrey.shade200),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            compactMoney(current),
                            style: const TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Summary('Invested', invested),
                              Summary(
                                'P&L',
                                pnl,
                                suffix: ' (${pnlPct.toStringAsFixed(2)}%)',
                                color: movementColor(pnl),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                if (values.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(35),
                    child: Center(
                      child: Text(
                        'No holdings yet\nPlace an order to build your portfolio',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (final holding in values)
                          HoldingTile(
                            holding: holding,
                            feed: feed,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TicketScreen(
                                  store: store,
                                  symbol: holding.symbol,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
}
