class AppRoutes {
  AppRoutes._();

  static const login               = '/login';
  static const registro            = '/registro';
  static const recuperarContrasena = '/recuperar-contrasena';
  static const verificarCodigo     = '/verificar-codigo';
  static const cambiarContrasena   = '/cambiar-contrasena';

  static const homeUsuario         = '/home';
  static const homeEmpresa         = '/empresa/home';

  static const dispositivos        = '/dispositivos';
  static const registroDispositivo = '/dispositivos/registro';
  static const registroDispositivoExito = '/dispositivos/registro/exito';
  static const detalleDispositivo  = '/dispositivos/:id';

  static const solicitudes         = '/solicitudes';
  static const misSolicitudes      = '/solicitudes/lista';
  static const crearSolicitud      = '/solicitudes/crear';
  static const solicitudEnviada    = '/solicitudes/enviada';
  static const solicitudCancelada  = '/solicitudes/cancelada';

  static const tusPuntos           = '/puntos';

  static const bonoCiclox          = '/recompensas/bono-ciclox';
  static const mercaditos          = '/recompensas/mercaditos';

  static const qrBonoCiclox        = '/canjes/qr-bono';
  static const qrMercaditos        = '/canjes/qr-mercaditos';
  static const canjeExitoso        = '/canjes/exitoso';
  static const canjeRechazado      = '/canjes/rechazado';

  static const trazabilidad        = '/trazabilidad';
  static const trazabilidadMapa    = '/trazabilidad/mapa';

  static const notificaciones      = '/notificaciones';
}
