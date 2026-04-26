import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/trazabilidad_bloc.dart';
import '../bloc/trazabilidad_event.dart';
import '../bloc/trazabilidad_state.dart';

class TrazabilidadDetallePage extends StatefulWidget {
  final int dispositivoId;

  const TrazabilidadDetallePage({
    super.key,
    required this.dispositivoId,
  });

  @override
  State<TrazabilidadDetallePage> createState() => _TrazabilidadDetallePageState();
}

class _TrazabilidadDetallePageState extends State<TrazabilidadDetallePage> {
  @override
  void initState() {
    super.initState();
    if (widget.dispositivoId > 0) {
      context
          .read<TrazabilidadBloc>()
          .add(LoadTrazabilidadDispositivo(widget.dispositivoId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trazabilidad'),
      ),
      body: BlocBuilder<TrazabilidadBloc, TrazabilidadState>(
        builder: (context, state) {
          if (widget.dispositivoId <= 0) {
            return const _MessageView(
              icon: Icons.info_outline,
              message: 'No se recibió un dispositivo válido para consultar.',
            );
          }
          if (state.isLoadingHistorial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.errorHistorial != null) {
            return _MessageView(
              icon: Icons.error_outline,
              message: state.errorHistorial!,
            );
          }
          if (state.movimientos.isEmpty) {
            return const _MessageView(
              icon: Icons.timeline,
              message: 'Aún no hay movimientos de trazabilidad.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<TrazabilidadBloc>()
                  .add(LoadTrazabilidadDispositivo(widget.dispositivoId));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.movimientos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final m = state.movimientos[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ícono del tipo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _tipoColor(m.estado).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _tipoIcon(m.estado),
                          color: _tipoColor(m.estado),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge del tipo
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _tipoColor(m.estado).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _tipoLabel(m.estado),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: _tipoColor(m.estado),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              m.descripcion,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if (m.responsable != null) ...[
                                  const Icon(Icons.person_outline,
                                      size: 12, color: Color(0xFF90A4AE)),
                                  const SizedBox(width: 4),
                                  Text(
                                    m.responsable!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF90A4AE),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                const Icon(Icons.schedule_outlined,
                                    size: 12, color: Color(0xFF90A4AE)),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd MMM yyyy, hh:mm a', 'es')
                                      .format(m.fecha.toLocal()),
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
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _tipoColor(String tipo) {
    switch (tipo) {
      case 'REGISTRO':
        return const Color(0xFF1565C0);
      case 'SOLICITUD_CREADA':
        return const Color(0xFF00796B);
      case 'ACEPTADA':
      case 'SOLICITUD_ACEPTADA':
        return const Color(0xFF2E7D32);
      case 'EN_TRANSITO':
        return const Color(0xFFE65100);
      case 'RECOLECTADA':
        return const Color(0xFF6A1B9A);
      case 'CANCELADA':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF607D8B);
    }
  }

  IconData _tipoIcon(String tipo) {
    switch (tipo) {
      case 'REGISTRO':
        return Icons.app_registration_rounded;
      case 'SOLICITUD_CREADA':
        return Icons.post_add_rounded;
      case 'ACEPTADA':
      case 'SOLICITUD_ACEPTADA':
        return Icons.check_circle_outline_rounded;
      case 'EN_TRANSITO':
        return Icons.local_shipping_rounded;
      case 'RECOLECTADA':
        return Icons.recycling_rounded;
      case 'CANCELADA':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _tipoLabel(String tipo) {
    switch (tipo) {
      case 'REGISTRO':
        return 'Registro';
      case 'SOLICITUD_CREADA':
        return 'Solicitud creada';
      case 'ACEPTADA':
      case 'SOLICITUD_ACEPTADA':
        return 'Aceptada';
      case 'EN_TRANSITO':
        return 'En tránsito';
      case 'RECOLECTADA':
        return 'Recolectada';
      case 'CANCELADA':
        return 'Cancelada';
      default:
        return tipo;
    }
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _MessageView({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: const Color(0xFF78909C)),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF546E7A)),
            ),
          ],
        ),
      ),
    );
  }
}
