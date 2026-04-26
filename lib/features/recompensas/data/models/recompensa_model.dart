import '../../domain/entities/recompensa_entity.dart';

class RecompensaModel extends RecompensaEntity {
  const RecompensaModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.tipo,
    required super.puntosRequeridos,
    super.porcentajeDescuento,
    super.valorMonetario,
    super.aliados,
    super.iconoUrl,
  });

  factory RecompensaModel.fromJson(Map<String, dynamic> json) {
    return RecompensaModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tipo: json['tipo'],
      puntosRequeridos: json['puntos_requeridos'],
      porcentajeDescuento: json['porcentaje_descuento'],
      valorMonetario: json['valor_monetario'],
      aliados: json['aliados'],
      iconoUrl: json['icono_url'],
    );
  }
}