import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/movimiento_model.dart';

abstract class TrazabilidadRemoteDatasource {
  Future<List<MovimientoModel>> getTrazabilidadDispositivo(int dispositivoId);
  Future<UbicacionRecolectorModel> getUbicacionRecolector(int solicitudId);
}

class TrazabilidadRemoteDatasourceImpl implements TrazabilidadRemoteDatasource {
  final Dio _dio;
  TrazabilidadRemoteDatasourceImpl(this._dio);

  @override
  Future<List<MovimientoModel>> getTrazabilidadDispositivo(int dispositivoId) async {
    final res = await _dio.get(ApiConstants.trazabilidadDispositivo(dispositivoId));
    final rawData = res.data['data'];
    if (rawData == null) return [];
    // La API devuelve { dispositivo: {...}, movimientos: [...] }
    final list = rawData is Map
        ? (rawData['movimientos'] as List? ?? [])
        : (rawData is List ? rawData : <dynamic>[]);
    return list
        .map((json) => MovimientoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UbicacionRecolectorModel> getUbicacionRecolector(int solicitudId) async {
    final res = await _dio.get(ApiConstants.ubicacionRecolector(solicitudId));
    final rawData = res.data['data'] as Map<String, dynamic>? ?? {};
    return UbicacionRecolectorModel.fromJson(rawData);
  }
}
