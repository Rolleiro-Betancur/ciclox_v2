import 'package:flutter_bloc/flutter_bloc.dart';
import 'dispositivos_event.dart';
import 'dispositivos_state.dart';
import '../../domain/usecases/dispositivos_usecases.dart';

class DispositivosBloc extends Bloc<DispositivosEvent, DispositivosState> {
  final ObtenerDispositivosUsecase _obtenerUsecase;
  final CrearDispositivoUsecase _crearUsecase;
  final EliminarDispositivoUsecase _eliminarUsecase;

  DispositivosBloc({
    required ObtenerDispositivosUsecase obtenerUsecase,
    required CrearDispositivoUsecase crearUsecase,
    required EliminarDispositivoUsecase eliminarUsecase,
  })  : _obtenerUsecase = obtenerUsecase,
        _crearUsecase = crearUsecase,
        _eliminarUsecase = eliminarUsecase,
        super(DispositivosInitial()) {
    on<LoadDispositivos>(_onLoad);
    on<CrearDispositivo>(_onCreate);
    on<EliminarDispositivo>(_onEliminar);
  }

  Future<void> _onLoad(
      LoadDispositivos event, Emitter<DispositivosState> emit) async {
    emit(DispositivosLoading());

    final result = await _obtenerUsecase();

    result.fold(
      (failure) => emit(DispositivosError(failure.message)),
      (dispositivos) => emit(DispositivosLoaded(dispositivos)),
    );
  }

  Future<void> _onCreate(
      CrearDispositivo event, Emitter<DispositivosState> emit) async {
    emit(DispositivosLoading());

    String tipoApi = event.tipo;

    final body = {
      'tipo': tipoApi,
      'marca': event.marca,
      'modelo': event.modelo,
      'descripcion': event.descripcion,
      'estado_fisico': event.estadoFisico, 
      // TODO: Manejar foto_url real si el backend implementa upload
    };

    final result = await _crearUsecase(body);

    result.fold(
      (failure) => emit(DispositivosError(failure.message)),
      (dispositivo) => emit(DispositivoCreado(dispositivo)),
    );
  }

  Future<void> _onEliminar(
      EliminarDispositivo event, Emitter<DispositivosState> emit) async {
    emit(DispositivosLoading());

    final result = await _eliminarUsecase(event.id);

    result.fold(
      (failure) => emit(DispositivosError(failure.message)),
      (_) => emit(DispositivoEliminado()),
    );
  }
}
