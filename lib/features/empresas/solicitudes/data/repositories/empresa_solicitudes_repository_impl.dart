import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/empresa_solicitud_entity.dart';
import '../../domain/repositories/empresa_solicitudes_repository.dart';
import '../datasources/empresa_solicitudes_remote_datasource.dart';

class EmpresaSolicitudesRepositoryImpl implements EmpresaSolicitudesRepository {
  final EmpresaSolicitudesRemoteDatasource _remoteDatasource;

  EmpresaSolicitudesRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<EmpresaSolicitudEntity>>> getSolicitudes({
    String? estado,
  }) async {
    try {
      final data = await _remoteDatasource.getSolicitudes(estado: estado);
      return Right(data);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> aceptarSolicitud({
    required int id,
    required int recolectorId,
    required String horaEstimadaInicio,
    required String horaEstimadaFin,
    String? comentarioEmpresa,
  }) async {
    try {
      await _remoteDatasource.aceptarSolicitud(
        id: id,
        recolectorId: recolectorId,
        horaEstimadaInicio: horaEstimadaInicio,
        horaEstimadaFin: horaEstimadaFin,
        comentarioEmpresa: comentarioEmpresa,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rechazarSolicitud({
    required int id,
    required String motivo,
  }) async {
    try {
      await _remoteDatasource.rechazarSolicitud(id: id, motivo: motivo);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> marcarEnTransito({
    required int id,
    double? latitudRecolector,
    double? longitudRecolector,
    int? tiempoEstimadoMinutos,
  }) async {
    try {
      await _remoteDatasource.marcarEnTransito(
        id: id,
        latitudRecolector: latitudRecolector,
        longitudRecolector: longitudRecolector,
        tiempoEstimadoMinutos: tiempoEstimadoMinutos,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> marcarRecolectada({
    required int id,
    required int puntosOtorgados,
    String? evidenciaUrl,
  }) async {
    try {
      await _remoteDatasource.marcarRecolectada(
        id: id,
        puntosOtorgados: puntosOtorgados,
        evidenciaUrl: evidenciaUrl,
      );
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
