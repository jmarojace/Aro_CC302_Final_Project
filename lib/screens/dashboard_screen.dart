import 'package:flutter/material.dart';

import '../state/inventory_store.dart';
import '../widgets/product_card.dart';
import '../widgets/state_views.dart';
import 'product_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  // 1234567.5 -> ₱1,234,567.50
  String _peso(double v) {
    final parts = v.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
    return '₱$whole.${parts[1]}';
  }

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

        final low = inventory.lowStock;
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // Welcome banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F4C5C), Color(0xFF1B7A8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: const TextStyle(
                      color: Color(0xFFBCD6DC),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Here's your store today",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Total stock value',
                    style: TextStyle(color: Color(0xFFBCD6DC), fontSize: 13),
                  ),
                  Text(
                    _peso(inventory.stockValue),
                    style: const TextStyle(
                      color: Color(0xFFF0B429),
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Products',
                    value: '${inventory.products.length}',
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF0F4C5C),
                  ),
                ),
                Expanded(
                  child: StatCard(
                    label: 'Needs restocking',
                    value: '${low.length}',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
              child: Row(
                children: [
                  const Text(
                    'Low stock items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 8),
                  if (low.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${low.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (low.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF1F7A4D)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Everything is stocked. Nothing to reorder.',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...low.map(
                (p) => ProductCard(
                  product: p,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductFormScreen(product: p),
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
