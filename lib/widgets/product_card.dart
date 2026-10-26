import 'package:flutter/material.dart';
import '../models/product.dart';
import 'checkout_modal.dart';

class ProductCard extends StatelessWidget {
  final ProductItem product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = product;

    Color badgeBgColor;
    Color badgeTextColor;

    switch (p.type) {
      case ProductType.officialPod:
        badgeBgColor = const Color(0xFF245C45).withOpacity(0.12);
        badgeTextColor = const Color(0xFF245C45);
        break;
      case ProductType.localArtisan:
        badgeBgColor = const Color(0xFFC85A32).withOpacity(0.12);
        badgeTextColor = const Color(0xFFC85A32);
        break;
      case ProductType.physicalBook:
      case ProductType.ebookDigital:
        badgeBgColor = Colors.blueGrey.withOpacity(0.12);
        badgeTextColor = Colors.blueGrey.shade800;
        break;
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto do produto no topo
          Stack(
            children: [
              Image.network(
                p.imageUrl,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: Icon(Icons.shopping_bag_outlined, size: 40)),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    p.sellerBadge,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título em no máximo 2 linhas
                Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.25),
                ),
                const SizedBox(height: 4),
                // Vendedor e local
                Text(
                  '${p.sellerName} • ${p.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 8),
                // Preço verde-mata e botão Comprar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      p.formattedPrice,
                      style: const TextStyle(
                        color: Color(0xFF245C45),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF245C45),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        minimumSize: const Size(60, 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => CheckoutModal.show(context, p),
                      child: const Text('Comprar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
