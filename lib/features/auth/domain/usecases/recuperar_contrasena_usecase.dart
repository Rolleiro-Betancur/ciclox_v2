import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class RecuperarContrasenaUsecase {
  final AuthRepository _repository;
  RecuperarContrasenaUsecase(this._repository);

  Future<Either<Failure, void>> call(String email) =>
      _repository.recuperarContrasena(email);
}
