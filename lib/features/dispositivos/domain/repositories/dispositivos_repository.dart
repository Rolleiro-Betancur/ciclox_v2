import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dispositivo_entity.dart';

abstract class DispositivosRepository {
  Future<Either<Failure, List<DispositivoEntity>>> obtenerDispositivos();
  Future<Either<Failure, DispositivoEntity>> crearDispositivo(
      Map<String, dynamic> body);
  Future<Either<Failure, void>> eliminarDispositivo(int id);
}
