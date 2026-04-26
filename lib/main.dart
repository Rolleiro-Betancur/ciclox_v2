import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/router/app_router.dart';
import 'injection_container.dart';
import 'features/puntos/presentation/bloc/puntos_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar localización para fechas en español
  await initializeDateFormatting('es', null);

  // Inicializar inyección de dependencias
  await initDependencies();

  runApp(const CicloxApp());
}

class CicloxApp extends StatelessWidget {
  const CicloxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PuntosBloc>(
          create: (_) => sl<PuntosBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Ciclox',
        debugShowCheckedModeBanner: false,
        routerConfig: createAppRouter(),
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A1F3C),
            primary: const Color(0xFF1A1F3C),
            secondary: const Color(0xFFB4E614),
            surface: const Color(0xFFFFFFFF),
            background: const Color(0xFFF5F5F5),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1F3C),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1F3C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              minimumSize: const Size.fromHeight(52),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: UnderlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
