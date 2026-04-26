import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notificacion_entity.dart';
import '../repositories/notificaciones_repository.dart';

class GetNotificacionesUsecase {
  final NotificacionesRepository _repository;
  GetNotificacionesUsecase(this._repository);

  Future<Either<Failure, List<NotificacionEntity>>> call() {
    return _repository.getNotificaciones();
  }
}
