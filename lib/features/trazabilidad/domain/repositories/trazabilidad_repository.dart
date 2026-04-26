import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movimiento_entity.dart';

abstract class TrazabilidadRepository {
  Future<Either<Failure, List<MovimientoEntity>>> getTrazabilidadDispositivo(
    int dispositivoId,
  );

  Future<Either<Failure, UbicacionRecolectorEntity>> getUbicacionRecolector(
    int solicitudId,
  );
}
