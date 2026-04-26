import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';

/// Página placeholder de notificaciones
class NotificacionesPage extends StatelessWidget {
  const NotificacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CicloxHeader(title: 'NOTIFICACIONES', showBack: true),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.navy.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none_rounded,
                          color: AppColors.navy, size: 46),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sin notificaciones',
                      style: AppTextStyles.heading3
                          .copyWith(color: AppColors.navy),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Te avisaremos aquí cuando haya\nnovedades sobre tus solicitudes',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
