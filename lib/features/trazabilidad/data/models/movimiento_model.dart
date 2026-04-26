import '../../domain/entities/movimiento_entity.dart';

class MovimientoModel extends MovimientoEntity {
  const MovimientoModel({
    required super.id,
    required super.estado,
    required super.descripcion,
    required super.fecha,
    super.latitud,
    super.longitud,
    super.responsable,
  });

  factory MovimientoModel.fromJson(Map<String, dynamic> json) {
    return MovimientoModel(
      id: (json['id'] ?? 0) as int,
      // La API devuelve 'tipo' (REGISTRO, SOLICITUD_CREADA, etc.)
      estado: (json['tipo'] ?? json['estado'] ?? 'DESCONOCIDO') as String,
      descripcion: (json['descripcion'] ?? '') as String,
      fecha: DateTime.parse(
        (json['fecha'] ?? json['created_at'] ?? DateTime.now().toIso8601String())
            as String,
      ),
      latitud: _toDouble(json['latitud'] ?? json['lat']),
      longitud: _toDouble(json['longitud'] ?? json['lng']),
      responsable: json['responsable_nombre'] as String?,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class UbicacionRecolectorModel extends UbicacionRecolectorEntity {
  const UbicacionRecolectorModel({
    required super.latitud,
    required super.longitud,
    required super.fechaActualizacion,
    super.nombreRecolector,
  });

  factory UbicacionRecolectorModel.fromJson(Map<String, dynamic> json) {
    return UbicacionRecolectorModel(
      latitud: MovimientoModel._toDouble(json['latitud'] ?? json['lat']) ?? 0,
      longitud: MovimientoModel._toDouble(json['longitud'] ?? json['lng']) ?? 0,
      fechaActualizacion: DateTime.parse(
        (json['fecha_actualizacion'] ??
                json['updated_at'] ??
                DateTime.now().toIso8601String()) as String,
      ),
      nombreRecolector: json['nombre_recolector'] as String?,
    );
  }
}
