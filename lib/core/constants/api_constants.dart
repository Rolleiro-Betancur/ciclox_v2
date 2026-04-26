import 'package:flutter/foundation.dart';

/// Constantes de la API de Ciclox
class ApiConstants {
  ApiConstants._();

  // ── Base URL ──────────────────────────────────────────────
  // - Android emulador: 10.0.2.2 apunta al localhost del host
  // - Web / Windows desktop: usa localhost directamente
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return 'http://localhost:3000/api';
    }
    // Android emulador
    return 'http://10.0.2.2:3000/api';
  }

  // ── Auth ──────────────────────────────────────────────────
  static String get login            => '/auth/login';
  static String get registro         => '/auth/registro';
  static String get recuperarContrasena => '/auth/recuperar-contrasena';
  static String get verificarCodigo  => '/auth/verificar-codigo';
  static String get cambiarContrasena=> '/auth/cambiar-contrasena';

  // ── Dispositivos ──────────────────────────────────────────
  static String get dispositivos     => '/dispositivos';
  static String dispositivoById(int id) => '/dispositivos/$id';

  // ── Solicitudes ───────────────────────────────────────────
  static String get solicitudes      => '/solicitudes';
  static String solicitudById(int id) => '/solicitudes/$id';
  static String cancelarSolicitud(int id) => '/solicitudes/$id/cancelar';

  // ── Puntos ───────────────────────────────────────────────
  static String get misPuntos        => '/puntos';
  static String get historialPuntos  => '/puntos/historial';

  // ── Usuarios ─────────────────────────────────────────────
  static String get perfil           => '/usuarios/perfil';

  // ── Reciclajes ───────────────────────────────────────────
  static String get reciclajes       => '/reciclajes';
  static String reciclajeById(int id) => '/reciclajes/$id';

  // ── Recompensas ───────────────────────────────────────────
  static String get recompensas      => '/recompensas';
  static String recompensaById(int id) => '/recompensas/$id';

  // ── Recolectores (empresa) ────────────────────────────────
  static String get recolectores     => '/recolectores';

  // ── Timeouts ─────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
