import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/canje_entity.dart';

abstract class CanjesRepository {
  Future<Either<Failure, List<CanjeEntity>>> getCanjes();

  Future<Either<Failure, CanjeEntity>> crearCanje({
    required int recompensaId,
  });
}
