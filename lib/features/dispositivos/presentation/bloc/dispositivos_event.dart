import 'package:equatable/equatable.dart';
import '../../domain/entities/dispositivo_entity.dart';

abstract class DispositivosEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDispositivos extends DispositivosEvent {}

class LoadDispositivoById extends DispositivosEvent {
  final int id;
  LoadDispositivoById(this.id);
  @override
  List<Object?> get props => [id];
}

class CrearDispositivo extends DispositivosEvent {
  final String tipo;
  final String marca;
  final String modelo;
  final String? descripcion;
  final String estadoFisico;
  final String? fotoPath;

  CrearDispositivo({
    required this.tipo,
    required this.marca,
    required this.modelo,
    this.descripcion,
    required this.estadoFisico,
    this.fotoPath,
  });

  @override
  List<Object?> get props => [tipo, marca, modelo];
}

class EliminarDispositivo extends DispositivosEvent {
  final int id;
  EliminarDispositivo(this.id);
  @override
  List<Object?> get props => [id];
}
