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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      ctx.read<AuthBloc>().add(LoginRequested(
            email: _emailCtrl.text.trim(),
            contrasena: _passCtrl.text,
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
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // ── Header ────────────────────────────────
              const CicloxHeader(title: 'INICIAR SESIÓN'),

              // ── Body ──────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 36),
                        const CicloxLogo(),
                        const SizedBox(height: 44),

                        // Email
                        CicloxTextField(
                          controller: _emailCtrl,
                          hintText: 'Usuario',
                          prefixIcon: Icons.person_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Ingresa tu correo';
                            }
                            if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$')
                                .hasMatch(v.trim())) {
                              return 'Correo inválido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Contraseña
                        CicloxTextField(
                          controller: _passCtrl,
                          hintText: 'Contraseña',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
                        ),

                        const SizedBox(height: 14),

                        // Links
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LinkRow(
                                label: '¿Olvidaste tu contraseña?',
                                onTap: () =>
                                    ctx.push(AppRoutes.recuperarContrasena),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 44),

                        // Botón
                        CicloxPrimaryButton(
                          label: 'Ingresar',
                          isLoading: loading,
                          onPressed: loading ? null : () => _submit(ctx),
                        ),

                        const SizedBox(height: 24),

                        // Registro
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('¿No tienes cuenta? ',
                                style: AppTextStyles.bodySmall),
                            GestureDetector(
                              onTap: () => ctx.push(AppRoutes.registro),
                              child: Text(
                                'Regístrate',
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

class _LinkRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.close_rounded, size: 13, color: AppColors.navy),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.navy,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
