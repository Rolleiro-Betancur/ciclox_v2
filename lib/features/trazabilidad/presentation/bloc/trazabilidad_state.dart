import 'package:equatable/equatable.dart';
import '../../domain/entities/movimiento_entity.dart';

class TrazabilidadState extends Equatable {
  final bool isLoadingHistorial;
  final bool isLoadingUbicacion;
  final String? errorHistorial;
  final String? errorUbicacion;
  final List<MovimientoEntity> movimientos;
  final UbicacionRecolectorEntity? ubicacion;

  const TrazabilidadState({
    this.isLoadingHistorial = false,
    this.isLoadingUbicacion = false,
    this.errorHistorial,
    this.errorUbicacion,
    this.movimientos = const [],
    this.ubicacion,
  });

  TrazabilidadState copyWith({
    bool? isLoadingHistorial,
    bool? isLoadingUbicacion,
    String? errorHistorial,
    String? errorUbicacion,
    List<MovimientoEntity>? movimientos,
    UbicacionRecolectorEntity? ubicacion,
    bool clearErrorHistorial = false,
    bool clearErrorUbicacion = false,
  }) {
    return TrazabilidadState(
      isLoadingHistorial: isLoadingHistorial ?? this.isLoadingHistorial,
      isLoadingUbicacion: isLoadingUbicacion ?? this.isLoadingUbicacion,
      errorHistorial:
          clearErrorHistorial ? null : (errorHistorial ?? this.errorHistorial),
      errorUbicacion:
          clearErrorUbicacion ? null : (errorUbicacion ?? this.errorUbicacion),
      movimientos: movimientos ?? this.movimientos,
      ubicacion: ubicacion ?? this.ubicacion,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingHistorial,
        isLoadingUbicacion,
        errorHistorial,
        errorUbicacion,
        movimientos,
        ubicacion,
      ];
}
