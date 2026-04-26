import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/aceptar_empresa_solicitud_usecase.dart';
import '../../domain/usecases/get_empresa_solicitudes_usecase.dart';
import '../../domain/usecases/marcar_en_transito_empresa_solicitud_usecase.dart';
import '../../domain/usecases/marcar_recolectada_empresa_solicitud_usecase.dart';
import '../../domain/usecases/rechazar_empresa_solicitud_usecase.dart';
import 'empresa_solicitudes_event.dart';
import 'empresa_solicitudes_state.dart';

class EmpresaSolicitudesBloc
    extends Bloc<EmpresaSolicitudesEvent, EmpresaSolicitudesState> {
  final GetEmpresaSolicitudesUsecase _getSolicitudes;
  final AceptarEmpresaSolicitudUsecase _aceptarSolicitud;
  final RechazarEmpresaSolicitudUsecase _rechazarSolicitud;
  final MarcarEnTransitoEmpresaSolicitudUsecase _marcarEnTransito;
  final MarcarRecolectadaEmpresaSolicitudUsecase _marcarRecolectada;

  String? _lastEstado;

  EmpresaSolicitudesBloc({
    required GetEmpresaSolicitudesUsecase getSolicitudes,
    required AceptarEmpresaSolicitudUsecase aceptarSolicitud,
    required RechazarEmpresaSolicitudUsecase rechazarSolicitud,
    required MarcarEnTransitoEmpresaSolicitudUsecase marcarEnTransito,
    required MarcarRecolectadaEmpresaSolicitudUsecase marcarRecolectada,
  })  : _getSolicitudes = getSolicitudes,
        _aceptarSolicitud = aceptarSolicitud,
        _rechazarSolicitud = rechazarSolicitud,
        _marcarEnTransito = marcarEnTransito,
        _marcarRecolectada = marcarRecolectada,
        super(EmpresaSolicitudesInitial()) {
    on<LoadEmpresaSolicitudes>(_onLoadSolicitudes);
    on<AceptarEmpresaSolicitud>(_onAceptarSolicitud);
    on<RechazarEmpresaSolicitud>(_onRechazarSolicitud);
    on<MarcarSolicitudEnTransito>(_onMarcarEnTransito);
    on<MarcarSolicitudRecolectada>(_onMarcarRecolectada);
  }

  Future<void> _onLoadSolicitudes(
    LoadEmpresaSolicitudes event,
    Emitter<EmpresaSolicitudesState> emit,
  ) async {
    emit(EmpresaSolicitudesLoading());
    _lastEstado = event.estado;
    final result = await _getSolicitudes(estado: event.estado);
    result.fold(
      (failure) => emit(EmpresaSolicitudesError(failure.message)),
      (solicitudes) => emit(
        EmpresaSolicitudesLoaded(
          solicitudes: solicitudes,
          estadoFiltro: event.estado,
        ),
      ),
    );
  }

  Future<void> _onAceptarSolicitud(
    AceptarEmpresaSolicitud event,
    Emitter<EmpresaSolicitudesState> emit,
  ) async {
    emit(EmpresaSolicitudesLoading());
    final result = await _aceptarSolicitud(
      id: event.solicitudId,
      recolectorId: event.recolectorId,
      horaEstimadaInicio: event.horaEstimadaInicio,
      horaEstimadaFin: event.horaEstimadaFin,
      comentarioEmpresa: event.comentarioEmpresa,
    );
    await result.fold(
      (failure) async => emit(EmpresaSolicitudesError(failure.message)),
      (_) async {
        emit(const EmpresaSolicitudesActionSuccess('Solicitud aceptada'));
        add(LoadEmpresaSolicitudes(estado: _lastEstado));
      },
    );
  }

  Future<void> _onRechazarSolicitud(
    RechazarEmpresaSolicitud event,
    Emitter<EmpresaSolicitudesState> emit,
  ) async {
    emit(EmpresaSolicitudesLoading());
    final result = await _rechazarSolicitud(
      id: event.solicitudId,
      motivo: event.motivo,
    );
    await result.fold(
      (failure) async => emit(EmpresaSolicitudesError(failure.message)),
      (_) async {
        emit(const EmpresaSolicitudesActionSuccess('Solicitud rechazada'));
        add(LoadEmpresaSolicitudes(estado: _lastEstado));
      },
    );
  }

  Future<void> _onMarcarEnTransito(
    MarcarSolicitudEnTransito event,
    Emitter<EmpresaSolicitudesState> emit,
  ) async {
    emit(EmpresaSolicitudesLoading());
    final result = await _marcarEnTransito(
      id: event.solicitudId,
      latitudRecolector: event.latitudRecolector,
      longitudRecolector: event.longitudRecolector,
      tiempoEstimadoMinutos: event.tiempoEstimadoMinutos,
    );
    await result.fold(
      (failure) async => emit(EmpresaSolicitudesError(failure.message)),
      (_) async {
        emit(const EmpresaSolicitudesActionSuccess('Solicitud en tránsito'));
        add(LoadEmpresaSolicitudes(estado: _lastEstado));
      },
    );
  }

  Future<void> _onMarcarRecolectada(
    MarcarSolicitudRecolectada event,
    Emitter<EmpresaSolicitudesState> emit,
  ) async {
    emit(EmpresaSolicitudesLoading());
    final result = await _marcarRecolectada(
      id: event.solicitudId,
      puntosOtorgados: event.puntosOtorgados,
      evidenciaUrl: event.evidenciaUrl,
    );
    await result.fold(
      (failure) async => emit(EmpresaSolicitudesError(failure.message)),
      (_) async {
        emit(const EmpresaSolicitudesActionSuccess('Solicitud recolectada'));
        add(LoadEmpresaSolicitudes(estado: _lastEstado));
      },
    );
  }
}
