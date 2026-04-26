import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/canje_entity.dart';
import '../repositories/canjes_repository.dart';

class CrearCanjeUsecase {
  final CanjesRepository _repository;
  CrearCanjeUsecase(this._repository);

  Future<Either<Failure, CanjeEntity>> call({
    required int recompensaId,
  }) {
    return _repository.crearCanje(recompensaId: recompensaId);
  }
}
