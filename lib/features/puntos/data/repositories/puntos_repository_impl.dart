import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/puntos_entity.dart';
import '../../domain/repositories/puntos_repository.dart';
import '../datasources/puntos_remote_datasource.dart';

class PuntosRepositoryImpl implements PuntosRepository {
  final PuntosRemoteDatasource _datasource;
  PuntosRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, PuntosEntity>> getPuntos() async {
    try {
      final result = await _datasource.getPuntos();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<MovimientoPuntosEntity>>> getHistorialPuntos({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _datasource.getHistorialPuntos(page: page, limit: limit);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) return const UnauthorizedFailure();
    if (e.type == DioExceptionType.connectionError) return const NetworkFailure();
    final message = e.response?.data?['error']?['message'] ?? 'Error desconocido';
    final code = e.response?.data?['error']?['code'];
    return ServerFailure(message: message, code: code);
  }
}