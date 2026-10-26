import 'package:flutter/material.dart';
import '../services/mock_supabase_service.dart';
import '../models/course.dart';
import 'profile_screen.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  void _openLessonPlayer(LessonItem lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Player de vídeo leve / embed placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.play_circle_filled, size: 64, color: Color(0xFFC85A32)),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lesson.duration,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lesson.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                lesson.summary,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF245C45),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(lesson.isCompleted ? Icons.check_circle : Icons.done),
                label: Text(lesson.isCompleted ? 'Aula Concluída' : 'Marcar como Assistida'),
                onPressed: () {
                  setState(() => lesson.isCompleted = true);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Progresso salvo na Escola Soberana!')),
                  );
                },
              ),
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
    final modules = supabase.schoolModules;

    int totalLessons = 0;
    int completedLessons = 0;
    for (var m in modules) {
      totalLessons += m.totalLessons;
      completedLessons += m.completedLessons;
    }
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;
    final isCertified = completedLessons >= totalLessons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escola Soberana', style: TextStyle(fontWeight: FontWeight.bold)),
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
          // Cartão de Progresso e Selo Criador Soberano
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF245C45),
                  const Color(0xFF183F2F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF245C45).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trilha Criador Soberano',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCertified ? const Color(0xFFC85A32) : Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCertified ? Icons.verified : Icons.lock_clock,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCertified ? 'SELO ATIVO' : 'EM FORMAÇÃO',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete os módulos sobre letramento digital, regras comunitárias e legislação para desbloquear o painel de vendas no Marketplace.',
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.35),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC85A32)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedLessons de $totalLessons aulas concluídas (${(progress * 100).toInt()}%)',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Lista de Módulos
          ...modules.map((module) => Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              shape: const Border(),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF245C45).withOpacity(0.12),
                child: Icon(
                  module.isCompleted ? Icons.check : Icons.school_outlined,
                  color: const Color(0xFF245C45),
                ),
              ),
              title: Text(
                module.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Text(
                '${module.completedLessons}/${module.totalLessons} aulas • ${module.description}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
              children: module.lessons.map((lesson) => ListTile(
                leading: Icon(
                  lesson.isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                  color: lesson.isCompleted ? const Color(0xFF245C45) : theme.iconTheme.color,
                ),
                title: Text(lesson.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                subtitle: Text('${lesson.duration} • Toque para assistir', style: const TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () => _openLessonPlayer(lesson),
              )).toList(),
            ),
          )),
          const SizedBox(height: 10),
          // Aviso Ético de Fitoterapia e Saúde
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
                      Icon(Icons.shield_outlined, color: Color(0xFFC85A32), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Diretrizes Éticas de Fitoterapia e Saúde',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC85A32)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'As informações compartilhadas na plataforma têm caráter exclusivamente cultural, '
                    'histórico e etnobotânico. Jamais substitua consultas, diagnósticos ou tratamentos médicos. '
                    'É expressamente proibido anunciar "curas milagrosas" no YBYgram.',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
