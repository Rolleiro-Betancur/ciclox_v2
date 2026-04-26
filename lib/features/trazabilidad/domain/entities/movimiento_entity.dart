import 'package:equatable/equatable.dart';

class MovimientoEntity extends Equatable {
  final int id;
  final String estado;
  final String descripcion;
  final DateTime fecha;
  final double? latitud;
  final double? longitud;
  final String? responsable;

  const MovimientoEntity({
    required this.id,
    required this.estado,
    required this.descripcion,
    required this.fecha,
    this.latitud,
    this.longitud,
    this.responsable,
  });

  @override
  List<Object?> get props => [id, estado, fecha, latitud, longitud, responsable];
}

class UbicacionRecolectorEntity extends Equatable {
  final double latitud;
  final double longitud;
  final DateTime fechaActualizacion;
  final String? nombreRecolector;

  const UbicacionRecolectorEntity({
    required this.latitud,
    required this.longitud,
    required this.fechaActualizacion,
    this.nombreRecolector,
  });

  @override
  List<Object?> get props => [latitud, longitud, fechaActualizacion, nombreRecolector];
}
