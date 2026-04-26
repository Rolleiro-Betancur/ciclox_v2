import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sin conexión a internet'});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Sesión expirada'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class PuntosInsuficientesFailure extends Failure {
  const PuntosInsuficientesFailure()
      : super(message: 'Puntos insuficientes para canjear');
}

class CanjeExpiradoFailure extends Failure {
  const CanjeExpiradoFailure() : super(message: 'El código QR ha expirado');
}

class SolicitudNoCancelableFailure extends Failure {
  const SolicitudNoCancelableFailure()
      : super(message: 'No se puede cancelar la solicitud en este estado');
}
