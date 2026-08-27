# Trade App

A complete Flutter stock-trading application built as a realistic, local-only
trading demo. It uses a configurable mock market feed instead of a real
brokerage backend.

## Requirements

- Flutter stable channel
- Dart 3.0 or later
- Android Studio/emulator, Xcode/iOS simulator, or another supported Flutter
  device

## Run the app

From the `Trade_App` directory:

```bash
flutter pub get
flutter run
```

To run on a specific Android emulator:

```bash
flutter run -d emulator-5554
```

The project includes Android, iOS, web, macOS, Linux, and Windows platform
targets. No backend, API key, brokerage account, or additional setup is
required.

## Features

### Watchlists

- Create multiple watchlists.
- Rename and delete watchlists.
- Add any of the ten supported NSE symbols through a picker.
- Reorder symbols with drag-and-drop.
- Swipe a symbol left to remove it.
- Persist watchlists and their order across restarts.
- Tap a symbol to open a pre-filled buy/sell ticket.
- Empty watchlists display a dedicated empty state.

### Live market overview

- Displays all ten supported stocks.
- Shows symbol, LTP, absolute change, and percentage change.
- Prices update continuously while navigating between screens.
- Price updates use green for upward movement and red for downward movement.
- A subtle animated switcher provides visual feedback when an LTP changes.

### Buy and sell orders

- Select a stock and Buy or Sell side.
- Quantity must be a positive whole number.
- LTP and projected order value update live.
- Orders execute using the feed price at submission time.
- Buy orders are blocked when the wallet balance is insufficient.
- Sell orders are blocked when the requested quantity exceeds holdings.
- Successful orders navigate to an order confirmation screen.

### Portfolio and holdings

- Shows invested value, current value, total P&L, and total P&L percentage.
- Each holding shows symbol, quantity, average cost, current LTP, current
  value, and P&L.
- Multiple buys update quantity and weighted average cost.
- Selling reduces quantity and removes a holding at zero.
- Holdings are sorted dynamically by P&L descending.
- Tapping a holding opens a pre-filled order ticket.
- Wallet, holdings, and order history persist across restarts.

## Supported stocks

The app intentionally uses exactly these ten symbols:

`RELIANCE`, `TCS`, `INFY`, `HDFCBANK`, `ICICIBANK`, `SBIN`, `ITC`, `LT`,
`BHARTIARTL`, and `AXISBANK`.

Initial prices and the initial wallet balance are configured centrally in
`lib/core/constants/app_constants.dart`. The default mock wallet is
₹10,00,000.

## Architecture

The app follows a clean architecture separation:

```text
lib/
├── core/
│   ├── constants/       App-wide stock and wallet configuration
│   └── utils/            Currency and display formatters
├── data/
│   ├── datasources/     Mock market feed and SharedPreferences storage
│   └── repositories/    Trading repository implementation
├── domain/
│   ├── entities/        Price, holding, order, and trading state models
│   └── repositories/    Repository contracts
├── presentation/
│   ├── pages/           Watchlists, markets, portfolio, ticket, confirmation
│   ├── providers/       AppStore application state
│   └── widgets/         Reusable financial UI components
└── main.dart            Dependency composition and app bootstrap
```

### Shared market-data source

`MarketFeed` is the single source of truth for every current price. It owns one
timer and stores prices by stock symbol, not list index. Watchlists, markets,
holdings, and order tickets all read from this same feed, so the same stock
always displays the same LTP everywhere.

The feed ticks every 500 milliseconds by default. It is independent of the
currently visible screen and is disposed with the app.

### Persistence

`LocalStorageDataSource` wraps `SharedPreferences`. The repository persists:

- Wallet balance
- Watchlists and symbol ordering
- Holdings and weighted average costs
- Order history

The market feed itself is intentionally not persisted; prices start from the
configured mock values whenever the app is launched.

### Money handling

The UI formats all monetary values to two decimal places in INR. Order,
holding, and portfolio calculations use controlled decimal display precision
and execute using the latest symbol-bound feed price.

## Testing and validation

Run the analyzer and tests with:

```bash
flutter analyze
flutter test
```

The test suite covers:

- Buy execution using the shared current price
- Holding creation and wallet deduction
- Sell validation for insufficient holdings
- Symbol-based shared price lookup

## Scope and limitations

This is a simulated trading experience for demonstration and testing. It does
not connect to a real exchange, provide investment advice, process payments, or
submit real orders.
