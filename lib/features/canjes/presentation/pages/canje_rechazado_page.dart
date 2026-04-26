import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../bloc/canjes_bloc.dart';
import '../bloc/canjes_event.dart';

class CanjeRechazadoPage extends StatelessWidget {
  const CanjeRechazadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cancel_rounded,
                color: Color(0xFFC62828),
                size: 100,
              ),
              const SizedBox(height: 18),
              const Text(
                'No se pudo completar el canje',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB71C1C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'El código fue rechazado o expiró. Puedes intentar generar uno nuevo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFC62828), height: 1.35),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  context.read<CanjesBloc>().add(ClearCanjeActual());
                  context.go(AppRoutes.bonoCiclox);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Intentar de nuevo'),
              ),
              TextButton(
                onPressed: () {
                  context.read<CanjesBloc>().add(ClearCanjeActual());
                  context.go(AppRoutes.homeUsuario);
                },
                child: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
