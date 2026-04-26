import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notificaciones_repository.dart';

class MarcarLeidaUsecase {
  final NotificacionesRepository _repository;
  MarcarLeidaUsecase(this._repository);

  Future<Either<Failure, void>> call(int id) {
    return _repository.marcarLeida(id);
  }
}
