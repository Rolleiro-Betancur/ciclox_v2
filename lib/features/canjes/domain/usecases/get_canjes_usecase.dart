import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/canje_entity.dart';
import '../repositories/canjes_repository.dart';

class GetCanjesUsecase {
  final CanjesRepository _repository;
  GetCanjesUsecase(this._repository);

  Future<Either<Failure, List<CanjeEntity>>> call() {
    return _repository.getCanjes();
  }
}
