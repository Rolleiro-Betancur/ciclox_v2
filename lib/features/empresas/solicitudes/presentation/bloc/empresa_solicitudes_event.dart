import 'package:equatable/equatable.dart';

abstract class EmpresaSolicitudesEvent extends Equatable {
  const EmpresaSolicitudesEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmpresaSolicitudes extends EmpresaSolicitudesEvent {
  final String? estado;

  const LoadEmpresaSolicitudes({this.estado});

  @override
  List<Object?> get props => [estado];
}

class AceptarEmpresaSolicitud extends EmpresaSolicitudesEvent {
  final int solicitudId;
  final int recolectorId;
  final String horaEstimadaInicio;
  final String horaEstimadaFin;
  final String? comentarioEmpresa;

  const AceptarEmpresaSolicitud({
    required this.solicitudId,
    required this.recolectorId,
    required this.horaEstimadaInicio,
    required this.horaEstimadaFin,
    this.comentarioEmpresa,
  });

  @override
  List<Object?> get props => [
        solicitudId,
        recolectorId,
        horaEstimadaInicio,
        horaEstimadaFin,
        comentarioEmpresa,
      ];
}

class RechazarEmpresaSolicitud extends EmpresaSolicitudesEvent {
  final int solicitudId;
  final String motivo;

  const RechazarEmpresaSolicitud({
    required this.solicitudId,
    required this.motivo,
  });

  @override
  List<Object?> get props => [solicitudId, motivo];
}

class MarcarSolicitudEnTransito extends EmpresaSolicitudesEvent {
  final int solicitudId;
  final double? latitudRecolector;
  final double? longitudRecolector;
  final int? tiempoEstimadoMinutos;

  const MarcarSolicitudEnTransito({
    required this.solicitudId,
    this.latitudRecolector,
    this.longitudRecolector,
    this.tiempoEstimadoMinutos,
  });

  @override
  List<Object?> get props => [
        solicitudId,
        latitudRecolector,
        longitudRecolector,
        tiempoEstimadoMinutos,
      ];
}

class MarcarSolicitudRecolectada extends EmpresaSolicitudesEvent {
  final int solicitudId;
  final int puntosOtorgados;
  final String? evidenciaUrl;

  const MarcarSolicitudRecolectada({
    required this.solicitudId,
    required this.puntosOtorgados,
    this.evidenciaUrl,
  });

  @override
  List<Object?> get props => [solicitudId, puntosOtorgados, evidenciaUrl];
}
