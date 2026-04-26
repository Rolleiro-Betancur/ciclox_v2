import 'package:equatable/equatable.dart';

abstract class RecolectoresEvent extends Equatable {
  const RecolectoresEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecolectores extends RecolectoresEvent {
  final bool? activo;

  const LoadRecolectores({this.activo});

  @override
  List<Object?> get props => [activo];
}

class CrearRecolector extends RecolectoresEvent {
  final String nombre;
  final String? telefono;
  final String? fotoUrl;

  const CrearRecolector({
    required this.nombre,
    this.telefono,
    this.fotoUrl,
  });

  @override
  List<Object?> get props => [nombre, telefono, fotoUrl];
}

class DesactivarRecolector extends RecolectoresEvent {
  final int id;

  const DesactivarRecolector(this.id);

  @override
  List<Object?> get props => [id];
}
