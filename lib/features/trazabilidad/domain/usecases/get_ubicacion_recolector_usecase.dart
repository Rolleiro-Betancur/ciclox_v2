import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movimiento_entity.dart';
import '../repositories/trazabilidad_repository.dart';

class GetUbicacionRecolectorUsecase {
  final TrazabilidadRepository _repository;
  GetUbicacionRecolectorUsecase(this._repository);

  Future<Either<Failure, UbicacionRecolectorEntity>> call(int solicitudId) {
    return _repository.getUbicacionRecolector(solicitudId);
  }
}
