import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../recolectores/domain/entities/recolector_entity.dart';
import '../../recolectores/presentation/bloc/recolectores_bloc.dart';
import '../../recolectores/presentation/bloc/recolectores_event.dart';
import '../../recolectores/presentation/bloc/recolectores_state.dart';

class EmpresaRecolectoresPage extends StatefulWidget {
  const EmpresaRecolectoresPage({super.key});

  @override
  State<EmpresaRecolectoresPage> createState() => _EmpresaRecolectoresPageState();
}

class _EmpresaRecolectoresPageState extends State<EmpresaRecolectoresPage> {
  bool? _filtroActivo = true;

  @override
  void initState() {
    super.initState();
    context.read<RecolectoresBloc>().add(LoadRecolectores(activo: _filtroActivo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recolectores')),
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCrearRecolectorDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Crear recolector'),
      ),
      body: BlocConsumer<RecolectoresBloc, RecolectoresState>(
        listener: (context, state) {
          if (state is RecolectoresError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is RecolectoresActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is RecolectoresLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final recolectores = state is RecolectoresLoaded
              ? state.recolectores
              : const <RecolectorEntity>[];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Equipo de recolección', style: AppTextStyles.heading2),
                    ),
                    DropdownButton<bool?>(
                      value: _filtroActivo,
                      items: const [
                        DropdownMenuItem<bool?>(
                          value: null,
                          child: Text('Todos'),
                        ),
                        DropdownMenuItem<bool?>(
                          value: true,
                          child: Text('Activos'),
                        ),
                        DropdownMenuItem<bool?>(
                          value: false,
                          child: Text('Inactivos'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _filtroActivo = value);
                        context.read<RecolectoresBloc>().add(
                              LoadRecolectores(activo: value),
                            );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: recolectores.isEmpty
                    ? const Center(
                        child: Text('No hay recolectores para este filtro'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: recolectores.length,
                        itemBuilder: (context, index) {
                          final recolector = recolectores[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: recolector.activo
                                    ? const Color(0x1A2D7D46)
                                    : const Color(0x1AD32F2F),
                                child: Icon(
                                  Icons.person_outline,
                                  color: recolector.activo
                                      ? const Color(0xFF2D7D46)
                                      : const Color(0xFFD32F2F),
                                ),
                              ),
                              title: Text(
                                recolector.nombre,
                                style: AppTextStyles.labelLarge,
                              ),
                              subtitle: Text(
                                '${recolector.telefono ?? 'Sin teléfono'} · ${recolector.activo ? 'Activo' : 'Inactivo'}',
                                style: AppTextStyles.caption,
                              ),
                              trailing: recolector.activo
                                  ? IconButton(
                                      tooltip: 'Desactivar',
                                      onPressed: () => _confirmarDesactivar(
                                        context,
                                        recolector.id,
                                      ),
                                      icon: const Icon(
                                        Icons.person_remove_alt_1_outlined,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showCrearRecolectorDialog(BuildContext context) async {
    final nombreCtrl = TextEditingController();
    final telefonoCtrl = TextEditingController();
    final fotoCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Crear recolector'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Nombre completo',
                ),
              ),
              TextField(
                controller: telefonoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                ),
              ),
              TextField(
                controller: fotoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Foto URL (opcional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      final nombre = nombreCtrl.text.trim();
      final fotoUrl = fotoCtrl.text.trim();
      if (nombre.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre debe tener al menos 2 caracteres')),
        );
        return;
      }

      if (fotoUrl.isNotEmpty &&
          (Uri.tryParse(fotoUrl)?.hasAbsolutePath != true ||
              !(Uri.tryParse(fotoUrl)?.hasScheme ?? false))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La foto URL no tiene un formato válido')),
        );
        return;
      }

      context.read<RecolectoresBloc>().add(
            CrearRecolector(
              nombre: nombre,
              telefono: telefonoCtrl.text.trim().isEmpty
                  ? null
                  : telefonoCtrl.text.trim(),
              fotoUrl: fotoUrl.isEmpty ? null : fotoUrl,
            ),
          );
    }
  }

  Future<void> _confirmarDesactivar(BuildContext context, int recolectorId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desactivar recolector'),
        content: const Text('Esta acción marcará el recolector como inactivo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      if (!context.mounted) return;
      context.read<RecolectoresBloc>().add(DesactivarRecolector(recolectorId));
    }
  }
}
