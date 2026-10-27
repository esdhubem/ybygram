import 'package:flutter/material.dart';
import 'dart:ui';
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
  final TextEditingController _videoDescController = TextEditingController();
  final TextEditingController _videoAuthorController = TextEditingController();
  final TextEditingController _videoSearchController = TextEditingController();
  final TextEditingController _saberesSearchController = TextEditingController();
  final TextEditingController _curtosSearchController = TextEditingController();
  final TextEditingController _musicaSearchController = TextEditingController();
  String _selectedVideoTopic = 'Todos';
  String? _activeInlineVideoId;

  final _subTabs = const [
    ('📚 Saberes', 'Postagens em texto e imagem'),
    ('🎬 Curtos', 'Pílulas verticais em 9:16'),
    ('🖥️ Longos', 'Grade vitrine com player embutido'),
    ('🎵 Música', 'Paisagens sonoras e cantos autorais'),
  ];

  @override
  void dispose() {
    _postTextController.dispose();
    _tagController.dispose();
    _videoLinkController.dispose();
    _videoTitleController.dispose();
    _videoDescController.dispose();
    _videoAuthorController.dispose();
    _videoSearchController.dispose();
    _saberesSearchController.dispose();
    _curtosSearchController.dispose();
    _musicaSearchController.dispose();
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
                    // Campo 4: Título / Legenda da publicação (Obrigatório)
                    const Text('4. Título / Legenda da publicação *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _videoTitleController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.title, size: 18),
                        hintText: 'Ex: Multiplicação de enxame de abelha Jataí...',
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Campo 5: Descrição
                    const Text('5. Descrição:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _videoDescController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.description_outlined, size: 18),
                        hintText: 'Descreva os saberes, contexto ou detalhes da publicação...',
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Campo 6: Canal / Autor Responsável
                    const Text('6. Canal / Autor Responsável:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _videoAuthorController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline, size: 18),
                        hintText: 'Ex: @agroecologia_viva ou Nome do Canal',
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
                        final author = _videoAuthorController.text.trim().isNotEmpty
                            ? _videoAuthorController.text.trim()
                            : user.name;

                        if (currentFormat == 'curto') {
                          final newReel = VideoReelItem(
                            id: 'vr_${DateTime.now().millisecondsSinceEpoch}',
                            authorName: author,
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
                            _videoDescController.clear();
                            _videoAuthorController.clear();
                          });
                        } else if (currentFormat == 'longo') {
                          final newLong = VideoLongItem(
                            id: 'vl_${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            authorName: author,
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
                            _videoDescController.clear();
                            _videoAuthorController.clear();
                          });
                        } else {
                          final newMusic = AudioMusicItem(
                            id: 'mus_${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            authorName: author,
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
                            _videoDescController.clear();
                            _videoAuthorController.clear();
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D6E4B), Color(0xFF12442E), Color(0xFF082417)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            border: Border(
              bottom: BorderSide(color: Color(0x3334D399), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x66051E14),
                blurRadius: 18,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        title: GestureDetector(
          onTap: () {
            setState(() => _selectedSubTab = 0);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('📚 Página Principal de Saberes Comunitários')),
            );
          },
          child: Row(
            children: [
              const Text(
                'YBY',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  fontSize: 24,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
              const Text(
                'gram',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFFCD34D),
                  letterSpacing: -0.5,
                  fontSize: 24,
                  shadows: [Shadow(color: Color(0x80FCD34D), blurRadius: 8)],
                ),
              ),
              const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF06281A).withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF34D399).withOpacity(0.6)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34D399).withOpacity(0.35),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34D399),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Color(0xFF34D399), blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Rede Soberana',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
          // Botão Superior: Faça sua Postagem Lindo em Amarelo Dourado
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE27A), Color(0xFFF6CF4C), Color(0xFFE3A316)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFF2A8), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF6CF4C).withOpacity(0.55),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _showNewVideoLinkDialog,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Text(
                    'Faça sua Postagem',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: Color(0xFF0A291C),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEF4444), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.7),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFFDC2626).withOpacity(0.45),
                        blurRadius: 22,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(supabase.currentUser.avatarUrl),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: 8,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF51DE06),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.check, size: 9, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.bottomCenter,
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

                const inactiveTextColor = Colors.white;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: InkWell(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      onTap: () => setState(() => _selectedSubTab = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
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
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? Colors.white : inactiveTextColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 11,
                          ),
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
        1 => _buildVideosCurtosFeed(supabase),
        2 => _buildVideosLongosFeed(supabase),
        _ => _buildMusicaFeed(supabase),
      },
    );
  }

  // Componente Reutilizável: Motor de Pesquisa Unificado
  Widget _buildSearchField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onChanged,
    required VoidCallback onClear,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  }) {
    return Container(
      margin: margin,
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF245C45)),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD5D8D2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD5D8D2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF245C45), width: 1.5),
          ),
        ),
      ),
    );
  }

  void _showQuickNotePlayerDialog(StoryItem story) {
    if (story.quickNote == null) return;
    final note = story.quickNote!;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botão Fechar no topo direito
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.18),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // CÍRCULO / BOLINHA CENTRAL 1:1 (ESTILO WHATSAPP)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Anel de Progresso Circular de 15s em loop
                        const SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                            backgroundColor: Colors.white24,
                          ),
                        ),

                        // Bolinha de Vídeo / Áudio com borda elegante #245C45
                        Container(
                          width: 236,
                          height: 236,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF245C45), width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF245C45).withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: note.isVideo
                                      ? Image.network(
                                          story.avatarUrl,
                                          fit: BoxFit.cover,
                                          color: Colors.black.withOpacity(0.2),
                                          colorBlendMode: BlendMode.darken,
                                        )
                                      : Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF0F172A), Color(0xFF064E3B), Color(0xFF022C22)],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircleAvatar(
                                                  radius: 36,
                                                  backgroundImage: NetworkImage(story.avatarUrl),
                                                ),
                                                const SizedBox(height: 10),
                                                const Icon(Icons.graphic_eq, color: Color(0xFF34D399), size: 36),
                                              ],
                                            ),
                                          ),
                                        ),
                                ),
                                // Indicador Play central discreto no vídeo
                                if (note.isVideo)
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.25),
                                        border: Border.all(color: Colors.white30),
                                      ),
                                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                                    ),
                                  ),
                                // Tag discreta de autor no topo da bolinha
                                Positioned(
                                  top: 12,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.65),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.white24),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            story.authorName,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            '• 15s',
                                            style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // CONTROLES COMPACTOS E MINIMALISTAS LOGO ABAIXO DA BOLINHA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171717).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            note.text,
                            style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF059669),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  icon: const Text('🌱', style: TextStyle(fontSize: 12)),
                                  label: const Text('Semear Gratidão', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('🌱 Semente de gratidão enviada a ${story.authorName}!')),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                                  backgroundColor: Colors.white.withOpacity(0.08),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.article_outlined, size: 14),
                                label: const Text('Ver Saber', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Abrindo saberes de ${story.authorName}...')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRecordQuickNoteDialog() {
    bool isVideo = true;
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botão Fechar no topo direito
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => Navigator.pop(ctx),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.18),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),

                        // Seletor Minimalista de Formato (Vídeo / Voz)
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => setDialogState(() => isVideo = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isVideo ? const Color(0xFF059669) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.videocam, size: 14, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('Vídeo', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setDialogState(() => isVideo = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: !isVideo ? const Color(0xFF059669) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.mic, size: 14, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('Voz', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // BOLINHA CENTRAL CIRCULAR DE GRAVAÇÃO (1:1 ESTILO WHATSAPP)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Anel de gravação circular
                            const SizedBox(
                              width: 250,
                              height: 250,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                                backgroundColor: Colors.white24,
                              ),
                            ),

                            // Visor Circular com borda elegante #245C45
                            Container(
                              width: 236,
                              height: 236,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF245C45), width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: isVideo
                                          ? Container(
                                              color: const Color(0xFF262626),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const [
                                                  CircleAvatar(
                                                    radius: 36,
                                                    backgroundColor: Color(0xFF059669),
                                                    child: Icon(Icons.person, size: 40, color: Colors.white),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Câmera Frontal Ativa',
                                                    style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Color(0xFF0F172A), Color(0xFF064E3B), Color(0xFF022C22)],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: const [
                                                    Icon(Icons.mic, color: Color(0xFF34D399), size: 44),
                                                    SizedBox(height: 6),
                                                    Text(
                                                      'Microfone Ativo • Voz da Terra',
                                                      style: TextStyle(color: Colors.white70, fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                    // Timer superior discreto
                                    Positioned(
                                      top: 10,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white24),
                                          ),
                                          child: const Text(
                                            '00:15',
                                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Botão de Gravação circular no interior inferior
                                    Positioned(
                                      bottom: 12,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.redAccent,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.fiber_manual_record, color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // CONTROLES COMPACTOS LOGO ABAIXO DA BOLINHA
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF171717).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: controller,
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                                decoration: InputDecoration(
                                  hintText: 'Escreva uma legenda rápida...',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 36,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF059669),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.check, size: 16),
                                  label: const Text('Publicar Recado (24h)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('🎙️ Recado Rápido publicado na sua Rede de Conexões por 24h!')),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ABA 1: Saberes (Textos e Imagens Comunitárias)
  Widget _buildSaberesFeed(MockSupabaseService supabase) {
    final query = _saberesSearchController.text.trim().toLowerCase();
    final filteredPosts = supabase.posts.where((post) {
      if (query.isEmpty) return true;
      return post.content.toLowerCase().contains(query) ||
          post.authorName.toLowerCase().contains(query) ||
          post.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();

    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView(
        children: [
          // Pessoas que Sigo
          StoriesBar(
            stories: supabase.stories,
            onQuickNoteTap: _showQuickNotePlayerDialog,
            onRecordTap: _showRecordQuickNoteDialog,
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
          // Card de Oportunidades Cronológico: "Algoritmos Amigáveis" (Gradiente Dourado Radiante e Efeito Vidro)
          Container(
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF2A8), Color(0xFFF6CF4C), Color(0xFFD49312)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFF1A8), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD49312).withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.80)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.balance, size: 20, color: Color(0xFF0A291C)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        margin: const EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.75)),
                        ),
                        child: const Text(
                          '🌱 ALGORITMOS AMIGÁVEIS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: Color(0xFF0A291C),
                          ),
                        ),
                      ),
                      const Text(
                        'Fluxo cronológico de oportunidades para todos',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0A291C),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: Color(0xFF0A291C)),
                          SizedBox(width: 4),
                          Text(
                            'Recentes primeiro',
                            style: TextStyle(fontSize: 11, color: Color(0xFF144933), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Motor de Pesquisa da Aba Saberes (Posicionado exatamente onde a seta indica: entre Algoritmos Amigáveis e Partilha)
          _buildSearchField(
            controller: _saberesSearchController,
            hintText: 'Pesquisar publicações, saberes ou autores...',
            onChanged: () => setState(() {}),
            onClear: () {
              _saberesSearchController.clear();
              setState(() {});
            },
            margin: const EdgeInsets.fromLTRB(14, 4, 14, 6),
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
          // Posts dinâmicos cronológicos filtrados
          if (filteredPosts.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text(
                    'Nenhuma publicação encontrada para esta busca.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      _saberesSearchController.clear();
                      setState(() {});
                    },
                    child: const Text('Limpar busca'),
                  ),
                ],
              ),
            )
          else
            ...filteredPosts.map((post) => PostCard(
              post: post,
              onLikeChanged: () => setState(() {}),
            )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ABA 2: Vídeos Curtos (9:16) — Motor de Pesquisa no topo conforme indicado pela seta
  Widget _buildVideosCurtosFeed(MockSupabaseService supabase) {
    final query = _curtosSearchController.text.trim().toLowerCase();
    final filteredReels = supabase.videoReels.where((reel) {
      if (query.isEmpty) return true;
      return reel.caption.toLowerCase().contains(query) ||
          reel.authorName.toLowerCase().contains(query) ||
          reel.tag.toLowerCase().contains(query);
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Card Explicativo: Vídeos Curtos (No mesmo estilo do card de Música)
        Container(
          margin: const EdgeInsets.fromLTRB(14, 4, 14, 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6E3012), Color(0xFF3A1506)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PÍLULAS VERTICAIS SOBERANAS',
                        style: TextStyle(
                          color: Color(0xFFFDE68A),
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Vídeos Curtos & Práticas da Terra',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Saberes práticos, agroecologia e momentos da comunidade em formato 9:16.',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: const Text('🎬', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
        // Motor de Pesquisa da Aba Vídeos Curtos
        _buildSearchField(
          controller: _curtosSearchController,
          hintText: 'Pesquisar vídeos curtos ou criadores...',
          onChanged: () => setState(() {}),
          onClear: () {
            _curtosSearchController.clear();
            setState(() {});
          },
          margin: const EdgeInsets.fromLTRB(14, 2, 14, 10),
        ),
        if (filteredReels.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(Icons.search_off, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                const Text(
                  'Nenhum vídeo curto encontrado.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    _curtosSearchController.clear();
                    setState(() {});
                  },
                  child: const Text('Limpar busca'),
                ),
              ],
            ),
          )
        else
          ...filteredReels.map((reel) => VideoReelCard(reel: reel)),
      ],
    );
  }

  // ABA 3: Vídeos Longos (Estilo YouTube com Motor de Pesquisa e Player Dedicado)
  Widget _buildVideosLongosFeed(MockSupabaseService supabase) {
    final query = _videoSearchController.text.trim().toLowerCase();
    final filteredVideos = supabase.longVideos.where((v) {
      final matchesTopic = _selectedVideoTopic == 'Todos' ||
          v.category.toLowerCase() == _selectedVideoTopic.toLowerCase();
      final matchesQuery = query.isEmpty ||
          v.title.toLowerCase().contains(query) ||
          v.authorName.toLowerCase().contains(query) ||
          v.category.toLowerCase().contains(query) ||
          v.platform.toLowerCase().contains(query);
      return matchesTopic && matchesQuery;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Card Explicativo: Vídeos Longos (No mesmo estilo lindo do card de Música)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D3455), Color(0xFF081F33)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ACERVO AUDIOVISUAL LIVRE',
                        style: TextStyle(
                          color: Color(0xFFBAE6FD),
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Aulas, Vivências & Documentários',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Encontros gravados, registros tradicionais e aulas completas com player direto.',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: const Text('🖥️', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
        // 1. Motor de Pesquisa de Assunto
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _videoSearchController,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Pesquisar vídeos, aulas ou assuntos...',
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF245C45)),
                  suffixIcon: _videoSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _videoSearchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD5D8D2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD5D8D2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF245C45), width: 1.5),
                  ),
                ),
              ),
              // Mini Abas de Caderno: 8 Temas da Natureza e Comunidade
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fileira 1
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        {'name': 'Todos', 'icon': '✨'},
                        {'name': 'Agroecologia', 'icon': '🌱'},
                        {'name': 'Plantas Medicinais', 'icon': '🌿'},
                        {'name': 'Abelhas Nativas', 'icon': '🐝'},
                      ].map((item) => _buildNotebookCategoryTab(item['name']!, item['icon']!)).toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Fileira 2
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        {'name': 'Saúde Integrativa', 'icon': '💚'},
                        {'name': 'Artesanato MEI', 'icon': '🧶'},
                        {'name': 'Filosofia & Saberes', 'icon': '📜'},
                        {'name': 'Música & Cultura', 'icon': '🎵'},
                      ].map((item) => _buildNotebookCategoryTab(item['name']!, item['icon']!)).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (filteredVideos.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(Icons.search_off, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                const Text(
                  'Nenhum vídeo encontrado para este assunto.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    _videoSearchController.clear();
                    setState(() => _selectedVideoTopic = 'Todos');
                  },
                  child: const Text('Limpar filtros de busca'),
                ),
              ],
            ),
          )
        else
          // 2. Lista de Vídeos Longos (Estilo YouTube Exato)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredVideos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final video = filteredVideos[index];
              final isPlaying = _activeInlineVideoId == video.id;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Miniatura 16:9 OU Player Inline Direto no Card (Sem abrir janela)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: isPlaying
                          ? Container(
                              color: const Color(0xFF121814),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(video.thumbnailUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                  Container(color: Colors.black.withOpacity(0.72)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 26,
                                        backgroundColor: Color(0xFFC85A32),
                                        child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.graphic_eq, color: Color(0xFFC85A32), size: 16),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Assistindo via ${video.platform}',
                                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Botão Fechar Player e voltar para miniatura
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() => _activeInlineVideoId = null);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.85),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.white24),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.close, color: Colors.white, size: 14),
                                            SizedBox(width: 4),
                                            Text('Fechar', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Selo de Origem
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF245C45),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        video.platformBadge,
                                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() => _activeInlineVideoId = video.id);
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(video.thumbnailUrl, fit: BoxFit.cover),
                                  Container(color: Colors.black12),
                                  // Selo de Origem Superior
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        color: video.platform.toLowerCase().contains('youtube')
                                            ? Colors.red.shade700
                                            : const Color(0xFF245C45),
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                      ),
                                      child: Text(
                                        video.platformBadge,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Botão Central de Play
                                  Center(
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFC85A32),
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
                                      ),
                                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                                    ),
                                  ),
                                  // Badge de Duração ou AO VIVO Inferior Direito
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: video.isLive ? Colors.red.shade700 : Colors.black87,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4)],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (video.isLive) ...[
                                            const Icon(Icons.circle, color: Colors.white, size: 7),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'AO VIVO',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ] else
                                            Text(
                                              video.duration,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'monospace',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                    // Detalhes no Estilo YouTube (Avatar + Título + Canal + Views + Menu)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(video.authorAvatar),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  height: 1.25,
                                  color: Color(0xFF1D2D24),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text(
                                    video.authorName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.check_circle, size: 13, color: Colors.grey.shade600),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${video.views} • ${video.timeAgo}',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert, size: 18, color: Colors.grey.shade700),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Opções para: ${video.title}')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // ABA 4: Música (Paisagens Sonoras, Cantos e Áudios Autorais)
  Widget _buildMusicaFeed(MockSupabaseService supabase) {
    final query = _musicaSearchController.text.trim().toLowerCase();
    final filteredAudios = supabase.musicAudios.where((audio) {
      if (query.isEmpty) return true;
      return audio.title.toLowerCase().contains(query) ||
          audio.authorName.toLowerCase().contains(query) ||
          audio.platformBadge.toLowerCase().contains(query);
    }).toList();

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
        // Motor de Pesquisa da Aba Música (Posicionado logo abaixo do card roxo conforme indicado pela seta)
        _buildSearchField(
          controller: _musicaSearchController,
          hintText: 'Pesquisar cantos, paisagens sonoras ou artistas...',
          onChanged: () => setState(() {}),
          onClear: () {
            _musicaSearchController.clear();
            setState(() {});
          },
          margin: const EdgeInsets.only(top: 10, bottom: 12),
        ),
        if (filteredAudios.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(Icons.search_off, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                const Text(
                  'Nenhum áudio ou música encontrado.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    _musicaSearchController.clear();
                    setState(() {});
                  },
                  child: const Text('Limpar busca'),
                ),
              ],
            ),
          )
        else
          ...filteredAudios.map((audio) {
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

  // Mini Aba de Caderno para Filtro de Temas da Natureza
  Widget _buildNotebookCategoryTab(String theme, String icon) {
    final isSelected = _selectedVideoTopic == theme;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedVideoTopic = theme;
          });
        },
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
          bottom: Radius.circular(6),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC85A32) : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
              bottom: Radius.circular(6),
            ),
            border: Border(
              top: BorderSide(
                color: isSelected ? const Color(0xFFFDBA74) : const Color(0xFFE2DDD2),
                width: isSelected ? 2.5 : 1,
              ),
              left: BorderSide(
                color: isSelected ? const Color(0xFFEA580C) : const Color(0xFFD5D8D2),
              ),
              right: BorderSide(
                color: isSelected ? const Color(0xFFEA580C) : const Color(0xFFD5D8D2),
              ),
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF9A3412) : const Color(0xFFD5D8D2),
                width: 1.5,
              ),
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: const Color(0xFFC85A32).withOpacity(0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Text(
                theme,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF1D2D24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reprodução de Vídeo Inline (Direto no Card sem abrir janela)
  void _openEmbeddedPlayer(VideoLongItem video) {
    setState(() {
      _activeInlineVideoId = video.id;
    });
  }
}

