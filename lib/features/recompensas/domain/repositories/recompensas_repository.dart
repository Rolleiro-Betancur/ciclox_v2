import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recompensa_entity.dart';

abstract class RecompensasRepository {
  Future<Either<Failure, List<RecompensaEntity>>> getRecompensas();
  Future<Either<Failure, RecompensaEntity>> getRecompensa(int id);
}