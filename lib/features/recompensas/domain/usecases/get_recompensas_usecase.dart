import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recompensa_entity.dart';
import '../repositories/recompensas_repository.dart';

class GetRecompensasUsecase {
  final RecompensasRepository _repository;
  GetRecompensasUsecase(this._repository);

  Future<Either<Failure, List<RecompensaEntity>>> call() {
    return _repository.getRecompensas();
  }
}