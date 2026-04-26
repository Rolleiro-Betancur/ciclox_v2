import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, ({String token, UsuarioEntity usuario})>> login({
    required String email,
    required String contrasena,
  });

  Future<Either<Failure, ({String token, UsuarioEntity usuario})>> registro({
    required String nombre,
    required String email,
    required String contrasena,
    required String telefono,
    required String rol,
    Map<String, dynamic>? empresa,
  });

  Future<Either<Failure, void>> recuperarContrasena(String email);

  Future<Either<Failure, void>> verificarCodigo({
    required String email,
    required String codigo,
  });

  Future<Either<Failure, void>> cambiarContrasena({
    required String email,
    required String codigo,
    required String nuevaContrasena,
  });
}
