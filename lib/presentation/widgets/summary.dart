import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';

class Summary extends StatelessWidget {
  const Summary(
    this.label,
    this.value, {
    super.key,
    this.suffix = '',
    this.color,
  });

  final String label;
  final double value;
  final String suffix;
  final Color? color;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 12),
          ),
          Text(
            '${money(value)}$suffix',
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
        ],
      );
}
