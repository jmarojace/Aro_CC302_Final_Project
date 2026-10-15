import 'package:flutter/material.dart';

import '../state/inventory_store.dart';
import '../widgets/product_card.dart';
import '../widgets/state_views.dart';
import 'product_form_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: inventory,
      builder: (context, _) {
        if (inventory.state == LoadState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (inventory.state == LoadState.error) {
          return MessageView(
            icon: Icons.wifi_off,
            title: 'Something went wrong',
            subtitle: inventory.error,
            actionLabel: 'Try again',
            onAction: inventory.load,
          );
        }

        final items = inventory.visible;
        return Column(
          children: [
            if (inventory.usingSampleCatalog)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: CatalogNotice(onRetry: inventory.load),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF16282D))),
                            SizedBox(height: 3),
                            Text('Search, update, or sell an item', style: TextStyle(color: Color(0xFF687A7E), fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(14)),
                        child: Text('${inventory.products.length} items', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: inventory.setQuery,
                    decoration: InputDecoration(
                      hintText: 'Search products',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                child: FilterChip(
                  avatar: const Icon(Icons.warning_amber_rounded, size: 18),
                  label: const Text('Low stock only'),
                  selected: inventory.lowOnly,
                  onSelected: inventory.setLowOnly,
                  showCheckmark: false,
                  side: BorderSide.none,
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const MessageView(
                      icon: Icons.inbox_outlined,
                      title: 'No products found',
                      subtitle: 'Try a different search, or tap Add product.',
                    )
                  : RefreshIndicator(
                      onRefresh: inventory.load,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 90),
                        itemCount: items.length,
                        itemBuilder: (context, i) => ProductCard(
                          product: items[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductFormScreen(product: items[i]),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
