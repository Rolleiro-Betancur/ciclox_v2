import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, ({String token, UsuarioEntity usuario})>> login({
    required String email,
    required String contrasena,
  }) async {
    try {
      final result = await _datasource.login(email, contrasena);
      return Right((token: result.token, usuario: result.usuario));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, ({String token, UsuarioEntity usuario})>> registro({
    required String nombre,
    required String email,
    required String contrasena,
    required String telefono,
    required String rol,
    Map<String, dynamic>? empresa,
  }) async {
    try {
      final body = {
        'nombre': nombre,
        'email': email,
        'contrasena': contrasena,
        'telefono': telefono,
        'rol': rol,
        if (empresa != null) 'empresa': empresa,
      };
      final result = await _datasource.registro(body);
      return Right((token: result.token, usuario: result.usuario));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> recuperarContrasena(String email) async {
    try {
      await _datasource.recuperarContrasena(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> verificarCodigo({
    required String email,
    required String codigo,
  }) async {
    try {
      await _datasource.verificarCodigo(email, codigo);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> cambiarContrasena({
    required String email,
    required String codigo,
    required String nuevaContrasena,
  }) async {
    try {
      await _datasource.cambiarContrasena(email, codigo, nuevaContrasena);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  Failure _handleDioError(DioException e) {
    final code = e.response?.data?['error']?['code'];
    final message =
        e.response?.data?['error']?['message'] ?? 'Error desconocido';

    if (e.response?.statusCode == 401) return const UnauthorizedFailure();
    if (code == 'PUNTOS_INSUFICIENTES') {
      return const PuntosInsuficientesFailure();
    }
    if (code == 'CANJE_EXPIRADO') return const CanjeExpiradoFailure();
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return ServerFailure(message: message, code: code);
  }
}
