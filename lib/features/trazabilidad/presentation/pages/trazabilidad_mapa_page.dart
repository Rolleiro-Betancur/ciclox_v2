import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/trazabilidad_bloc.dart';
import '../bloc/trazabilidad_event.dart';
import '../bloc/trazabilidad_state.dart';

class TrazabilidadMapaPage extends StatefulWidget {
  final int solicitudId;

  const TrazabilidadMapaPage({
    super.key,
    required this.solicitudId,
  });

  @override
  State<TrazabilidadMapaPage> createState() => _TrazabilidadMapaPageState();
}

class _TrazabilidadMapaPageState extends State<TrazabilidadMapaPage> {
  @override
  void initState() {
    super.initState();
    if (widget.solicitudId > 0) {
      context
          .read<TrazabilidadBloc>()
          .add(LoadUbicacionRecolector(widget.solicitudId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación del recolector'),
      ),
      body: BlocBuilder<TrazabilidadBloc, TrazabilidadState>(
        builder: (context, state) {
          if (widget.solicitudId <= 0) {
            return const _MapMessage(
              message: 'No se recibió una solicitud válida para consultar.',
            );
          }
          if (state.isLoadingUbicacion) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorUbicacion != null) {
            return _MapMessage(message: state.errorUbicacion!);
          }
          final ubicacion = state.ubicacion;
          if (ubicacion == null) {
            return const _MapMessage(
              message: 'Aún no hay ubicación disponible.',
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBDEFB)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 52, color: Color(0xFF1565C0)),
                      SizedBox(height: 8),
                      Text(
                        'Vista de mapa',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dataRow('Latitud', ubicacion.latitud.toStringAsFixed(6)),
                      _dataRow('Longitud', ubicacion.longitud.toStringAsFixed(6)),
                      if (ubicacion.nombreRecolector != null)
                        _dataRow('Recolector', ubicacion.nombreRecolector!),
                      _dataRow(
                        'Actualizado',
                        DateFormat('dd MMM yyyy, hh:mm a', 'es')
                            .format(ubicacion.fechaActualizacion.toLocal()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<TrazabilidadBloc>()
                        .add(LoadUbicacionRecolector(widget.solicitudId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Actualizar ubicación'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF455A64),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF1A1F3C)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMessage extends StatelessWidget {
  final String message;
  const _MapMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF546E7A)),
        ),
      ),
    );
  }
}
