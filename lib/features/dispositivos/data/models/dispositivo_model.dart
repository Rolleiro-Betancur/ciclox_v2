import '../../domain/entities/dispositivo_entity.dart';

class DispositivoModel extends DispositivoEntity {
  const DispositivoModel({
    required super.id,
    required super.tipo,
    required super.marca,
    required super.modelo,
    super.descripcion,
    required super.estado,
    super.estadoFisico,
    super.fotoUrl,
    required super.createdAt,
  });

  factory DispositivoModel.fromJson(Map<String, dynamic> json) {
    return DispositivoModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      tipo: json['tipo'] as String? ?? 'OTRO',
      marca: json['marca'] as String? ?? 'Desconocida',
      modelo: json['modelo'] as String? ?? 'Desconocido',
      descripcion: json['descripcion'] as String?,
      estado: json['estado'] as String? ?? 'ACTIVO',
      estadoFisico: json['estado_fisico'] as String?,
      fotoUrl: json['foto_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
