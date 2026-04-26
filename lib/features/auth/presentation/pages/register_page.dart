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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();

  // Empresa
  final _nombreEmpresaCtrl = TextEditingController();
  final _nifCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  String _rol = 'USUARIO';
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    for (final c in [
      _nombreCtrl, _emailCtrl, _passCtrl, _confirmCtrl, _telefonoCtrl,
      _nombreEmpresaCtrl, _nifCtrl, _direccionCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      final esEmpresa = _rol == 'EMPRESA';
      ctx.read<AuthBloc>().add(RegisterRequested(
            nombre: _nombreCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            contrasena: _passCtrl.text,
            telefono: _telefonoCtrl.text.trim(),
            rol: _rol,
            empresa: esEmpresa
                ? {
                    'nombre_empresa': _nombreEmpresaCtrl.text.trim(),
                    'nit': _nifCtrl.text.trim(),
                    'descripcion': _direccionCtrl.text.trim(),
                  }
                : null,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthAuthenticated) {
          ctx.go(state.usuario.esEmpresa
              ? AppRoutes.homeEmpresa
              : AppRoutes.homeUsuario);
        } else if (state is AuthError) {
          showErrorSnackBar(ctx, state.message);
        }
      },
      builder: (ctx, state) {
        final loading = state is AuthLoading;
        final esEmpresa = _rol == 'EMPRESA';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              const CicloxHeader(title: 'CREAR CUENTA'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // ── Selector de rol ─────────────
                        Text('Tipo de cuenta',
                            style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        _RolSelector(
                          selected: _rol,
                          onChanged: (r) => setState(() => _rol = r),
                        ),

                        const SizedBox(height: 24),

                        // ── Campos base ──────────────────
                        _Label('Nombre completo'),
                        CicloxTextField(
                          controller: _nombreCtrl,
                          hintText: 'Tu nombre',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (v) =>
                              _req(v) ? null : 'Campo requerido',
                        ),
                        const SizedBox(height: 14),

                        _Label('Correo electrónico'),
                        CicloxTextField(
                          controller: _emailCtrl,
                          hintText: 'correo@ejemplo.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (!_req(v)) return 'Campo requerido';
                            if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$')
                                .hasMatch(v!.trim())) return 'Correo inválido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        _Label('Teléfono'),
                        CicloxTextField(
                          controller: _telefonoCtrl,
                          hintText: '+57 300 000 0000',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              _req(v) ? null : 'Campo requerido',
                        ),
                        const SizedBox(height: 14),

                        _Label('Contraseña'),
                        CicloxTextField(
                          controller: _passCtrl,
                          hintText: 'Mínimo 8 caracteres',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscurePass,
                          suffixIcon: _toggleIcon(
                              _obscurePass,
                              () => setState(() => _obscurePass = !_obscurePass)),
                          validator: (v) {
                            if (!_req(v)) return 'Campo requerido';
                            if (v!.length < 8) return 'Mínimo 8 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        _Label('Confirmar contraseña'),
                        CicloxTextField(
                          controller: _confirmCtrl,
                          hintText: 'Repite tu contraseña',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscureConfirm,
                          suffixIcon: _toggleIcon(
                              _obscureConfirm,
                              () => setState(
                                  () => _obscureConfirm = !_obscureConfirm)),
                          validator: (v) => v != _passCtrl.text
                              ? 'Las contraseñas no coinciden'
                              : null,
                        ),

                        // ── Campos empresa ───────────────
                        if (esEmpresa) ...[
                          const SizedBox(height: 28),
                          _SectionDivider(label: 'Datos de empresa'),
                          const SizedBox(height: 18),

                          _Label('Nombre de la empresa'),
                          CicloxTextField(
                            controller: _nombreEmpresaCtrl,
                            hintText: 'Razón social',
                            prefixIcon: Icons.business_outlined,
                            validator: (v) =>
                                esEmpresa && !_req(v) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),

                          _Label('NIF / RUC'),
                          CicloxTextField(
                            controller: _nifCtrl,
                            hintText: 'Número de identificación fiscal',
                            prefixIcon: Icons.badge_outlined,
                            validator: (v) =>
                                esEmpresa && !_req(v) ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 14),

                          _Label('Descripción'),
                          CicloxTextField(
                            controller: _direccionCtrl,
                            hintText: 'Descripción de la empresa',
                            prefixIcon: Icons.location_on_outlined,
                            validator: (v) =>
                                esEmpresa && !_req(v) ? 'Campo requerido' : null,
                          ),
                        ],

                        const SizedBox(height: 36),

                        CicloxPrimaryButton(
                          label: 'Crear cuenta',
                          isLoading: loading,
                          onPressed: loading ? null : () => _submit(ctx),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('¿Ya tienes cuenta? ',
                                  style: AppTextStyles.bodySmall),
                              GestureDetector(
                                onTap: () => ctx.go(AppRoutes.login),
                                child: Text(
                                  'Inicia sesión',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.navy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
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

  bool _req(String? v) => v != null && v.trim().isNotEmpty;

  Widget _toggleIcon(bool obscure, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: AppColors.textSecondary,
      ),
      onPressed: onPressed,
    );
  }
}

// ── Widgets privados ──────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: AppTextStyles.labelMedium
              .copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label,
              style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.navy, fontWeight: FontWeight.w700)),
        ),
        Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _RolSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _RolSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip('USUARIO', Icons.person_rounded, selected, onChanged),
        const SizedBox(width: 12),
        _Chip('EMPRESA', Icons.business_rounded, selected, onChanged),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String rol;
  final IconData icon;
  final String selected;
  final ValueChanged<String> onChanged;
  const _Chip(this.rol, this.icon, this.selected, this.onChanged);

  @override
  Widget build(BuildContext context) {
    final active = selected == rol;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(rol),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          decoration: BoxDecoration(
            color: active ? AppColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? AppColors.navy : AppColors.divider,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: active ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(rol,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: active ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
