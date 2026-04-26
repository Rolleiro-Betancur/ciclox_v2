import 'package:equatable/equatable.dart';

abstract class TrazabilidadEvent extends Equatable {
  const TrazabilidadEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrazabilidadDispositivo extends TrazabilidadEvent {
  final int dispositivoId;
  const LoadTrazabilidadDispositivo(this.dispositivoId);

  @override
  List<Object?> get props => [dispositivoId];
}

class LoadUbicacionRecolector extends TrazabilidadEvent {
  final int solicitudId;
  const LoadUbicacionRecolector(this.solicitudId);

  @override
  List<Object?> get props => [solicitudId];
}
