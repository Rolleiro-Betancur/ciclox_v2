import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

// ──────────────────────────────────────────────────────────────
//  CICLOX SHARED WIDGETS
// ──────────────────────────────────────────────────────────────

/// Header con fondo navy y clipper curvo inferior
class CicloxHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackPressed;

  const CicloxHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.navyGradient),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          bottom: 44,
          left: showBack ? 0 : 24,
          right: 24,
        ),
        child: Row(
          children: [
            if (showBack)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
                onPressed: onBackPressed ?? () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 28)
      ..quadraticBezierTo(
          size.width / 2, size.height + 12, size.width, size.height - 28)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(_HeaderClipper old) => false;
}

// ──────────────────────────────────────────────────────────────

/// Logo de Ciclox — usa asset, fallback icono reciclaje
class CicloxLogo extends StatelessWidget {
  final double height;
  const CicloxLogo({super.key, this.height = 110});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/ciclox_logo.png',
      height: height,
      errorBuilder: (_, __, ___) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: height,
            height: height,
            decoration: BoxDecoration(
              gradient: AppColors.navyGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.recycling_rounded,
                size: height * 0.5, color: AppColors.accent),
          ),
          const SizedBox(height: 6),
          Text(
            'CICLOX',
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.navy,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          Text(
            'Transforma · Recupera · Reintegra',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────

/// Campo de texto con estilo Ciclox (línea inferior)
class CicloxTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputAction? textInputAction;

  const CicloxTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText && maxLines == 1,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      textInputAction: textInputAction,
      style: AppTextStyles.bodyMedium
          .copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium
            .copyWith(color: AppColors.textSecondary),
        prefixIcon: Icon(prefixIcon, color: AppColors.navy, size: 22),
        suffixIcon: suffixIcon,
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.divider, width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.navy, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────

/// Botón primario navy Ciclox
class CicloxPrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double height;

  const CicloxPrimaryButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation(Colors.white)),
              )
            : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────

/// Botón secundario con borde
class CicloxOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;

  const CicloxOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: borderColor ?? AppColors.navy, width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonSecondary.copyWith(
            color: textColor ?? AppColors.navy,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────

/// Card estándar Ciclox con sombra suave
class CicloxCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  const CicloxCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────

/// Badge de estado para solicitudes/dispositivos
class CicloxStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const CicloxStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────

/// SnackBar de error estándar
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: AppTextStyles.bodySmall
              .copyWith(color: Colors.white)),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}

/// SnackBar de éxito estándar
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: AppTextStyles.bodySmall
              .copyWith(color: Colors.white)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}
