import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notificacion_entity.dart';

abstract class NotificacionesRepository {
  Future<Either<Failure, List<NotificacionEntity>>> getNotificaciones();
  Future<Either<Failure, void>> marcarLeida(int id);
  Future<Either<Failure, void>> marcarTodasLeidas();
}
