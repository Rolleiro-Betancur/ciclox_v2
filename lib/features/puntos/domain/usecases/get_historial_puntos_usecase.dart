import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/puntos_entity.dart';
import '../repositories/puntos_repository.dart';

class GetHistorialPuntosUsecase {
  final PuntosRepository _repository;
  GetHistorialPuntosUsecase(this._repository);

  Future<Either<Failure, List<MovimientoPuntosEntity>>> call({
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getHistorialPuntos(page: page, limit: limit);
  }
}