import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/solicitud_model.dart';

abstract class SolicitudesRemoteDataSource {
  Future<List<SolicitudModel>> getSolicitudes({String? estado});
  Future<SolicitudModel> crearSolicitud(Map<String, dynamic> body);
  Future<void> cancelarSolicitud(int id);
}

class SolicitudesRemoteDataSourceImpl implements SolicitudesRemoteDataSource {
  final Dio _dio;
  SolicitudesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SolicitudModel>> getSolicitudes({String? estado}) async {
    final response = await _dio.get(
      ApiConstants.solicitudes, // Que debe ser '/api/solicitudes'
      queryParameters: estado != null ? {'estado': estado} : null,
    );
    final data = response.data['data'] as List;
    return data.map((json) => SolicitudModel.fromJson(json)).toList();
  }

  @override
  Future<SolicitudModel> crearSolicitud(Map<String, dynamic> body) async {
    final response = await _dio.post(
      ApiConstants.solicitudes,
      data: body,
    );
    return SolicitudModel.fromJson(response.data['data']);
  }

  @override
  Future<void> cancelarSolicitud(int id) async {
    await _dio.patch('${ApiConstants.solicitudes}/$id/cancelar');
  }
}
