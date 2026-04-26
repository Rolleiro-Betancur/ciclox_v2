import 'package:equatable/equatable.dart';

class RecolectorEntity extends Equatable {
  final int id;
  final String nombre;
  final String? telefono;
  final String? fotoUrl;
  final bool activo;

  const RecolectorEntity({
    required this.id,
    required this.nombre,
    this.telefono,
    this.fotoUrl,
    required this.activo,
  });

  @override
  List<Object?> get props => [id, nombre, telefono, fotoUrl, activo];
}
