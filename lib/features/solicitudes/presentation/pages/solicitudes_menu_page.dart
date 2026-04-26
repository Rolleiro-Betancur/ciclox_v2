import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';

class SolicitudesMenuPage extends StatelessWidget {
  const SolicitudesMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CicloxLogo(height: 30),
                  const Icon(Icons.notifications_rounded,
                      color: AppColors.navy, size: 28),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tus\nSolicitudes',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.navy,
                      fontSize: 48,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestiona tus recogidas',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Botón Crear Solicitud
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.crearSolicitud),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Crear\nSolicitud',
                            style: AppTextStyles.heading1.copyWith(
                              color: Colors.white,
                              fontSize: 36,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botón Tus Solicitudes
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.misSolicitudes),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.textSecondary.withOpacity(0.5), width: 1),
                          ),
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tus\nSolicitudes',
                            style: AppTextStyles.heading1.copyWith(
                              color: AppColors.navy,
                              fontSize: 36,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F3E8), // Verde claro estilo crema
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.settings, color: AppColors.navy),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.home, color: AppColors.navy, size: 32),
              onPressed: () => context.go(AppRoutes.homeUsuario),
            ),
            IconButton(
              icon: const Icon(Icons.stars, color: AppColors.navy),
              onPressed: () => context.go(AppRoutes.tusPuntos),
            ),
          ],
        ),
      ),
    );
  }
}
