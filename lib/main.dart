import 'package:flutter/material.dart';

void main() => runApp(const YbyGramApp());

class YbyGramApp extends StatelessWidget {
  const YbyGramApp({super.key});

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF245C45);
    return MaterialApp(
      title: 'YbyGram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forest,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F6F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F6F0),
          foregroundColor: Color(0xFF20382D),
          centerTitle: false,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forest,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    FeedScreen(),
    StoreScreen(),
    EducationScreen(),
    HabitsScreen(),
  ];

  static const _titles = ['YbyGram', 'Loja', 'Aulas e Direitos', 'Hábitos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex],
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Loja'),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Aulas'),
          NavigationDestination(icon: Icon(Icons.spa_outlined), label: 'Hábitos'),
        ],
      ),
    );
  }
}

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
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_tabs[index]),
                  selected: _tab == index,
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
            2 => const _ProductGrid(compact: true),
            _ => const _ReadingList(),
          },
        ),
      ],
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList();

  @override
  Widget build(BuildContext context) {
    // Conteúdo demonstrativo: substituir por repositório/backend real.
    final posts = [
      ('Roda de saberes', 'Como os conhecimentos locais ajudam a preservar a biodiversidade?', Icons.eco_outlined),
      ('Consumo consciente', 'Pequenas escolhas podem abrir espaço para conversas sobre origem, trabalho e impacto ambiental.', Icons.lightbulb_outline),
      ('Comunidade', 'Compartilhe experiências, faça perguntas e respeite diferentes perspectivas.', Icons.people_outline),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CircleAvatar(child: Icon(post.$3)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(post.$1, style: Theme.of(context).textTheme.titleMedium)),
                  const Chip(label: Text('Demonstração')),
                ]),
                const SizedBox(height: 12),
                Text(post.$2),
                const SizedBox(height: 8),
                const Row(children: [
                  Icon(Icons.favorite_border, size: 20),
                  SizedBox(width: 6),
                  Text('Curtir'),
                  SizedBox(width: 20),
                  Icon(Icons.bookmark_border, size: 20),
                  SizedBox(width: 6),
                  Text('Salvar'),
                ]),
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
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_outline, size: 64),
              SizedBox(height: 12),
              Text('Espaço de vídeos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Os vídeos aparecerão aqui quando o serviço de mídia estiver integrado.'),
            ],
          ),
        ),
      );
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  static const products = [
    ('Camiseta YbyGram', 'Loja oficial', 'R$ 59,90', Icons.checkroom_outlined),
    ('Caderno artesanal', 'Criador independente', 'R$ 32,00', Icons.menu_book_outlined),
    ('Biojoia autoral', 'Artesanato comunitário', 'R$ 45,00', Icons.auto_awesome_outlined),
    ('Livro independente', 'Livraria', 'R$ 39,90', Icons.book_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('Comércio comunitário', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Vitrine demonstrativa. Preços e produtos abaixo são exemplos, não ofertas reais.'),
        const SizedBox(height: 12),
        const _ProductGrid(),
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final bool compact;
  const _ProductGrid({this.compact = false});

  static const products = StoreScreen.products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: compact,
      physics: compact ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.73,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Detalhes de produto serão integrados nesta etapa.')),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(p.$4, size: 54),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(p.$1, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(p.$2, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(p.$3, style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  static const modules = [
    'Saberes tradicionais e comunicação responsável',
    'Liberdade de expressão e debate público',
    'Direitos autorais e publicação independente',
    'Privacidade e segurança digital',
    'Bem-estar e uso consciente das telas',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Trilha Criador Soberano', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Formação demonstrativa. O progresso ainda não é salvo em uma conta.'),
        const SizedBox(height: 12),
        ...modules.asMap().entries.map((entry) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${entry.key + 1}')),
            title: Text(entry.value),
            subtitle: const Text('Aula e material de apoio'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conteúdo da aula será adicionado nesta etapa.')),
            ),
          ),
        )),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aviso sobre conteúdos de saúde', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Este conteúdo compartilha informações culturais, históricas e etnobotânicas. Não substitui avaliação, diagnóstico ou acompanhamento de profissional de saúde. O uso de plantas pode apresentar riscos, interações e contraindicações.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final Map<String, bool> _checked = {
    'Li por alguns minutos': false,
    'Fiz uma pausa ou respirei com calma': false,
    'Movimentei meu corpo': false,
    'Passei um tempo ao ar livre': false,
  };

  @override
  Widget build(BuildContext context) {
    final completed = _checked.values.where((v) => v).length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Pequenos passos, sem pressão', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Registros voluntários e locais nesta demonstração. Você não precisa cumprir todas as metas.'),
        const SizedBox(height: 16),
        LinearProgressIndicator(value: completed / _checked.length),
        const SizedBox(height: 8),
        Text('$completed de ${_checked.length} atividades marcadas'),
        const SizedBox(height: 8),
        ..._checked.keys.map((habit) => Card(
          child: CheckboxListTile(
            value: _checked[habit],
            title: Text(habit),
            onChanged: (value) => setState(() => _checked[habit] = value ?? false),
          ),
        )),
        TextButton(
          onPressed: () => setState(() {
            for (final key in _checked.keys) {
              _checked[key] = false;
            }
          }),
          child: const Text('Limpar registros de demonstração'),
        ),
      ],
    );
  }
}

class _ReadingList extends StatelessWidget {
  const _ReadingList();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Cartilhas e saberes', 'Materiais educativos da comunidade'),
      ('Ensaios independentes', 'Textos longos e reflexões'),
      ('Livros de autores brasileiros', 'Vitrine de publicações independentes'),
    ];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: items.map((item) => Card(
        child: ListTile(
          leading: const Icon(Icons.menu_book_outlined, size: 32),
          title: Text(item.$1),
          subtitle: Text(item.$2),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biblioteca demonstrativa; catálogo ainda não conectado.')),
          ),
        ),
      )).toList(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(radius: 42, child: Icon(Icons.person_outline, size: 44)),
          const SizedBox(height: 12),
          Text('Perfil YbyGram', textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Personalize sua apresentação e acompanhe sua trilha de aprendizagem.',
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          const Card(
            child: ListTile(
              leading: Icon(Icons.workspace_premium_outlined),
              title: Text('Selo Criador Soberano'),
              subtitle: Text('A trilha e os critérios de conclusão serão conectados ao perfil após a implementação de contas.'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Preferências e privacidade'),
              subtitle: Text('Configurações demonstrativas; persistência ainda não implementada.'),
            ),
          ),
        ],
      ),
    );
  }
}
