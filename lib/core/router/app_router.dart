import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import 'app_routes.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/recuperar_contrasena_page.dart';
import '../../features/auth/presentation/pages/verificar_codigo_page.dart';
import '../../features/auth/presentation/pages/cambiar_contrasena_page.dart';
import '../../features/home/presentation/pages/home_usuario_page.dart';
import '../../features/home/presentation/pages/home_empresa_page.dart';
import '../../features/dispositivos/presentation/pages/dispositivos_list_page.dart';
import '../../features/dispositivos/presentation/pages/registro_dispositivo_page.dart';
import '../../features/dispositivos/presentation/pages/registro_exito_page.dart';
import '../../features/solicitudes/presentation/pages/crear_solicitud_page.dart';
import '../../features/solicitudes/presentation/pages/solicitud_enviada_page.dart';
import '../../features/solicitudes/presentation/pages/solicitud_cancelada_page.dart';
import '../../features/solicitudes/presentation/pages/solicitudes_menu_page.dart';
import '../../features/solicitudes/presentation/pages/solicitudes_page.dart';
import '../../features/solicitudes/presentation/bloc/solicitudes_bloc.dart';
import '../../features/puntos/presentation/bloc/puntos_bloc.dart';
import '../../features/puntos/presentation/pages/tus_puntos_page.dart';
import '../../features/notificaciones/presentation/pages/notificaciones_page.dart';
import '../../features/recompensas/presentation/bloc/recompensas_bloc.dart';
import '../../features/recompensas/presentation/pages/bono_ciclox_page.dart';
import '../../features/recompensas/presentation/pages/mercaditos_page.dart';
import '../../injection_container.dart';
import '../storage/secure_storage.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,

    redirect: (context, state) async {
      final storage = sl<SecureStorage>();
      final token = await storage.getToken();
      final rol = await storage.getRol();

      final loc = state.matchedLocation;
      final esPublica = loc == AppRoutes.login ||
          loc == AppRoutes.registro ||
          loc.startsWith('/recuperar') ||
          loc.startsWith('/verificar') ||
          loc.startsWith('/cambiar');

      if (token == null) {
        return esPublica ? null : AppRoutes.login;
      }

      if (loc == AppRoutes.login || loc == AppRoutes.registro) {
        return rol == 'EMPRESA'
            ? AppRoutes.homeEmpresa
            : AppRoutes.homeUsuario;
      }

      return null;
    },

    routes: [



      // ── AUTH ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (ctx, _) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registro,
        builder: (ctx, _) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.recuperarContrasena,
        builder: (ctx, _) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const RecuperarContrasenaPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.verificarCodigo,
        builder: (ctx, state) {
          final email = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: VerificarCodigoPage(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.cambiarContrasena,
        builder: (ctx, state) {
          final extra =
              (state.extra as Map?)?.cast<String, String>() ?? {};
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: CambiarContrasenaPage(
              email: extra['email'] ?? '',
              codigo: extra['codigo'] ?? '',
            ),
          );
        },
      ),

      // ── HOME ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.homeUsuario,
        builder: (ctx, _) => _HomeUsuarioWrapper(),
      ),
      GoRoute(
        path: AppRoutes.homeEmpresa,
        builder: (_, __) => const HomeEmpresaPage(),
      ),

      // ── DISPOSITIVOS ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.dispositivos,
        builder: (_, __) => const DispositivosListPage(),
      ),
      GoRoute(
        path: AppRoutes.registroDispositivo,
        builder: (_, __) => const RegistroDispositivoPage(),
      ),
      GoRoute(
        path: AppRoutes.registroDispositivoExito,
        builder: (_, __) => const RegistroExitoPage(),
      ),

      // ── SOLICITUDES ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.solicitudes,
        builder: (_, __) => const SolicitudesMenuPage(),
      ),
      GoRoute(
        path: AppRoutes.misSolicitudes,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<SolicitudesBloc>(),
          child: const SolicitudesPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.crearSolicitud,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<SolicitudesBloc>(),
          child: const CrearSolicitudPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.solicitudEnviada,
        builder: (_, __) => const SolicitudEnviadaPage(),
      ),
      GoRoute(
        path: AppRoutes.solicitudCancelada,
        builder: (_, __) => const SolicitudCanceladaPage(),
      ),

      // ── PUNTOS ───────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.tusPuntos,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<PuntosBloc>(),
          child: const TusPuntosPage(),
        ),
      ),

      // ── RECOMPENSAS ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.bonoCiclox,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<RecompensasBloc>(),
          child: const BonoCicloxPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.mercaditos,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<RecompensasBloc>(),
          child: const MercaditosPage(),
        ),
      ),

      // ── NOTIFICACIONES ───────────────────────────────────────────
      GoRoute(
        path: AppRoutes.notificaciones,
        builder: (_, __) => const NotificacionesPage(),
      ),
    ],

    errorBuilder: (ctx, state) => Scaffold(
      backgroundColor: const Color(0xFF1A1F3C),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Color(0xFFB4E614), size: 64),
            const SizedBox(height: 16),
            const Text(
              'Página no encontrada',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ctx.go(AppRoutes.login),
              child: const Text('Volver al inicio',
                  style: TextStyle(color: Color(0xFFB4E614))),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Wrapper que lee el nombre del usuario guardado de forma segura
class _HomeUsuarioWrapper extends StatefulWidget {
  @override
  State<_HomeUsuarioWrapper> createState() => _HomeUsuarioWrapperState();
}

class _HomeUsuarioWrapperState extends State<_HomeUsuarioWrapper> {
  String _nombre = 'Usuario';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadNombre();
  }

  Future<void> _loadNombre() async {
    try {
      final data = await sl<SecureStorage>().getUserData();
      if (data != null) {
        final map = jsonDecode(data) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _nombre = map['nombre'] as String? ?? 'Usuario';
            _loaded = true;
          });
          return;
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1F3C),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFB4E614),
          ),
        ),
      );
    }
    return HomeUsuarioPage(nombreUsuario: _nombre);
  }
}
