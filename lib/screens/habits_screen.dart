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
  double _userWeightKg = 68.0;
  double _userHeightM = 1.72;

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
          const SizedBox(height: 16),
          // Monitor e Contador de IMC (Índice de Massa Corporal)
          _buildImcCard(theme),
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

  Widget _buildImcCard(ThemeData theme) {
    final double imc = _userWeightKg / (_userHeightM * _userHeightM);
    
    String imcCategory;
    Color imcColor;
    String imcTip;
    double sliderPercent; // 0.0 a 1.0 para posicionar a agulha na régua (faixa de 15 a 35)

    if (imc < 18.5) {
      imcCategory = 'Abaixo do peso';
      imcColor = Colors.lightBlue;
      imcTip = 'Nutrição consciente: inclua carboidratos complexos da terra, castanhas e raízes nutritivas.';
      sliderPercent = ((imc - 15) / 20).clamp(0.05, 0.22);
    } else if (imc < 25.0) {
      imcCategory = 'Peso Saudável';
      imcColor = const Color(0xFF245C45);
      imcTip = 'Equilíbrio exemplar! Mantenha a hidratação pura, sono reparador e caminhadas ativas.';
      sliderPercent = 0.25 + ((imc - 18.5) / 6.5) * 0.25;
    } else if (imc < 30.0) {
      imcCategory = 'Sobrepeso Leve';
      imcColor = const Color(0xFFD48B38);
      imcTip = 'Dica da Terra: priorize refeições coloridas e aumente 15 min de caminhada diária.';
      sliderPercent = 0.50 + ((imc - 25.0) / 5.0) * 0.25;
    } else {
      imcCategory = 'Obesidade';
      imcColor = const Color(0xFFC85A32);
      imcTip = 'Passo a passo consciente: reduza açúcares refinados e fortaleça sua rotina com apoio comunitário.';
      sliderPercent = 0.75 + ((imc - 30.0) / 10.0).clamp(0.0, 0.22);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do Card de IMC
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF245C45).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ],
                    child: const Icon(Icons.monitor_weight_outlined, color: Color(0xFF245C45), size: 18),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ÍNDICE DE MASSA CORPORAL (IMC)',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                      ),
                      Text(
                        'Monitore sua saúde e equilíbrio físico',
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: imcColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: imcColor.withOpacity(0.4)),
                ),
                child: Text(
                  imcCategory,
                  style: TextStyle(
                    color: imcColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Valor em Destaque do IMC
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  imc.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: imcColor,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'kg/m²',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Régua Visual Colorida com Agulha Indicadora
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    Expanded(child: Container(height: 8, color: Colors.lightBlue.shade300)),
                    const SizedBox(width: 2),
                    Expanded(child: Container(height: 8, color: const Color(0xFF245C45))),
                    const SizedBox(width: 2),
                    Expanded(child: Container(height: 8, color: const Color(0xFFD48B38))),
                    const SizedBox(width: 2),
                    Expanded(child: Container(height: 8, color: const Color(0xFFC85A32))),
                  ],
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 64) * sliderPercent.clamp(0.02, 0.96),
                top: -5,
                child: Container(
                  width: 14,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: imcColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('< 18.5', style: TextStyle(fontSize: 9, color: Colors.grey)),
              Text('18.5 - 24.9', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('25 - 29.9', style: TextStyle(fontSize: 9, color: Colors.grey)),
              Text('30+', style: TextStyle(fontSize: 9, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 14),

          // Controles de Peso e Altura com botões [-] e [+]
          Row(
            children: [
              // Ajuste de Peso
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      const Text('Peso (kg)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      Text(
                        '${_userWeightKg.toStringAsFixed(1)} kg',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_userWeightKg > 35) {
                                setState(() => _userWeightKg -= 0.5);
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                              ),
                              child: const Icon(Icons.remove, size: 14),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              if (_userWeightKg < 220) {
                                setState(() => _userWeightKg += 0.5);
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                              ),
                              child: const Icon(Icons.add, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Ajuste de Altura
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      const Text('Altura (m)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      Text(
                        '${_userHeightM.toStringAsFixed(2)} m',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_userHeightM > 1.20) {
                                setState(() => _userHeightM -= 0.01);
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                              ),
                              child: const Icon(Icons.remove, size: 14),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              if (_userHeightM < 2.30) {
                                setState(() => _userHeightM += 0.01);
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                              ),
                              child: const Icon(Icons.add, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Caixa de Dica Consciente Comunitária
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: imcColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: imcColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.eco_outlined, color: imcColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    imcTip,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withOpacity(0.85),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
