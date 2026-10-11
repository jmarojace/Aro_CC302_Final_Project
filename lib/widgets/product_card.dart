import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/inventory_store.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 2, 10),
          child: Row(
            children: [
              _Thumb(product),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      product.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '₱${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF0F4C5C),
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        _StockChip(product),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Sell one',
                icon: const Icon(Icons.shopping_cart_checkout),
                color: const Color(0xFF0F4C5C),
                onPressed: product.stock == 0
                    ? null
                    : () {
                        inventory.sellOne(product);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sold 1 ${product.name}. ${product.stock} left.',
                              ),
                            ),
                          );
                      },
              ),
              IconButton(
                tooltip: 'Delete',
                icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                onPressed: () => confirmDelete(context, product),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Colored badge: in stock, low, or out of stock
class _StockChip extends StatelessWidget {
  final Product product;
  const _StockChip(this.product);

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String text;
    if (product.stock == 0) {
      color = Colors.red.shade700;
      text = 'Out of stock';
    } else if (product.isLow) {
      color = const Color(0xFFB45309);
      text = 'Low • ${product.stock} left';
    } else {
      color = const Color(0xFF1F7A4D);
      text = '${product.stock} in stock';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11.5,
        ),
      ),
    );
  }
}

// Picture for a product: local image (png/jpg/jpeg/webp), API image, or a category icon
class _Thumb extends StatelessWidget {
  final Product product;
  const _Thumb(this.product);

  static IconData _icon(String category) {
    switch (category.toLowerCase()) {
      case 'noodles':
        return Icons.ramen_dining;
      case 'canned goods':
        return Icons.set_meal;
      case 'rice & grains':
        return Icons.rice_bowl;
      case 'condiments':
        return Icons.water_drop_outlined;
      case 'fresh goods':
        return Icons.egg_alt_outlined;
      case 'snacks':
        return Icons.cookie_outlined;
      case 'beverages':
        return Icons.local_drink_outlined;
      case 'household':
        return Icons.cleaning_services_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    const size = 60.0;
    final fallback = Container(
      width: size,
      height: size,
      color: color.withAlpha(25),
      child: Icon(_icon(product.category), color: color),
    );

    // Filipino sample products (ids 1001-1999) use assets/images/p<id>.<png|jpg|jpeg|webp>
    final url = product.imageUrl;
    final isLocal = url.isEmpty && product.id >= 1001 && product.id < 2000;

    Widget child;
    if (isLocal) {
      const exts = ['png', 'jpg', 'jpeg', 'webp'];
      Widget tryExt(int i) => Image.asset(
        'assets/images/p${product.id}.${exts[i]}',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            i + 1 < exts.length ? tryExt(i + 1) : fallback,
      );
      child = tryExt(0);
    } else if (url.startsWith('assets/')) {
      child = Image.asset(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    } else if (url.isNotEmpty) {
      child = Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    } else {
      child = fallback;
    }
    return ClipRRect(borderRadius: BorderRadius.circular(12), child: child);
  }
}

// Delete with confirmation, plus an Undo option
Future<void> confirmDelete(BuildContext context, Product p) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete product?'),
      content: Text('"${p.name}" will be removed from your inventory.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;

  final index = inventory.products.indexOf(p);
  inventory.remove(p);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('${p.name} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => inventory.restore(p, index),
        ),
      ),
    );
}
