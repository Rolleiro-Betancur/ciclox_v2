import 'package:equatable/equatable.dart';

abstract class NotificacionesEvent extends Equatable {
  const NotificacionesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificaciones extends NotificacionesEvent {}

class MarcarNotificacionLeidaRequested extends NotificacionesEvent {
  final int id;
  const MarcarNotificacionLeidaRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class MarcarTodasLeidasRequested extends NotificacionesEvent {}
