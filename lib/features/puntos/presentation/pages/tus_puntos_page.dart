import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/puntos_bloc.dart';
import '../bloc/puntos_event.dart';
import '../bloc/puntos_state.dart';
import '../../domain/entities/puntos_entity.dart';
import '../../../../core/router/app_routes.dart';

const Color _darkBlue = Color(0xFF151532);
const Color _lightGreen = Color(0xFFEBF2E4);
const Color _textGreen = Color(0xFFBFE396);
const Color _textRed = Color(0xFFF27A73);

class TusPuntosPage extends StatefulWidget {
  const TusPuntosPage({super.key});

  @override
  State<TusPuntosPage> createState() => _TusPuntosPageState();
}

class _TusPuntosPageState extends State<TusPuntosPage> {
  @override
  void initState() {
    super.initState();
    context.read<PuntosBloc>()
      ..add(LoadPuntos())
      ..add(LoadHistorialPuntos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tus puntos',
          style: TextStyle(
            color: _darkBlue,
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: _darkBlue, size: 28),
      ),
      body: RefreshIndicator(
        color: _darkBlue,
        onRefresh: () async {
          context.read<PuntosBloc>()
            ..add(RefreshPuntos())
            ..add(LoadHistorialPuntos());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _SaldoYProgresoSection(),
              const SizedBox(height: 40),
              _RecompensasAcciones(),
              const SizedBox(height: 40),
              _HistorialSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _SaldoYProgresoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuntosBloc, PuntosState>(
      builder: (context, state) {
        if (state.isLoadingPuntos && state.puntos == null) {
          return const _CardSkeleton(height: 120);
        }
        if (state.puntosError != null && state.puntos == null) {
          return _ErrorCard(message: state.puntosError!);
        }
        if (state.puntos != null) {
          final p = state.puntos!;
          final proxima = p.proximaRecompensa;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${NumberFormat('#,###').format(p.saldoActual)} pts',
                style: const TextStyle(
                  color: _darkBlue,
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 16),
              if (proxima != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: proxima.progresoPorcentaje / 100,
                    minHeight: 12,
                    backgroundColor: _lightGreen,
                    color: _darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Te faltan ${NumberFormat('#,###').format(proxima.puntosFaltantes)} puntos para tu proxima recompensa',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _RecompensasAcciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recompensas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _RecompensaButton(
                label: 'Bono Ciclox',
                subtitle: 'Descuento en tecnologia',
                icon: Icons.phone_android_rounded,
                onTap: () => context.push(AppRoutes.bonoCiclox),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RecompensaButton(
                label: 'Mercaditos',
                subtitle: 'Descuentos en supermercados',
                icon: Icons.storefront_rounded,
                onTap: () => context.push(AppRoutes.mercaditos),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecompensaButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RecompensaButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: _darkBlue, size: 56),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: _darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text(
                'Ver detalles',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorialSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<PuntosBloc, PuntosState>(
          builder: (context, state) {
            if (state.isLoadingHistorial && state.historial.isEmpty) {
              return Column(
                children: List.generate(
                  4,
                  (_) => const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _CardSkeleton(height: 24),
                  ),
                ),
              );
            }
            if (state.historialError != null && state.historial.isEmpty) {
              return _ErrorCard(message: state.historialError!);
            }
            if (!state.isLoadingHistorial && state.historial.isEmpty) {
              return const Text(
                'Aún no tienes movimientos',
                style: TextStyle(color: Colors.grey),
              );
            }
            if (state.historial.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...state.historial.map((m) => _MovimientoItem(movimiento: m)),
                  if (state.hasMoreHistorial && !state.isLoadingHistorial)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextButton(
                          onPressed: () {
                            context.read<PuntosBloc>().add(
                                  LoadHistorialPuntos(page: state.currentPage + 1),
                                );
                          },
                          child: const Text(
                            'Ver más',
                            style: TextStyle(color: _darkBlue),
                          ),
                        ),
                      ),
                    ),
                  if (state.isLoadingHistorial)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: CircularProgressIndicator(color: _darkBlue),
                      ),
                    )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _MovimientoItem extends StatelessWidget {
  final MovimientoPuntosEntity movimiento;
  const _MovimientoItem({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final esGanado = movimiento.esGanado;
    final color = esGanado ? _textGreen : _textRed;
    final signo = esGanado ? '+' : '-';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$signo${NumberFormat('#,###').format(movimiento.cantidad.abs())} pts ${movimiento.descripcion}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

// ─── Bottom Navigation ─────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Configuración
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: _darkBlue, size: 32),
          ),
          // Home
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.login);
              }
            },
            icon: const Icon(Icons.home, color: _darkBlue, size: 36),
          ),
          // Recompensas/Puntos
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.stars, color: _darkBlue, size: 32),
          ),
        ],
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────
class _CardSkeleton extends StatelessWidget {
  final double height;
  const _CardSkeleton({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF9A9A)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 13),
      ),
    );
  }
}