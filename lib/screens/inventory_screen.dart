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
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: TextField(
                onChanged: inventory.setQuery,
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: FilterChip(
                  label: const Text('Low stock only'),
                  selected: inventory.lowOnly,
                  onSelected: inventory.setLowOnly,
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
