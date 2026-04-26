import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/recolectores_repository.dart';

class DesactivarRecolectorUsecase {
  final RecolectoresRepository _repository;
  DesactivarRecolectorUsecase(this._repository);

  Future<Either<Failure, void>> call(int id) {
    return _repository.desactivarRecolector(id);
  }
}
