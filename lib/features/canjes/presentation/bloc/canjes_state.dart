import 'package:equatable/equatable.dart';
import '../../domain/entities/canje_entity.dart';

class CanjesState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final List<CanjeEntity> canjes;
  final CanjeEntity? canjeActual;

  const CanjesState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.canjes = const [],
    this.canjeActual,
  });

  CanjesState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    List<CanjeEntity>? canjes,
    CanjeEntity? canjeActual,
    bool clearError = false,
    bool clearCanjeActual = false,
  }) {
    return CanjesState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      canjes: canjes ?? this.canjes,
      canjeActual: clearCanjeActual ? null : (canjeActual ?? this.canjeActual),
    );
  }

  @override
  List<Object?> get props => [isLoading, isSubmitting, error, canjes, canjeActual];
}
