import 'package:dio/dio.dart';

import '../../../../../core/constants/api_constants.dart';
import '../models/empresa_solicitud_model.dart';

abstract class EmpresaSolicitudesRemoteDatasource {
  Future<List<EmpresaSolicitudModel>> getSolicitudes({String? estado});
  Future<void> aceptarSolicitud({
    required int id,
    required int recolectorId,
    required String horaEstimadaInicio,
    required String horaEstimadaFin,
    String? comentarioEmpresa,
  });
  Future<void> rechazarSolicitud({required int id, required String motivo});
  Future<void> marcarEnTransito({
    required int id,
    double? latitudRecolector,
    double? longitudRecolector,
    int? tiempoEstimadoMinutos,
  });
  Future<void> marcarRecolectada({
    required int id,
    required int puntosOtorgados,
    String? evidenciaUrl,
  });
}

class EmpresaSolicitudesRemoteDatasourceImpl
    implements EmpresaSolicitudesRemoteDatasource {
  final Dio _dio;

  EmpresaSolicitudesRemoteDatasourceImpl(this._dio);

  @override
  Future<List<EmpresaSolicitudModel>> getSolicitudes({String? estado}) async {
    final response = await _dio.get(
      ApiConstants.empresaSolicitudes,
      queryParameters: estado != null ? {'estado': estado} : null,
    );
    final data = (response.data['data'] as List?) ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(EmpresaSolicitudModel.fromJson)
        .toList();
  }

  @override
  Future<void> aceptarSolicitud({
    required int id,
    required int recolectorId,
    required String horaEstimadaInicio,
    required String horaEstimadaFin,
    String? comentarioEmpresa,
  }) async {
    await _dio.patch(
      ApiConstants.aceptarSolicitud(id),
      data: {
        'recolector_id': recolectorId,
        'hora_estimada_inicio': horaEstimadaInicio,
        'hora_estimada_fin': horaEstimadaFin,
        if (comentarioEmpresa != null && comentarioEmpresa.isNotEmpty)
          'comentario_empresa': comentarioEmpresa,
      },
    );
  }

  @override
  Future<void> rechazarSolicitud({required int id, required String motivo}) async {
    await _dio.patch(
      ApiConstants.rechazarSolicitud(id),
      data: {'motivo_rechazo': motivo},
    );
  }

  @override
  Future<void> marcarEnTransito({
    required int id,
    double? latitudRecolector,
    double? longitudRecolector,
    int? tiempoEstimadoMinutos,
  }) async {
    await _dio.patch(
      ApiConstants.enTransitoSolicitud(id),
      data: {
        if (latitudRecolector != null) 'latitud_recolector': latitudRecolector,
        if (longitudRecolector != null) 'longitud_recolector': longitudRecolector,
        if (tiempoEstimadoMinutos != null)
          'tiempo_estimado_minutos': tiempoEstimadoMinutos,
      },
    );
  }

  @override
  Future<void> marcarRecolectada({
    required int id,
    required int puntosOtorgados,
    String? evidenciaUrl,
  }) async {
    await _dio.patch(
      ApiConstants.recolectadaSolicitud(id),
      data: {
        'puntos_otorgados': puntosOtorgados,
        if (evidenciaUrl != null && evidenciaUrl.isNotEmpty)
          'evidencia_url': evidenciaUrl,
      },
    );
  }
}
