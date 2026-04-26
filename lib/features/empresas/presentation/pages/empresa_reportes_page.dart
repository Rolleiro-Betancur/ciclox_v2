import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmpresaReportesPage extends StatelessWidget {
  const EmpresaReportesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Centro de reportes', style: AppTextStyles.heading2),
          const SizedBox(height: 10),
          Text(
            'Descarga y consulta indicadores de recolección, reciclaje y desempeño.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _ReportTile(
            icon: Icons.insert_chart_outlined_rounded,
            title: 'Reporte de reciclajes',
            subtitle: 'Consolidado por periodo',
          ),
          _ReportTile(
            icon: Icons.route_outlined,
            title: 'Reporte de rutas',
            subtitle: 'Atención por recolector',
          ),
          _ReportTile(
            icon: Icons.assessment_outlined,
            title: 'Reporte de solicitudes',
            subtitle: 'Aceptadas, rechazadas y completadas',
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ReportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTextStyles.labelLarge),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.download_rounded),
      ),
    );
  }
}
