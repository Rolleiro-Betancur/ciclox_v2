import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/notificacion_model.dart';

abstract class NotificacionesRemoteDatasource {
  Future<List<NotificacionModel>> getNotificaciones();
  Future<void> marcarLeida(int id);
  Future<void> marcarTodasLeidas();
}

class NotificacionesRemoteDatasourceImpl implements NotificacionesRemoteDatasource {
  final Dio _dio;
  NotificacionesRemoteDatasourceImpl(this._dio);

  @override
  Future<List<NotificacionModel>> getNotificaciones() async {
    final res = await _dio.get(ApiConstants.notificaciones);
    final rawData = res.data['data'];
    if (rawData == null) return [];
    final list = rawData is List ? rawData : <dynamic>[];
    return list
        .map((json) => NotificacionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> marcarLeida(int id) async {
    await _dio.patch(ApiConstants.leerNotificacion(id));
  }

  @override
  Future<void> marcarTodasLeidas() async {
    await _dio.patch(ApiConstants.leerTodasNotificaciones);
  }
}
