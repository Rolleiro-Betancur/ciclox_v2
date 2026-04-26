import 'package:equatable/equatable.dart';

class RecompensaEntity extends Equatable {
  final int id;
  final String nombre;
  final String descripcion;
  final String tipo; // 'BONO_CICLOX' | 'MERCADITOS'
  final int puntosRequeridos;
  final int? porcentajeDescuento;
  final int? valorMonetario;
  final String? aliados;
  final String? iconoUrl;

  const RecompensaEntity({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.puntosRequeridos,
    this.porcentajeDescuento,
    this.valorMonetario,
    this.aliados,
    this.iconoUrl,
  });

  bool get esBonoCiclox => tipo == 'BONO_CICLOX';
  bool get esMercaditos => tipo == 'MERCADITOS';

  List<String> get aliadosList =>
      aliados != null ? aliados!.split(',').map((a) => a.trim()).toList() : [];

  @override
  List<Object?> get props => [id, tipo, puntosRequeridos];
}