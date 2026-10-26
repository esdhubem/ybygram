import 'package:flutter/material.dart';
import 'marketplace_screen.dart';
import 'profile_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _tab = 0;
  final _tabs = const ['Saberes', 'Vídeos', 'Produtos', 'Leitura'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YBYgram',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            tooltip: 'Meu perfil',
            icon: const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person_outline, size: 20),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = _tab == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_tabs[index]),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.18),
                    labelStyle: TextStyle(
                      color: isSelected ? theme.colorScheme.primary : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) => setState(() => _tab = index),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: switch (_tab) {
              0 => const _PostList(),
              1 => const _VideoPlaceholder(),
              2 => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ProductGrid(compact: true),
                ),
              _ => const _ReadingList(),
            },
          ),
        ],
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posts = [
      (
        'Roda de saberes comunitários',
        'Como os conhecimentos locais e tradicionais ajudam a preservar a biodiversidade e fortalecer a comunidade?',
        Icons.eco_outlined,
      ),
      (
        'Consumo consciente e solidário',
        'Pequenas escolhas diárias abrem caminhos para conversas reais sobre origem, trabalho justo e impacto ambiental.',
        Icons.lightbulb_outline,
      ),
      (
        'Comunicação Livre e Soberana',
        'Construindo pontes entre criadores, saberes ancestrais e redes descentralizadas no Brasil.',
        Icons.people_outline,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                      child: Icon(post.$3, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        post.$1,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Chip(
                      label: const Text('Comunidade', style: TextStyle(fontSize: 11)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post.$2, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border, size: 20),
                      onPressed: () {},
                      tooltip: 'Apoiar',
                    ),
                    const Text('Apoiar'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      onPressed: () {},
                      tooltip: 'Comentar',
                    ),
                    const Text('Conversar'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, size: 20),
                      onPressed: () {},
                      tooltip: 'Salvar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_circle_outline, size: 64, color: theme.colorScheme.secondary),
            const SizedBox(height: 14),
            Text(
              'Espaço de Vídeos e Rodas Vivas',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Os vídeos e relatos audiovisuais aparecerão aqui quando o serviço de mídia distribuída for ativado.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingList extends StatelessWidget {
  const _ReadingList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const items = [
      ('Cartilhas e saberes tradicionais', 'Materiais educativos e cartilhas comunitárias'),
      ('Ensaios independentes', 'Textos sobre comunicação livre e autonomia tecnológica'),
      ('Acervo literário comunitário', 'Vitrine de publicações independentes e autores brasileiros'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: items.map((item) => Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(Icons.menu_book_outlined, color: theme.colorScheme.primary),
          ),
          title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(item.$2),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biblioteca comunitária em fase de catalogação.')),
          ),
        ),
      )).toList(),
    );
  }
}
