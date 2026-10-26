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
          // Cabeçalho limpo da Aba PESSOAS QUE SIGO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
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

                return GestureDetector(
                  onTap: () {
                    if (onStoryTap != null) {
                      onStoryTap!(story);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Visualizando última partilha de ${story.authorName}'),
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
                            // Foto dentro do anel (Sem ícone de '+' conforme diretriz)
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
