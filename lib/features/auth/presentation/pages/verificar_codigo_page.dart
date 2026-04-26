import 'dart:async';
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

/// Paso 2: ingresar el código OTP de 5 dígitos
class VerificarCodigoPage extends StatefulWidget {
  final String email;
  const VerificarCodigoPage({super.key, required this.email});

  @override
  State<VerificarCodigoPage> createState() => _VerificarCodigoPageState();
}

class _VerificarCodigoPageState extends State<VerificarCodigoPage> {
  static const _codeLength = 5;
  final List<TextEditingController> _ctrls =
      List.generate(_codeLength, (_) => TextEditingController());
  final List<FocusNode> _nodes =
      List.generate(_codeLength, (_) => FocusNode());

  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  String get _code => _ctrls.map((c) => c.text).join();

  void _verify(BuildContext ctx) {
    if (_code.length == _codeLength) {
      ctx.read<AuthBloc>().add(VerificarCodigoRequested(
            email: widget.email,
            codigo: _code,
          ));
    } else {
      showErrorSnackBar(ctx, 'Ingresa los $_codeLength dígitos del código');
    }
  }

  void _resend(BuildContext ctx) {
    ctx.read<AuthBloc>().add(
          RecuperarContrasenaRequested(email: widget.email),
        );
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthCodigoVerificado) {
          ctx.push(AppRoutes.cambiarContrasena,
              extra: {'email': state.email, 'codigo': state.codigo});
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
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const CicloxLogo(),
                      const SizedBox(height: 28),

                      Text('Verifica tu correo',
                          style: AppTextStyles.heading2),
                      const SizedBox(height: 6),
                      Text(
                        'Ingresa el código enviado',
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // ── Cajas OTP ────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_codeLength, (i) {
                          return Container(
                            width: 52,
                            height: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _ctrls[i],
                              focusNode: _nodes[i],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              style: AppTextStyles.heading2,
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onChanged: (v) {
                                if (v.isNotEmpty && i < _codeLength - 1) {
                                  _nodes[i + 1].requestFocus();
                                }
                                if (v.isEmpty && i > 0) {
                                  _nodes[i - 1].requestFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Reenviar
                      GestureDetector(
                        onTap: _secondsLeft == 0 ? () => _resend(ctx) : null,
                        child: Text(
                          _secondsLeft > 0
                              ? 'Reenviar código ($_secondsLeft\s)'
                              : 'Reenviar código',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _secondsLeft == 0
                                ? AppColors.navy
                                : AppColors.textSecondary,
                            fontWeight: _secondsLeft == 0
                                ? FontWeight.w700
                                : FontWeight.w400,
                            decoration: _secondsLeft == 0
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      CicloxPrimaryButton(
                        label: 'Verificar',
                        isLoading: loading,
                        onPressed: loading ? null : () => _verify(ctx),
                      ),

                      const SizedBox(height: 32),
                    ],
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
