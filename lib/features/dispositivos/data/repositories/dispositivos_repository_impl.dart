import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/dispositivo_entity.dart';
import '../../domain/repositories/dispositivos_repository.dart';
import '../datasources/dispositivos_remote_datasource.dart';

class DispositivosRepositoryImpl implements DispositivosRepository {
  final DispositivosRemoteDatasource _remoteDatasource;

  DispositivosRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<DispositivoEntity>>> obtenerDispositivos() async {
    try {
      final dispositivos = await _remoteDatasource.obtenerDispositivos();
      return Right(dispositivos);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data?['message'] ?? e.message ?? 'Error en el servidor'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DispositivoEntity>> crearDispositivo(
      Map<String, dynamic> body) async {
    try {
      final dispositivo = await _remoteDatasource.crearDispositivo(body);
      return Right(dispositivo);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data?['message'] ?? e.message ?? 'Error en el servidor'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> eliminarDispositivo(int id) async {
    try {
      await _remoteDatasource.eliminarDispositivo(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data?['message'] ?? e.message ?? 'Error en el servidor'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
