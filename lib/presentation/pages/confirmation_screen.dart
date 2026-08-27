import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({
    super.key,
    required this.symbol,
    required this.side,
    required this.quantity,
  });

  final String symbol;
  final String side;
  final int quantity;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xff16b364),
                  size: 76,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Order placed',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  '$side $quantity shares of $symbol',
                  style: TextStyle(color: Colors.blueGrey.shade200),
                ),
                const SizedBox(height: 30),
                FilledButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('Back to portfolio'),
                ),
              ],
            ),
          ),
        ),
      );
}
