import 'package:equatable/equatable.dart';

abstract class PuntosEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPuntos extends PuntosEvent {}

class LoadHistorialPuntos extends PuntosEvent {
  final int page;
  final int limit;

  LoadHistorialPuntos({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class RefreshPuntos extends PuntosEvent {}