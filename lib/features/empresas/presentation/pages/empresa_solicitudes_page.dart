import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../injection_container.dart';
import '../../solicitudes/domain/entities/empresa_solicitud_entity.dart';
import '../../solicitudes/presentation/bloc/empresa_solicitudes_bloc.dart';
import '../../solicitudes/presentation/bloc/empresa_solicitudes_event.dart';
import '../../solicitudes/presentation/bloc/empresa_solicitudes_state.dart';

class EmpresaSolicitudesPage extends StatefulWidget {
  const EmpresaSolicitudesPage({super.key});

  @override
  State<EmpresaSolicitudesPage> createState() => _EmpresaSolicitudesPageState();
}

class _EmpresaSolicitudesPageState extends State<EmpresaSolicitudesPage> {
  String? _estadoFiltro;

  @override
  void initState() {
    super.initState();
    context.read<EmpresaSolicitudesBloc>().add(const LoadEmpresaSolicitudes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes de empresa')),
      backgroundColor: AppColors.background,
      body: BlocConsumer<EmpresaSolicitudesBloc, EmpresaSolicitudesState>(
        listener: (context, state) {
          if (state is EmpresaSolicitudesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is EmpresaSolicitudesActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is EmpresaSolicitudesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final solicitudes =
              state is EmpresaSolicitudesLoaded ? state.solicitudes : const <EmpresaSolicitudEntity>[];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Gestión de solicitudes', style: AppTextStyles.heading2),
                    ),
                    DropdownButton<String?>(
                      value: _estadoFiltro,
                      hint: const Text('Filtrar'),
                      items: const [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Todos'),
                        ),
                        DropdownMenuItem(value: 'PENDIENTE', child: Text('Pendiente')),
                        DropdownMenuItem(value: 'ACEPTADA', child: Text('Aceptada')),
                        DropdownMenuItem(value: 'EN_TRANSITO', child: Text('En tránsito')),
                        DropdownMenuItem(value: 'RECOLECTADA', child: Text('Recolectada')),
                        DropdownMenuItem(value: 'RECHAZADA', child: Text('Rechazada')),
                      ],
                      onChanged: (value) {
                        setState(() => _estadoFiltro = value);
                        context
                            .read<EmpresaSolicitudesBloc>()
                            .add(LoadEmpresaSolicitudes(estado: value));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: solicitudes.isEmpty
                    ? const Center(child: Text('No hay solicitudes disponibles'))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: solicitudes.length,
                        itemBuilder: (context, index) {
                          final solicitud = solicitudes[index];
                          return _SolicitudCard(
                            solicitud: solicitud,
                            onAceptar: () => _showAcceptDialog(
                              context: context,
                              solicitudId: solicitud.id,
                            ),
                            onRechazar: () => _showRejectDialog(
                              context: context,
                              solicitudId: solicitud.id,
                            ),
                            onEnTransito: () => _showEnTransitoDialog(
                              context: context,
                              solicitudId: solicitud.id,
                            ),
                            onRecolectada: () => _showRecolectadaDialog(
                              context: context,
                              solicitudId: solicitud.id,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showRejectDialog({
    required BuildContext context,
    required int solicitudId,
  }) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Motivo',
            hintText: 'Escribe el motivo de rechazo',
          ),
          minLines: 2,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final motivo = controller.text.trim();
      context.read<EmpresaSolicitudesBloc>().add(
            RechazarEmpresaSolicitud(
              solicitudId: solicitudId,
              motivo: motivo.isEmpty ? 'Sin motivo especificado' : motivo,
            ),
          );
    }
  }

  Future<void> _showAcceptDialog({
    required BuildContext context,
    required int solicitudId,
  }) async {
    final recolectores = await _getRecolectoresActivos();
    if (!mounted) return;
    if (recolectores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay recolectores activos para asignar'),
        ),
      );
      return;
    }

    int? recolectorId = recolectores.first.id;
    final inicioCtrl = TextEditingController();
    final finCtrl = TextEditingController();
    final comentarioCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Aceptar solicitud'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: recolectorId,
                  decoration: const InputDecoration(
                    labelText: 'Recolector',
                  ),
                  items: recolectores
                      .map(
                        (r) => DropdownMenuItem<int>(
                          value: r.id,
                          child: Text(r.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setDialogState(() => recolectorId = value),
                ),
                TextField(
                  controller: inicioCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Hora inicio (HH:MM)',
                    hintText: '09:00',
                  ),
                ),
                TextField(
                  controller: finCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Hora fin (HH:MM)',
                    hintText: '11:00',
                  ),
                ),
                TextField(
                  controller: comentarioCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Comentario (opcional)',
                  ),
                  minLines: 1,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final inicio = inicioCtrl.text.trim();
      final fin = finCtrl.text.trim();

      if (recolectorId == null || inicio.isEmpty || fin.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa recolector y horas válidas')),
        );
        return;
      }

      context.read<EmpresaSolicitudesBloc>().add(
            AceptarEmpresaSolicitud(
              solicitudId: solicitudId,
              recolectorId: recolectorId!,
              horaEstimadaInicio: inicio,
              horaEstimadaFin: fin,
              comentarioEmpresa: comentarioCtrl.text.trim().isEmpty
                  ? null
                  : comentarioCtrl.text.trim(),
            ),
          );
    }
  }

  Future<List<_RecolectorOption>> _getRecolectoresActivos() async {
    try {
      final response = await sl<Dio>().get(ApiConstants.recolectores);
      final rawData = response.data['data'];
      if (rawData is! List) return const [];

      return rawData
          .whereType<Map<String, dynamic>>()
          .map(_RecolectorOption.fromJson)
          .where((r) => r.activo)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _showEnTransitoDialog({
    required BuildContext context,
    required int solicitudId,
  }) async {
    final tiempoCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Marcar en tránsito'),
        content: TextField(
          controller: tiempoCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Tiempo estimado (min, opcional)',
            hintText: '20',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<EmpresaSolicitudesBloc>().add(
            MarcarSolicitudEnTransito(
              solicitudId: solicitudId,
              tiempoEstimadoMinutos: int.tryParse(tiempoCtrl.text.trim()),
            ),
          );
    }
  }

  Future<void> _showRecolectadaDialog({
    required BuildContext context,
    required int solicitudId,
  }) async {
    final puntosCtrl = TextEditingController();
    final evidenciaCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Marcar recolectada'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: puntosCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Puntos otorgados',
                  hintText: 'Ej: 150',
                ),
              ),
              TextField(
                controller: evidenciaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Evidencia URL (opcional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final puntos = int.tryParse(puntosCtrl.text.trim());
      if (puntos == null || puntos <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa puntos otorgados válidos')),
        );
        return;
      }
      context.read<EmpresaSolicitudesBloc>().add(
            MarcarSolicitudRecolectada(
              solicitudId: solicitudId,
              puntosOtorgados: puntos,
              evidenciaUrl: evidenciaCtrl.text.trim().isEmpty
                  ? null
                  : evidenciaCtrl.text.trim(),
            ),
          );
    }
  }
}

class _RecolectorOption {
  final int id;
  final String label;
  final bool activo;

  const _RecolectorOption({
    required this.id,
    required this.label,
    required this.activo,
  });

  factory _RecolectorOption.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'];
    final nombre = usuario is Map<String, dynamic>
        ? (usuario['nombre'] as String? ?? 'Recolector')
        : (json['nombre'] as String? ?? 'Recolector');
    final documento = json['documento_identidad']?.toString();
    return _RecolectorOption(
      id: (json['id'] as num?)?.toInt() ?? 0,
      label: documento == null || documento.isEmpty
          ? '$nombre (#${(json['id'] as num?)?.toInt() ?? 0})'
          : '$nombre - $documento',
      activo: (json['activo'] as bool?) ?? true,
    );
  }
}

class _SolicitudCard extends StatelessWidget {
  final EmpresaSolicitudEntity solicitud;
  final VoidCallback onAceptar;
  final VoidCallback onRechazar;
  final VoidCallback onEnTransito;
  final VoidCallback onRecolectada;

  const _SolicitudCard({
    required this.solicitud,
    required this.onAceptar,
    required this.onRechazar,
    required this.onEnTransito,
    required this.onRecolectada,
  });

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd/MM/yyyy').format(solicitud.fechaPreferida);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${solicitud.id} - ${solicitud.nombreSolicitante}',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${solicitud.direccionRecoleccion} · $fecha',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 4),
            Text('Estado: ${solicitud.estado}', style: AppTextStyles.caption),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(onPressed: onAceptar, child: const Text('Aceptar')),
                OutlinedButton(onPressed: onRechazar, child: const Text('Rechazar')),
                OutlinedButton(onPressed: onEnTransito, child: const Text('En tránsito')),
                ElevatedButton(onPressed: onRecolectada, child: const Text('Recolectada')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
