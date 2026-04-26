import 'package:dio/dio.dart';

import '../../../../../core/constants/api_constants.dart';
import '../models/recolector_model.dart';

abstract class RecolectoresRemoteDatasource {
  Future<List<RecolectorModel>> getRecolectores({bool? activo});
  Future<RecolectorModel> crearRecolector({
    required String nombre,
    String? telefono,
    String? fotoUrl,
  });
  Future<void> desactivarRecolector(int id);
}

class RecolectoresRemoteDatasourceImpl implements RecolectoresRemoteDatasource {
  final Dio _dio;
  RecolectoresRemoteDatasourceImpl(this._dio);

  @override
  Future<List<RecolectorModel>> getRecolectores({bool? activo}) async {
    final response = await _dio.get(
      ApiConstants.recolectores,
      queryParameters: activo != null ? {'activo': activo} : null,
    );
    final data = (response.data['data'] as List?) ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(RecolectorModel.fromJson)
        .toList();
  }

  @override
  Future<RecolectorModel> crearRecolector({
    required String nombre,
    String? telefono,
    String? fotoUrl,
  }) async {
    final response = await _dio.post(
      ApiConstants.recolectores,
      data: {
        'nombre': nombre,
        if (telefono != null && telefono.isNotEmpty) 'telefono': telefono,
        if (fotoUrl != null && fotoUrl.isNotEmpty) 'foto_url': fotoUrl,
      },
    );
    return RecolectorModel.fromJson(response.data['data']);
  }

  @override
  Future<void> desactivarRecolector(int id) async {
    await _dio.delete(ApiConstants.recolectorById(id));
  }
}
