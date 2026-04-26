import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/movimiento_entity.dart';
import '../../domain/repositories/trazabilidad_repository.dart';
import '../datasources/trazabilidad_remote_datasource.dart';

class TrazabilidadRepositoryImpl implements TrazabilidadRepository {
  final TrazabilidadRemoteDatasource _datasource;
  TrazabilidadRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<MovimientoEntity>>> getTrazabilidadDispositivo(
    int dispositivoId,
  ) async {
    try {
      final result = await _datasource.getTrazabilidadDispositivo(dispositivoId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, UbicacionRecolectorEntity>> getUbicacionRecolector(
    int solicitudId,
  ) async {
    try {
      final result = await _datasource.getUbicacionRecolector(solicitudId);
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
