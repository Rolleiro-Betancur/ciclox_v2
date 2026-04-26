import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/empresa_solicitudes_repository.dart';

class MarcarEnTransitoEmpresaSolicitudUsecase {
  final EmpresaSolicitudesRepository _repository;

  MarcarEnTransitoEmpresaSolicitudUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required int id,
    double? latitudRecolector,
    double? longitudRecolector,
    int? tiempoEstimadoMinutos,
  }) {
    return _repository.marcarEnTransito(
      id: id,
      latitudRecolector: latitudRecolector,
      longitudRecolector: longitudRecolector,
      tiempoEstimadoMinutos: tiempoEstimadoMinutos,
    );
  }
}
