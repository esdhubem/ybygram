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
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore, color: Color(0xFF245C45)),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: Color(0xFF245C45)),
            label: 'Aulas',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite, color: Color(0xFF245C45)),
            label: 'Hábitos',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: Color(0xFF245C45)),
            label: 'Loja',
          ),
        ],
      ),
    );
  }
}
