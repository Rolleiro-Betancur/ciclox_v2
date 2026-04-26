import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmpresaReciclajesPage extends StatelessWidget {
  const EmpresaReciclajesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reciclajes')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Procesamiento de RAEE', style: AppTextStyles.heading2),
          const SizedBox(height: 10),
          Text(
            'Consulta reciclajes pendientes y completa el registro de procesamiento.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _StatusCard(
            title: 'Pendientes',
            value: '12',
            color: const Color(0xFFB08800),
          ),
          _StatusCard(
            title: 'Completados hoy',
            value: '5',
            color: const Color(0xFF2D7D46),
          ),
          _StatusCard(
            title: 'Total mensual',
            value: '83',
            color: const Color(0xFF1A1F3C),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
