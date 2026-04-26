import 'package:flutter_bloc/flutter_bloc.dart';
import 'canjes_event.dart';
import 'canjes_state.dart';
import '../../domain/usecases/crear_canje_usecase.dart';
import '../../domain/usecases/get_canjes_usecase.dart';

class CanjesBloc extends Bloc<CanjesEvent, CanjesState> {
  final CrearCanjeUsecase _crearCanjeUsecase;
  final GetCanjesUsecase _getCanjesUsecase;

  CanjesBloc({
    required CrearCanjeUsecase crearCanjeUsecase,
    required GetCanjesUsecase getCanjesUsecase,
  })  : _crearCanjeUsecase = crearCanjeUsecase,
        _getCanjesUsecase = getCanjesUsecase,
        super(const CanjesState()) {
    on<LoadCanjes>(_onLoadCanjes);
    on<CrearCanjeRequested>(_onCrearCanje);
    on<ClearCanjeActual>(_onClearCanjeActual);
  }

  Future<void> _onLoadCanjes(LoadCanjes event, Emitter<CanjesState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getCanjesUsecase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (canjes) => emit(state.copyWith(isLoading: false, canjes: canjes, clearError: true)),
    );
  }

  Future<void> _onCrearCanje(
    CrearCanjeRequested event,
    Emitter<CanjesState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _crearCanjeUsecase(recompensaId: event.recompensaId);
    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, error: failure.message)),
      (canje) => emit(
        state.copyWith(
          isSubmitting: false,
          canjeActual: canje,
          canjes: [canje, ...state.canjes],
          clearError: true,
        ),
      ),
    );
  }

  void _onClearCanjeActual(ClearCanjeActual event, Emitter<CanjesState> emit) {
    emit(state.copyWith(clearCanjeActual: true));
  }
}
