import 'package:equatable/equatable.dart';

abstract class RecompensasEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRecompensas extends RecompensasEvent {}

class LoadRecompensa extends RecompensasEvent {
  final int id;
  LoadRecompensa(this.id);

  @override
  List<Object?> get props => [id];
}