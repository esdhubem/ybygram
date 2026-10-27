import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/mock_supabase_service.dart';

class StoriesBar extends StatelessWidget {
  final List<StoryItem> stories;
  final Function(StoryItem)? onStoryTap;
  final Function(StoryItem)? onQuickNoteTap;
  final VoidCallback? onRecordTap;

  const StoriesBar({
    super.key,
    required this.stories,
    this.onStoryTap,
    this.onQuickNoteTap,
    this.onRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supabase = MockSupabaseService();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.12),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabeçalho da Rede de Conexões com Botão + Recado Rápido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined, size: 16, color: Color(0xFF245C45)),
                    const SizedBox(width: 6),
                    Text(
                      'Rede de Conexões',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF245C45),
                        letterSpacing: 0.8,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: onRecordTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF10B981).withOpacity(0.35)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam_outlined, size: 13, color: Color(0xFF047857)),
                        SizedBox(width: 4),
                        Text(
                          '+ Recado Rápido',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Lista horizontal de Avatares Circulares (Você + Conexões)
          SizedBox(
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: stories.length + 1, // +1 para o avatar de "Você"
              itemBuilder: (context, index) {
                // Item 0: "Você"
                if (index == 0) {
                  return GestureDetector(
                    onTap: onRecordTap,
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.dividerColor.withOpacity(0.3), width: 1.5),
                                ),
                              ),
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                                padding: const EdgeInsets.all(2.5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    supabase.currentUser.avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.person),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.add, size: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Você',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final story = stories[index - 1];
                final hasQuickNote = story.hasActiveQuickNote;

                return GestureDetector(
                  onTap: () {
                    if (hasQuickNote && onQuickNoteTap != null) {
                      onQuickNoteTap!(story);
                    } else if (onStoryTap != null) {
                      onStoryTap!(story);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Anel circular: BORDA VIVA com gradiente vibrante se tiver recado rápido ativo
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: hasQuickNote
                                    ? const LinearGradient(
                                        colors: [Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFF059669)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: !hasQuickNote
                                    ? (story.hasUnseen ? const Color(0xFF245C45) : theme.dividerColor.withOpacity(0.25))
                                    : null,
                                boxShadow: hasQuickNote
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF10B981).withOpacity(0.55),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            // Foto dentro do anel
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.scaffoldBackgroundColor,
                              ),
                              padding: const EdgeInsets.all(2.5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  story.avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.person),
                                ),
                              ),
                            ),
                            // Badge indicador de recado ativo (🎬 ou 🎙️)
                            if (hasQuickNote)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF059669),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      story.quickNote?.isVideo == true ? Icons.videocam : Icons.mic,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 66,
                          child: Text(
                            story.authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: (story.hasUnseen || hasQuickNote) ? FontWeight.bold : FontWeight.normal,
                              color: hasQuickNote
                                  ? const Color(0xFF059669)
                                  : (story.hasUnseen ? const Color(0xFF245C45) : null),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
