import 'package:equatable/equatable.dart';

class PuntosEntity extends Equatable {
  final int saldoActual;
  final int totalGanado;
  final int totalCanjeado;
  final ProximaRecompensaEntity? proximaRecompensa;
 
  const PuntosEntity({
    required this.saldoActual,
    required this.totalGanado,
    required this.totalCanjeado,
    this.proximaRecompensa,
  });
 
  @override
  List<Object?> get props => [saldoActual, totalGanado, totalCanjeado, proximaRecompensa];
}
 
class ProximaRecompensaEntity extends Equatable {
  final String nombre;
  final int puntosRequeridos;
  final int puntosFaltantes;
  final int progresoPorcentaje;
 
  const ProximaRecompensaEntity({
    required this.nombre,
    required this.puntosRequeridos,
    required this.puntosFaltantes,
    required this.progresoPorcentaje,
  });
 
  @override
  List<Object?> get props => [nombre, puntosRequeridos, puntosFaltantes, progresoPorcentaje];
}
 
class MovimientoPuntosEntity extends Equatable {
  final int id;
  final int cantidad;
  final String tipo; // 'GANADO_RECICLAJE' | 'CANJEADO_RECOMPENSA'
  final String descripcion;
  final DateTime fecha;
 
  const MovimientoPuntosEntity({
    required this.id,
    required this.cantidad,
    required this.tipo,
    required this.descripcion,
    required this.fecha,
  });
 
  bool get esGanado => cantidad > 0;
 
  @override
  List<Object?> get props => [id, cantidad, tipo, descripcion, fecha];
}