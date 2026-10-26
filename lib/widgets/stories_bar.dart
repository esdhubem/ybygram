import 'package:flutter/material.dart';
import '../models/post.dart';

class StoriesBar extends StatelessWidget {
  final List<StoryItem> stories;
  final Function(StoryItem)? onStoryTap;

  const StoriesBar({
    super.key,
    required this.stories,
    this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          // Cabeçalho da Aba Pessoas que Sigo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_outline, size: 16, color: Color(0xFF245C45)),
                    const SizedBox(width: 6),
                    Text(
                      'Pessoas que Sigo',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF245C45),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Novos saberes recentes',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Lista horizontal de Avatares Circulares
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final isFirst = index == 0;

                return GestureDetector(
                  onTap: () {
                    if (onStoryTap != null) {
                      onStoryTap!(story);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Partilha de saberes de ${story.authorName}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
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
                            // Anel circular: destaque visual em verde-mata (#245C45) para novo saber publicado
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: story.hasUnseen
                                    ? const Color(0xFF245C45)
                                    : theme.dividerColor.withOpacity(0.25),
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
                            // Ícone de adicionar no seu saber
                            if (isFirst)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF245C45),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5),
                                  ),
                                  child: const Icon(Icons.add, size: 14, color: Colors.white),
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
                              fontWeight: story.hasUnseen ? FontWeight.bold : FontWeight.normal,
                              color: story.hasUnseen ? const Color(0xFF245C45) : null,
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
