import '../../domain/entities/solicitud_entity.dart';

class SolicitudModel extends SolicitudEntity {
  const SolicitudModel({
    required super.id,
    required super.dispositivoId,
    required super.nombreDispositivo,
    required super.fechaAgendada,
    required super.estado,
    required super.createdAt,
    super.direccion,
    super.tipoResiduo,
    super.cantidadDispositivos = 1,
    super.telefonoContacto,
    super.horaEstimadaInicio,
    super.horaEstimadaFin,
    super.motivoRechazo,
    super.puntosGanados,
  });

  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    int cantidadTotal = 0;
    String tipoPrincipal = 'Otro';
    int dId = 0;
    String nombreD = 'Dispositivo(s)';

    if (json['dispositivos'] != null && json['dispositivos'] is List) {
      final list = json['dispositivos'] as List;
      for (var item in list) {
        if (item is Map) {
          cantidadTotal += (item['cantidad'] as num?)?.toInt() ?? 1;
        }
      }
      if (list.isNotEmpty) {
        final first = list.first;
        tipoPrincipal = _capitalize(first['tipo']?.toString() ?? 'Otro');
        dId = (first['id'] as num?)?.toInt() ?? 0;
        nombreD = first['marca']?.toString() ?? 'Dispositivo';
      }
    }

    return SolicitudModel(
      id: (json['id'] as num).toInt(),
      dispositivoId: dId,
      nombreDispositivo: nombreD,
      fechaAgendada: json['fecha_preferida'] != null
          ? DateTime.tryParse(json['fecha_preferida']) ?? DateTime.now()
          : DateTime.now(),
      estado: json['estado'] ?? 'PENDIENTE',
      createdAt: json['fecha_creacion'] != null
          ? DateTime.tryParse(json['fecha_creacion']) ?? DateTime.now()
          : DateTime.now(),
      direccion: json['direccion_recoleccion'],
      tipoResiduo: tipoPrincipal,
      cantidadDispositivos: cantidadTotal > 0 ? cantidadTotal : 1,
      telefonoContacto: json['telefono_contacto'],
      horaEstimadaInicio: json['hora_estimada_inicio'],
      horaEstimadaFin: json['hora_estimada_fin'],
      motivoRechazo: json['motivo_rechazo'],
      puntosGanados: (json['puntos_otorgados'] as num?)?.toInt(),
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
