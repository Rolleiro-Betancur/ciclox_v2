import 'package:equatable/equatable.dart';
import '../../domain/entities/dispositivo_entity.dart';

abstract class DispositivosState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DispositivosInitial extends DispositivosState {}

class DispositivosLoading extends DispositivosState {}

class DispositivosLoaded extends DispositivosState {
  final List<DispositivoEntity> dispositivos;
  DispositivosLoaded(this.dispositivos);

  @override
  List<Object?> get props => [dispositivos];
}

class DispositivoDetailLoaded extends DispositivosState {
  final DispositivoEntity dispositivo;
  DispositivoDetailLoaded(this.dispositivo);

  @override
  List<Object?> get props => [dispositivo];
}

class DispositivoCreado extends DispositivosState {
  final DispositivoEntity dispositivo;
  DispositivoCreado(this.dispositivo);

  @override
  List<Object?> get props => [dispositivo];
}

class DispositivoEliminado extends DispositivosState {}

class DispositivosError extends DispositivosState {
  final String message;
  DispositivosError(this.message);

  @override
  List<Object?> get props => [message];
}
