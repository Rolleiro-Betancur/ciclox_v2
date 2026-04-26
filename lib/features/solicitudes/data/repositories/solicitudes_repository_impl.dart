import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/solicitud_entity.dart';
import '../../domain/repositories/solicitudes_repository.dart';
import '../datasources/solicitudes_remote_data_source.dart';

class SolicitudesRepositoryImpl implements SolicitudesRepository {
  final SolicitudesRemoteDataSource _remoteDataSource;

  SolicitudesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<SolicitudEntity>>> getSolicitudes({String? estado}) async {
    try {
      final solicitudes = await _remoteDataSource.getSolicitudes(estado: estado);
      return Right(solicitudes);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, SolicitudEntity>> crearSolicitud(Map<String, dynamic> body) async {
    try {
      final solicitud = await _remoteDataSource.crearSolicitud(body);
      return Right(solicitud);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelarSolicitud(int id) async {
    try {
      await _remoteDataSource.cancelarSolicitud(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      String message = 'Error de servidor';
      if (data is Map && data['error'] is Map && data['error']['message'] != null) {
        message = data['error']['message'].toString();
      }
      return ServerFailure(message: message);
    }
    return const NetworkFailure();
  }
}
