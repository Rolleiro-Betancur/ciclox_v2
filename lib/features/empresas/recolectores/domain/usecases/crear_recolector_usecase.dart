import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/recolector_entity.dart';
import '../repositories/recolectores_repository.dart';

class CrearRecolectorUsecase {
  final RecolectoresRepository _repository;
  CrearRecolectorUsecase(this._repository);

  Future<Either<Failure, RecolectorEntity>> call({
    required String nombre,
    String? telefono,
    String? fotoUrl,
  }) {
    return _repository.crearRecolector(
      nombre: nombre,
      telefono: telefono,
      fotoUrl: fotoUrl,
    );
  }
}
