import 'package:flutter/material.dart';
import '../models/post.dart';

class VideoReelCard extends StatefulWidget {
  final VideoReelItem reel;

  const VideoReelCard({
    super.key,
    required this.reel,
  });

  @override
  State<VideoReelCard> createState() => _VideoReelCardState();
}

class _VideoReelCardState extends State<VideoReelCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = widget.reel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 480, // proporção vertical mobile
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail / Vídeo de fundo
          Image.network(
            r.thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black54),
          ),
          // Gradiente inferior para leitura de texto
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.4, 1.0],
              ),
            ),
          ),
          // Badge da plataforma no topo + Selo Discreto de Rede de Origem
          Positioned(
            top: 14,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.play_circle_fill, size: 14, color: Color(0xFFC85A32)),
                          const SizedBox(width: 5),
                          Text(
                            r.platformBadge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12, width: 1),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.open_in_new, size: 11, color: Color(0xFF81C784)),
                          SizedBox(width: 4),
                          Text(
                            'Rede de Origem',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Botão de Denúncia Ética / Proteção à Saúde
                IconButton(
                  icon: const Icon(Icons.shield_outlined, color: Colors.white70, size: 20),
                  tooltip: 'Reportar violação ética / desinformação em saúde',
                  onPressed: () => _showReportDialog(context, r.title),
                ),
              ],
            ),
          ),
          // Botão Play central
          Center(
            child: IconButton(
              iconSize: 64,
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: Colors.white.withOpacity(0.9),
              ),
              onPressed: () {
                setState(() => _isPlaying = !_isPlaying);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isPlaying ? 'Reproduzindo stream de ${r.platform}...' : 'Pausado.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
          // Barra lateral de interações (Curtidas, Comentários, Compartilhar)
          Positioned(
            right: 12,
            bottom: 40,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    r.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: r.isLiked ? const Color(0xFFC85A32) : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      r.isLiked = !r.isLiked;
                      r.likesCount += r.isLiked ? 1 : -1;
                    });
                  },
                ),
                Text(
                  '${r.likesCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abrindo comentários do vídeo comunitário.')),
                    );
                  },
                ),
                Text(
                  '${r.commentsCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link compartilhado na rede!')),
                    );
                  },
                ),
              ],
            ),
          ),
          // Informações do Autor e Título no rodapé
          Positioned(
            left: 16,
            right: 70,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(r.authorAvatar),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      r.authorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      r.authorHandle,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  r.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.shield, color: Color(0xFFC85A32), size: 22),
            SizedBox(width: 8),
            Text('Denúncia Ética', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Conteúdo: "$title"', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('Motivo da denúncia ética / saúde:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('• Promessa de cura milagrosa de doença grave\n• Desestímulo a tratamentos convencionais prescritos\n• Diagnóstico pseudocientífico perigoso\n• Venda de produto sem registro profissional\n• Sensacionalismo de cliques ou clickbait', style: TextStyle(fontSize: 11, height: 1.4)),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Detalhes adicionais para a curadoria (opcional)...',
                  hintStyle: TextStyle(fontSize: 11),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC85A32),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🛡️ Denúncia enviada! A curadoria central do YBYgram analisará com máxima prioridade.')),
              );
            },
            child: const Text('Enviar Denúncia'),
          ),
        ],
      ),
    );
  }
}
