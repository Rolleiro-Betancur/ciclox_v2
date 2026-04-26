import '../../domain/entities/recolector_entity.dart';

class RecolectorModel extends RecolectorEntity {
  const RecolectorModel({
    required super.id,
    required super.nombre,
    super.telefono,
    super.fotoUrl,
    required super.activo,
  });

  factory RecolectorModel.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'];
    final nombre = usuario is Map<String, dynamic>
        ? (usuario['nombre'] as String? ?? 'Recolector')
        : (json['nombre'] as String? ?? 'Recolector');

    return RecolectorModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: nombre,
      telefono: json['telefono'] as String?,
      fotoUrl: json['foto_url'] as String?,
      activo: (json['activo'] as bool?) ?? true,
    );
  }
}
