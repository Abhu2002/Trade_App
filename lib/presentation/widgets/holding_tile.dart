import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../data/datasources/market_feed.dart';
import '../../domain/entities/holding.dart';

class HoldingTile extends StatelessWidget {
  const HoldingTile({
    super.key,
    required this.holding,
    required this.feed,
    required this.onTap,
  });

  final Holding holding;
  final MarketFeed feed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final price = feed.price(holding.symbol);
    final pnl = (price.ltp - holding.averageCost) * holding.quantity;
    final pnlPct = holding.averageCost == 0
        ? 0.0
        : (price.ltp - holding.averageCost) / holding.averageCost * 100;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    holding.symbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${money(pnl)} (${pnlPct.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      color: movementColor(pnl),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${holding.quantity} shares  •  Avg ${money(holding.averageCost)}',
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'LTP ${money(price.ltp)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
