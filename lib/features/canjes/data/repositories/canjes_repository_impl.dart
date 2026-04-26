import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/canje_entity.dart';
import '../../domain/repositories/canjes_repository.dart';
import '../datasources/canjes_remote_datasource.dart';

class CanjesRepositoryImpl implements CanjesRepository {
  final CanjesRemoteDatasource _datasource;
  CanjesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<CanjeEntity>>> getCanjes() async {
    try {
      final result = await _datasource.getCanjes();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, CanjeEntity>> crearCanje({
    required int recompensaId,
  }) async {
    try {
      final result = await _datasource.crearCanje(recompensaId: recompensaId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) return const UnauthorizedFailure();
    if (e.type == DioExceptionType.connectionError) return const NetworkFailure();

    final code = e.response?.data?['error']?['code'];
    final message = e.response?.data?['error']?['message'] ?? 'Error desconocido';
    if (code == 'PUNTOS_INSUFICIENTES') return const PuntosInsuficientesFailure();
    if (code == 'CANJE_EXPIRADO') return const CanjeExpiradoFailure();

    return ServerFailure(message: message, code: code);
  }
}
