import 'package:flutter/material.dart';
import 'profile_screen.dart';

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
    'Bebi água suficiente hoje': false,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = _checked.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hábitos e Bem-Estar', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Pequenos Passos, Sem Pressão',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Registros voluntários e 100% locais nesta demonstração. Você não precisa cumprir todas as metas.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _checked.isEmpty ? 0 : completed / _checked.length,
              minHeight: 10,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$completed de ${_checked.length} hábitos marcados hoje',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ..._checked.keys.map((habit) => Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: CheckboxListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              value: _checked[habit],
              activeColor: theme.colorScheme.primary,
              title: Text(habit, style: const TextStyle(fontWeight: FontWeight.w500)),
              onChanged: (value) => setState(() => _checked[habit] = value ?? false),
            ),
          )),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {
              for (final key in _checked.keys) {
                _checked[key] = false;
              }
            }),
            label: const Text('Limpar registros de demonstração'),
          ),
        ],
      ),
    );
  }
}
