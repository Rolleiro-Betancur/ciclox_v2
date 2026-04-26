import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';
import '../bloc/solicitudes_bloc.dart';
import '../bloc/solicitudes_event.dart';
import '../bloc/solicitudes_state.dart';
import '../../domain/entities/solicitud_entity.dart';
import '../../../../injection_container.dart';

class SolicitudesPage extends StatelessWidget {
  const SolicitudesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SolicitudesBloc>()..add(LoadSolicitudes()),
      child: const _SolicitudesView(),
    );
  }
}

class _SolicitudesView extends StatefulWidget {
  const _SolicitudesView();

  @override
  State<_SolicitudesView> createState() => _SolicitudesViewState();
}

class _SolicitudesViewState extends State<_SolicitudesView> {
  String _selectedFilter = 'Pendientes';

  final List<String> _filters = [
    'Pendientes',
    'Aceptado',
    'Recogido',
    'Rechazados'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<SolicitudesBloc, SolicitudesState>(
        listener: (ctx, state) {
          if (state is SolicitudesError) {
            showErrorSnackBar(ctx, state.message);
          }
          if (state is SolicitudCancelada) {
            // Ir a la pantalla de éxito de cancelación
            ctx.go(AppRoutes.solicitudCancelada);
          }
        },
        builder: (ctx, state) {
          if (state is SolicitudesLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.navy));
          }

          if (state is SolicitudesLoaded) {
            final allSolicitudes = state.solicitudes;
            
            if (allSolicitudes.isEmpty) {
              return _buildEmptyState(ctx);
            }

            final filtered = _filterSolicitudes(allSolicitudes, _selectedFilter);

            return _buildPopulatedState(ctx, filtered);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F3E8),
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

  List<SolicitudEntity> _filterSolicitudes(
      List<SolicitudEntity> all, String filter) {
    return all.where((s) {
      if (filter == 'Pendientes') return s.estado == 'PENDIENTE';
      if (filter == 'Aceptado') return s.estado == 'ACEPTADA';
      if (filter == 'Recogido') return s.estado == 'RECOLECTADA';
      if (filter == 'Rechazados') return s.estado == 'RECHAZADA' || s.estado == 'CANCELADA';
      return true;
    }).toList();
  }

  Widget _buildPopulatedState(
      BuildContext context, List<SolicitudEntity> solicitudes) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Moderno
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Haz seguimiento\na tus recogidas.',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.navy,
                fontSize: 32,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: _filters.map((f) {
                final isSelected = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => setState(() => _selectedFilter = f),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.navy : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.navy),
                      ),
                      child: Text(
                        f,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isSelected ? Colors.white : AppColors.navy,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          
          // Lista de Tarjetas
          Expanded(
            child: RefreshIndicator(
              color: AppColors.navy,
              onRefresh: () async =>
                  context.read<SolicitudesBloc>().add(LoadSolicitudes()),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: solicitudes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 32),
                itemBuilder: (_, i) => _buildCard(context, solicitudes[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, SolicitudEntity solicitud) {
    if (solicitud.estado == 'RECOLECTADA') {
      return _PuntosCompletadaCard(solicitud: solicitud);
    }
    return _SolicitudDetalleCard(solicitud: solicitud);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        const CicloxHeader(title: 'MIS SOLICITUDES', showBack: true),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.navy.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.assignment_outlined,
                        color: AppColors.navy, size: 48),
                  ),
                  const SizedBox(height: 20),
                  Text('Sin solicitudes',
                      style: AppTextStyles.heading3
                          .copyWith(color: AppColors.navy)),
                  const SizedBox(height: 8),
                  Text(
                    'Crea una solicitud para agendar\nla recolección de tus dispositivos',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  CicloxPrimaryButton(
                    label: 'Nueva solicitud',
                    onPressed: () => context.push(AppRoutes.crearSolicitud),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// TARJETAS ESPECÍFICAS
// ──────────────────────────────────────────────────────────────

class _SolicitudDetalleCard extends StatelessWidget {
  final SolicitudEntity solicitud;

  const _SolicitudDetalleCard({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final bool isAceptada = solicitud.estado == 'ACEPTADA';
    final bool isPendiente = solicitud.estado == 'PENDIENTE';
    final bool isRechazada = solicitud.estado == 'RECHAZADA' || solicitud.estado == 'CANCELADA';

    String title = '';
    String subtitle = '';
    if (isAceptada) {
      title = '¡Tu solicitud fue aceptada!';
      subtitle = 'Ya estamos preparando tu recolección';
    } else if (isPendiente) {
      title = 'Solicitud en revisión';
      subtitle = 'Pronto te confirmaremos la recolección';
    } else if (isRechazada) {
      title = 'Solicitud rechazada';
      subtitle = 'No pudimos procesarla en este momento';
    }

    // Datos simulados o extraídos
    final fechaS = DateFormat('dd MMMM yyyy', 'es').format(solicitud.createdAt);
    final fechaR = DateFormat('dd MMMM yyyy', 'es').format(solicitud.fechaAgendada);

    return Column(
      children: [
        if (title.isNotEmpty) ...[
          Text(title,
              style: AppTextStyles.heading3.copyWith(
                  color: AppColors.navy, fontSize: 22),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(subtitle,
              style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder de imagen
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.smartphone_rounded,
                  color: AppColors.navy, size: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow('Tipo de residuo:', solicitud.tipoResiduo ?? 'Otro'),
                  _InfoRow('Cantidad:', '${solicitud.cantidadDispositivos.toString().padLeft(2, '0')} dispositivo(s)'),
                  _InfoRow('Dirección:', solicitud.direccion ?? 'Sin dirección'),
                  _InfoRow('Teléfono:', solicitud.telefonoContacto ?? 'No registrado'),
                  _InfoRow('Fecha de solicitud:', fechaS),
                  if (!isRechazada) _InfoRow('Fecha de recolección:', fechaR),
                  if (!isRechazada && solicitud.horaEstimadaInicio != null) 
                    _InfoRow('Hora estimada:', 'Entre ${solicitud.horaEstimadaInicio} - ${solicitud.horaEstimadaFin}'),
                  if (isRechazada && solicitud.motivoRechazo != null) ...[
                    Text('Motivo del rechazo',
                        style: AppTextStyles.labelLarge
                            .copyWith(color: AppColors.navy, fontWeight: FontWeight.bold)),
                    Text(solicitud.motivoRechazo!,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (isAceptada || isPendiente)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<SolicitudesBloc>().add(CancelarSolicitud(solicitud.id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error, // Rojo
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Column(
                children: [
                  Text('Cancelar solicitud',
                      style: AppTextStyles.button.copyWith(fontSize: 16)),
                  Text(
                    'solo se puede cancelar si no se ha notificado la recogida',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        if (isAceptada) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push(
                AppRoutes.trazabilidadMapa,
                extra: solicitud.id,
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.navy),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.map_outlined, color: AppColors.navy),
              label: Text(
                'Ver trazabilidad',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.navy,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
        if (isRechazada)
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.crearSolicitud),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Hacer otra solicitud',
                  style: AppTextStyles.button.copyWith(fontSize: 14)),
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.navy, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuntosCompletadaCard extends StatelessWidget {
  final SolicitudEntity solicitud;

  const _PuntosCompletadaCard({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('¡Recolección completada!',
            style: AppTextStyles.heading3.copyWith(
                color: AppColors.navy, fontSize: 22),
            textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text('Gracias por reciclar con Ciclox.',
            style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF161433), // Azul muy oscuro del mockup
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                '+${solicitud.puntosGanados ?? 0}',
                style: AppTextStyles.heading1.copyWith(
                    color: Colors.white, fontSize: 56, height: 1.0),
              ),
              Text(
                'Puntos ganados',
                style: AppTextStyles.heading2.copyWith(
                    color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'Tus puntos ya fueron añadidos a tu cuenta',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 220,
          child: ElevatedButton(
            onPressed: () => context.go(AppRoutes.tusPuntos),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF161433),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text('Ver recompensa',
                style: AppTextStyles.button.copyWith(fontSize: 14)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 220,
          child: OutlinedButton.icon(
            onPressed: () => context.push(
              AppRoutes.trazabilidad,
              extra: solicitud.dispositivoId,
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.navy),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.timeline_rounded, color: AppColors.navy),
            label: Text(
              'Ver trazabilidad',
              style: AppTextStyles.button.copyWith(
                color: AppColors.navy,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
