import 'package:flutter/material.dart';
import '../services/mock_supabase_service.dart';
import '../models/habit.dart';
import 'profile_screen.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _foodController = TextEditingController();

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  void _showAddFoodDialog(HealthHabitsState habits, List<FoodItem> database) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alimentação Consciente Comunitária',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Selecione um alimento típico ou tradicional para somar às calorias do dia:', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              ...database.map((food) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restaurant_menu, color: Color(0xFF245C45), size: 20),
                title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                subtitle: Text('${food.portion} • ${food.category}', style: const TextStyle(fontSize: 11)),
                trailing: Text('+${food.calories} kcal', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC85A32))),
                onTap: () {
                  setState(() {
                    habits.addFoodCalories(food.calories);
                    habits.healthPoints += 10;
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${food.name} registrado (+10 pontos de saúde)!')),
                  );
                },
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supabase = MockSupabaseService();
    final h = supabase.habitsState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hábitos & Bem-Estar', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Meu Perfil',
            icon: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(supabase.currentUser.avatarUrl),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner de Pontos de Saúde & Cupons
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF245C45), Color(0xFF317C5D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SEUS PONTOS DE SAÚDE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${h.healthPoints} Pontos Yby',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Convertíveis em cupons de frete e desconto no Marketplace comunitário!',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC85A32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Você tem ${h.healthPoints} pontos! Cupom "YBYSAUDE" gerado para a Loja.')),
                    );
                  },
                  child: const Text('Resgatar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Check-ins Diários de Bem-Estar',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Grid dos 4 Hábitos Principais
          Row(
            children: [
              // Água
              Expanded(
                child: _buildHabitCard(
                  theme: theme,
                  icon: Icons.water_drop_outlined,
                  iconColor: Colors.blueAccent,
                  title: 'Água Ingerida',
                  value: '${h.waterLiters.toStringAsFixed(2)} L',
                  sub: 'Meta: 2.0 L',
                  buttonLabel: '+ Copo (250ml)',
                  onTap: () => setState(() => h.addWaterGlass()),
                ),
              ),
              const SizedBox(width: 12),
              // Sono
              Expanded(
                child: _buildHabitCard(
                  theme: theme,
                  icon: Icons.bedtime_outlined,
                  iconColor: Colors.deepPurpleAccent,
                  title: 'Sono Reparador',
                  value: '${h.sleepHours.toStringAsFixed(1)} h',
                  sub: 'Meta: 8.0 h',
                  buttonLabel: 'Ajustar',
                  onTap: () => setState(() => h.sleepHours = (h.sleepHours + 0.5) % 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Caminhada & Exercício com calorias
              Expanded(
                child: _buildHabitCard(
                  theme: theme,
                  icon: Icons.directions_walk,
                  iconColor: const Color(0xFF245C45),
                  title: 'Caminhada/Atividade',
                  value: '${h.walkMinutes} min',
                  sub: '~${h.caloriesBurned} kcal gastas',
                  buttonLabel: '+15 min',
                  onTap: () => setState(() => h.updateWalkMinutes(h.walkMinutes + 15)),
                ),
              ),
              const SizedBox(width: 12),
              // Leitura & Estudo
              Expanded(
                child: _buildHabitCard(
                  theme: theme,
                  icon: Icons.menu_book_outlined,
                  iconColor: const Color(0xFFC85A32),
                  title: 'Estudo/Leitura',
                  value: '${h.studyMinutes} min',
                  sub: 'Meta: 30 min',
                  buttonLabel: '+10 min',
                  onTap: () => setState(() {
                    h.studyMinutes += 10;
                    h.healthPoints += 10;
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Seção de Alimentação e Calorias
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alimentação Comunitária',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total consumido hoje: ${h.caloriesConsumed} kcal',
                    style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Registrar'),
                onPressed: () => _showAddFoodDialog(h, supabase.foodDatabase),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Lista de alimentos sugeridos
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, idx) {
                final item = supabase.foodDatabase[idx];
                return ListTile(
                  dense: true,
                  title: Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  subtitle: Text(item.category, style: const TextStyle(fontSize: 11)),
                  trailing: Text('${item.calories} kcal', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHabitCard({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String sub,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          Text(
            sub,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                foregroundColor: theme.colorScheme.primary,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: onTap,
              child: Text(buttonLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
