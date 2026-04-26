import 'package:equatable/equatable.dart';

import '../../domain/entities/empresa_solicitud_entity.dart';

abstract class EmpresaSolicitudesState extends Equatable {
  const EmpresaSolicitudesState();

  @override
  List<Object?> get props => [];
}

class EmpresaSolicitudesInitial extends EmpresaSolicitudesState {}

class EmpresaSolicitudesLoading extends EmpresaSolicitudesState {}

class EmpresaSolicitudesLoaded extends EmpresaSolicitudesState {
  final List<EmpresaSolicitudEntity> solicitudes;
  final String? estadoFiltro;

  const EmpresaSolicitudesLoaded({
    required this.solicitudes,
    this.estadoFiltro,
  });

  @override
  List<Object?> get props => [solicitudes, estadoFiltro];
}

class EmpresaSolicitudesActionSuccess extends EmpresaSolicitudesState {
  final String message;

  const EmpresaSolicitudesActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmpresaSolicitudesError extends EmpresaSolicitudesState {
  final String message;

  const EmpresaSolicitudesError(this.message);

  @override
  List<Object?> get props => [message];
}
