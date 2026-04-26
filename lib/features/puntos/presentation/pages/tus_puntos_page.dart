import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/puntos_bloc.dart';
import '../bloc/puntos_event.dart';
import '../bloc/puntos_state.dart';
import '../../domain/entities/puntos_entity.dart';
import '../../../../core/router/app_routes.dart';

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
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tus Puntos',
          style: TextStyle(
            color: Color(0xFF1A3A1A),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1A3A1A)),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF2E7D32),
        onRefresh: () async {
          context.read<PuntosBloc>()
            ..add(RefreshPuntos())
            ..add(LoadHistorialPuntos());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _SaldoCard(),
              const SizedBox(height: 24),
              _ProximaRecompensaSection(),
              const SizedBox(height: 24),
              _RecompensasAcciones(),
              const SizedBox(height: 24),
              _HistorialSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Saldo Card ────────────────────────────────────────────────
class _SaldoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuntosBloc, PuntosState>(
      builder: (context, state) {
        if (state.isLoadingPuntos && state.puntos == null) {
          return const _CardSkeleton(height: 160);
        }
        if (state.puntosError != null && state.puntos == null) {
          return _ErrorCard(message: state.puntosError!);
        }
        if (state.puntos != null) {
          final p = state.puntos!;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo disponible',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormat('#,###').format(p.saldoActual),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'pts',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatChip(
                      label: 'Ganados',
                      value: NumberFormat('#,###').format(p.totalGanado),
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      label: 'Canjeados',
                      value: NumberFormat('#,###').format(p.totalCanjeado),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            '$value pts',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Próxima Recompensa ──────────────────────────────────────
class _ProximaRecompensaSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuntosBloc, PuntosState>(
      builder: (context, state) {
        if (state.puntos == null) return const SizedBox.shrink();
        final proxima = state.puntos!.proximaRecompensa;
        if (proxima == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8F5E9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Próxima recompensa',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${proxima.progresoPorcentaje}%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                proxima.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3A1A),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: proxima.progresoPorcentaje / 100,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE8F5E9),
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Te faltan ${NumberFormat('#,###').format(proxima.puntosFaltantes)} pts '
                'de ${NumberFormat('#,###').format(proxima.puntosRequeridos)} pts',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Botones de recompensas ──────────────────────────────────
class _RecompensasAcciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Canjear puntos',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A3A1A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RecompensaButton(
                label: 'Bono Ciclox',
                subtitle: 'Desde 600 pts',
                icon: Icons.discount_outlined,
                color: const Color(0xFF1565C0),
                onTap: () => context.push(AppRoutes.bonoCiclox),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RecompensaButton(
                label: 'Mercaditos',
                subtitle: 'Desde 5.000 pts',
                icon: Icons.shopping_basket_outlined,
                color: const Color(0xFFE65100),
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
  final Color color;
  final VoidCallback onTap;

  const _RecompensaButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF1A3A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Historial ────────────────────────────────────────────────
class _HistorialSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de puntos',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A3A1A),
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<PuntosBloc, PuntosState>(
          builder: (context, state) {
            if (state.isLoadingHistorial && state.historial.isEmpty) {
              return Column(
                children: List.generate(
                  4,
                  (_) => const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _CardSkeleton(height: 64),
                  ),
                ),
              );
            }
            if (state.historialError != null && state.historial.isEmpty) {
              return _ErrorCard(message: state.historialError!);
            }
            if (!state.isLoadingHistorial && state.historial.isEmpty) {
              return _EmptyHistorial();
            }
            if (state.historial.isNotEmpty) {
              return Column(
                children: [
                  ...state.historial.map((m) => _MovimientoTile(movimiento: m)),
                  if (state.hasMoreHistorial && !state.isLoadingHistorial)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextButton(
                        onPressed: () {
                          context.read<PuntosBloc>().add(
                                LoadHistorialPuntos(page: state.currentPage + 1),
                              );
                        },
                        child: const Text(
                          'Ver más',
                          style: TextStyle(color: Color(0xFF2E7D32)),
                        ),
                      ),
                    ),
                  if (state.isLoadingHistorial)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
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

class _MovimientoTile extends StatelessWidget {
  final MovimientoPuntosEntity movimiento;
  const _MovimientoTile({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final esGanado = movimiento.esGanado;
    final color = esGanado ? const Color(0xFF2E7D32) : const Color(0xFFE53935);
    final signo = esGanado ? '+' : '';
    final fmt = DateFormat('dd MMM yyyy', 'es');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              esGanado ? Icons.recycling : Icons.redeem,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movimiento.descripcion,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fmt.format(movimiento.fecha),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$signo${NumberFormat('#,###').format(movimiento.cantidad.abs())} pts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.history, size: 48, color: Color(0xFFBDBDBD)),
          SizedBox(height: 12),
          Text(
            'Aún no tienes movimientos',
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
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