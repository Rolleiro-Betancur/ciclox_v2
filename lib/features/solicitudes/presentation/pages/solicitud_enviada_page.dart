import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';

class SolicitudEnviadaPage extends StatelessWidget {
  const SolicitudEnviadaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CicloxLogo(height: 30),
                  const Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 28),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Círculo Verde con Check
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.navy,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Texto principal
                    Text(
                      'Solicitud Enviada',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    
                    // Texto secundario
                    Text(
                      'Te notificaremos cuando sea aceptada',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Botón Volver
                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: () => context.go(AppRoutes.homeUsuario),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8F3E8), // Un verde muy claro según diseño
                          foregroundColor: AppColors.navy,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Volver al inicio',
                          style: AppTextStyles.buttonSecondary.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
