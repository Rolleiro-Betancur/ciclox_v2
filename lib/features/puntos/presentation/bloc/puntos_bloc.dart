import 'package:flutter_bloc/flutter_bloc.dart';
import 'puntos_event.dart';
import 'puntos_state.dart';
import '../../domain/usecases/get_puntos_usecase.dart';
import '../../domain/usecases/get_historial_puntos_usecase.dart';
import '../../domain/entities/puntos_entity.dart';

class PuntosBloc extends Bloc<PuntosEvent, PuntosState> {
  final GetPuntosUsecase _getPuntosUsecase;
  final GetHistorialPuntosUsecase _getHistorialPuntosUsecase;

  PuntosBloc({
    required GetPuntosUsecase getPuntosUsecase,
    required GetHistorialPuntosUsecase getHistorialPuntosUsecase,
  })  : _getPuntosUsecase = getPuntosUsecase,
        _getHistorialPuntosUsecase = getHistorialPuntosUsecase,
        super(const PuntosState()) {
    on<LoadPuntos>(_onLoadPuntos);
    on<RefreshPuntos>(_onRefreshPuntos);
    on<LoadHistorialPuntos>(_onLoadHistorial);
  }

  Future<void> _onLoadPuntos(LoadPuntos event, Emitter<PuntosState> emit) async {
    emit(state.copyWith(isLoadingPuntos: true, puntosError: null));
    try {
      final result = await _getPuntosUsecase();
      result.fold(
        (failure) => emit(state.copyWith(isLoadingPuntos: false, puntosError: failure.message)),
        (puntos) => emit(state.copyWith(isLoadingPuntos: false, puntos: puntos, puntosError: null)),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingPuntos: false, puntosError: "Error de formato de datos: ${e.toString()}"));
    }
  }

  Future<void> _onRefreshPuntos(RefreshPuntos event, Emitter<PuntosState> emit) async {
    try {
      final result = await _getPuntosUsecase();
      result.fold(
        (failure) => emit(state.copyWith(puntosError: failure.message)),
        (puntos) => emit(state.copyWith(puntos: puntos, puntosError: null)),
      );
    } catch (e) {
      emit(state.copyWith(puntosError: "Error de formato de datos: ${e.toString()}"));
    }
  }

  Future<void> _onLoadHistorial(LoadHistorialPuntos event, Emitter<PuntosState> emit) async {
    if (event.page == 1) {
      emit(state.copyWith(isLoadingHistorial: true, historialError: null, historial: [], currentPage: 1));
    } else {
      emit(state.copyWith(isLoadingHistorial: true, historialError: null));
    }

    try {
      final result = await _getHistorialPuntosUsecase(page: event.page, limit: event.limit);
      result.fold(
        (failure) => emit(state.copyWith(isLoadingHistorial: false, historialError: failure.message)),
        (nuevos) {
          final isFirstPage = event.page == 1;
          final updatedList = isFirstPage ? nuevos : [...state.historial, ...nuevos];
          emit(state.copyWith(
            isLoadingHistorial: false,
            historial: updatedList,
            hasMoreHistorial: nuevos.length == event.limit,
            currentPage: event.page,
            historialError: null,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoadingHistorial: false, historialError: e.toString()));
    }
  }
}