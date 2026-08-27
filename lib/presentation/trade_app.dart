import 'package:flutter/material.dart';

import '../data/datasources/market_feed.dart';
import 'pages/holdings_screen.dart';
import 'pages/market_screen.dart';
import 'pages/watchlists_screen.dart';
import 'providers/app_store.dart';

class TradeApp extends StatefulWidget {
  const TradeApp({super.key, required this.store, required this.feed});

  final AppStore store;
  final MarketFeed feed;

  @override
  State<TradeApp> createState() => _TradeAppState();
}

class _TradeAppState extends State<TradeApp> {
  int tab = 0;

  @override
  void initState() {
    super.initState();
    widget.store.load();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.store,
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xff0b111b),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff6675f7),
              brightness: Brightness.dark,
            ),
            cardTheme: const CardThemeData(
              color: Color(0xff121b29),
              margin: EdgeInsets.zero,
            ),
          ),
          home: Scaffold(
            body: IndexedStack(
              index: tab,
              children: [
                WatchlistsScreen(store: widget.store),
                MarketScreen(store: widget.store, feed: widget.feed),
                HoldingsScreen(store: widget.store, feed: widget.feed),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: tab,
              onDestinationSelected: (value) => setState(() => tab = value),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.bookmark_border),
                  selectedIcon: Icon(Icons.bookmark),
                  label: 'Watchlists',
                ),
                NavigationDestination(
                  icon: Icon(Icons.show_chart),
                  label: 'Markets',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Portfolio',
                ),
              ],
            ),
          ),
        ),
      );
}
