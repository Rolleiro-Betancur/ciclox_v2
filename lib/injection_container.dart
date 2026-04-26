import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/storage/secure_storage.dart';

// Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/recuperar_contrasena_usecase.dart';
import 'features/auth/domain/usecases/verificar_codigo_usecase.dart';
import 'features/auth/domain/usecases/cambiar_contrasena_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Dispositivos
import 'features/dispositivos/data/datasources/dispositivos_remote_datasource.dart';
import 'features/dispositivos/data/repositories/dispositivos_repository_impl.dart';
import 'features/dispositivos/domain/repositories/dispositivos_repository.dart';
import 'features/dispositivos/domain/usecases/dispositivos_usecases.dart';
import 'features/dispositivos/presentation/bloc/dispositivos_bloc.dart';

// Solicitudes
import 'features/solicitudes/data/datasources/solicitudes_remote_data_source.dart';
import 'features/solicitudes/data/repositories/solicitudes_repository_impl.dart';
import 'features/solicitudes/domain/repositories/solicitudes_repository.dart';
import 'features/solicitudes/domain/usecases/get_solicitudes_usecase.dart';
import 'features/solicitudes/domain/usecases/crear_solicitud_usecase.dart';
import 'features/solicitudes/domain/usecases/cancelar_solicitud_usecase.dart';
import 'features/solicitudes/presentation/bloc/solicitudes_bloc.dart';

// Puntos
import 'features/puntos/data/datasources/puntos_remote_datasource.dart';
import 'features/puntos/data/repositories/puntos_repository_impl.dart';
import 'features/puntos/domain/repositories/puntos_repository.dart';
import 'features/puntos/domain/usecases/get_puntos_usecase.dart';
import 'features/puntos/domain/usecases/get_historial_puntos_usecase.dart';
import 'features/puntos/presentation/bloc/puntos_bloc.dart';

// Recompensas
import 'features/recompensas/data/datasources/recompensas_remote_datasource.dart';
import 'features/recompensas/data/repositories/recompensas_repository_impl.dart';
import 'features/recompensas/domain/repositories/recompensas_repository.dart';
import 'features/recompensas/domain/usecases/get_recompensas_usecase.dart';
import 'features/recompensas/domain/usecases/get_recompensa_usecase.dart';
import 'features/recompensas/presentation/bloc/recompensas_bloc.dart';
import 'features/canjes/data/datasources/canjes_remote_datasource.dart';
import 'features/canjes/data/repositories/canjes_repository_impl.dart';
import 'features/canjes/domain/repositories/canjes_repository.dart';
import 'features/canjes/domain/usecases/crear_canje_usecase.dart';
import 'features/canjes/domain/usecases/get_canjes_usecase.dart';
import 'features/canjes/presentation/bloc/canjes_bloc.dart';
import 'features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'features/notificaciones/data/repositories/notificaciones_repository_impl.dart';
import 'features/notificaciones/domain/repositories/notificaciones_repository.dart';
import 'features/notificaciones/domain/usecases/get_notificaciones_usecase.dart';
import 'features/notificaciones/domain/usecases/marcar_leida_usecase.dart';
import 'features/notificaciones/domain/usecases/marcar_todas_leidas_usecase.dart';
import 'features/notificaciones/presentation/bloc/notificaciones_bloc.dart';
import 'features/trazabilidad/data/datasources/trazabilidad_remote_datasource.dart';
import 'features/trazabilidad/data/repositories/trazabilidad_repository_impl.dart';
import 'features/trazabilidad/domain/repositories/trazabilidad_repository.dart';
import 'features/trazabilidad/domain/usecases/get_trazabilidad_usecase.dart';
import 'features/trazabilidad/domain/usecases/get_ubicacion_recolector_usecase.dart';
import 'features/trazabilidad/presentation/bloc/trazabilidad_bloc.dart';
import 'features/empresas/solicitudes/data/datasources/empresa_solicitudes_remote_datasource.dart';
import 'features/empresas/solicitudes/data/repositories/empresa_solicitudes_repository_impl.dart';
import 'features/empresas/solicitudes/domain/repositories/empresa_solicitudes_repository.dart';
import 'features/empresas/solicitudes/domain/usecases/get_empresa_solicitudes_usecase.dart';
import 'features/empresas/solicitudes/domain/usecases/aceptar_empresa_solicitud_usecase.dart';
import 'features/empresas/solicitudes/domain/usecases/rechazar_empresa_solicitud_usecase.dart';
import 'features/empresas/solicitudes/domain/usecases/marcar_en_transito_empresa_solicitud_usecase.dart';
import 'features/empresas/solicitudes/domain/usecases/marcar_recolectada_empresa_solicitud_usecase.dart';
import 'features/empresas/solicitudes/presentation/bloc/empresa_solicitudes_bloc.dart';
import 'features/empresas/recolectores/data/datasources/recolectores_remote_datasource.dart';
import 'features/empresas/recolectores/data/repositories/recolectores_repository_impl.dart';
import 'features/empresas/recolectores/domain/repositories/recolectores_repository.dart';
import 'features/empresas/recolectores/domain/usecases/get_recolectores_usecase.dart';
import 'features/empresas/recolectores/domain/usecases/crear_recolector_usecase.dart';
import 'features/empresas/recolectores/domain/usecases/desactivar_recolector_usecase.dart';
import 'features/empresas/recolectores/presentation/bloc/recolectores_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core ─────────────────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage(sl()));
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl()));
  sl.registerLazySingleton<Dio>(() => ApiClient.create(sl()));

  // ── Auth ─────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => RecuperarContrasenaUsecase(sl()));
  sl.registerLazySingleton(() => VerificarCodigoUsecase(sl()));
  sl.registerLazySingleton(() => CambiarContrasenaUsecase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      recuperarUsecase: sl(),
      verificarUsecase: sl(),
      cambiarUsecase: sl(),
      storage: sl(),
    ),
  );

  // ── Dispositivos ─────────────────────────────────────────────
  sl.registerLazySingleton<DispositivosRemoteDatasource>(
    () => DispositivosRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<DispositivosRepository>(
    () => DispositivosRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ObtenerDispositivosUsecase(sl()));
  sl.registerLazySingleton(() => CrearDispositivoUsecase(sl()));
  sl.registerLazySingleton(() => EliminarDispositivoUsecase(sl()));

  sl.registerFactory(
    () => DispositivosBloc(
      obtenerUsecase: sl(),
      crearUsecase: sl(),
      eliminarUsecase: sl(),
    ),
  );

  // ── Solicitudes ──────────────────────────────────────────────
  sl.registerLazySingleton<SolicitudesRemoteDataSource>(
    () => SolicitudesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SolicitudesRepository>(
    () => SolicitudesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSolicitudesUseCase(sl()));
  sl.registerLazySingleton(() => CrearSolicitudUseCase(sl()));
  sl.registerLazySingleton(() => CancelarSolicitudUseCase(sl()));

  sl.registerFactory(
    () => SolicitudesBloc(
      sl(),
      sl(),
      sl(),
    ),
  );


  

  // ── Puntos ───────────────────────────────────────────────────
  sl.registerLazySingleton<PuntosRemoteDatasource>(
    () => PuntosRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<PuntosRepository>(
    () => PuntosRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetPuntosUsecase(sl()));
  sl.registerLazySingleton(() => GetHistorialPuntosUsecase(sl()));

  sl.registerFactory(
    () => PuntosBloc(
      getPuntosUsecase: sl(),
      getHistorialPuntosUsecase: sl(),
    ),
  );


// ── Recompensas ───────────────────────────────────────────────────
  sl.registerLazySingleton<RecompensasRemoteDatasource>(
    () => RecompensasRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<RecompensasRepository>(
    () => RecompensasRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetRecompensasUsecase(sl()));
  sl.registerLazySingleton(() => GetRecompensaUsecase(sl()));
  sl.registerFactory(
    () => RecompensasBloc(
      getRecompensasUsecase: sl(),
      getRecompensaUsecase: sl(),
    ),
  );

  // ── Canjes ──────────────────────────────────────────────────
  sl.registerLazySingleton<CanjesRemoteDatasource>(
    () => CanjesRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<CanjesRepository>(
    () => CanjesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CrearCanjeUsecase(sl()));
  sl.registerLazySingleton(() => GetCanjesUsecase(sl()));
  sl.registerFactory(
    () => CanjesBloc(
      crearCanjeUsecase: sl(),
      getCanjesUsecase: sl(),
    ),
  );

  // ── Notificaciones ───────────────────────────────────────────
  sl.registerLazySingleton<NotificacionesRemoteDatasource>(
    () => NotificacionesRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificacionesRepository>(
    () => NotificacionesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetNotificacionesUsecase(sl()));
  sl.registerLazySingleton(() => MarcarLeidaUsecase(sl()));
  sl.registerLazySingleton(() => MarcarTodasLeidasUsecase(sl()));
  sl.registerFactory(
    () => NotificacionesBloc(
      getNotificacionesUsecase: sl(),
      marcarLeidaUsecase: sl(),
      marcarTodasLeidasUsecase: sl(),
    ),
  );

  // ── Trazabilidad ─────────────────────────────────────────────
  sl.registerLazySingleton<TrazabilidadRemoteDatasource>(
    () => TrazabilidadRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<TrazabilidadRepository>(
    () => TrazabilidadRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTrazabilidadUsecase(sl()));
  sl.registerLazySingleton(() => GetUbicacionRecolectorUsecase(sl()));
  sl.registerFactory(
    () => TrazabilidadBloc(
      getTrazabilidadUsecase: sl(),
      getUbicacionRecolectorUsecase: sl(),
    ),
  );

  // ── Empresa solicitudes ────────────────────────────────────
  sl.registerLazySingleton<EmpresaSolicitudesRemoteDatasource>(
    () => EmpresaSolicitudesRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<EmpresaSolicitudesRepository>(
    () => EmpresaSolicitudesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetEmpresaSolicitudesUsecase(sl()));
  sl.registerLazySingleton(() => AceptarEmpresaSolicitudUsecase(sl()));
  sl.registerLazySingleton(() => RechazarEmpresaSolicitudUsecase(sl()));
  sl.registerLazySingleton(() => MarcarEnTransitoEmpresaSolicitudUsecase(sl()));
  sl.registerLazySingleton(() => MarcarRecolectadaEmpresaSolicitudUsecase(sl()));
  sl.registerFactory(
    () => EmpresaSolicitudesBloc(
      getSolicitudes: sl(),
      aceptarSolicitud: sl(),
      rechazarSolicitud: sl(),
      marcarEnTransito: sl(),
      marcarRecolectada: sl(),
    ),
  );

  // ── Empresa recolectores ───────────────────────────────────
  sl.registerLazySingleton<RecolectoresRemoteDatasource>(
    () => RecolectoresRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<RecolectoresRepository>(
    () => RecolectoresRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetRecolectoresUsecase(sl()));
  sl.registerLazySingleton(() => CrearRecolectorUsecase(sl()));
  sl.registerLazySingleton(() => DesactivarRecolectorUsecase(sl()));
  sl.registerFactory(
    () => RecolectoresBloc(
      getRecolectores: sl(),
      crearRecolector: sl(),
      desactivarRecolector: sl(),
    ),
  );



}
