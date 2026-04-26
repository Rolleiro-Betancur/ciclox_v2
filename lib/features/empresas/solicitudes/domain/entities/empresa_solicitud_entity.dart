import 'package:equatable/equatable.dart';

class EmpresaSolicitudEntity extends Equatable {
  final int id;
  final int usuarioId;
  final String nombreSolicitante;
  final String? emailSolicitante;
  final String? telefonoContacto;
  final String direccionRecoleccion;
  final DateTime fechaPreferida;
  final String estado;
  final String? referencia;
  final String? motivoRechazo;
  final DateTime createdAt;

  const EmpresaSolicitudEntity({
    required this.id,
    required this.usuarioId,
    required this.nombreSolicitante,
    this.emailSolicitante,
    this.telefonoContacto,
    required this.direccionRecoleccion,
    required this.fechaPreferida,
    required this.estado,
    this.referencia,
    this.motivoRechazo,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, estado, usuarioId];
}
