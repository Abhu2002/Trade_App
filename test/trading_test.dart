import 'package:flutter_test/flutter_test.dart';
import 'package:trade/main.dart';

void main() {
  test('buy uses the shared feed price and creates a holding', () async {
    final feed = MarketFeed();
    final store = AppStore(feed);

    final result = await store.execute('TCS', 'BUY', 2);

    expect(result, isNull);
    expect(store.holdings['TCS']!.quantity, 2);
    expect(store.holdings['TCS']!.averageCost, feed.price('TCS').ltp);
    expect(store.wallet,
        closeTo(initialWallet - feed.price('TCS').ltp * 2, 0.001));
    feed.dispose();
  });

  test('sell rejects quantities above the current holding', () async {
    final feed = MarketFeed();
    final store = AppStore(feed);
    await store.execute('INFY', 'BUY', 1);

    expect(await store.execute('INFY', 'SELL', 2),
        'You do not hold enough shares.');
    expect(store.holdings['INFY']!.quantity, 1);
    feed.dispose();
  });

  test('feed prices are shared by symbol rather than list position', () {
    final feed = MarketFeed();
    expect(feed.price('RELIANCE').ltp, initialPrices['RELIANCE']);
    expect(feed.price('TCS').ltp, initialPrices['TCS']);
    feed.dispose();
  });
}
