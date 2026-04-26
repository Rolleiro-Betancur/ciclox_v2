import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/recompensa_model.dart';

abstract class RecompensasRemoteDatasource {
  Future<List<RecompensaModel>> getRecompensas();
  Future<RecompensaModel> getRecompensa(int id);
}

class RecompensasRemoteDatasourceImpl implements RecompensasRemoteDatasource {
  final Dio _dio;
  RecompensasRemoteDatasourceImpl(this._dio);

  @override
  Future<List<RecompensaModel>> getRecompensas() async {
    final res = await _dio.get(ApiConstants.recompensas);
    final dynamic rawData = res.data['data'];
    if (rawData == null) return [];
    final List data = rawData is List ? rawData : [];
    return data
        .map((json) => RecompensaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RecompensaModel> getRecompensa(int id) async {
    final res = await _dio.get(ApiConstants.recompensaById(id));
    final dynamic rawData = res.data['data'];
    if (rawData == null) throw Exception('Recompensa no encontrada');
    return RecompensaModel.fromJson(rawData as Map<String, dynamic>);
  }
}