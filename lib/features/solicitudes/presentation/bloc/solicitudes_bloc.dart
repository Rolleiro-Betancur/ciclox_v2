import 'package:flutter_bloc/flutter_bloc.dart';
import 'solicitudes_event.dart';
import 'solicitudes_state.dart';
import '../../domain/usecases/get_solicitudes_usecase.dart';
import '../../domain/usecases/crear_solicitud_usecase.dart';
import '../../domain/usecases/cancelar_solicitud_usecase.dart';

class SolicitudesBloc extends Bloc<SolicitudesEvent, SolicitudesState> {
  final GetSolicitudesUseCase _getSolicitudes;
  final CrearSolicitudUseCase _crearSolicitud;
  final CancelarSolicitudUseCase _cancelarSolicitud;

  SolicitudesBloc(
    this._getSolicitudes,
    this._crearSolicitud,
    this._cancelarSolicitud,
  ) : super(SolicitudesInitial()) {
    on<LoadSolicitudes>(_onLoad);
    on<CrearSolicitud>(_onCreate);
    on<CancelarSolicitud>(_onCancelar);
  }

  Future<void> _onLoad(
      LoadSolicitudes event, Emitter<SolicitudesState> emit) async {
    emit(SolicitudesLoading());
    final result = await _getSolicitudes();
    result.fold(
      (failure) => emit(SolicitudesError(failure.message)),
      (solicitudes) => emit(SolicitudesLoaded(solicitudes)),
    );
  }

  Future<void> _onCreate(
      CrearSolicitud event, Emitter<SolicitudesState> emit) async {
    emit(SolicitudesLoading());
    
    // Preparar el body según la API
    final body = {
      "tipo_recoleccion": "DOMICILIO",
      "dispositivos": event.dispositivosIds.map((id) => {"dispositivo_id": id, "cantidad": 1}).toList(),
      "direccion_recoleccion": event.direccion,
      "ciudad": event.ciudad,
      "departamento": event.departamento,
      "referencia": event.referencia,
      "telefono_contacto": "3000000000",
      "email_contacto": event.email,
      "fecha_preferida": DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T').first,
    };

    final result = await _crearSolicitud(body);
    result.fold(
      (failure) => emit(SolicitudesError(failure.message)),
      (solicitud) => emit(SolicitudCreada(solicitud)),
    );
  }

  Future<void> _onCancelar(
      CancelarSolicitud event, Emitter<SolicitudesState> emit) async {
    emit(SolicitudesLoading());
    final result = await _cancelarSolicitud(event.id);
    result.fold(
      (failure) => emit(SolicitudesError(failure.message)),
      (_) => emit(SolicitudCancelada()),
    );
  }
}
