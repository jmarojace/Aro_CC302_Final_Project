# Mini Store

Mini Store is a Flutter inventory app for a small neighborhood grocery or sari-sari store. It helps a shop owner track products, check low stock, update inventory, and record a sale by reducing an item's stock by one.

## Run the app

Install Flutter, open a terminal in this folder, then run:

```sh
flutter pub get
flutter run
```

Choose an emulator or connected phone when Flutter asks. For the web version, run `flutter run -d chrome`.

## Demo account

- Email: `arojoshua185@gmail.com`
- Password: `admin123`

This is a classroom demo login, not production authentication.

## Features

- Dashboard with stock value, product count, and low-stock alerts.
- Inventory search and low-stock filter.
- Add and edit products with input validation.
- Sell-one action, delete confirmation, and undo.
- Profile and settings screens, including light and dark themes.
- Muted, looping login video background with a still-image fallback.
- Responsive bottom navigation on phones and a navigation rail on wider screens.
- Product catalog fetched from DummyJSON, with Filipino sample products available as an offline fallback.

The remote catalog is fetched from `https://dummyjson.com/products/category/groceries`. API prices are displayed as approximate Philippine pesos using a fixed demo conversion rate. If the API cannot be reached, the app shows a sample-catalog notice with a retry button. Inventory changes are held in memory and reset when the app is restarted.

## CC 302 concepts demonstrated

| Requirement | Mini Store example |
| --- | --- |
| App bars and titles | Main sections and product/profile/settings screens |
| Text, colors, fonts, and assets | Plus Jakarta Sans, store photos, product images, and icons |
| Stateless and stateful widgets | Reusable display widgets and interactive forms/settings |
| Custom widgets | `ProductCard`, `StatCard`, `MessageView`, and `ResponsiveBody` |
| Efficient lists | Inventory uses `ListView.builder` |
| API integration | `ProductService` fetches and parses the grocery catalog |
| Delete and user control | Confirmation dialog plus Undo action |
| Navigation and state | Navigation bar/rail, `ChangeNotifier`, and `ListenableBuilder` |
| Loading, errors, and empty states | Loading indicators, offline sample fallback notice, and empty results view |
| HCI and accessibility | Labeled controls, form validation, feedback, responsive layout, and dark mode |

## Suggested presentation flow

1. Introduce Mini Store and its intended users: owners of small neighborhood shops.
2. Sign in, then show the dashboard and its total stock value and restock alerts.
3. Open Inventory, search and filter products, then add or edit a product.
4. Demonstrate Sell one, delete confirmation, and Undo.
5. Point out API-loaded products. To demonstrate the offline fallback, run without a network connection and use Retry to try again.
6. Show the profile and toggle dark mode in Settings.
7. Explain the reusable widgets, app state, form validation, responsive navigation, and feedback choices.

Before presenting, run the app on the device you plan to use and verify the network/API demo there. Push the finished project to GitHub and submit the repository link through CASTLY as required by the course.
