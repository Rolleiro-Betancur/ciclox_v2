import 'package:equatable/equatable.dart';
import '../../domain/entities/notificacion_entity.dart';

class NotificacionesState extends Equatable {
  final bool isLoading;
  final bool isUpdating;
  final String? error;
  final List<NotificacionEntity> items;

  const NotificacionesState({
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
    this.items = const [],
  });

  int get noLeidas => items.where((n) => !n.leida).length;

  NotificacionesState copyWith({
    bool? isLoading,
    bool? isUpdating,
    String? error,
    List<NotificacionEntity>? items,
    bool clearError = false,
  }) {
    return NotificacionesState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: clearError ? null : (error ?? this.error),
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [isLoading, isUpdating, error, items];
}
