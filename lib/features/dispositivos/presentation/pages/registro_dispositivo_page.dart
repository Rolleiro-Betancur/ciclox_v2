import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';
import '../../../../injection_container.dart';
import '../bloc/dispositivos_bloc.dart';
import '../bloc/dispositivos_event.dart';
import '../bloc/dispositivos_state.dart';

class RegistroDispositivoPage extends StatefulWidget {
  const RegistroDispositivoPage({super.key});

  @override
  State<RegistroDispositivoPage> createState() =>
      _RegistroDispositivoPageState();
}

class _RegistroDispositivoPageState extends State<RegistroDispositivoPage> {
  final _formKey = GlobalKey<FormState>();
  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  String _tipo = 'Televisor';
  String _estado = 'Funciona'; // Funciona o Dañado
  XFile? _foto;
  Uint8List? _fotoBytes;

  static const _tipos = [
    'Celular',
    'Computador',
    'Tablet',
    'Televisor',
    'Impresora',
    'Batería',
    'Cargador',
    'Electrodoméstico',
    'Otro',
  ];

  @override
  void dispose() {
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // En web no hay cámara confiable; usamos galería
    final source = kIsWeb ? ImageSource.gallery : ImageSource.camera;
    final file = await picker.pickImage(source: source, imageQuality: 80);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        _foto = file;
        _fotoBytes = bytes;
      });
    }
  }

  String _mapTipo(String tipoUI) {
    switch (tipoUI) {
      case 'Batería':
        return 'BATERIA';
      case 'Electrodoméstico':
        return 'ELECTRODOMESTICO';
      default:
        return tipoUI.toUpperCase();
    }
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      ctx.read<DispositivosBloc>().add(CrearDispositivo(
            tipo: _mapTipo(_tipo), // Convierte a las opciones exactas
            marca: _marcaCtrl.text.trim(),
            modelo: _modeloCtrl.text.trim(),
            descripcion: _descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim(),
            estadoFisico: _estado == 'Funciona' ? 'ENCIENDE' : 'DANIADO',
            fotoPath: kIsWeb ? null : _foto?.path,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DispositivosBloc>(),
      child: BlocConsumer<DispositivosBloc, DispositivosState>(
        listener: (ctx, state) {
          if (state is DispositivoCreado) {
            context.go(AppRoutes.registroDispositivoExito);
          } else if (state is DispositivosError) {
            showErrorSnackBar(ctx, state.message);
          }
        },
        builder: (ctx, state) {
          final loading = state is DispositivosLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // ── Top bar (como en home) ───────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CicloxLogoText(),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.notificaciones),
                          child: const Icon(
                            Icons.notifications_rounded,
                            color: AppColors.navy,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            // Header "<- Registro del dispositivo"
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: const Icon(Icons.arrow_back,
                                      color: AppColors.navy, size: 28),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Registro del dispositivo',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.navy,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // ── Tipo de dispositivo ──────────
                            Text('Tipo de dispositivo',
                                style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.navy, fontSize: 16)),
                            const SizedBox(height: 8),
                            Container(
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.divider, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _tipo,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: AppColors.navy),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary),
                                  items: _tipos.map((t) {
                                    return DropdownMenuItem(
                                      value: t,
                                      child: Text(t),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _tipo = val);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ── Marca ──────────
                            Text('Marca',
                                style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.navy, fontSize: 16)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _marcaCtrl,
                              textInputAction: TextInputAction.next,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Samsung',
                                hintStyle: AppTextStyles.bodyMedium
                                    .copyWith(color: AppColors.textSecondary),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.divider, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.navy, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.error, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.error, width: 1.5),
                                ),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Campo requerido'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // ── Modelo Opcional ──────────
                            Text('Modelo Opcional',
                                style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.navy, fontSize: 16)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _modeloCtrl,
                              textInputAction: TextInputAction.done,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Neo QLED 8K',
                                hintStyle: AppTextStyles.bodyMedium
                                    .copyWith(color: AppColors.textSecondary),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.divider, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.navy, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ── Estado del dispositivo ──────────
                            Text('Estado del dispositivo',
                                style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.navy, fontSize: 16)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _RadioOption(
                                  label: 'Funciona',
                                  value: 'Funciona',
                                  groupValue: _estado,
                                  onChanged: (v) =>
                                      setState(() => _estado = v!),
                                ),
                                const SizedBox(width: 24),
                                _RadioOption(
                                  label: 'Dañado',
                                  value: 'Dañado',
                                  groupValue: _estado,
                                  onChanged: (v) =>
                                      setState(() => _estado = v!),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ── Descripción Opcional ──────────
                            Text('Descripción Opcional',
                                style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.navy, fontSize: 16)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descripcionCtrl,
                              textInputAction: TextInputAction.done,
                              maxLines: 3,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Ej: Pantalla rota pero enciende...',
                                hintStyle: AppTextStyles.bodyMedium
                                    .copyWith(color: AppColors.textSecondary),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.divider, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.navy, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ── Subir foto ─────────────────────────
                            Text('Subir foto',
                                style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.navy, fontSize: 16)),
                            const SizedBox(height: 8),

                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: double.infinity,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.divider,
                                    width: 1,
                                  ),
                                ),
                                child: _fotoBytes != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.memory(_fotoBytes!,
                                            fit: BoxFit.cover),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.camera_alt_outlined,
                                              color: AppColors.textSecondary,
                                              size: 40),
                                          const SizedBox(height: 8),
                                          Text('Subir foto',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // ── Botón Registrar ───────────────────────
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: loading ? null : () => _submit(ctx),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.navy,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: loading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2))
                                      : const Text(
                                          'Registrar dispositivo',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Nav
            bottomNavigationBar: _BottomNav(
              onSettings: () {},
              onHome: () => context.go(AppRoutes.homeUsuario),
              onRewards: () => context.push(AppRoutes.tusPuntos),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS PRIVADOS
// ─────────────────────────────────────────────────────────────

class _CicloxLogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'cl',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.navy,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          child: const Icon(
            Icons.recycling_rounded,
            color: AppColors.accent,
            size: 24,
          ),
        ),
        const Text(
          'x',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.navy : AppColors.divider,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onHome;
  final VoidCallback onRewards;

  const _BottomNav({
    required this.onSettings,
    required this.onHome,
    required this.onRewards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5E9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.settings_outlined, onTap: onSettings, isActive: false),
          _NavItem(icon: Icons.home_rounded, onTap: onHome, isActive: true),
          _NavItem(icon: Icons.stars_rounded, onTap: onRewards, isActive: false),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(),
        child: Icon(
          icon,
          size: 28,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
