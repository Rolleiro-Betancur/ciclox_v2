import 'package:equatable/equatable.dart';

abstract class SolicitudesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSolicitudes extends SolicitudesEvent {}

class LoadSolicitudById extends SolicitudesEvent {
  final int id;
  LoadSolicitudById(this.id);
  @override
  List<Object?> get props => [id];
}

class CrearSolicitud extends SolicitudesEvent {
  final List<int> dispositivosIds;
  final String direccion;
  final String ciudad;
  final String departamento;
  final String email;
  final String? referencia;

  CrearSolicitud({
    required this.dispositivosIds,
    required this.direccion,
    required this.ciudad,
    required this.departamento,
    required this.email,
    this.referencia,
  });

  @override
  List<Object?> get props => [
        dispositivosIds,
        direccion,
        ciudad,
        departamento,
        email,
        referencia,
      ];
}

class CancelarSolicitud extends SolicitudesEvent {
  final int id;
  CancelarSolicitud(this.id);
  @override
  List<Object?> get props => [id];
}
