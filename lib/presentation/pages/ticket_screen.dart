import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../providers/app_store.dart';
import 'confirmation_screen.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.store, required this.symbol});

  final AppStore store;
  final String symbol;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late String symbol;
  String side = 'BUY';
  final quantity = TextEditingController(text: '1');
  String? error;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    symbol = widget.symbol;
    widget.store.feed.addListener(_update);
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.store.feed.removeListener(_update);
    quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.store.feed.price(symbol);
    final qty = int.tryParse(quantity.text) ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Place order')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            initialValue: symbol,
            decoration: const InputDecoration(
              labelText: 'Instrument',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final stock in stocks)
                DropdownMenuItem(value: stock, child: Text(stock)),
            ],
            onChanged: (value) => setState(() => symbol = value!),
          ),
          const SizedBox(height: 22),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'BUY', label: Text('BUY')),
              ButtonSegment(value: 'SELL', label: Text('SELL')),
            ],
            selected: {side},
            onSelectionChanged: (value) => setState(() {
              side = value.first;
              error = null;
            }),
          ),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Market price'),
                  Text(
                    money(price.ltp),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: quantity,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Quantity',
              suffixText: 'shares',
              border: const OutlineInputBorder(),
              errorText: error,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated order value',
                style: TextStyle(color: Colors.blueGrey.shade200),
              ),
              Text(
                money(price.ltp * qty),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (side == 'BUY')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Available balance ${money(widget.store.wallet)}',
                style: TextStyle(
                  color: Colors.blueGrey.shade300,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: submitting ? null : _submit,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text('$side ${symbol.toUpperCase()}'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final parsed = int.tryParse(quantity.text);
    if (parsed == null || parsed <= 0 || quantity.text.contains('.')) {
      setState(() => error = 'Enter a positive whole number.');
      return;
    }
    setState(() => submitting = true);
    final result = await widget.store.execute(symbol, side, parsed);
    if (!mounted) return;
    if (result != null) {
      setState(() {
        error = result;
        submitting = false;
      });
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          symbol: symbol,
          side: side,
          quantity: parsed,
        ),
      ),
    );
  }
}
