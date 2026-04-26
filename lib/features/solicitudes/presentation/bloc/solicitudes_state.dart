import 'package:equatable/equatable.dart';
import '../../domain/entities/solicitud_entity.dart';

abstract class SolicitudesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SolicitudesInitial extends SolicitudesState {}

class SolicitudesLoading extends SolicitudesState {}

class SolicitudesLoaded extends SolicitudesState {
  final List<SolicitudEntity> solicitudes;
  SolicitudesLoaded(this.solicitudes);

  @override
  List<Object?> get props => [solicitudes];
}

class SolicitudDetailLoaded extends SolicitudesState {
  final SolicitudEntity solicitud;
  SolicitudDetailLoaded(this.solicitud);

  @override
  List<Object?> get props => [solicitud];
}

class SolicitudCreada extends SolicitudesState {
  final SolicitudEntity solicitud;
  SolicitudCreada(this.solicitud);

  @override
  List<Object?> get props => [solicitud];
}

class SolicitudCancelada extends SolicitudesState {}

class SolicitudesError extends SolicitudesState {
  final String message;
  SolicitudesError(this.message);

  @override
  List<Object?> get props => [message];
}
