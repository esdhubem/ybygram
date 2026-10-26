import 'package:flutter/material.dart';
import 'profile_screen.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({super.key});

  static const modules = [
    'Saberes tradicionais e comunicação responsável',
    'Liberdade de expressão e debate público',
    'Direitos autorais e publicação independente',
    'Privacidade, criptografia e segurança digital',
    'Bem-estar e uso consciente das telas',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escola de Saberes', style: TextStyle(fontWeight: FontWeight.bold)),
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
            'Trilha Criador Soberano',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Formação demonstrativa para incentivo à autonomia cultural e digital.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          ...modules.asMap().entries.map((entry) => Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: Text(
                  '${entry.key + 1}',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Aula e material de apoio comunitário'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conteúdo da aula será adicionado nesta etapa.')),
              ),
            ),
          )),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: const Color(0xFFC85A32).withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: const Color(0xFFC85A32).withOpacity(0.25)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFFC85A32)),
                      SizedBox(width: 8),
                      Text(
                        'Aviso sobre conteúdos de saúde',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC85A32)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Este conteúdo compartilha informações culturais, históricas e etnobotânicas. '
                    'Não substitui avaliação, diagnóstico ou acompanhamento de profissional de saúde. '
                    'O uso de plantas pode apresentar riscos, interações e contraindicações.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
