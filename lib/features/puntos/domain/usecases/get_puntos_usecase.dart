import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/puntos_entity.dart';
import '../repositories/puntos_repository.dart';

class GetPuntosUsecase {
  final PuntosRepository _repository;
  GetPuntosUsecase(this._repository);

  Future<Either<Failure, PuntosEntity>> call() {
    return _repository.getPuntos();
  }
}