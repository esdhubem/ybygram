import 'package:flutter/material.dart';
import '../services/mock_supabase_service.dart';
import '../models/product.dart';
import '../widgets/stories_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/video_reel_card.dart';
import '../widgets/product_card.dart';
import 'profile_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedSubTab = 0; // 0: Saberes, 1: Vídeos, 2: Produtos, 3: Leitura
  final TextEditingController _postTextController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final _subTabs = const [
    ('📚 Saberes', 'Ensaios e fotos comunitárias'),
    ('🎬 Vídeos', 'Reels verticais 9:16 livres'),
    ('🛍️ Produtos', 'Destaques do marketplace'),
    ('📖 Leitura', 'Livros UICLAP e E-books PDF'),
  ];

  @override
  void dispose() {
    _postTextController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _showNewPostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Compartilhar Saber ou Vídeo', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _postTextController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escreva um ensaio, relato ou cole o link de um vídeo vertical (Odysee, YouTube Shorts, Reels, TikTok)...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tagController,
                decoration: const InputDecoration(
                  hintText: 'Tag ou Comunidade (Ex: Agroecologia, Fitoterapia, Autonomia)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF245C45),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.send),
                label: const Text('Publicar na Rede Livre'),
                onPressed: () {
                  final text = _postTextController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      MockSupabaseService().addPost(text, null, _tagController.text.trim());
                      _postTextController.clear();
                      _tagController.clear();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Publicado com sucesso no YBYgram!')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supabase = MockSupabaseService();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            const Text(
              'YBY',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF245C45),
                letterSpacing: -0.5,
                fontSize: 24,
              ),
            ),
            Text(
              'gram',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.secondary,
                letterSpacing: -0.5,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Criar Publicação',
            icon: const Icon(Icons.add_box_outlined, size: 24),
            onPressed: _showNewPostDialog,
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
              itemCount: _subTabs.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedSubTab == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 6),
                  child: FilterChip(
                    label: Text(_subTabs[index].$1),
                    selected: isSelected,
                    selectedColor: const Color(0xFF245C45).withOpacity(0.18),
                    checkmarkColor: const Color(0xFF245C45),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF245C45) : theme.textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF245C45) : theme.dividerColor.withOpacity(0.2),
                      ),
                    ),
                    onSelected: (_) => setState(() => _selectedSubTab = index),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: switch (_selectedSubTab) {
        0 => _buildSaberesFeed(supabase),
        1 => _buildVideosFeed(supabase),
        2 => _buildProdutosFeed(supabase),
        _ => _buildLeituraFeed(supabase),
      },
    );
  }

  Widget _buildSaberesFeed(MockSupabaseService supabase) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView(
        children: [
          // Rodas de Saberes Vivas (Stories)
          StoriesBar(stories: supabase.stories),
          const Divider(height: 1),
          // Posts dinâmicos
          ...supabase.posts.map((post) => PostCard(
            post: post,
            onLikeChanged: () => setState(() {}),
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVideosFeed(MockSupabaseService supabase) {
    return ListView.builder(
      itemCount: supabase.videoReels.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return VideoReelCard(reel: supabase.videoReels[index]);
      },
    );
  }

  Widget _buildProdutosFeed(MockSupabaseService supabase) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.68,
      ),
      itemCount: supabase.products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: supabase.products[index]);
      },
    );
  }

  Widget _buildLeituraFeed(MockSupabaseService supabase) {
    final bookProducts = supabase.products
        .where((p) => p.type == ProductType.physicalBook || p.type == ProductType.ebookDigital)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Vitrine de Autores Independentes e Livros Comunitários',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Livros físicos impressos sob demanda via UICLAP e E-books em PDF sem DRM predatório.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.68,
          ),
          itemCount: bookProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(product: bookProducts[index]);
          },
        ),
      ],
    );
  }
}
