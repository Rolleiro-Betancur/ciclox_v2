import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _repository;
  RegisterUsecase(this._repository);

  Future<Either<Failure, ({String token, UsuarioEntity usuario})>> call({
    required String nombre,
    required String email,
    required String contrasena,
    required String telefono,
    required String rol,
    Map<String, dynamic>? empresa,
  }) =>
      _repository.registro(
        nombre: nombre,
        email: email,
        contrasena: contrasena,
        telefono: telefono,
        rol: rol,
        empresa: empresa,
      );
}
