import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notificaciones_repository.dart';

class MarcarTodasLeidasUsecase {
  final NotificacionesRepository _repository;
  MarcarTodasLeidasUsecase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.marcarTodasLeidas();
  }
}
