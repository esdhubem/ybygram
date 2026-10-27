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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CABEÇALHO ESTILO TIKTOK / BIOLINK SOBERANO
                  // Avatar Circular com Suporte a Recado Rápido (WhatsApp 1:1)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🎙️ Recado Rápido: Toque para gravar ou ver status de 15 segundos')),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFC85A32)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 46,
                            backgroundImage: NetworkImage(user.avatarUrl),
                          ),
                        ),
                        if (user.isSovereignCreator)
                          Positioned(
                            bottom: 2,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF51DE06),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 4),
                                ],
                              ),
                              child: const Icon(Icons.check, size: 14, color: Colors.white),
                            ),
                          ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF245C45),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.videocam, size: 10, color: Colors.white),
                                SizedBox(width: 2),
                                Text(
                                  '15s',
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nome do Criador e Selo Criadora Soberana
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF81C784)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🌱', style: TextStyle(fontSize: 10)),
                            SizedBox(width: 3),
                            Text(
                              'Criadora Soberana',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF245C45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Alça (@) e Localização
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.handle,
                        style: const TextStyle(
                          color: Color(0xFFC85A32),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('•', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 6),
                      const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF245C45)),
                      const SizedBox(width: 2),
                      Text(
                        user.location,
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 1. BARRA DE CONEXÕES OFICIAIS & BIOLINK INTEGRADO (SUBSTITUTO DE SEGUIDORES / CURTIDAS)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.link, size: 14, color: Color(0xFF245C45)),
                            SizedBox(width: 4),
                            Text(
                              'CONEXÕES OFICIAIS • BIOLINK YBY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF245C45),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Instagram
                            _buildSocialButton(
                              icon: Icons.camera_alt,
                              color: const Color(0xFFE1306C),
                              tooltip: 'Instagram Oficial',
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('🌐 Abrindo Instagram oficial: @silviane.terra')),
                              ),
                            ),
                            // LinkedIn
                            _buildSocialButton(
                              icon: Icons.work_outline,
                              color: const Color(0xFF0A66C2),
                              tooltip: 'LinkedIn Profissional',
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('🌐 Abrindo LinkedIn oficial: Silviane Terra')),
                              ),
                            ),
                            // Facebook
                            _buildSocialButton(
                              icon: Icons.facebook,
                              color: const Color(0xFF1877F2),
                              tooltip: 'Comunidade no Facebook',
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('🌐 Abrindo Facebook oficial: Comunidade Silviane')),
                              ),
                            ),
                            // YouTube
                            _buildSocialButton(
                              icon: Icons.play_circle_fill,
                              color: const Color(0xFFFF0000),
                              tooltip: 'Canal no YouTube',
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('🌐 Abrindo YouTube oficial: Canal Saberes da Terra')),
                              ),
                            ),
                            // Spotify
                            _buildSocialButton(
                              icon: Icons.graphic_eq,
                              color: const Color(0xFF1DB954),
                              tooltip: 'Podcast no Spotify',
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('🌐 Abrindo Spotify oficial: Podcast Saberes Ancestrais')),
                              ),
                            ),
                            // Biolink
                            _buildSocialButton(
                              icon: Icons.share,
                              color: const Color(0xFF245C45),
                              tooltip: 'Copiar Biolink',
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('🔗 Link do perfil copiado com sucesso!')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // BOTÕES DE AÇÃO DO PERFIL (ESTILO TIKTOK SOBERANO)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black26),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Modo de edição do perfil')),
                            );
                          },
                          child: const Text('Editar Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF245C45),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🎙️ Abrindo gravador de Recado Rápido')),
                            );
                          },
                          icon: const Icon(Icons.radio, size: 14, color: Color(0xFFFCD34D)),
                          label: const Text('Recado Rápido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send_outlined, size: 18, color: Color(0xFF245C45)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🔗 Compartilhando Perfil Soberano')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2. BIOGRAFIA DE PROPÓSITO E SABERES
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      user.bio,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
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

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
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
