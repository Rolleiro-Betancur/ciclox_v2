import '../../domain/entities/usuario_entity.dart';

class AuthResponseModel {
  final String token;
  final UsuarioModel usuario;

  AuthResponseModel({required this.token, required this.usuario});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'],
      usuario: UsuarioModel.fromJson(json['usuario']),
    );
  }
}

class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.nombre,
    required super.email,
    required super.rol,
    required super.activo,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'] as String? ?? '',
      email: json['email'] as String? ?? '',
      rol: json['rol'] as String? ?? 'USUARIO',
      activo: json['activo'] as bool? ?? true,
    );
  }
}
