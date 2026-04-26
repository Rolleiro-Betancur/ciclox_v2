import 'package:equatable/equatable.dart';

import '../../domain/entities/recolector_entity.dart';

abstract class RecolectoresState extends Equatable {
  const RecolectoresState();

  @override
  List<Object?> get props => [];
}

class RecolectoresInitial extends RecolectoresState {}

class RecolectoresLoading extends RecolectoresState {}

class RecolectoresLoaded extends RecolectoresState {
  final List<RecolectorEntity> recolectores;
  final bool? filtroActivo;

  const RecolectoresLoaded({
    required this.recolectores,
    this.filtroActivo,
  });

  @override
  List<Object?> get props => [recolectores, filtroActivo];
}

class RecolectoresActionSuccess extends RecolectoresState {
  final String message;

  const RecolectoresActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RecolectoresError extends RecolectoresState {
  final String message;

  const RecolectoresError(this.message);

  @override
  List<Object?> get props => [message];
}
