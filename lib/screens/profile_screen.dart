import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            child: Icon(Icons.person, size: 48, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 14),
          Text(
            'Perfil YBYgram',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalize sua apresentação e acompanhe sua trilha de saberes e aprendizagem.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: const ListTile(
              leading: Icon(Icons.workspace_premium_outlined, color: Color(0xFFC85A32)),
              title: Text('Selo Criador Soberano', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                'A trilha e os critérios de conclusão serão conectados ao perfil na próxima etapa.',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: const ListTile(
              leading: Icon(Icons.shield_outlined, color: Color(0xFF245C45)),
              title: Text('Soberania e Privacidade', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                'Seus dados permanecem no seu dispositivo com controle total e transparente.',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: const ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Preferências do Aplicativo', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Configurações de tema, notificações e idioma.'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
