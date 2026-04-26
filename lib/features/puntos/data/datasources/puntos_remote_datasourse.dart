import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/puntos_model.dart';
 
abstract class PuntosRemoteDatasource {
  Future<PuntosModel> getPuntos();
  Future<List<MovimientoPuntosModel>> getHistorialPuntos({
    int page = 1,
    int limit = 20,
  });
}
 
class PuntosRemoteDatasourceImpl implements PuntosRemoteDatasource {
  final Dio _dio;
  PuntosRemoteDatasourceImpl(this._dio);
 
  @override
  Future<PuntosModel> getPuntos() async {
    final res = await _dio.get(ApiConstants.puntos);
    return PuntosModel.fromJson(res.data['data']);
  }
 
  @override
  Future<List<MovimientoPuntosModel>> getHistorialPuntos({
    int page = 1,
    int limit = 20,
  }) async {
    final res = await _dio.get(
      ApiConstants.historialPuntos,
      queryParameters: {'page': page, 'limit': limit},
    );
    final List data = res.data['data'];
    return data.map((json) => MovimientoPuntosModel.fromJson(json)).toList();
  }
}