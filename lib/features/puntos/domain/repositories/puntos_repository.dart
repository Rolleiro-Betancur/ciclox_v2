import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/puntos_entity.dart';

abstract class PuntosRepository {
  Future<Either<Failure, PuntosEntity>> getPuntos();
  Future<Either<Failure, List<MovimientoPuntosEntity>>> getHistorialPuntos({
    int page = 1,
    int limit = 20,
  });
}