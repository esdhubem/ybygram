import 'package:flutter/material.dart';
import '../services/mock_supabase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0; // 0: Painel Vendedor MEI, 1: Biblioteca E-books, 2: Histórico Hábitos

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supabase = MockSupabaseService();
    final user = supabase.currentUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar expansível com Capa e Avatar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    user.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF245C45)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configurações de privacidade soberana e segurança.')),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto do perfil com Selo Criador Soberano
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.avatarUrl),
                          ),
                          if (user.isSovereignCreator)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC85A32),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.verified, size: 16, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.handle,
                              style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF245C45)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    user.location,
                                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Bio
                  Text(
                    user.bio,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                  const SizedBox(height: 16),
                  // Banner de Status "Criador Soberano"
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF245C45).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF245C45).withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.workspace_premium, color: Color(0xFF245C45), size: 28),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: Criador Soberano Ativo',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF245C45), fontSize: 13),
                              ),
                              Text(
                                'Formação na Escola concluída. Painel de Vendas no Marketplace habilitado.',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Abas internas do Perfil
                  Row(
                    children: [
                      _buildTabButton(0, '🏪 Vendedor MEI'),
                      _buildTabButton(1, '📖 Biblioteca'),
                      _buildTabButton(2, '🌱 Hábitos & Pontos'),
                    ],
                  ),
                  const Divider(height: 24),
                  // Conteúdo da Aba Selecionada
                  if (_selectedTab == 0) _buildSellerPanel(theme, user),
                  if (_selectedTab == 1) _buildLibraryPanel(theme, user),
                  if (_selectedTab == 2) _buildHabitsHistoryPanel(theme, supabase),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF245C45) : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF245C45) : null,
            ),
          ),
        ),
      ),
    );
  }

  // 1. Painel do Vendedor MEI / Artesão
  Widget _buildSellerPanel(ThemeData theme, dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gestão de Produtos e Envios',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.local_shipping_outlined, size: 13, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('Melhor Envio Conectado', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(theme, 'Produtos Ativos', '${user.myStoreProducts.length}', Icons.inventory_2_outlined),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(theme, 'Pedidos Concluídos', '${user.completedOrdersCount}', Icons.check_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Meus Produtos no Marketplace:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        ...user.myStoreProducts.map((p) => Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(p.imageUrl, width: 44, height: 44, fit: BoxFit.cover),
            ),
            title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('${p.formattedPrice} • ${p.salesCount} vendas', style: const TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.edit_outlined, size: 18),
          ),
        )),
      ],
    );
  }

  // 2. Biblioteca Pessoal do Leitor (E-books e PDFs)
  Widget _buildLibraryPanel(ThemeData theme, dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meus E-books e Leituras Adquiridas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        const Text(
          'Seus livros digitais ficam disponíveis permanentemente para leitura direta ou download em PDF sem restrição.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        ...user.libraryEbooks.map((b) => Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(b.imageUrl, width: 60, height: 80, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(b.sellerName, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF245C45),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              minimumSize: const Size(60, 28),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.picture_as_pdf, size: 14),
                            label: const Text('Ler PDF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Abrindo leitor de PDF nativo do YBYgram...')),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              minimumSize: const Size(60, 28),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Download do arquivo iniciado com sucesso!')),
                              );
                            },
                            child: const Text('Download', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  // 3. Histórico de Hábitos e Pontos Acumulados
  Widget _buildHabitsHistoryPanel(ThemeData theme, MockSupabaseService supabase) {
    final h = supabase.habitsState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Saldo de Pontos de Saúde', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('${h.healthPoints} pts', style: const TextStyle(color: Color(0xFF245C45), fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              ListTile(
                dense: true,
                leading: const Icon(Icons.water_drop, color: Colors.blueAccent),
                title: const Text('Hidratação Diária', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                trailing: Text('${h.waterLiters} Litros', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                dense: true,
                leading: const Icon(Icons.directions_walk, color: Color(0xFF245C45)),
                title: const Text('Caminhada & Exercícios', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                trailing: Text('${h.walkMinutes} min (${h.caloriesBurned} kcal)', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                dense: true,
                leading: const Icon(Icons.menu_book, color: Color(0xFFC85A32)),
                title: const Text('Leitura & Saberes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                trailing: Text('${h.studyMinutes} min', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(ThemeData theme, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF245C45)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(title, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
