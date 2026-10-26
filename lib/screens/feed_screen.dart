import 'package:flutter/material.dart';
import '../services/mock_supabase_service.dart';
import '../models/product.dart';
import '../models/post.dart';
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
  int _selectedSubTab = 0; // 0: Saberes, 1: Vídeos, 2: Leitura / Receitas
  final TextEditingController _postTextController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  final TextEditingController _videoTitleController = TextEditingController();

  final _subTabs = const [
    ('📚 Saberes', 'Textos e imagens comunitárias'),
    ('🎬 Vídeos', 'Vídeos 9:16 com selo de origem'),
    ('🌿 Leitura / Receitas', 'Livros UICLAP, e-books e receitas ancestrais'),
  ];

  @override
  void dispose() {
    _postTextController.dispose();
    _tagController.dispose();
    _videoLinkController.dispose();
    _videoTitleController.dispose();
    super.dispose();
  }

  // 1. Modal para Republicar Vídeo Curto por Link Oficial
  void _showNewVideoLinkDialog() {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF245C45).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.video_library_outlined, color: Color(0xFF245C45), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Republicar Vídeo Curto (9:16)', style: Theme.of(ctx).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const Text('Instagram Reels, Shorts, TikTok, Kwai ou Face', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _videoLinkController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.link),
                  hintText: 'Cole o link do Reels, Shorts, TikTok ou Kwai...',
                  hintStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _videoTitleController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  hintText: 'Legenda ou título do vídeo curto...',
                  hintStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF245C45).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Color(0xFF245C45)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sem necessidade de banco de dados: o player oficial é incorporado de forma leve e direta.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF245C45)),
                      ),
                    ),
                  ],
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
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Republicar Vídeo no Feed 9:16'),
                onPressed: () {
                  final link = _videoLinkController.text.trim();
                  final title = _videoTitleController.text.trim().isNotEmpty
                      ? _videoTitleController.text.trim()
                      : 'Vídeo comunitário republicado';

                  if (link.isNotEmpty) {
                    final newReel = VideoReelItem(
                      id: 'vr_${DateTime.now().millisecondsSinceEpoch}',
                      authorName: MockSupabaseService().currentUser.name,
                      authorHandle: MockSupabaseService().currentUser.handle,
                      authorAvatar: MockSupabaseService().currentUser.avatarUrl,
                      title: title,
                      platform: 'Rede Externa',
                      platformBadge: 'VÍDEO REPASSADO',
                      thumbnailUrl: 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=600',
                      likesCount: 1,
                    );
                    setState(() {
                      MockSupabaseService().videoReels.insert(0, newReel);
                      _selectedSubTab = 1; // Leva para a aba de vídeos
                      _videoLinkController.clear();
                      _videoTitleController.clear();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🎬 Vídeo curto republicado com sucesso no feed 9:16!')),
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

  // 2. Modal para Publicar Texto e Imagem no Feed de Saberes
  void _showNewTextPostDialog() {
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
              Text('Publicar Saber ou Ensaio', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _postTextController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escreva seu relato, reflexão tradicional ou partilha comunitária...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tagController,
                decoration: const InputDecoration(
                  hintText: 'Comunidade ou Tag (Ex: Agroecologia, Fitoterapia, Redes Livres)',
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
                label: const Text('Publicar no Feed de Saberes'),
                onPressed: () {
                  final text = _postTextController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      MockSupabaseService().addPost(text, null, _tagController.text.trim());
                      _selectedSubTab = 0;
                      _postTextController.clear();
                      _tagController.clear();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('📝 Saber publicado com sucesso no feed comunitário!')),
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
          // Botão 1: Exclusivo para Republicar Vídeo Curto por Link
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF245C45).withOpacity(0.12),
              foregroundColor: const Color(0xFF245C45),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.videocam_outlined, size: 18),
            label: const Text('+ Vídeo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: _showNewVideoLinkDialog,
          ),
          const SizedBox(width: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomLeft,
            child: Row(
              children: List.generate(_subTabs.length, (index) {
                final isSelected = _selectedSubTab == index;

                // Cores secundárias distintas para cada categoria quando inativa
                final inactiveColor = switch (index) {
                  0 => const Color(0xFF2D6F53).withOpacity(0.35),
                  1 => const Color(0xFF804928).withOpacity(0.35),
                  _ => const Color(0xFF476B3C).withOpacity(0.35),
                };

                final inactiveTextColor = switch (index) {
                  0 => const Color(0xFFD3EDE1),
                  1 => const Color(0xFFFBE8DA),
                  _ => const Color(0xFFE5F2DF),
                };

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    onTap: () => setState(() => _selectedSubTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        // Regra de seleção: Laranja de destaque (#C85A32) na aba ativa
                        color: isSelected ? const Color(0xFFC85A32) : inactiveColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        border: Border(
                          top: BorderSide(
                            color: isSelected ? const Color(0xFFFFA07A) : Colors.white12,
                            width: isSelected ? 2 : 1,
                          ),
                          left: const BorderSide(color: Colors.white12, width: 1),
                          right: const BorderSide(color: Colors.white12, width: 1),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, -2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        _subTabs[index].$1,
                        style: TextStyle(
                          color: isSelected ? Colors.white : inactiveTextColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: switch (_selectedSubTab) {
        0 => _buildSaberesFeed(supabase),
        1 => _buildVideosFeed(supabase),
        _ => _buildLeituraFeed(supabase),
      },
    );
  }

  Widget _buildSaberesFeed(MockSupabaseService supabase) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView(
        children: [
          // 2. Pessoas que Sigo (Limpo e direciona para última publicação)
          StoriesBar(
            stories: supabase.stories,
            onStoryTap: (story) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('📍 Visualizando última partilha de ${story.authorName}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1),
          // 3. Card Dedicado: "Fluxo cronológico de oportunidades para todos"
          Container(
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EFE9), // Tom sutil orgânico destacado
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF245C45).withOpacity(0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF245C45).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.balance, size: 20, color: Color(0xFF245C45)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fluxo cronológico de oportunidades para todos',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF245C45),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: Color(0xFF245C45)),
                          SizedBox(width: 4),
                          Text(
                            'Recentes primeiro',
                            style: TextStyle(fontSize: 11, color: Color(0xFF1B4734), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 4. Harmonização da Caixa de Texto e Partilha (Tom de cinza claro unificado e idêntico)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAECE8), // Tom de cinza claro unificado
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD5D8D2)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(supabase.currentUser.avatarUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _showNewTextPostDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAECE8), // Tom idêntico para coesão
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD5D8D2)),
                      ),
                      child: const Text(
                        'Publicar texto, reflexão ou partilha com foto...',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image_outlined, size: 20, color: Color(0xFF245C45)),
                  onPressed: _showNewTextPostDialog,
                  tooltip: 'Adicionar Imagem',
                ),
              ],
            ),
          ),
          // Posts dinâmicos cronológicos
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
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Banner de Republicação de Vídeos Curtos por Link
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF245C45), Color(0xFF183F2F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.video_library_outlined, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Republique aqui seu vídeo curto do Insta, Face, YouTube, Kwai e TikTok',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Sem necessidade de banco de dados no início: cole o link oficial e o player é incorporado na hora!',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF52A37F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.link, size: 16),
                label: const Text('Colar Link de Vídeo Curto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: _showNewVideoLinkDialog,
              ),
            ],
          ),
        ),
        ...supabase.videoReels.map((reel) => VideoReelCard(reel: reel)),
      ],
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
