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
          // Badge da plataforma no topo (Odysee, YouTube Shorts, etc)
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(12),
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
}
