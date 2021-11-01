part of 'fabric_bloc.dart';

abstract class FabricEvent extends Equatable {
  const FabricEvent();

  @override
  List<Object?> get props => [];
}

class FabricLoadEvent extends FabricEvent {}

class FabricAddEvent extends FabricEvent {
  const FabricAddEvent(this.fabric);

  final Fabric fabric;

  @override
  List<Object?> get props => [fabric];

  @override
  String toString() => 'FabricAddEvent {fabric: $fabric}';
}

class FabricUpdateEvent extends FabricEvent {
  const FabricUpdateEvent(this.fabric);

  final Fabric fabric;

  @override
  List<Object?> get props => [fabric];

  @override
  String toString() => 'FabricUpdateEvent {fabric: $fabric}';
}

class FabricDeleteEvent extends FabricEvent {
  const FabricDeleteEvent(this.fabric);

  final Fabric fabric;

  @override
  List<Object?> get props => [fabric];

  @override
  String toString() => 'FabricDeleteEvent {fabric: $fabric}';
}
