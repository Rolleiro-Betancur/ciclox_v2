import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';
import '../bloc/notificaciones_bloc.dart';
import '../bloc/notificaciones_event.dart';
import '../bloc/notificaciones_state.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificacionesBloc>().add(LoadNotificaciones());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<NotificacionesBloc, NotificacionesState>(
        builder: (context, state) {
          return Column(
            children: [
              const CicloxHeader(title: 'NOTIFICACIONES', showBack: true),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      '${state.noLeidas} sin leer',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: state.items.isEmpty
                          ? null
                          : () => context
                              .read<NotificacionesBloc>()
                              .add(MarcarTodasLeidasRequested()),
                      child: const Text('Marcar todas como leídas'),
                    ),
                  ],
                ),
              ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Color(0xFFB71C1C)),
                    ),
                  ),
                ),
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.navy),
                      )
                    : state.items.isEmpty
                        ? const _EmptyNotificaciones()
                        : RefreshIndicator(
                            color: AppColors.navy,
                            onRefresh: () async => context
                                .read<NotificacionesBloc>()
                                .add(LoadNotificaciones()),
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                              itemCount: state.items.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final item = state.items[i];
                                return _NotificacionTile(
                                  titulo: item.titulo,
                                  mensaje: item.mensaje,
                                  fecha: item.fecha,
                                  leida: item.leida,
                                  icon: _iconByTipo(item.tipo),
                                  onTap: item.leida
                                      ? null
                                      : () => context.read<NotificacionesBloc>().add(
                                            MarcarNotificacionLeidaRequested(
                                              item.id,
                                            ),
                                          ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _iconByTipo(String tipo) {
    switch (tipo) {
      case 'SOLICITUD':
        return Icons.inventory_2_outlined;
      case 'CANJE':
        return Icons.qr_code_rounded;
      case 'PUNTOS':
        return Icons.stars_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}

class _NotificacionTile extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final DateTime fecha;
  final bool leida;
  final IconData icon;
  final VoidCallback? onTap;

  const _NotificacionTile({
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    required this.leida,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: leida ? Colors.white : const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: leida ? const Color(0xFFE0E0E0) : const Color(0xFFB3C7FF),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F3C).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.navy, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.navy,
                      fontWeight: leida ? FontWeight.w600 : FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mensaje,
                    style: AppTextStyles.bodySmall.copyWith(height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a', 'es')
                        .format(fecha.toLocal()),
                    style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (!leida)
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1F3C),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotificaciones extends StatelessWidget {
  const _EmptyNotificaciones();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.navy,
                size: 46,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sin notificaciones',
              style: AppTextStyles.heading3.copyWith(color: AppColors.navy),
            ),
            const SizedBox(height: 8),
            const Text(
              'Te avisaremos aquí cuando haya\nnovedades sobre tus solicitudes',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
