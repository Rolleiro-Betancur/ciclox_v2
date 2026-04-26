import 'package:flutter_bloc/flutter_bloc.dart';
import 'recompensas_event.dart';
import 'recompensas_state.dart';
import '../../domain/usecases/get_recompensas_usecase.dart';
import '../../domain/usecases/get_recompensa_usecase.dart';

class RecompensasBloc extends Bloc<RecompensasEvent, RecompensasState> {
  final GetRecompensasUsecase _getRecompensasUsecase;
  final GetRecompensaUsecase _getRecompensaUsecase;

  RecompensasBloc({
    required GetRecompensasUsecase getRecompensasUsecase,
    required GetRecompensaUsecase getRecompensaUsecase,
  })  : _getRecompensasUsecase = getRecompensasUsecase,
        _getRecompensaUsecase = getRecompensaUsecase,
        super(RecompensasInitial()) {
    on<LoadRecompensas>(_onLoadRecompensas);
    on<LoadRecompensa>(_onLoadRecompensa);
  }

  Future<void> _onLoadRecompensas(
      LoadRecompensas event, Emitter<RecompensasState> emit) async {
    emit(RecompensasLoading());
    final result = await _getRecompensasUsecase();
    result.fold(
      (failure) => emit(RecompensasError(failure.message)),
      (recompensas) => emit(RecompensasLoaded(recompensas: recompensas)),
    );
  }

  Future<void> _onLoadRecompensa(
      LoadRecompensa event, Emitter<RecompensasState> emit) async {
    emit(RecompensaDetalleLoading());
    final result = await _getRecompensaUsecase(event.id);
    result.fold(
      (failure) => emit(RecompensaDetalleError(failure.message)),
      (recompensa) => emit(RecompensaDetalleLoaded(recompensa: recompensa)),
    );
  }
}