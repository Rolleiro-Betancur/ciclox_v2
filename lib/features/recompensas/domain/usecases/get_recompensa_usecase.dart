import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recompensa_entity.dart';
import '../repositories/recompensas_repository.dart';

class GetRecompensaUsecase {
  final RecompensasRepository _repository;
  GetRecompensaUsecase(this._repository);

  Future<Either<Failure, RecompensaEntity>> call(int id) {
    return _repository.getRecompensa(id);
  }
}