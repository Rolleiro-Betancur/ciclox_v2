import '../../domain/entities/empresa_solicitud_entity.dart';

class EmpresaSolicitudModel extends EmpresaSolicitudEntity {
  const EmpresaSolicitudModel({
    required super.id,
    required super.usuarioId,
    required super.nombreSolicitante,
    super.emailSolicitante,
    super.telefonoContacto,
    required super.direccionRecoleccion,
    required super.fechaPreferida,
    required super.estado,
    super.referencia,
    super.motivoRechazo,
    required super.createdAt,
  });

  factory EmpresaSolicitudModel.fromJson(Map<String, dynamic> json) {
    final usuario = (json['usuario'] as Map<String, dynamic>?) ?? const {};

    return EmpresaSolicitudModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      usuarioId: (json['usuario_id'] as num?)?.toInt() ?? 0,
      nombreSolicitante: (usuario['nombre'] as String?) ?? 'Usuario',
      emailSolicitante: usuario['email'] as String?,
      telefonoContacto: json['telefono_contacto'] as String?,
      direccionRecoleccion: (json['direccion_recoleccion'] as String?) ?? 'Sin dirección',
      fechaPreferida: DateTime.tryParse((json['fecha_preferida'] as String?) ?? '') ?? DateTime.now(),
      estado: (json['estado'] as String?) ?? 'PENDIENTE',
      referencia: json['referencia'] as String?,
      motivoRechazo: json['motivo_rechazo'] as String?,
      createdAt: DateTime.tryParse((json['fecha_creacion'] as String?) ?? '') ?? DateTime.now(),
    );
  }
}
