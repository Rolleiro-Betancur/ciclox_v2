import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/dispositivo_entity.dart';
import '../bloc/dispositivos_bloc.dart';
import '../bloc/dispositivos_event.dart';
import '../bloc/dispositivos_state.dart';

class DispositivosListPage extends StatelessWidget {
  const DispositivosListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DispositivosBloc>()..add(LoadDispositivos()),
      child: const _DispositivosListView(),
    );
  }
}

class _DispositivosListView extends StatelessWidget {
  const _DispositivosListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<DispositivosBloc, DispositivosState>(
        listener: (ctx, state) {
          if (state is DispositivosError) {
            showErrorSnackBar(ctx, state.message);
          }
          if (state is DispositivoEliminado) {
            showSuccessSnackBar(ctx, 'Dispositivo eliminado');
            ctx.read<DispositivosBloc>().add(LoadDispositivos());
          }
        },
        builder: (ctx, state) {
          return Column(
            children: [
              // Header
              CicloxHeader(title: 'MIS DISPOSITIVOS', showBack: true),

              Expanded(
                child: _buildBody(ctx, state),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.registroDispositivo),
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Registrar',
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildBody(BuildContext ctx, DispositivosState state) {
    if (state is DispositivosLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.navy),
      );
    }

    if (state is DispositivosLoaded) {
      if (state.dispositivos.isEmpty) {
        return _EmptyState(
          onTap: () => ctx.push(AppRoutes.registroDispositivo),
        );
      }
      return RefreshIndicator(
        color: AppColors.navy,
        onRefresh: () async {
          ctx.read<DispositivosBloc>().add(LoadDispositivos());
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: state.dispositivos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) =>
              _DispositivoCard(dispositivo: state.dispositivos[i]),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _DispositivoCard extends StatelessWidget {
  final DispositivoEntity dispositivo;
  const _DispositivoCard({required this.dispositivo});

  Color get _estadoColor {
    switch (dispositivo.estado) {
      case 'ACTIVO':
        return AppColors.success;
      case 'EN_PROCESO':
        return AppColors.warning;
      case 'RECICLADO':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _tipoIcon {
    switch (dispositivo.tipo) {
      case 'CELULAR':
        return Icons.smartphone_rounded;
      case 'LAPTOP':
        return Icons.laptop_rounded;
      case 'TABLET':
        return Icons.tablet_rounded;
      case 'TV':
        return Icons.tv_rounded;
      default:
        return Icons.devices_other_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CicloxCard(
      child: Row(
        children: [
          // Ícono tipo
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.navy.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_tipoIcon, color: AppColors.navy, size: 28),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dispositivo.marca} ${dispositivo.modelo}',
                  style: AppTextStyles.labelLarge
                      .copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(dispositivo.tipo,
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                CicloxStatusBadge(
                  label: dispositivo.estado,
                  color: _estadoColor,
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.devices_rounded,
                  color: AppColors.navy, size: 48),
            ),
            const SizedBox(height: 20),
            Text('Sin dispositivos',
                style:
                    AppTextStyles.heading3.copyWith(color: AppColors.navy)),
            const SizedBox(height: 8),
            Text(
              'Registra tu primer dispositivo electrónico para reciclarlo',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 24),
            CicloxPrimaryButton(
              label: 'Registrar dispositivo',
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
