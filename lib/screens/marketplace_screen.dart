import 'package:flutter/material.dart';
import '../services/mock_supabase_service.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'profile_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  int _selectedFilter = 0; // 0: Todos, 1: Oficiais POD, 2: Artesãos MEI, 3: Livros & E-books

  final _filters = const [
    '✨ Todos',
    '🌿 YBYgram Oficial (POD)',
    '🍯 Artesãos & MEI',
    '📚 Livros & E-books',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supabase = MockSupabaseService();

    final filteredProducts = supabase.products.where((p) {
      if (_selectedFilter == 1) return p.type == ProductType.officialPod;
      if (_selectedFilter == 2) return p.type == ProductType.localArtisan;
      if (_selectedFilter == 3) return p.type == ProductType.physicalBook || p.type == ProductType.ebookDigital;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Comunitária', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Filtros Éticos',
            icon: const Icon(Icons.verified_outlined, color: Color(0xFF245C45)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Marketplace 100% livre de manufatura predatória ou produtos chineses de massa.'),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Meu Perfil',
            icon: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(supabase.currentUser.avatarUrl),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilter == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 6),
                  child: FilterChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    selectedColor: const Color(0xFF245C45).withOpacity(0.18),
                    checkmarkColor: const Color(0xFF245C45),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF245C45) : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF245C45) : theme.dividerColor.withOpacity(0.2),
                      ),
                    ),
                    onSelected: (_) => setState(() => _selectedFilter = index),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Banner de Regras Éticas do Marketplace
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF245C45).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF245C45).withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF245C45), size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YBY gram MarketPlace',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF245C45)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Aqui valorizamos produtos da nossa Terra! Naturais e Artesanais.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Grade ESTRITAMENTE em 2 Colunas (Masonry / GridView)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.68,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
