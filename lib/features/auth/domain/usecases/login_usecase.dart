import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;
  LoginUsecase(this._repository);

  Future<Either<Failure, ({String token, UsuarioEntity usuario})>> call({
    required String email,
    required String contrasena,
  }) =>
      _repository.login(email: email, contrasena: contrasena);
}
