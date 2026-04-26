import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class CambiarContrasenaUsecase {
  final AuthRepository _repository;
  CambiarContrasenaUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String codigo,
    required String nuevaContrasena,
  }) =>
      _repository.cambiarContrasena(
        email: email,
        codigo: codigo,
        nuevaContrasena: nuevaContrasena,
      );
}
