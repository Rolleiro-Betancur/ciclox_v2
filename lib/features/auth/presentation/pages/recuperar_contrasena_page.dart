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

/// Paso 1: ingresar email para recibir código
class RecuperarContrasenaPage extends StatefulWidget {
  const RecuperarContrasenaPage({super.key});

  @override
  State<RecuperarContrasenaPage> createState() =>
      _RecuperarContrasenaPageState();
}

class _RecuperarContrasenaPageState extends State<RecuperarContrasenaPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      ctx.read<AuthBloc>().add(
            RecuperarContrasenaRequested(email: _emailCtrl.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthRecuperacionEnviada) {
          // Navegar al paso de verificación con el email
          ctx.push(AppRoutes.verificarCodigo,
              extra: _emailCtrl.text.trim());
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
                title: '¿OLVIDASTE TU\nCONTRASEÑA?',
                showBack: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const CicloxLogo(),
                        const SizedBox(height: 32),

                        Text(
                          'Ingresa tu correo\ny te enviaremos un código',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Campo correo
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: AppTextStyles.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Correo electrónico',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary),
                              border: InputBorder.none,
                              labelText: 'Correo electrónico',
                              labelStyle: AppTextStyles.labelMedium,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
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
                        ),

                        const SizedBox(height: 40),

                        CicloxPrimaryButton(
                          label: 'Enviar Código',
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
