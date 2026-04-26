import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/recolector_entity.dart';

abstract class RecolectoresRepository {
  Future<Either<Failure, List<RecolectorEntity>>> getRecolectores({bool? activo});
  Future<Either<Failure, RecolectorEntity>> crearRecolector({
    required String nombre,
    String? telefono,
    String? fotoUrl,
  });
  Future<Either<Failure, void>> desactivarRecolector(int id);
}
