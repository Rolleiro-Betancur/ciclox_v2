import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/solicitud_entity.dart';

abstract class SolicitudesRepository {
  Future<Either<Failure, List<SolicitudEntity>>> getSolicitudes({String? estado});
  Future<Either<Failure, SolicitudEntity>> crearSolicitud(Map<String, dynamic> body);
  Future<Either<Failure, void>> cancelarSolicitud(int id);
}
