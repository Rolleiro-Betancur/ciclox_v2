import 'package:equatable/equatable.dart';

class CanjeEntity extends Equatable {
  final int id;
  final int recompensaId;
  final String recompensaNombre;
  final String tipoRecompensa;
  final int puntosUsados;
  final String codigoQr;
  final DateTime fechaExpiracion;
  final String estado;
  final DateTime creadoEn;

  const CanjeEntity({
    required this.id,
    required this.recompensaId,
    required this.recompensaNombre,
    required this.tipoRecompensa,
    required this.puntosUsados,
    required this.codigoQr,
    required this.fechaExpiracion,
    required this.estado,
    required this.creadoEn,
  });

  bool get expirado => DateTime.now().isAfter(fechaExpiracion);
  bool get esBonoCiclox => tipoRecompensa == 'BONO_CICLOX';
  bool get esMercaditos => tipoRecompensa == 'MERCADITOS';

  @override
  List<Object?> get props => [id, estado, fechaExpiracion];
}
