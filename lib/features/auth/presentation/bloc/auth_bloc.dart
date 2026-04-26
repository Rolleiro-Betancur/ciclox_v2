import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/recuperar_contrasena_usecase.dart';
import '../../domain/usecases/verificar_codigo_usecase.dart';
import '../../domain/usecases/cambiar_contrasena_usecase.dart';
import '../../../../core/storage/secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final RecuperarContrasenaUsecase _recuperarUsecase;
  final VerificarCodigoUsecase _verificarUsecase;
  final CambiarContrasenaUsecase _cambiarUsecase;
  final SecureStorage _storage;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required RecuperarContrasenaUsecase recuperarUsecase,
    required VerificarCodigoUsecase verificarUsecase,
    required CambiarContrasenaUsecase cambiarUsecase,
    required SecureStorage storage,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _recuperarUsecase = recuperarUsecase,
        _verificarUsecase = verificarUsecase,
        _cambiarUsecase = cambiarUsecase,
        _storage = storage,
        super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<RecuperarContrasenaRequested>(_onRecuperar);
    on<VerificarCodigoRequested>(_onVerificar);
    on<CambiarContrasenaRequested>(_onCambiarContrasena);
  }

  // ─────────────────────────────────────────────────────────────
  // IMPORTANTE: nunca usar callbacks async dentro de result.fold()
  // fold() de dartz es síncrono → BLoC cierra el emitter antes
  // de que terminen los await internos.
  // Solución: extraer la lógica fuera del fold con isLeft/isRight.
  // ─────────────────────────────────────────────────────────────

  Future<void> _onLogin(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _loginUsecase(
      email: event.email,
      contrasena: event.contrasena,
    );

    // ✅ Manejamos Left y Right sin callbacks async en fold()
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null)!;
      emit(AuthError(failure.message));
      return;
    }

    final data = result.getOrElse(() => throw Exception());
    await _storage.saveToken(data.token);
    await _storage.saveRol(data.usuario.rol);
    await _storage.saveUserData(jsonEncode({
      'id': data.usuario.id,
      'nombre': data.usuario.nombre,
      'email': data.usuario.email,
      'rol': data.usuario.rol,
    }));
    emit(AuthAuthenticated(usuario: data.usuario));
  }

  Future<void> _onRegister(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _registerUsecase(
      nombre: event.nombre,
      email: event.email,
      contrasena: event.contrasena,
      telefono: event.telefono,
      rol: event.rol,
      empresa: event.empresa,
    );

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null)!;
      emit(AuthError(failure.message));
      return;
    }

    final data = result.getOrElse(() => throw Exception());
    await _storage.saveToken(data.token);
    await _storage.saveRol(data.usuario.rol);
    await _storage.saveUserData(jsonEncode({
      'id': data.usuario.id,
      'nombre': data.usuario.nombre,
      'email': data.usuario.email,
      'rol': data.usuario.rol,
    }));
    emit(AuthAuthenticated(usuario: data.usuario));
  }

  Future<void> _onLogout(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await _storage.clearAll();
    emit(AuthUnauthenticated());
  }

  Future<void> _onRecuperar(
      RecuperarContrasenaRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _recuperarUsecase(event.email);

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null)!;
      emit(AuthError(failure.message));
      return;
    }

    emit(AuthRecuperacionEnviada());
  }

  Future<void> _onVerificar(
      VerificarCodigoRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _verificarUsecase(
      email: event.email,
      codigo: event.codigo,
    );

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null)!;
      emit(AuthError(failure.message));
      return;
    }

    emit(AuthCodigoVerificado(email: event.email, codigo: event.codigo));
  }

  Future<void> _onCambiarContrasena(
      CambiarContrasenaRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _cambiarUsecase(
      email: event.email,
      codigo: event.codigo,
      nuevaContrasena: event.nuevaContrasena,
    );

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null)!;
      emit(AuthError(failure.message));
      return;
    }

    emit(AuthContrasenaActualizada());
  }
}
