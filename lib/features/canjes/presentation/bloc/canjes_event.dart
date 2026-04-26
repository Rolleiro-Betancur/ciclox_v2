import 'package:equatable/equatable.dart';

abstract class CanjesEvent extends Equatable {
  const CanjesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCanjes extends CanjesEvent {}

class CrearCanjeRequested extends CanjesEvent {
  final int recompensaId;
  const CrearCanjeRequested({required this.recompensaId});

  @override
  List<Object?> get props => [recompensaId];
}

class ClearCanjeActual extends CanjesEvent {}
