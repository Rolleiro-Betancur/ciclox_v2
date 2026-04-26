import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/crear_recolector_usecase.dart';
import '../../domain/usecases/desactivar_recolector_usecase.dart';
import '../../domain/usecases/get_recolectores_usecase.dart';
import 'recolectores_event.dart';
import 'recolectores_state.dart';

class RecolectoresBloc extends Bloc<RecolectoresEvent, RecolectoresState> {
  final GetRecolectoresUsecase _getRecolectores;
  final CrearRecolectorUsecase _crearRecolector;
  final DesactivarRecolectorUsecase _desactivarRecolector;

  bool? _lastFiltroActivo;

  RecolectoresBloc({
    required GetRecolectoresUsecase getRecolectores,
    required CrearRecolectorUsecase crearRecolector,
    required DesactivarRecolectorUsecase desactivarRecolector,
  })  : _getRecolectores = getRecolectores,
        _crearRecolector = crearRecolector,
        _desactivarRecolector = desactivarRecolector,
        super(RecolectoresInitial()) {
    on<LoadRecolectores>(_onLoadRecolectores);
    on<CrearRecolector>(_onCrearRecolector);
    on<DesactivarRecolector>(_onDesactivarRecolector);
  }

  Future<void> _onLoadRecolectores(
    LoadRecolectores event,
    Emitter<RecolectoresState> emit,
  ) async {
    emit(RecolectoresLoading());
    _lastFiltroActivo = event.activo;
    final result = await _getRecolectores(activo: event.activo);
    result.fold(
      (failure) => emit(RecolectoresError(failure.message)),
      (data) => emit(RecolectoresLoaded(recolectores: data, filtroActivo: event.activo)),
    );
  }

  Future<void> _onCrearRecolector(
    CrearRecolector event,
    Emitter<RecolectoresState> emit,
  ) async {
    emit(RecolectoresLoading());
    final result = await _crearRecolector(
      nombre: event.nombre,
      telefono: event.telefono,
      fotoUrl: event.fotoUrl,
    );
    await result.fold(
      (failure) async => emit(RecolectoresError(failure.message)),
      (_) async {
        emit(const RecolectoresActionSuccess('Recolector creado correctamente'));
        add(LoadRecolectores(activo: _lastFiltroActivo));
      },
    );
  }

  Future<void> _onDesactivarRecolector(
    DesactivarRecolector event,
    Emitter<RecolectoresState> emit,
  ) async {
    emit(RecolectoresLoading());
    final result = await _desactivarRecolector(event.id);
    await result.fold(
      (failure) async => emit(RecolectoresError(failure.message)),
      (_) async {
        emit(const RecolectoresActionSuccess('Recolector desactivado correctamente'));
        add(LoadRecolectores(activo: _lastFiltroActivo));
      },
    );
  }
}
