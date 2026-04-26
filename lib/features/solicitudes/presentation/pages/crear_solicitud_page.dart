import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';
import '../../../../injection_container.dart';
import '../../../dispositivos/domain/entities/dispositivo_entity.dart';
import '../../../dispositivos/presentation/bloc/dispositivos_bloc.dart';
import '../../../dispositivos/presentation/bloc/dispositivos_event.dart';
import '../../../dispositivos/presentation/bloc/dispositivos_state.dart';
import '../bloc/solicitudes_bloc.dart';
import '../bloc/solicitudes_event.dart';
import '../bloc/solicitudes_state.dart';

class CrearSolicitudPage extends StatefulWidget {
  const CrearSolicitudPage({super.key});

  @override
  State<CrearSolicitudPage> createState() => _CrearSolicitudPageState();
}

class _CrearSolicitudPageState extends State<CrearSolicitudPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // ── Estado del Paso 1: Selección de dispositivos ──
  final Set<int> _selectedDispositivos = {};
  List<DispositivoEntity> _allDispositivos = [];

  // ── Estado del Paso 2: Formulario de contacto ──
  final _formKey = GlobalKey<FormState>();
  final _direccionCtrl = TextEditingController();
  final _ciudadCtrl = TextEditingController();
  final _departamentoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _referenciaCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();
    _departamentoCtrl.dispose();
    _correoCtrl.dispose();
    _referenciaCtrl.dispose();
    super.dispose();
  }

  void _nextStep(BuildContext ctx) {
    if (_currentStep == 0) {
      if (_selectedDispositivos.isEmpty) {
        showErrorSnackBar(ctx, 'Selecciona al menos un dispositivo');
        return;
      }
    } else if (_currentStep == 1) {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
    }
    
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _confirmar(ctx);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.solicitudes);
      }
    }
  }

  void _confirmar(BuildContext ctx) {
    ctx.read<SolicitudesBloc>().add(CrearSolicitud(
          dispositivosIds: _selectedDispositivos.toList(),
          direccion: _direccionCtrl.text.trim(),
          ciudad: _ciudadCtrl.text.trim(),
          departamento: _departamentoCtrl.text.trim(),
          email: _correoCtrl.text.trim(),
          referencia: _referenciaCtrl.text.trim().isEmpty ? null : _referenciaCtrl.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<DispositivosBloc>()..add(LoadDispositivos()),
        ),
        BlocProvider(
          create: (_) => sl<SolicitudesBloc>(),
        ),
      ],
      child: BlocConsumer<SolicitudesBloc, SolicitudesState>(
        listener: (ctx, state) {
          if (state is SolicitudCreada) {
            ctx.go(AppRoutes.solicitudEnviada);
          } else if (state is SolicitudesError) {
            showErrorSnackBar(ctx, state.message);
          }
        },
        builder: (ctx, state) {
          final isSubmitting = state is SolicitudesLoading;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                CicloxHeader(
                  title: 'Dispositivos registrados',
                  showBack: true,
                  onBackPressed: isSubmitting ? null : _previousStep,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPaso1(ctx),
                      _buildPaso2(ctx),
                      _buildPaso3(ctx, isSubmitting),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================================
  // PASO 1: SELECCIONAR DISPOSITIVOS
  // =========================================================================
  Widget _buildPaso1(BuildContext ctx) {
    return BlocConsumer<DispositivosBloc, DispositivosState>(
      listener: (context, state) {
        if (state is DispositivosLoaded) {
          _allDispositivos = state.dispositivos;
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                '1. Elige qué deseas entregar',
                style: AppTextStyles.heading3.copyWith(color: AppColors.navy),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state is DispositivosLoading) {
                    return const Center(
                        child: CircularProgressIndicator(color: AppColors.navy));
                  }
                  if (state is DispositivosLoaded) {
                    if (state.dispositivos.isEmpty) {
                      return Center(
                        child: Text(
                          'No tienes dispositivos registrados.\nVe a la sección Dispositivos para registrar uno.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: state.dispositivos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, i) {
                        final d = state.dispositivos[i];
                        final isSelected = _selectedDispositivos.contains(d.id);
                        return _DeviceSelectionCard(
                          dispositivo: d,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedDispositivos.remove(d.id);
                              } else {
                                _selectedDispositivos.add(d.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CicloxPrimaryButton(
                label: 'Siguiente paso',
                onPressed: _selectedDispositivos.isEmpty ? null : () => _nextStep(ctx),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================================
  // PASO 2: DATOS DE CONTACTO
  // =========================================================================
  Widget _buildPaso2(BuildContext ctx) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2. ¿Dónde y cómo te contactamos?',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.navy),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Dirección',
                    hint: 'Cll 138 b sur cra 49a 14',
                    controller: _direccionCtrl,
                    validator: (v) =>
                        v!.isEmpty ? 'La dirección es obligatoria' : null,
                  ),
                  _buildTextField(
                    label: 'Ciudad',
                    hint: 'Medellín',
                    controller: _ciudadCtrl,
                    validator: (v) =>
                        v!.isEmpty ? 'La ciudad es obligatoria' : null,
                  ),
                  _buildTextField(
                    label: 'Departamento',
                    hint: 'Antioquia',
                    controller: _departamentoCtrl,
                    validator: (v) =>
                        v!.isEmpty ? 'El departamento es obligatorio' : null,
                  ),
                  _buildTextField(
                    label: 'Correo electrónico',
                    hint: 'Ejemplo@gmail.com',
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v!.isEmpty ? 'El correo es obligatorio' : null, // Validación básica
                  ),
                  _buildTextField(
                    label: 'Referencia (opcional)',
                    hint: 'Tercer piso',
                    controller: _referenciaCtrl,
                    isOptional: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: CicloxPrimaryButton(
            label: 'Confirmar',
            onPressed: () => _nextStep(ctx),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isOptional = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.navy)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: isOptional ? null : validator,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // PASO 3: CONFIRMACIÓN Y RESUMEN
  // =========================================================================
  Widget _buildPaso3(BuildContext ctx, bool isSubmitting) {
    // Obtener nombres de los dispositivos seleccionados
    final nombresDispositivos = _allDispositivos
        .where((d) => _selectedDispositivos.contains(d.id))
        .map((d) => '${d.marca} ${d.modelo}')
        .join(', ');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                const Icon(Icons.warning_rounded,
                    color: AppColors.error, size: 80),
                const SizedBox(height: 24),
                Text(
                  'Verifica que toda la información esté correcta antes de enviar',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading3.copyWith(color: AppColors.navy),
                ),
                const SizedBox(height: 40),
                
                // Resumen Dispositivos
                Text('Dispositivos seleccionados',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.navy, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(nombresDispositivos.isEmpty ? 'Ninguno' : nombresDispositivos,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium),
                
                const SizedBox(height: 32),
                
                // Resumen Información
                Text('Información',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.navy, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Dirección: ${_direccionCtrl.text}\n'
                  'Ciudad: ${_ciudadCtrl.text}\n'
                  'Correo: ${_correoCtrl.text}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: CicloxPrimaryButton(
            label: 'Confirmar',
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : () => _confirmar(ctx),
          ),
        ),
      ],
    );
  }
}

// ── Widget de Tarjeta de Dispositivo (Paso 1) ────────────────────────────────

class _DeviceSelectionCard extends StatelessWidget {
  final DispositivoEntity dispositivo;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeviceSelectionCard({
    required this.dispositivo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.navy : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // Checkbox circular
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.navy : AppColors.divider,
                  width: 2,
                ),
                color: isSelected ? AppColors.navy : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            
            // Imagen Placeholder (cuadrada con bordes redondeados)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.devices_rounded, color: AppColors.textSecondary, size: 32),
            ),
            const SizedBox(width: 16),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RichTextRow(label: 'Marca: ', value: dispositivo.marca),
                  _RichTextRow(label: 'Tipo: ', value: dispositivo.tipo),
                  _RichTextRow(
                    label: 'Estado: ',
                    value: dispositivo.estadoFisico ?? 'Enciende',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RichTextRow extends StatelessWidget {
  final String label;
  final String value;
  const _RichTextRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          text: label,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.navy),
          children: [
            TextSpan(
              text: value,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
