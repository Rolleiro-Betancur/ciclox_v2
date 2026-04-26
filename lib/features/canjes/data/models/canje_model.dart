import '../../domain/entities/canje_entity.dart';

class CanjeModel extends CanjeEntity {
  const CanjeModel({
    required super.id,
    required super.recompensaId,
    required super.recompensaNombre,
    required super.tipoRecompensa,
    required super.puntosUsados,
    required super.codigoQr,
    required super.fechaExpiracion,
    required super.estado,
    required super.creadoEn,
  });

  factory CanjeModel.fromJson(Map<String, dynamic> json) {
    return CanjeModel(
      id: (json['id'] ?? 0) as int,
      recompensaId: (json['recompensa_id'] ?? json['recompensaId'] ?? 0) as int,
      recompensaNombre: (json['recompensa_nombre'] ??
              json['recompensaNombre'] ??
              'Recompensa') as String,
      tipoRecompensa:
          (json['tipo_recompensa'] ?? json['tipoRecompensa'] ?? '') as String,
      puntosUsados: (json['puntos_usados'] ?? json['puntosUsados'] ?? 0) as int,
      codigoQr: (json['codigo_qr'] ?? json['codigoQr'] ?? '') as String,
      fechaExpiracion: DateTime.parse(
        (json['fecha_expiracion'] ?? json['fechaExpiracion']) as String,
      ),
      estado: (json['estado'] ?? 'PENDIENTE') as String,
      creadoEn: DateTime.parse(
        (json['creado_en'] ?? json['creadoEn'] ?? DateTime.now().toIso8601String())
            as String,
      ),
    );
  }
}
