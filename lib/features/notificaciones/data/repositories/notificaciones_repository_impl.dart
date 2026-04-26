import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notificacion_entity.dart';
import '../../domain/repositories/notificaciones_repository.dart';
import '../datasources/notificaciones_remote_datasource.dart';

class NotificacionesRepositoryImpl implements NotificacionesRepository {
  final NotificacionesRemoteDatasource _datasource;
  NotificacionesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<NotificacionEntity>>> getNotificaciones() async {
    try {
      final result = await _datasource.getNotificaciones();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> marcarLeida(int id) async {
    try {
      await _datasource.marcarLeida(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> marcarTodasLeidas() async {
    try {
      await _datasource.marcarTodasLeidas();
      return const Right(null);
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
