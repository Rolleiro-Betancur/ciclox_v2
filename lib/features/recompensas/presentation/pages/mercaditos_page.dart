import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/recompensas_bloc.dart';
import '../bloc/recompensas_event.dart';
import '../bloc/recompensas_state.dart';
import '../../domain/entities/recompensa_entity.dart';
import '../../../../core/router/app_routes.dart';

class MercaditosPage extends StatefulWidget {
  const MercaditosPage({super.key});

  @override
  State<MercaditosPage> createState() => _MercaditosPageState();
}

class _MercaditosPageState extends State<MercaditosPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecompensasBloc>().add(LoadRecompensas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: BlocBuilder<RecompensasBloc, RecompensasState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _MercaditosSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (state is RecompensasLoading) ...[
                      const SizedBox(height: 20),
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ] else if (state is RecompensasError) ...[
                      _ErrorCard(message: state.message),
                    ] else if (state is RecompensasLoaded) ...[
                      _buildContent(
                        context,
                        state.recompensas
                            .where((r) => r.esMercaditos)
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<RecompensaEntity> mercaditos) {
    if (mercaditos.isEmpty) {
      return const _EmptyState(message: 'No hay mercaditos disponibles');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBanner(),
        const SizedBox(height: 24),
        const Text(
          'Opciones disponibles',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3E1A00),
          ),
        ),
        const SizedBox(height: 12),
        ...mercaditos.map((m) => _MercaditoCard(recompensa: m)),
      ],
    );
  }
}

class _MercaditosSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xFFE65100),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBF360C), Color(0xFFFFB300)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                left: -10,
                bottom: -10,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              const Positioned(
                left: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shopping_basket_outlined,
                        color: Colors.white70, size: 36),
                    SizedBox(height: 8),
                    Text(
                      'Mercaditos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Descuento en supermercados',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCC80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFE65100), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'El código QR tiene una vigencia de 30 minutos desde que '
              'lo generes. Úsalo en los supermercados aliados para obtener tu descuento.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MercaditoCard extends StatelessWidget {
  final RecompensaEntity recompensa;
  const _MercaditoCard({required this.recompensa});

  @override
  Widget build(BuildContext context) {
    final valorFmt = recompensa.valorMonetario != null
        ? NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0)
            .format(recompensa.valorMonetario)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header naranja
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE65100), Color(0xFFFFB300)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recompensa.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (valorFmt != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      valorFmt,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recompensa.descripcion,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF616161),
                    height: 1.4,
                  ),
                ),
                if (recompensa.aliadosList.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Supermercados aliados',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: recompensa.aliadosList
                        .map((a) => _AliadoChip(nombre: a))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                // ✅ Row corregido con Expanded y SizedBox en el botón
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.stars_rounded,
                              color: Color(0xFFE65100), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${NumberFormat('#,###').format(recompensa.puntosRequeridos)} pts',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE65100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () => context.push(
                          AppRoutes.qrMercaditos,
                          extra: recompensa,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE65100),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Canjear',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AliadoChip extends StatelessWidget {
  final String nombre;
  const _AliadoChip({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        nombre,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFFE65100),
          fontWeight: FontWeight.w600,
        ),
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
      margin: const EdgeInsets.only(top: 20),
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

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const Icon(Icons.shopping_basket_outlined,
                size: 56, color: Color(0xFFBDBDBD)),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}