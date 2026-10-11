class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final int reorderLevel;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imageUrl = '',
    this.reorderLevel = 10,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as int,
    name: j['title'] as String,
    category: j['category'] as String,
    price: ((j['price'] as num) * 56).roundToDouble(),
    stock: j['stock'] as int,
    imageUrl: (j['thumbnail'] ?? '') as String,
  );

  bool get isLow => stock <= reorderLevel;
}
