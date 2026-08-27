import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../providers/app_store.dart';
import '../widgets/name_dialog.dart';
import '../widgets/stock_tile.dart';
import 'ticket_screen.dart';

class WatchlistsScreen extends StatelessWidget {
  const WatchlistsScreen({super.key, required this.store});

  final AppStore store;

  Future<void> _new(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (_) => NameDialog(
        controller: controller,
        title: 'New watchlist',
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      store.addWatchlist(name.trim());
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store.feed,
        builder: (_, __) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Trade',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                onPressed: () => _new(context),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Text(
                'Your market, your edge',
                style: TextStyle(color: Colors.blueGrey.shade200),
              ),
              const SizedBox(height: 16),
              for (final entry in store.watchlists.entries)
                WatchlistCard(
                  store: store,
                  name: entry.key,
                  symbols: entry.value,
                ),
            ],
          ),
        ),
      );
}

class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    super.key,
    required this.store,
    required this.name,
    required this.symbols,
  });

  final AppStore store;
  final String name;
  final List<String> symbols;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'delete') store.deleteWatchlist(name);
                      if (action == 'rename') {
                        final newName = await showDialog<String>(
                          context: context,
                          builder: (_) => NameDialog(
                            title: 'Rename watchlist',
                            initial: name,
                          ),
                        );
                        if (!context.mounted) return;
                        if (newName != null && newName.trim().isNotEmpty) {
                          store.renameWatchlist(name, newName.trim());
                        }
                      }
                      if (action == 'add') {
                        _pick(context);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'add', child: Text('Add stocks')),
                      PopupMenuItem(value: 'rename', child: Text('Rename')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              const Divider(height: 18),
              if (symbols.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No stocks yet. Add symbols to start tracking.'),
                )
              else
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorderItem: (oldIndex, newIndex) {
                    final updated = [...symbols]
                      ..insert(newIndex, symbols.removeAt(oldIndex));
                    store.updateList(name, updated);
                  },
                  children: [
                    for (final symbol in symbols)
                      Dismissible(
                        key: ValueKey(symbol),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 18),
                          color: const Color(0xffef5b67),
                          child: const Icon(Icons.delete_outline),
                        ),
                        onDismissed: (_) => store.updateList(
                            name, [...symbols]..remove(symbol)),
                        child: StockTile(
                          symbol: symbol,
                          price: store.feed.price(symbol),
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
                      ),
                  ],
                ),
            ],
          ),
        ),
      );

  Future<void> _pick(BuildContext context) async {
    final selected = <String>{...symbols};
    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, set) => AlertDialog(
          title: Text('Add to $name'),
          content: SizedBox(
            width: 340,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final symbol in stocks)
                  CheckboxListTile(
                    value: selected.contains(symbol),
                    title: Text(symbol),
                    onChanged: (value) => set(
                      () => value!
                          ? selected.add(symbol)
                          : selected.remove(symbol),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                store.updateList(name, selected.toList());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
