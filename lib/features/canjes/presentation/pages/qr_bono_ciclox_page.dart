import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/router/app_routes.dart';
import '../../../recompensas/domain/entities/recompensa_entity.dart';
import '../bloc/canjes_bloc.dart';
import '../bloc/canjes_event.dart';
import '../bloc/canjes_state.dart';

class QrBonoCicloxPage extends StatefulWidget {
  final RecompensaEntity recompensa;

  const QrBonoCicloxPage({
    super.key,
    required this.recompensa,
  });

  @override
  State<QrBonoCicloxPage> createState() => _QrBonoCicloxPageState();
}

class _QrBonoCicloxPageState extends State<QrBonoCicloxPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<CanjesBloc>()
        .add(CrearCanjeRequested(recompensaId: widget.recompensa.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('QR Bono Ciclox'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CanjesBloc, CanjesState>(
        listenWhen: (prev, curr) => prev.canjeActual != curr.canjeActual,
        listener: (context, state) {
          final canje = state.canjeActual;
          if (canje == null) return;
          if (canje.expirado) {
            context.go(AppRoutes.canjeRechazado);
          }
        },
        builder: (context, state) {
          if (state.isSubmitting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            );
          }

          if (state.error != null) {
            return _ErrorView(message: state.error!);
          }

          final canje = state.canjeActual;
          if (canje == null) {
            return const _ErrorView(
              message: 'No fue posible generar el código de canje.',
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  widget.recompensa.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Presenta este QR en el aliado para validar tu descuento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: QrImageView(
                    data: canje.codigoQr,
                    size: 240,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Expira: ${canje.fechaExpiracion.toLocal()}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF455A64),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.canjeExitoso),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Ya lo usé'),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.canjeRechazado),
                  child: const Text('Cancelar canje'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFB71C1C), size: 48),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFB71C1C)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
