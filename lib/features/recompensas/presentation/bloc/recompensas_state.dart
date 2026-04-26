import 'package:equatable/equatable.dart';
import '../../domain/entities/recompensa_entity.dart';

abstract class RecompensasState extends Equatable {
  const RecompensasState();

  @override
  List<Object?> get props => [];
}

class RecompensasInitial extends RecompensasState {}

class RecompensasLoading extends RecompensasState {}

class RecompensasLoaded extends RecompensasState {
  final List<RecompensaEntity> recompensas;
  const RecompensasLoaded({required this.recompensas});

  @override
  List<Object?> get props => [recompensas];
}

class RecompensasError extends RecompensasState {
  final String message;
  const RecompensasError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecompensaDetalleLoading extends RecompensasState {}

class RecompensaDetalleLoaded extends RecompensasState {
  final RecompensaEntity recompensa;
  const RecompensaDetalleLoaded({required this.recompensa});

  @override
  List<Object?> get props => [recompensa];
}

class RecompensaDetalleError extends RecompensasState {
  final String message;
  const RecompensaDetalleError(this.message);

  @override
  List<Object?> get props => [message];
}