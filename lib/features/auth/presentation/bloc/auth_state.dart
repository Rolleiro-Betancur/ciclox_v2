import 'package:equatable/equatable.dart';
import '../../domain/entities/usuario_entity.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UsuarioEntity usuario;
  AuthAuthenticated({required this.usuario});

  @override
  List<Object?> get props => [usuario];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Emitido tras solicitar recuperación de contraseña con éxito
class AuthRecuperacionEnviada extends AuthState {}

/// Emitido tras verificar código correctamente
class AuthCodigoVerificado extends AuthState {
  final String email;
  final String codigo;
  AuthCodigoVerificado({required this.email, required this.codigo});

  @override
  List<Object?> get props => [email, codigo];
}

/// Emitido tras cambiar contraseña con éxito
class AuthContrasenaActualizada extends AuthState {}
