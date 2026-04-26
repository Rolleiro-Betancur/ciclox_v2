import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/dispositivo_model.dart';

abstract class DispositivosRemoteDatasource {
  Future<List<DispositivoModel>> obtenerDispositivos();
  Future<DispositivoModel> crearDispositivo(Map<String, dynamic> body);
  Future<void> eliminarDispositivo(int id);
}

class DispositivosRemoteDatasourceImpl implements DispositivosRemoteDatasource {
  final Dio _dio;

  DispositivosRemoteDatasourceImpl(this._dio);

  @override
  Future<List<DispositivoModel>> obtenerDispositivos() async {
    final res = await _dio.get(ApiConstants.dispositivos);
    final data = res.data['data'] as List;
    return data.map((e) => DispositivoModel.fromJson(e)).toList();
  }

  @override
  Future<DispositivoModel> crearDispositivo(Map<String, dynamic> body) async {
    final res = await _dio.post(ApiConstants.dispositivos, data: body);
    final data = res.data['data'];
    return DispositivoModel.fromJson(data);
  }

  @override
  Future<void> eliminarDispositivo(int id) async {
    await _dio.delete(ApiConstants.dispositivoById(id));
  }
}
