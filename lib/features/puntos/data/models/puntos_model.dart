import '../../domain/entities/puntos_entity.dart';
 
class PuntosModel extends PuntosEntity {
  const PuntosModel({
    required super.saldoActual,
    required super.totalGanado,
    required super.totalCanjeado,
    super.proximaRecompensa,
  });
 
  factory PuntosModel.fromJson(Map<String, dynamic> json) {
    return PuntosModel(
      saldoActual: json['saldo_actual'],
      totalGanado: json['total_ganado'],
      totalCanjeado: json['total_canjeado'],
      proximaRecompensa: json['proxima_recompensa'] != null
          ? ProximaRecompensaModel.fromJson(json['proxima_recompensa'])
          : null,
    );
  }
}
 
class ProximaRecompensaModel extends ProximaRecompensaEntity {
  const ProximaRecompensaModel({
    required super.nombre,
    required super.puntosRequeridos,
    required super.puntosFaltantes,
    required super.progresoPorcentaje,
  });
 
  factory ProximaRecompensaModel.fromJson(Map<String, dynamic> json) {
    return ProximaRecompensaModel(
      nombre: json['nombre'],
      puntosRequeridos: json['puntos_requeridos'],
      puntosFaltantes: json['puntos_faltantes'],
      progresoPorcentaje: json['progreso_porcentaje'],
    );
  }
}
 
class MovimientoPuntosModel extends MovimientoPuntosEntity {
  const MovimientoPuntosModel({
    required super.id,
    required super.cantidad,
    required super.tipo,
    required super.descripcion,
    required super.fecha,
  });
 
  factory MovimientoPuntosModel.fromJson(Map<String, dynamic> json) {
    return MovimientoPuntosModel(
      id: json['id'],
      cantidad: json['cantidad'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
