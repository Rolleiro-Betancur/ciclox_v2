import 'package:flutter_bloc/flutter_bloc.dart';
import 'trazabilidad_event.dart';
import 'trazabilidad_state.dart';
import '../../domain/usecases/get_trazabilidad_usecase.dart';
import '../../domain/usecases/get_ubicacion_recolector_usecase.dart';

class TrazabilidadBloc extends Bloc<TrazabilidadEvent, TrazabilidadState> {
  final GetTrazabilidadUsecase _getTrazabilidadUsecase;
  final GetUbicacionRecolectorUsecase _getUbicacionRecolectorUsecase;

  TrazabilidadBloc({
    required GetTrazabilidadUsecase getTrazabilidadUsecase,
    required GetUbicacionRecolectorUsecase getUbicacionRecolectorUsecase,
  })  : _getTrazabilidadUsecase = getTrazabilidadUsecase,
        _getUbicacionRecolectorUsecase = getUbicacionRecolectorUsecase,
        super(const TrazabilidadState()) {
    on<LoadTrazabilidadDispositivo>(_onLoadTrazabilidad);
    on<LoadUbicacionRecolector>(_onLoadUbicacion);
  }

  Future<void> _onLoadTrazabilidad(
    LoadTrazabilidadDispositivo event,
    Emitter<TrazabilidadState> emit,
  ) async {
    emit(state.copyWith(isLoadingHistorial: true, clearErrorHistorial: true));
    final result = await _getTrazabilidadUsecase(event.dispositivoId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingHistorial: false,
          errorHistorial: failure.message,
        ),
      ),
      (movimientos) => emit(
        state.copyWith(
          isLoadingHistorial: false,
          movimientos: movimientos,
          clearErrorHistorial: true,
        ),
      ),
    );
  }

  Future<void> _onLoadUbicacion(
    LoadUbicacionRecolector event,
    Emitter<TrazabilidadState> emit,
  ) async {
    emit(state.copyWith(isLoadingUbicacion: true, clearErrorUbicacion: true));
    final result = await _getUbicacionRecolectorUsecase(event.solicitudId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingUbicacion: false,
          errorUbicacion: failure.message,
        ),
      ),
      (ubicacion) => emit(
        state.copyWith(
          isLoadingUbicacion: false,
          ubicacion: ubicacion,
          clearErrorUbicacion: true,
        ),
      ),
    );
  }
}
