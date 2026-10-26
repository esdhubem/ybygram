import 'package:flutter/material.dart';
import 'profile_screen.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  static const products = [
    ('Camiseta YBYgram', 'Loja oficial', 'R\$ 59,90', Icons.checkroom_outlined),
    ('Caderno artesanal', 'Criador independente', 'R\$ 32,00', Icons.menu_book_outlined),
    ('Biojoia autoral', 'Artesanato comunitário', 'R\$ 45,00', Icons.auto_awesome_outlined),
    ('Livro independente', 'Livraria comunitária', 'R\$ 39,90', Icons.book_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja e Economia Solidária', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Meu perfil',
            icon: const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person_outline, size: 20),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Comércio Comunitário',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Vitrine demonstrativa de produtos de produtores locais e economia solidária.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          const ProductGrid(),
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final bool compact;
  const ProductGrid({super.key, this.compact = false});

  static const products = MarketplaceScreen.products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: compact,
      physics: compact ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.74,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        final theme = Theme.of(context);

        return Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
          child: InkWell(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Detalhes de produto serão integrados nesta etapa.')),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(p.$4, size: 48, color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.$1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.$3,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
