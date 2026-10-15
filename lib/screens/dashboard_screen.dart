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
            if (inventory.usingSampleCatalog)
              CatalogNotice(onRetry: inventory.load),
            // Welcome banner
            HoverLift(
              interactive: false,
              radius: 20,
              child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/store_background.webp'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Color(0xCC0B3D49),
                    BlendMode.srcATop,
                  ),
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x220F4C5C), blurRadius: 18, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.waving_hand_outlined, color: Color(0xFFF0B429), size: 18),
                      const SizedBox(width: 8),
                      Text(_greeting(), style: const TextStyle(color: Color(0xFFBCD6DC), fontSize: 14)),
                    ],
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(24), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFFF0B429)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total stock value', style: TextStyle(color: Color(0xFFBCD6DC), fontSize: 12)),
                              Text(_peso(inventory.stockValue), maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Color(0xFFF0B429), fontSize: 27, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
            ),
            const SizedBox(height: 10),
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
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
              child: Row(
                children: [
                  const Text(
                    'Low stock items',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF16282D)),
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
