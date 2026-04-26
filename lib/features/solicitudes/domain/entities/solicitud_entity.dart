import 'package:equatable/equatable.dart';

class SolicitudEntity extends Equatable {
  final int id;
  final int dispositivoId;
  final String nombreDispositivo;
  final DateTime fechaAgendada;
  final String estado; // PENDIENTE | ACEPTADA | EN_TRANSITO | RECOLECTADA | CANCELADA
  final String? direccion;
  final DateTime createdAt;
  
  // Nuevos campos mapeados desde la DB
  final String? tipoResiduo;
  final int cantidadDispositivos;
  final String? telefonoContacto;
  final String? horaEstimadaInicio;
  final String? horaEstimadaFin;
  final String? motivoRechazo;
  final int? puntosGanados;

  const SolicitudEntity({
    required this.id,
    required this.dispositivoId,
    required this.nombreDispositivo,
    required this.fechaAgendada,
    required this.estado,
    this.direccion,
    required this.createdAt,
    this.tipoResiduo,
    this.cantidadDispositivos = 1,
    this.telefonoContacto,
    this.horaEstimadaInicio,
    this.horaEstimadaFin,
    this.motivoRechazo,
    this.puntosGanados,
  });

  @override
  List<Object?> get props => [id, estado];
}
