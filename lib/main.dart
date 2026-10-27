import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/feed_screen.dart';
import 'screens/school_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YbygramApp());
}

class YbygramApp extends StatelessWidget {
  const YbygramApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Paleta de Cores Oficial do YBYgram
    const primaryVerdeMata = Color(0xFF245C45);
    const fundoBegeNatural = Color(0xFFF8F6F0);
    const terracota = Color(0xFFC85A32);

    return MaterialApp(
      title: 'YBYgram',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      // TEMA CLARO (Bege Natural / Verde Mata)
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fundoBegeNatural,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryVerdeMata,
          primary: primaryVerdeMata,
          secondary: terracota,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: fundoBegeNatural,
          foregroundColor: primaryVerdeMata,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
      ),
      // TEMA ESCURO (Tons Terrosos Profundos)
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF171512),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryVerdeMata,
          primary: const Color(0xFF52A37F),
          secondary: terracota,
          surface: const Color(0xFF1F1B17),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF171512),
          foregroundColor: Color(0xFFF3EFEA),
          elevation: 0,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FeedScreen(),
    SchoolScreen(),
    HabitsScreen(),
    MarketplaceScreen(),
  ];

  void _showMenuPoliciesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F6F0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF245C45).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.menu, color: Color(0xFF245C45), size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Menu & Governança YBY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Políticas, Soberania e Benefícios Éticos', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('📜 DIRETRIZES & POLÍTICAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF245C45))),
              const SizedBox(height: 8),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined, color: Color(0xFF245C45)),
                title: const Text('Termos de Uso Soberanos', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Direitos autorais comunitários, sem rastreamento abusivo', style: TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📜 Exibindo Termos de Uso Soberanos do YBYgram')));
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.shield_outlined, color: Color(0xFFC85A32)),
                title: const Text('Diretrizes da Comunidade', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Fim da vaidade, respeito mútuo e fitoterapia ética', style: TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🛡️ Diretrizes da Comunidade YBYgram')));
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.lock_outline, color: Color(0xFF0284C7)),
                title: const Text('Política de Privacidade & LGPD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Armazenamento local, criptografia e dados sob seu controle', style: TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔒 Política de Privacidade & LGPD')));
                },
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🎟️ RESGATE DE CUPONS ÉTICOS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Lomadee Parceiros', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard, color: Color(0xFFC85A32), size: 24),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Livraria Floresta Viva — 15% OFF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Cupom: YBYFLORESTA15 • Selo Lomadee 6% Fundo', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF245C45),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 Cupom YBYFLORESTA15 copiado com sucesso!')));
                      },
                      child: const Text('Copiar', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            _showMenuPoliciesSheet(context);
          } else {
            setState(() => _currentIndex = index);
          }
        },
        indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu, color: Color(0xFF059669)),
            selectedIcon: Icon(Icons.menu_open, color: Color(0xFF059669)),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined, color: Color(0xFF0284C7)),
            selectedIcon: Icon(Icons.school, color: Color(0xFF0284C7)),
            label: 'Aulas',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline, color: Color(0xFFE11D48)),
            selectedIcon: Icon(Icons.favorite, color: Color(0xFFE11D48)),
            label: 'Hábitos',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined, color: Color(0xFFEA580C)),
            selectedIcon: Icon(Icons.storefront, color: Color(0xFFEA580C)),
            label: 'Loja',
          ),
        ],
      ),
    );
  }
}
