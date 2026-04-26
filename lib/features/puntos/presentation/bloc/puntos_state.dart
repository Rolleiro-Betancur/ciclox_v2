import 'package:equatable/equatable.dart';
import '../../domain/entities/puntos_entity.dart';

class PuntosState extends Equatable {
  final PuntosEntity? puntos;
  final bool isLoadingPuntos;
  final String? puntosError;

  final List<MovimientoPuntosEntity> historial;
  final bool isLoadingHistorial;
  final String? historialError;
  final bool hasMoreHistorial;
  final int currentPage;

  const PuntosState({
    this.puntos,
    this.isLoadingPuntos = false,
    this.puntosError,
    this.historial = const [],
    this.isLoadingHistorial = false,
    this.historialError,
    this.hasMoreHistorial = false,
    this.currentPage = 1,
  });

  PuntosState copyWith({
    PuntosEntity? puntos,
    bool? isLoadingPuntos,
    String? puntosError,
    List<MovimientoPuntosEntity>? historial,
    bool? isLoadingHistorial,
    String? historialError,
    bool? hasMoreHistorial,
    int? currentPage,
  }) {
    return PuntosState(
      puntos: puntos ?? this.puntos,
      isLoadingPuntos: isLoadingPuntos ?? this.isLoadingPuntos,
      puntosError: puntosError ?? this.puntosError,
      historial: historial ?? this.historial,
      isLoadingHistorial: isLoadingHistorial ?? this.isLoadingHistorial,
      historialError: historialError ?? this.historialError,
      hasMoreHistorial: hasMoreHistorial ?? this.hasMoreHistorial,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        puntos,
        isLoadingPuntos,
        puntosError,
        historial,
        isLoadingHistorial,
        historialError,
        hasMoreHistorial,
        currentPage,
      ];
}