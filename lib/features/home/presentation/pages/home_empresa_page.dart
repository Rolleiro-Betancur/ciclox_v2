import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';

/// Home para rol EMPRESA
class HomeEmpresaPage extends StatelessWidget {
  const HomeEmpresaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmpresaHeader(),

              const SizedBox(height: 24),

              // Tarjetas de gestión
              GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.0,
                children: [
                  _EmpresaCard(
                    icon: Icons.assignment_outlined,
                    label: 'Solicitudes',
                    sublabel: 'Gestionar pedidos',
                    color: const Color(0xFF1A1F3C),
                    onTap: () => context.push(AppRoutes.empresaSolicitudes),
                  ),
                  _EmpresaCard(
                    icon: Icons.people_outlined,
                    label: 'Recolectores',
                    sublabel: 'Gestionar equipo',
                    color: const Color(0xFF2D7D46),
                    onTap: () => context.push(AppRoutes.empresaRecolectores),
                  ),
                  _EmpresaCard(
                    icon: Icons.recycling_rounded,
                    label: 'Reciclajes',
                    sublabel: 'Procesar RAEE',
                    color: const Color(0xFFB08800),
                    onTap: () => context.push(AppRoutes.empresaReciclajes),
                  ),
                  _EmpresaCard(
                    icon: Icons.bar_chart_rounded,
                    label: 'Reportes',
                    sublabel: 'Ver estadísticas',
                    color: const Color(0xFF7B3FBE),
                    onTap: () => context.push(AppRoutes.empresaReportes),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmpresaHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SoftClipper(),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.navyGradient),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          bottom: 44,
          left: 24,
          right: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panel Empresa',
                style:
                    AppTextStyles.heading1.copyWith(color: Colors.white)),
            const SizedBox(height: 4),
            Text('Bienvenido al panel de gestión',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _SoftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 24)
      ..quadraticBezierTo(
          size.width / 2, size.height + 8, size.width, size.height - 24)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(_SoftClipper old) => false;
}

class _EmpresaCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _EmpresaCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w800)),
                Text(sublabel,
                    style: AppTextStyles.caption
                        .copyWith(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
