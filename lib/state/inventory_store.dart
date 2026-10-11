import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

enum LoadState { loading, ready, error }

// Local sample products for a Filipino sari-sari / grocery store.
// IDs start at 1001 so they never clash with the API's IDs.
List<Product> _filipinoProducts() => [
  Product(
    id: 1001,
    name: 'Lucky Me Pancit Canton 60g',
    category: 'Noodles',
    price: 16,
    stock: 48,
  ),
  Product(
    id: 1002,
    name: 'Lucky Me Instant Mami 55g',
    category: 'Noodles',
    price: 13,
    stock: 36,
  ),
  Product(
    id: 1003,
    name: 'Century Tuna 155g',
    category: 'Canned Goods',
    price: 38,
    stock: 30,
  ),
  Product(
    id: 1004,
    name: 'Ligo Sardines 155g',
    category: 'Canned Goods',
    price: 24,
    stock: 40,
  ),
  Product(
    id: 1005,
    name: 'Argentina Corned Beef 150g',
    category: 'Canned Goods',
    price: 45,
    stock: 6,
  ),
  Product(
    id: 1006,
    name: 'Jasmine Rice 1kg',
    category: 'Rice & Grains',
    price: 58,
    stock: 60,
  ),
  Product(
    id: 1007,
    name: 'Dinorado Rice 1kg',
    category: 'Rice & Grains',
    price: 64,
    stock: 8,
  ),
  Product(
    id: 1008,
    name: 'Silver Swan Soy Sauce 385ml',
    category: 'Condiments',
    price: 22,
    stock: 25,
  ),
  Product(
    id: 1009,
    name: 'Datu Puti Vinegar 385ml',
    category: 'Condiments',
    price: 22,
    stock: 22,
  ),
  Product(
    id: 1010,
    name: 'Cooking Oil 1L',
    category: 'Condiments',
    price: 98,
    stock: 3,
  ),
  Product(
    id: 1011,
    name: 'Iodized Salt 500g',
    category: 'Condiments',
    price: 15,
    stock: 28,
  ),
  Product(
    id: 1012,
    name: 'Egg (per piece)',
    category: 'Fresh Goods',
    price: 9,
    stock: 90,
  ),
  Product(
    id: 1013,
    name: 'Pandesal Pack',
    category: 'Fresh Goods',
    price: 35,
    stock: 5,
  ),
  Product(
    id: 1014,
    name: 'Skyflakes Crackers',
    category: 'Snacks',
    price: 8,
    stock: 70,
  ),
  Product(
    id: 1015,
    name: 'Piattos Cheese 40g',
    category: 'Snacks',
    price: 18,
    stock: 32,
  ),
  Product(
    id: 1016,
    name: 'Great Taste White 3-in-1',
    category: 'Beverages',
    price: 8,
    stock: 120,
  ),
  Product(
    id: 1017,
    name: 'Milo Sachet 24g',
    category: 'Beverages',
    price: 10,
    stock: 85,
  ),
  Product(
    id: 1018,
    name: 'Bear Brand Milk Drink 33g',
    category: 'Beverages',
    price: 12,
    stock: 0,
  ),
  Product(
    id: 1019,
    name: 'Coke Mismo 295ml',
    category: 'Beverages',
    price: 20,
    stock: 24,
  ),
  Product(
    id: 1020,
    name: 'C2 Green Tea 230ml',
    category: 'Beverages',
    price: 25,
    stock: 18,
  ),
  Product(
    id: 1021,
    name: 'Safeguard Bar Soap',
    category: 'Household',
    price: 28,
    stock: 20,
  ),
  Product(
    id: 1022,
    name: 'Surf Detergent Sachet',
    category: 'Household',
    price: 10,
    stock: 55,
  ),
  Product(
    id: 1023,
    name: 'Sunsilk Shampoo Sachet',
    category: 'Household',
    price: 8,
    stock: 4,
  ),
];

class InventoryStore extends ChangeNotifier {
  final _service = ProductService();

  List<Product> products = [];
  LoadState state = LoadState.loading;
  String error = '';
  String query = '';
  bool lowOnly = false;

  Future<void> load() async {
    state = LoadState.loading;
    notifyListeners();
    try {
      final fromApi = await _service.fetchProducts();
      products = [..._filipinoProducts(), ...fromApi];
      state = LoadState.ready;
    } catch (_) {
      error = 'Could not load products. Check your internet connection and try again.';
      state = LoadState.error;
    }
    notifyListeners();
  }

  List<Product> get visible => products
      .where(
        (p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) &&
            (!lowOnly || p.isLow),
      )
      .toList();

  List<Product> get lowStock => products.where((p) => p.isLow).toList();

  double get stockValue =>
      products.fold(0.0, (sum, p) => sum + p.price * p.stock);

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  void setLowOnly(bool v) {
    lowOnly = v;
    notifyListeners();
  }

  // Create or update
  void save(Product p) {
    final i = products.indexWhere((x) => x.id == p.id);
    if (i == -1) {
      products.insert(0, p);
    } else {
      products[i] = p;
    }
    notifyListeners();
  }

  // Delete
  void remove(Product p) {
    products.remove(p);
    notifyListeners();
  }

  void restore(Product p, int index) {
    products.insert(index.clamp(0, products.length), p);
    notifyListeners();
  }

  void sellOne(Product p) {
    if (p.stock > 0) {
      p.stock--;
      notifyListeners();
    }
  }
}

// One shared store for the whole app
final inventory = InventoryStore();
