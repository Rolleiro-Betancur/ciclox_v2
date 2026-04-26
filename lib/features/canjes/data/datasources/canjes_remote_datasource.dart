import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/canje_model.dart';

abstract class CanjesRemoteDatasource {
  Future<List<CanjeModel>> getCanjes();
  Future<CanjeModel> crearCanje({required int recompensaId});
}

class CanjesRemoteDatasourceImpl implements CanjesRemoteDatasource {
  final Dio _dio;
  CanjesRemoteDatasourceImpl(this._dio);

  @override
  Future<List<CanjeModel>> getCanjes() async {
    final res = await _dio.get(ApiConstants.canjes);
    final rawData = res.data['data'];
    if (rawData == null) return [];

    final list = rawData is List ? rawData : <dynamic>[];
    return list
        .map((json) => CanjeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CanjeModel> crearCanje({required int recompensaId}) async {
    final res = await _dio.post(
      ApiConstants.canjes,
      data: {'recompensa_id': recompensaId},
    );
    return CanjeModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}
