import 'package:equatable/equatable.dart';

class NotificacionEntity extends Equatable {
  final int id;
  final String titulo;
  final String mensaje;
  final String tipo;
  final bool leida;
  final DateTime fecha;

  const NotificacionEntity({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.leida,
    required this.fecha,
  });

  NotificacionEntity copyWith({
    int? id,
    String? titulo,
    String? mensaje,
    String? tipo,
    bool? leida,
    DateTime? fecha,
  }) {
    return NotificacionEntity(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      tipo: tipo ?? this.tipo,
      leida: leida ?? this.leida,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  List<Object?> get props => [id, leida, fecha];
}
