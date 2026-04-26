import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';

class SolicitudCanceladaPage extends StatelessWidget {
  const SolicitudCanceladaPage({super.key});

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
                    // Texto principal
                    Text(
                      'Solicitud\ncancelada.',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 48,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Texto secundario
                    Text(
                      'Tu solicitud fue cancelada correctamente',
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
                          backgroundColor: const Color(0xFFE8F3E8), // Color similar a solicitud enviada
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
            
            // Botonera Inferior simulada o menú de navegación si aplica
            // Si el diseño lleva nav bar aquí se puede usar bottomNavigationBar en el scaffold
            // Según la imagen, tiene un nav bar color crema en el fondo.
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
