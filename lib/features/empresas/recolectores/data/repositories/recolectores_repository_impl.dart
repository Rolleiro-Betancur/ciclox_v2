import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/recolector_entity.dart';
import '../../domain/repositories/recolectores_repository.dart';
import '../datasources/recolectores_remote_datasource.dart';

class RecolectoresRepositoryImpl implements RecolectoresRepository {
  final RecolectoresRemoteDatasource _remoteDatasource;
  RecolectoresRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<RecolectorEntity>>> getRecolectores({
    bool? activo,
  }) async {
    try {
      final data = await _remoteDatasource.getRecolectores(activo: activo);
      return Right(data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, RecolectorEntity>> crearRecolector({
    required String nombre,
    String? telefono,
    String? fotoUrl,
  }) async {
    try {
      final data = await _remoteDatasource.crearRecolector(
        nombre: nombre,
        telefono: telefono,
        fotoUrl: fotoUrl,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> desactivarRecolector(int id) async {
    try {
      await _remoteDatasource.desactivarRecolector(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return const UnauthorizedFailure();
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    final data = e.response?.data;
    final message = (data is Map && data['error'] is Map)
        ? (data['error']['message']?.toString() ?? 'Error de servidor')
        : 'Error de servidor';
    return ServerFailure(message: message);
  }
}
