import 'package:equatable/equatable.dart';

class DispositivoEntity extends Equatable {
  final int id;
  final String tipo;        // 'CELULAR' | 'LAPTOP' | 'TABLET' | etc.
  final String marca;
  final String modelo;
  final String? descripcion;
  final String estado;      // 'ACTIVO' | 'EN_PROCESO' | 'RECICLADO'
  final String? estadoFisico; // 'ENCIENDE' | 'DANIADO'
  final String? fotoUrl;
  final DateTime createdAt;

  const DispositivoEntity({
    required this.id,
    required this.tipo,
    required this.marca,
    required this.modelo,
    this.descripcion,
    required this.estado,
    this.estadoFisico,
    this.fotoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, tipo, marca, modelo, estado, estadoFisico];
}
