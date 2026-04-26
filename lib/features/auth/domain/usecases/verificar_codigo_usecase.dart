import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class VerificarCodigoUsecase {
  final AuthRepository _repository;
  VerificarCodigoUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String codigo,
  }) =>
      _repository.verificarCodigo(email: email, codigo: codigo);
}
