import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/solicitudes_repository.dart';

class CancelarSolicitudUseCase {
  final SolicitudesRepository _repository;
  CancelarSolicitudUseCase(this._repository);

  Future<Either<Failure, void>> call(int id) =>
      _repository.cancelarSolicitud(id);
}
