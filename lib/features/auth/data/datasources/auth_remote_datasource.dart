import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> login(String email, String contrasena);
  Future<AuthResponseModel> registro(Map<String, dynamic> body);
  Future<void> recuperarContrasena(String email);
  Future<void> verificarCodigo(String email, String codigo);
  Future<void> cambiarContrasena(
      String email, String codigo, String nuevaContrasena);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(String email, String contrasena) async {
    final res = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'contrasena': contrasena},
    );
    // Soporta {data: {...}} y {token:..., usuario:...} directamente
    final body = (res.data is Map && res.data['data'] != null)
        ? res.data['data'] as Map<String, dynamic>
        : res.data as Map<String, dynamic>;
    return AuthResponseModel.fromJson(body);
  }

  @override
  Future<AuthResponseModel> registro(Map<String, dynamic> body) async {
    final res = await _dio.post(ApiConstants.registro, data: body);
    final resBody = (res.data is Map && res.data['data'] != null)
        ? res.data['data'] as Map<String, dynamic>
        : res.data as Map<String, dynamic>;
    return AuthResponseModel.fromJson(resBody);
  }

  @override
  Future<void> recuperarContrasena(String email) async {
    await _dio.post(ApiConstants.recuperarContrasena, data: {'email': email});
  }

  @override
  Future<void> verificarCodigo(String email, String codigo) async {
    await _dio.post(ApiConstants.verificarCodigo,
        data: {'email': email, 'codigo': codigo});
  }

  @override
  Future<void> cambiarContrasena(
      String email, String codigo, String nuevaContrasena) async {
    await _dio.post(ApiConstants.cambiarContrasena, data: {
      'email': email,
      'codigo': codigo,
      'nueva_contrasena': nuevaContrasena,
    });
  }
}
