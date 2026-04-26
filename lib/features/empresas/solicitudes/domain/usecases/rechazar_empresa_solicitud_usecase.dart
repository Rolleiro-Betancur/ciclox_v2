import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/empresa_solicitudes_repository.dart';

class RechazarEmpresaSolicitudUsecase {
  final EmpresaSolicitudesRepository _repository;

  RechazarEmpresaSolicitudUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required int id,
    required String motivo,
  }) {
    return _repository.rechazarSolicitud(id: id, motivo: motivo);
  }
}
