import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/ciclox_widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Paso 3: ingresar nueva contraseña
class CambiarContrasenaPage extends StatefulWidget {
  final String email;
  final String codigo;
  const CambiarContrasenaPage(
      {super.key, required this.email, required this.codigo});

  @override
  State<CambiarContrasenaPage> createState() => _CambiarContrasenaPageState();
}

class _CambiarContrasenaPageState extends State<CambiarContrasenaPage> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      ctx.read<AuthBloc>().add(CambiarContrasenaRequested(
            email: widget.email,
            codigo: widget.codigo,
            nuevaContrasena: _passCtrl.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthContrasenaActualizada) {
          // Mostrar éxito y llevar al login
          showSuccessSnackBar(ctx, 'Contraseña actualizada correctamente');
          ctx.go(AppRoutes.login);
        } else if (state is AuthError) {
          showErrorSnackBar(ctx, state.message);
        }
      },
      builder: (ctx, state) {
        final loading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              CicloxHeader(
                  title: '¿OLVIDASTE TU\nCONTRASEÑA?', showBack: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const CicloxLogo(),
                        const SizedBox(height: 36),

                        // Nueva contraseña
                        _OutlinedField(
                          label: 'Nueva contraseña',
                          controller: _passCtrl,
                          obscure: _obscurePass,
                          onToggle: () =>
                              setState(() => _obscurePass = !_obscurePass),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Campo requerido';
                            }
                            if (v.length < 8) return 'Mínimo 8 caracteres';
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _OutlinedField(
                          label: 'Confirmar contraseña',
                          controller: _confirmCtrl,
                          obscure: _obscureConfirm,
                          onToggle: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                          validator: (v) => v != _passCtrl.text
                              ? 'Las contraseñas no coinciden'
                              : null,
                        ),

                        const SizedBox(height: 48),

                        CicloxPrimaryButton(
                          label: 'Guardar cambios',
                          isLoading: loading,
                          onPressed: loading ? null : () => _submit(ctx),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OutlinedField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _OutlinedField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.labelMedium,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
