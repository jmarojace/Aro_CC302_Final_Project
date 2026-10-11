import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  static const _url = 'https://dummyjson.com/products/category/groceries';

  Future<List<Product>> fetchProducts() async {
    final res = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Server error (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
