import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/recompensa_entity.dart';
import '../../domain/repositories/recompensas_repository.dart';
import '../datasources/recompensas_remote_datasource.dart';

class RecompensasRepositoryImpl implements RecompensasRepository {
  final RecompensasRemoteDatasource _datasource;
  RecompensasRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<RecompensaEntity>>> getRecompensas() async {
    try {
      final result = await _datasource.getRecompensas();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, RecompensaEntity>> getRecompensa(int id) async {
    try {
      final result = await _datasource.getRecompensa(id);
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