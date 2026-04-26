import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String contrasena;
  LoginRequested({required this.email, required this.contrasena});

  @override
  List<Object?> get props => [email, contrasena];
}

class RegisterRequested extends AuthEvent {
  final String nombre;
  final String email;
  final String contrasena;
  final String telefono;
  final String rol;
  final Map<String, dynamic>? empresa;

  RegisterRequested({
    required this.nombre,
    required this.email,
    required this.contrasena,
    required this.telefono,
    required this.rol,
    this.empresa,
  });

  @override
  List<Object?> get props => [nombre, email, rol];
}

class LogoutRequested extends AuthEvent {}

class RecuperarContrasenaRequested extends AuthEvent {
  final String email;
  RecuperarContrasenaRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerificarCodigoRequested extends AuthEvent {
  final String email;
  final String codigo;
  VerificarCodigoRequested({required this.email, required this.codigo});

  @override
  List<Object?> get props => [email, codigo];
}

class CambiarContrasenaRequested extends AuthEvent {
  final String email;
  final String codigo;
  final String nuevaContrasena;
  CambiarContrasenaRequested({
    required this.email,
    required this.codigo,
    required this.nuevaContrasena,
  });

  @override
  List<Object?> get props => [email, codigo];
}
