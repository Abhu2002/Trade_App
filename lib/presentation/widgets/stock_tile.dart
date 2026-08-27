import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/price.dart';

class StockTile extends StatelessWidget {
  const StockTile({
    super.key,
    required this.symbol,
    required this.price,
    this.onTap,
  });

  final String symbol;
  final Price price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: const Color(0xff273452),
                  child: Text(
                    symbol.substring(0, 1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'NSE • Equity',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blueGrey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        money(price.ltp),
                        key: ValueKey(price.ltp),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${price.change >= 0 ? '+' : ''}${price.change.toStringAsFixed(2)}  ${price.changePct.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: movementColor(price.change),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
