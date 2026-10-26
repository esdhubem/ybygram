import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/mock_supabase_service.dart';

class PostCard extends StatefulWidget {
  final PostItem post;
  final VoidCallback? onLikeChanged;

  const PostCard({
    super.key,
    required this.post,
    this.onLikeChanged,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;
  bool _isDismissed = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      MockSupabaseService().addComment(widget.post.id, text);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.post;

    if (_isDismissed) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.visibility_off, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Publicação ocultada pelo seu controle de autonomia.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isDismissed = false),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('Desfazer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      color: const Color(0xFFEAECE8),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFFD5D8D2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do Post
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(p.authorAvatar),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${p.authorLocation} • ${p.communityTag}',
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (p.communityTag.toLowerCase().contains('etnobotânica') ||
                        p.communityTag.toLowerCase().contains('saúde') ||
                        p.communityTag.toLowerCase().contains('ervas'))
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF4F0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF245C45).withOpacity(0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user, size: 11, color: Color(0xFF245C45)),
                            SizedBox(width: 3),
                            Text(
                              'Curadoria Validada',
                              style: TextStyle(
                                color: Color(0xFF245C45),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.shield_outlined, size: 19, color: Colors.black45),
                      tooltip: 'Reportar violação ética / desinformação em saúde',
                      onPressed: () => _showPostReportDialog(context, p.authorName),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Texto do Post
            Text(
              p.text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45, fontSize: 14),
            ),
            // Imagem do Post
            if (p.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  p.imageUrl!,
                  width: double.infinity,
                  height: 210,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Ações do Post: Fim da Vaidade (Sem contadores públicos)
            Row(
              children: [
                // 1. Sementes de Gratidão (🌱) - Sem contador público de vaidade
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      MockSupabaseService().toggleLikePost(p.id);
                    });
                    if (widget.onLikeChanged != null) widget.onLikeChanged!();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(p.isLiked
                            ? '🌱 Semente de Gratidão plantada! O autor receberá privadamente.'
                            : 'Semente recolhida.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: p.isLiked ? const Color(0xFF245C45).withOpacity(0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: p.isLiked ? const Color(0xFF245C45).withOpacity(0.3) : theme.dividerColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🌱',
                          style: TextStyle(
                            fontSize: 16,
                            color: p.isLiked ? const Color(0xFF245C45) : null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          p.isLiked ? 'Gratidão' : 'Semear',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: p.isLiked ? const Color(0xFF245C45) : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 2. Roda de Partilha (Substituto de Comentários)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() => _showComments = !_showComments),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _showComments ? const Color(0xFFC85A32).withOpacity(0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _showComments ? const Color(0xFFC85A32).withOpacity(0.3) : theme.dividerColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.forum_outlined, size: 15, color: Color(0xFFC85A32)),
                        const SizedBox(width: 5),
                        const Text(
                          'Roda de Partilha',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // 3. Autonomia do Usuário: Ocultar publicação indesejada
                IconButton(
                  icon: const Icon(Icons.visibility_off_outlined, size: 18, color: Colors.black45),
                  tooltip: 'Ocultar conteúdo do meu feed (Autonomia)',
                  onPressed: () {
                    setState(() => _isDismissed = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Conteúdo ocultado do seu feed com sucesso.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                // 4. Salvamento Invisível no Acervo (sem contagem pública)
                IconButton(
                  icon: Icon(
                    p.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: p.isSaved ? const Color(0xFF245C45) : null,
                  ),
                  tooltip: 'Guardar no meu acervo pessoal',
                  onPressed: () {
                    setState(() => p.isSaved = !p.isSaved);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(p.isSaved
                            ? 'Saber guardado no seu acervo privado com sucesso!'
                            : 'Removido do acervo.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            // Roda de Partilha de Saberes (Comentários construtivos)
            if (_showComments) ...[
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(Icons.diversity_3, size: 16, color: Color(0xFF245C45)),
                  const SizedBox(width: 6),
                  Text(
                    'Roda de Partilha de Saberes',
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Text('Trocas construtivas', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              if (p.comments.isNotEmpty)
                ...p.comments.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(c.text, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              // Campo para escrever partilha comunitária
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Contribua com seu saber na roda...',
                        hintStyle: const TextStyle(fontSize: 12),
                        isDense: true,
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onSubmitted: (_) => _sendComment(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, size: 18, color: Color(0xFF245C45)),
                    onPressed: _sendComment,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPostReportDialog(BuildContext context, String author) {
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
              Text('Postagem de: $author', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('Motivo da denúncia ética / saúde:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text(
                '• Promessa de cura milagrosa (câncer/doenças crônicas)\n'
                '• Desestímulo a tratamentos médicos convencionais\n'
                '• Diagnóstico pseudocientífico perigoso\n'
                '• Venda sem responsável técnico ou curadoria\n'
                '• Desinformação ou sensacionalismo de cliques',
                style: TextStyle(fontSize: 11, height: 1.4),
              ),
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
