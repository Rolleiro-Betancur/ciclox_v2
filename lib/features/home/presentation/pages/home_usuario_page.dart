import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';

class HomeUsuarioPage extends StatelessWidget {
  final String nombreUsuario;
  const HomeUsuarioPage({super.key, this.nombreUsuario = 'Usuario'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // ── Top bar ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo ciclox
                  _CicloxLogoText(),
                  // Notificaciones
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.notificaciones),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: AppColors.navy,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // ── Greeting ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Bienvenida',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    '$nombreUsuario!',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 42,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '¿Que quieres hacer hoy?',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

              const SizedBox(height: 24),

              // ── Grid 2×2 ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Tus puntos — navy oscuro
                    _HomeCard(
                      label: 'Tus\npuntos',
                      backgroundColor: AppColors.navy,
                      textColor: Colors.white,
                      onTap: () => context.push(AppRoutes.tusPuntos),
                    ),

                    // Registrar Dispositivo — blanco
                    _HomeCard(
                      label: 'Registrar\nDispositivo',
                      backgroundColor: Colors.white,
                      textColor: AppColors.navy,
                      hasBorder: true,
                      onTap: () =>
                          context.push(AppRoutes.registroDispositivo),
                    ),

                    // Tus Solicitudes — blanco
                    _HomeCard(
                      label: 'Tus\nSolicitudes',
                      backgroundColor: Colors.white,
                      textColor: AppColors.navy,
                      hasBorder: true,
                      onTap: () =>
                          context.push(AppRoutes.solicitudes),
                    ),

                    // Sigue tu reciclaje — con mapa
                    _MapCard(
                      onTap: () =>
                          context.push(AppRoutes.trazabilidad),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ─────────────────────────────────
      bottomNavigationBar: _BottomNav(
        onSettings: () {},
        onHome: () {},
        onRewards: () => context.push(AppRoutes.tusPuntos),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS PRIVADOS
// ─────────────────────────────────────────────────────────────

class _CicloxLogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "cl" en navy
        Text(
          'cl',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.navy,
          ),
        ),
        // Ícono de reciclaje como la "o"
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          child: const Icon(
            Icons.recycling_rounded,
            color: AppColors.accent,
            size: 24,
          ),
        ),
        Text(
          'x',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool hasBorder;
  final VoidCallback onTap;

  const _HomeCard({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: hasBorder
              ? Border.all(color: const Color(0xFFE0E0E0), width: 1.5)
              : null,
          boxShadow: hasBorder
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.bottomLeft,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textColor,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

/// Card del mapa — fondo con imagen/mapa y texto superpuesto
class _MapCard extends StatelessWidget {
  final VoidCallback onTap;
  const _MapCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFE8F5E9),
          border: Border.all(color: const Color(0xFFCCE5CC), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Fondo simulando mapa
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(),
              ),
            ),

            // Botón zoom + / -
            Positioned(
              right: 8,
              top: 8,
              child: Column(
                children: [
                  _MapButton(icon: Icons.add),
                  const SizedBox(height: 4),
                  _MapButton(icon: Icons.remove),
                ],
              ),
            ),

            // Ícono de reciclaje centrado
            Positioned(
              left: 0,
              right: 40,
              top: 0,
              bottom: 30,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.recycling_rounded,
                      color: AppColors.navy, size: 22),
                ),
              ),
            ),

            // Texto inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.18),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text(
                  'Sigue\ntu reciclaje',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  const _MapButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, size: 16, color: AppColors.navy),
    );
  }
}

/// Painter que simula un fondo de mapa con calles
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8F0E8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final thinRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Calles horizontales
    canvas.drawLine(
        Offset(0, size.height * 0.3),
        Offset(size.width, size.height * 0.3),
        roadPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.6),
        Offset(size.width, size.height * 0.6),
        thinRoadPaint);

    // Calles verticales
    canvas.drawLine(
        Offset(size.width * 0.35, 0),
        Offset(size.width * 0.35, size.height),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height),
        thinRoadPaint);

    // Bloques de manzana
    final blockPaint = Paint()
      ..color = const Color(0xFFD4E8D4).withOpacity(0.6);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(4, 4, size.width * 0.3, size.height * 0.24),
          const Radius.circular(4),
        ),
        blockPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.4, 4, size.width * 0.26,
              size.height * 0.24),
          const Radius.circular(4),
        ),
        blockPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(4, size.height * 0.35, size.width * 0.3,
              size.height * 0.22),
          const Radius.circular(4),
        ),
        blockPaint);
  }

  @override
  bool shouldRepaint(_MapPainter old) => false;
}

// ─────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onHome;
  final VoidCallback onRewards;

  const _BottomNav({
    required this.onSettings,
    required this.onHome,
    required this.onRewards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Configuración
          _NavItem(
            icon: Icons.settings_outlined,
            onTap: onSettings,
            isActive: false,
          ),
          // Home — activo
          _NavItem(
            icon: Icons.home_rounded,
            onTap: onHome,
            isActive: true,
          ),
          // Recompensas/Puntos
          _NavItem(
            icon: Icons.stars_rounded,
            onTap: onRewards,
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Icon(
          icon,
          size: 26,
          color: isActive ? AppColors.navy : AppColors.textSecondary,
        ),
      ),
    );
  }
}
