import '../../domain/entities/notificacion_entity.dart';

class NotificacionModel extends NotificacionEntity {
  const NotificacionModel({
    required super.id,
    required super.titulo,
    required super.mensaje,
    required super.tipo,
    required super.leida,
    required super.fecha,
  });

  factory NotificacionModel.fromJson(Map<String, dynamic> json) {
    return NotificacionModel(
      id: (json['id'] ?? 0) as int,
      titulo: (json['titulo'] ?? 'Notificación') as String,
      mensaje: (json['mensaje'] ?? '') as String,
      tipo: (json['tipo'] ?? 'GENERAL') as String,
      leida: (json['leida'] ?? false) as bool,
      fecha: DateTime.parse(
        (json['fecha'] ?? json['created_at'] ?? DateTime.now().toIso8601String())
            as String,
      ),
    );
  }
}
