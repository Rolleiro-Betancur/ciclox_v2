import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/solicitud_entity.dart';
import '../repositories/solicitudes_repository.dart';

class CrearSolicitudUseCase {
  final SolicitudesRepository _repository;
  CrearSolicitudUseCase(this._repository);

  Future<Either<Failure, SolicitudEntity>> call(Map<String, dynamic> body) =>
      _repository.crearSolicitud(body);
}
