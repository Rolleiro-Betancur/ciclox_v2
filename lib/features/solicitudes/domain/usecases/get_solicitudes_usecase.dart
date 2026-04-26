import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/solicitud_entity.dart';
import '../repositories/solicitudes_repository.dart';

class GetSolicitudesUseCase {
  final SolicitudesRepository _repository;
  GetSolicitudesUseCase(this._repository);

  Future<Either<Failure, List<SolicitudEntity>>> call({String? estado}) =>
      _repository.getSolicitudes(estado: estado);
}
