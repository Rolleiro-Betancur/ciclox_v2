import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/empresa_solicitudes_repository.dart';

class MarcarRecolectadaEmpresaSolicitudUsecase {
  final EmpresaSolicitudesRepository _repository;

  MarcarRecolectadaEmpresaSolicitudUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required int id,
    required int puntosOtorgados,
    String? evidenciaUrl,
  }) {
    return _repository.marcarRecolectada(
      id: id,
      puntosOtorgados: puntosOtorgados,
      evidenciaUrl: evidenciaUrl,
    );
  }
}
