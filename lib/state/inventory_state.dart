import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

enum LoadState { loading, ready, error }

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
      products = await _service.fetchProducts();
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
