import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/recolector_entity.dart';
import '../repositories/recolectores_repository.dart';

class GetRecolectoresUsecase {
  final RecolectoresRepository _repository;
  GetRecolectoresUsecase(this._repository);

  Future<Either<Failure, List<RecolectorEntity>>> call({bool? activo}) {
    return _repository.getRecolectores(activo: activo);
  }
}
