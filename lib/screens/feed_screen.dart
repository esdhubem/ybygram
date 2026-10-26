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
  int _selectedSubTab = 0; // 0: Saberes, 1: Vídeos Curtos, 2: Vídeos Longos, 3: Música
  final TextEditingController _postTextController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  final TextEditingController _videoTitleController = TextEditingController();

  final _subTabs = const [
    ('📚 Saberes', 'Postagens em texto e imagem'),
    ('🎬 Vídeos Curtos', 'Pílulas verticais em 9:16'),
    ('🖥️ Vídeos Longos', 'Grade vitrine com player embutido'),
    ('🎵 Música', 'Paisagens sonoras e cantos autorais'),
  ];

  @override
  void dispose() {
    _postTextController.dispose();
    _tagController.dispose();
    _videoLinkController.dispose();
    _videoTitleController.dispose();
    super.dispose();
  }

  // 1. Modal para Publicação por Link Externo (Curto, Longo ou Música) com Validação Estrita
  void _showNewVideoLinkDialog() {
    String currentPlatform = 'YouTube';
    String currentFormat = 'curto';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
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
                          child: const Icon(Icons.link, color: Color(0xFF245C45), size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Publicação por Link Externo', style: Theme.of(ctx).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const Text('Vídeos Curtos, Aulas Longas e Áudios Autorais', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Banner Explicativo Restrito à Janela Modal (Limpeza visual das abas principais)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF245C45),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.video_library_outlined, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Republique aqui seu vídeo ou áudio do Insta, Face, YouTube, Kwai, TikTok, Odysee ou SoundCloud. Sem banco de dados pesado: player embutido com selo de transparência da rede de origem.',
                              style: TextStyle(fontSize: 11, color: Colors.white, height: 1.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Campo 1: Link do Vídeo/Áudio (Obrigatório)
                    const Text('1. Link da publicação *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _videoLinkController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.link, size: 18),
                        hintText: 'https://...',
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Campo 2: Plataforma de Origem (Obrigatório)
                    const Text('2. Plataforma de Origem *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: currentPlatform,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'YouTube', child: Text('YouTube')),
                        DropdownMenuItem(value: 'Instagram Reels', child: Text('Instagram Reels')),
                        DropdownMenuItem(value: 'TikTok', child: Text('TikTok')),
                        DropdownMenuItem(value: 'Kwai', child: Text('Kwai')),
                        DropdownMenuItem(value: 'Odysee Livre', child: Text('Odysee Livre')),
                        DropdownMenuItem(value: 'SoundCloud', child: Text('SoundCloud')),
                        DropdownMenuItem(value: 'PeerTube', child: Text('PeerTube')),
                        DropdownMenuItem(value: 'Facebook Reels', child: Text('Facebook Reels')),
                        DropdownMenuItem(value: 'Áudio Autoral', child: Text('Áudio Autoral / Podcast Livre')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => currentPlatform = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Campo 3: Formato Correspondente (Obrigatório)
                    const Text('3. Escolha o Formato Correspondente *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => currentFormat = 'curto'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: currentFormat == 'curto' ? const Color(0xFFC85A32).withOpacity(0.12) : const Color(0xFFEAECE8),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: currentFormat == 'curto' ? const Color(0xFFC85A32) : const Color(0xFFD5D8D2),
                                  width: currentFormat == 'curto' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text('🎬', style: TextStyle(fontSize: 16)),
                                  Text(
                                    'Curto (9:16)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: currentFormat == 'curto' ? const Color(0xFFC85A32) : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => currentFormat = 'longo'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: currentFormat == 'longo' ? const Color(0xFFC85A32).withOpacity(0.12) : const Color(0xFFEAECE8),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: currentFormat == 'longo' ? const Color(0xFFC85A32) : const Color(0xFFD5D8D2),
                                  width: currentFormat == 'longo' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text('🖥️', style: TextStyle(fontSize: 16)),
                                  Text(
                                    'Longo (16:9)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: currentFormat == 'longo' ? const Color(0xFFC85A32) : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => currentFormat = 'musica'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: currentFormat == 'musica' ? const Color(0xFFC85A32).withOpacity(0.12) : const Color(0xFFEAECE8),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: currentFormat == 'musica' ? const Color(0xFFC85A32) : const Color(0xFFD5D8D2),
                                  width: currentFormat == 'musica' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text('🎵', style: TextStyle(fontSize: 16)),
                                  Text(
                                    'Música',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: currentFormat == 'musica' ? const Color(0xFFC85A32) : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Campo 4: Título / Legenda (Obrigatório)
                    const Text('4. Título / Legenda *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _videoTitleController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.title, size: 18),
                        hintText: 'Ex: Manejo tradicional e identificação...',
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC85A32),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Publicar no Feed', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final link = _videoLinkController.text.trim();
                        final title = _videoTitleController.text.trim();

                        // Validação de formulário: impede o envio se campos obrigatórios estiverem vazios
                        if (link.isEmpty || title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text('⚠️ Por favor, preencha todos os campos obrigatórios (*) para publicar!'),
                            ),
                          );
                          return;
                        }

                        final user = MockSupabaseService().currentUser;

                        if (currentFormat == 'curto') {
                          final newReel = VideoReelItem(
                            id: 'vr_${DateTime.now().millisecondsSinceEpoch}',
                            authorName: user.name,
                            authorHandle: user.handle,
                            authorAvatar: user.avatarUrl,
                            title: title,
                            platform: currentPlatform,
                            platformBadge: currentPlatform.toUpperCase(),
                            thumbnailUrl: 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=600',
                            likesCount: 1,
                          );
                          setState(() {
                            MockSupabaseService().videoReels.insert(0, newReel);
                            _selectedSubTab = 1;
                            _videoLinkController.clear();
                            _videoTitleController.clear();
                          });
                        } else if (currentFormat == 'longo') {
                          final newLong = VideoLongItem(
                            id: 'vl_${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            authorName: user.name,
                            authorAvatar: user.avatarUrl,
                            duration: '18:30',
                            platform: currentPlatform,
                            platformBadge: currentPlatform.toUpperCase(),
                            thumbnailUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800',
                            videoUrl: link,
                            timeAgo: 'Agora mesmo',
                          );
                          setState(() {
                            MockSupabaseService().longVideos.insert(0, newLong);
                            _selectedSubTab = 2;
                            _videoLinkController.clear();
                            _videoTitleController.clear();
                          });
                        } else {
                          final newMusic = AudioMusicItem(
                            id: 'mus_${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            authorName: user.name,
                            duration: '06:20',
                            platform: currentPlatform,
                            platformBadge: currentPlatform.toUpperCase(),
                            audioUrl: link,
                            coverUrl: 'https://images.unsplash.com/photo-1511497584788-87676104235f?w=400',
                          );
                          setState(() {
                            MockSupabaseService().musicAudios.insert(0, newMusic);
                            _selectedSubTab = 3;
                            _videoLinkController.clear();
                            _videoTitleController.clear();
                          });
                        }

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('✨ Conteúdo incorporado na aba correta com selo de $currentPlatform!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
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
          // Botão Superior: Publicar Conteúdo por Link Externo
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF245C45).withOpacity(0.12),
              foregroundColor: const Color(0xFF245C45),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.link, size: 18),
            label: const Text('+ Link', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.bottomLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_subTabs.length, (index) {
                  final isSelected = _selectedSubTab == index;

                  // Cores secundárias distintas para cada categoria quando inativa (estilo abas de caderno)
                  final inactiveColor = switch (index) {
                    0 => const Color(0xFF245C45).withOpacity(0.40),
                    1 => const Color(0xFF804928).withOpacity(0.40),
                    2 => const Color(0xFF204A6E).withOpacity(0.40),
                    _ => const Color(0xFF5B21B6).withOpacity(0.40),
                  };

                  final inactiveTextColor = switch (index) {
                    0 => const Color(0xFFD3EDE1),
                    1 => const Color(0xFFFBE8DA),
                    2 => const Color(0xFFE2E8F0),
                    _ => const Color(0xFFEDE9FE),
                  };

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      onTap: () => setState(() => _selectedSubTab = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      ),
      body: switch (_selectedSubTab) {
        0 => _buildSaberesFeed(supabase),
        1 => _buildVideosCurtosFeed(supabase),
        2 => _buildVideosLongosFeed(supabase),
        _ => _buildMusicaFeed(supabase),
      },
    );
  }

  // ABA 1: Saberes (Textos e Imagens Comunitárias)
  Widget _buildSaberesFeed(MockSupabaseService supabase) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView(
        children: [
          // Pessoas que Sigo
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
          // Card de Oportunidades Cronológico (#F6CF4C)
          Container(
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6CF4C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5BE38)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
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
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF245C45).withOpacity(0.15)),
                  ),
                  child: const Icon(Icons.balance, size: 20, color: Color(0xFF1B4734)),
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
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1B4734),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: Color(0xFF1B4734)),
                          SizedBox(width: 4),
                          Text(
                            'Recentes primeiro',
                            style: TextStyle(fontSize: 11, color: Color(0xFF245C45), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Caixa de Partilha (Container cinza #EAECE8 e campo interno BRANCO para destaque)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAECE8),
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
                        color: Colors.white, // Fundo BRANCO para destacar do cinza
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

  // ABA 2: Vídeos Curtos (9:16) — LIMPO, SEM AVISOS REDUNDANTES NO TOPO
  Widget _buildVideosCurtosFeed(MockSupabaseService supabase) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ...supabase.videoReels.map((reel) => VideoReelCard(reel: reel)),
      ],
    );
  }

  // ABA 3: Vídeos Longos (Grade/Quadrinhos Estilo Vitrine com Player Embutido)
  Widget _buildVideosLongosFeed(MockSupabaseService supabase) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'VITRINE DE VÍDEOS LONGOS & AULAS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF245C45),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Toque para assistir',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemCount: supabase.longVideos.length,
          itemBuilder: (context, index) {
            final video = supabase.longVideos[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openEmbeddedPlayer(video),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEAECE8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD5D8D2)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Miniatura 16:9 com Selo de Origem e Duração
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(video.thumbnailUrl, fit: BoxFit.cover),
                          Container(color: Colors.black26),
                          // Selo de Origem Discreto
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: video.platform.toLowerCase().contains('youtube') ? Colors.red.shade700 : const Color(0xFF245C45),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                video.platformBadge,
                                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          // Duração
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                video.duration,
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Botão Play Central
                          const Center(
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white70,
                              child: Icon(Icons.play_arrow, color: Color(0xFF245C45), size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.2),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            video.authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF245C45), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ABA 4: Música (Paisagens Sonoras, Cantos e Áudios Autorais)
  Widget _buildMusicaFeed(MockSupabaseService supabase) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B21B6), Color(0xFF311042)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Text('🎵', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paisagens Sonoras & Cantos Tradicionais',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Áudios autorais, sons da mata e cantos ancestrais livres de algoritmos comerciais.',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...supabase.musicAudios.map((audio) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAECE8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD5D8D2)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        audio.coverUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5B21B6).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  audio.platformBadge,
                                  style: const TextStyle(color: Color(0xFF5B21B6), fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(audio.duration, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            audio.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            audio.authorName,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF245C45), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_circle_filled, size: 36, color: Color(0xFF5B21B6)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('▶️ Reproduzindo: ${audio.title}')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('0:00', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B21B6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(audio.duration, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🌱 Semente de gratidão enviada ao autor!')),
                        );
                      },
                      child: const Row(
                        children: [
                          Text('🌱', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Text(
                            'Semear',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF245C45)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Diálogo com Player Oficial Embutido de Vídeo Longo
  void _openEmbeddedPlayer(VideoLongItem video) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    video.platformBadge,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    video.authorName,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(video.thumbnailUrl, fit: BoxFit.cover, width: double.infinity),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF245C45),
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              video.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            const Text(
              'Reproduzido via player oficial leve incorporado na rede de origem.',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

