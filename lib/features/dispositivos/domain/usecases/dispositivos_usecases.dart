import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dispositivo_entity.dart';
import '../repositories/dispositivos_repository.dart';

class CrearDispositivoUsecase {
  final DispositivosRepository _repository;

  CrearDispositivoUsecase(this._repository);

  Future<Either<Failure, DispositivoEntity>> call(
      Map<String, dynamic> body) async {
    return await _repository.crearDispositivo(body);
  }
}

class ObtenerDispositivosUsecase {
  final DispositivosRepository _repository;

  ObtenerDispositivosUsecase(this._repository);

  Future<Either<Failure, List<DispositivoEntity>>> call() async {
    return await _repository.obtenerDispositivos();
  }
}

class EliminarDispositivoUsecase {
  final DispositivosRepository _repository;

  EliminarDispositivoUsecase(this._repository);

  Future<Either<Failure, void>> call(int id) async {
    return await _repository.eliminarDispositivo(id);
  }
}
