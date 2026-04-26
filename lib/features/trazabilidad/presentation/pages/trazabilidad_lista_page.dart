import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../solicitudes/domain/entities/solicitud_entity.dart';
import '../../../solicitudes/presentation/bloc/solicitudes_bloc.dart';
import '../../../solicitudes/presentation/bloc/solicitudes_event.dart';
import '../../../solicitudes/presentation/bloc/solicitudes_state.dart';

class TrazabilidadListaPage extends StatefulWidget {
  const TrazabilidadListaPage({super.key});

  @override
  State<TrazabilidadListaPage> createState() => _TrazabilidadListaPageState();
}

class _TrazabilidadListaPageState extends State<TrazabilidadListaPage> {
  @override
  void initState() {
    super.initState();
    context.read<SolicitudesBloc>().add(LoadSolicitudes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sigue tu reciclaje',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<SolicitudesBloc, SolicitudesState>(
        builder: (context, state) {
          if (state is SolicitudesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.navy),
            );
          }

          if (state is SolicitudesError) {
            return _EmptyView(
              icon: Icons.error_outline_rounded,
              title: 'Error al cargar',
              subtitle: state.message,
              onRetry: () =>
                  context.read<SolicitudesBloc>().add(LoadSolicitudes()),
            );
          }

          if (state is SolicitudesLoaded) {
            // Filtramos solo las que tienen seguimiento activo
            final activas = state.solicitudes
                .where((s) =>
                    s.estado == 'ACEPTADA' ||
                    s.estado == 'EN_TRANSITO' ||
                    s.estado == 'PENDIENTE')
                .toList();

            if (activas.isEmpty) {
              return const _EmptyView(
                icon: Icons.route_outlined,
                title: 'Sin solicitudes activas',
                subtitle:
                    'Cuando tengas una solicitud en progreso, podrás seguir su trazabilidad aquí.',
              );
            }

            return RefreshIndicator(
              color: AppColors.navy,
              onRefresh: () async {
                context.read<SolicitudesBloc>().add(LoadSolicitudes());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activas.length,
                itemBuilder: (_, i) => _SolicitudTrackCard(
                  solicitud: activas[i],
                  onTap: () => context.push(
                    '/trazabilidad/detalle',
                    extra: activas[i].dispositivoId,
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Card de solicitud para seguimiento
// ─────────────────────────────────────────────────────────────
class _SolicitudTrackCard extends StatelessWidget {
  final SolicitudEntity solicitud;
  final VoidCallback onTap;

  const _SolicitudTrackCard({
    required this.solicitud,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ícono de estado
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _estadoColor(solicitud.estado).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _estadoIcon(solicitud.estado),
                  color: _estadoColor(solicitud.estado),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitud.nombreDispositivo,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1F3C),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      solicitud.direccion ?? 'Sin dirección',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF607D8B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _EstadoBadge(estado: solicitud.estado),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy', 'es')
                              .format(solicitud.fechaAgendada),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF90A4AE),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Flecha
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB0BEC5),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _estadoColor(String estado) {
    switch (estado) {
      case 'EN_TRANSITO':
        return const Color(0xFF1565C0);
      case 'ACEPTADA':
        return const Color(0xFF2E7D32);
      case 'PENDIENTE':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF607D8B);
    }
  }

  IconData _estadoIcon(String estado) {
    switch (estado) {
      case 'EN_TRANSITO':
        return Icons.local_shipping_rounded;
      case 'ACEPTADA':
        return Icons.check_circle_outline_rounded;
      case 'PENDIENTE':
        return Icons.schedule_rounded;
      default:
        return Icons.recycling_rounded;
    }
  }
}

class _EstadoBadge extends StatelessWidget {
  final String estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (estado) {
      case 'EN_TRANSITO':
        color = const Color(0xFF1565C0);
        label = 'En tránsito';
        break;
      case 'ACEPTADA':
        color = const Color(0xFF2E7D32);
        label = 'Aceptada';
        break;
      case 'PENDIENTE':
        color = const Color(0xFFE65100);
        label = 'Pendiente';
        break;
      default:
        color = const Color(0xFF607D8B);
        label = estado;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Vista vacía / error
// ─────────────────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const _EmptyView({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: const Color(0xFFB0BEC5)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF455A64),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF78909C),
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: const BorderSide(color: AppColors.navy),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
