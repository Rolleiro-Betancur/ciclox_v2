import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/empresa_solicitud_entity.dart';
import '../repositories/empresa_solicitudes_repository.dart';

class GetEmpresaSolicitudesUsecase {
  final EmpresaSolicitudesRepository _repository;

  GetEmpresaSolicitudesUsecase(this._repository);

  Future<Either<Failure, List<EmpresaSolicitudEntity>>> call({String? estado}) {
    return _repository.getSolicitudes(estado: estado);
  }
}
