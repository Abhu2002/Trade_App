import 'package:flutter/material.dart';

class Metric extends StatelessWidget {
  const Metric({
    super.key,
    required this.label,
    required this.value,
    required this.change,
  });

  final String label;
  final String value;
  final String change;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 12),
              ),
              const SizedBox(height: 7),
              Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                change,
                style: const TextStyle(
                  color: Color(0xff16b364),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}
