import 'package:flutter/foundation.dart';

/// Constantes de la API de Ciclox
class ApiConstants {
  ApiConstants._();

  // ── Base URL ──────────────────────────────────────────────
  // - Android emulador: 10.0.2.2 apunta al localhost del host
  // - Web / Windows desktop: usa localhost directamente
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return 'http://54.173.222.249:3000/api';
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

  // ── Canjes ────────────────────────────────────────────────
  static String get canjes           => '/canjes';
  static String canjeById(int id)    => '/canjes/$id';
  static String confirmarCanje(int id) => '/canjes/$id/confirmar';
  static String rechazarCanje(int id)  => '/canjes/$id/rechazar';

  // ── Notificaciones ────────────────────────────────────────
  static String get notificaciones => '/notificaciones';
  static String leerNotificacion(int id) => '/notificaciones/$id/leer';
  static String get leerTodasNotificaciones => '/notificaciones/leer-todas';

  // ── Trazabilidad ───────────────────────────────────────────
  static String trazabilidadDispositivo(int id) => '/trazabilidad/dispositivo/$id';
  static String ubicacionRecolector(int id) => '/trazabilidad/solicitud/$id/ubicacion';

  // ── Recolectores (empresa) ────────────────────────────────
  static String get recolectores => '/empresa/recolectores';
  static String recolectorById(int id) => '/empresa/recolectores/$id';

  // ── Empresa solicitudes ────────────────────────────────────
  static String get empresaSolicitudes => '/empresa/solicitudes';
  static String aceptarSolicitud(int id) => '/empresa/solicitudes/$id/aceptar';
  static String rechazarSolicitud(int id) => '/empresa/solicitudes/$id/rechazar';
  static String enTransitoSolicitud(int id) => '/empresa/solicitudes/$id/en-transito';
  static String recolectadaSolicitud(int id) => '/empresa/solicitudes/$id/recolectada';

  // ── Timeouts ─────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
