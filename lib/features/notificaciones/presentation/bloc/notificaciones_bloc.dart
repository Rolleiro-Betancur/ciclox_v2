import 'package:flutter_bloc/flutter_bloc.dart';
import 'notificaciones_event.dart';
import 'notificaciones_state.dart';
import '../../domain/usecases/get_notificaciones_usecase.dart';
import '../../domain/usecases/marcar_leida_usecase.dart';
import '../../domain/usecases/marcar_todas_leidas_usecase.dart';

class NotificacionesBloc extends Bloc<NotificacionesEvent, NotificacionesState> {
  final GetNotificacionesUsecase _getNotificacionesUsecase;
  final MarcarLeidaUsecase _marcarLeidaUsecase;
  final MarcarTodasLeidasUsecase _marcarTodasLeidasUsecase;

  NotificacionesBloc({
    required GetNotificacionesUsecase getNotificacionesUsecase,
    required MarcarLeidaUsecase marcarLeidaUsecase,
    required MarcarTodasLeidasUsecase marcarTodasLeidasUsecase,
  })  : _getNotificacionesUsecase = getNotificacionesUsecase,
        _marcarLeidaUsecase = marcarLeidaUsecase,
        _marcarTodasLeidasUsecase = marcarTodasLeidasUsecase,
        super(const NotificacionesState()) {
    on<LoadNotificaciones>(_onLoad);
    on<MarcarNotificacionLeidaRequested>(_onMarcarLeida);
    on<MarcarTodasLeidasRequested>(_onMarcarTodas);
  }

  Future<void> _onLoad(
    LoadNotificaciones event,
    Emitter<NotificacionesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getNotificacionesUsecase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items, clearError: true)),
    );
  }

  Future<void> _onMarcarLeida(
    MarcarNotificacionLeidaRequested event,
    Emitter<NotificacionesState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, clearError: true));
    final result = await _marcarLeidaUsecase(event.id);
    await result.fold(
      (failure) async {
        emit(state.copyWith(isUpdating: false, error: failure.message));
      },
      (_) async {
        final updated = state.items
            .map((n) => n.id == event.id
                ? n.copyWith(leida: true)
                : n)
            .toList();
        emit(state.copyWith(isUpdating: false, items: updated, clearError: true));
      },
    );
  }

  Future<void> _onMarcarTodas(
    MarcarTodasLeidasRequested event,
    Emitter<NotificacionesState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, clearError: true));
    final result = await _marcarTodasLeidasUsecase();
    await result.fold(
      (failure) async {
        emit(state.copyWith(isUpdating: false, error: failure.message));
      },
      (_) async {
        final updated = state.items.map((n) => n.copyWith(leida: true)).toList();
        emit(state.copyWith(isUpdating: false, items: updated, clearError: true));
      },
    );
  }
}
