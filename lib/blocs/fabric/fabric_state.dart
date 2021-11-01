part of 'fabric_bloc.dart';

abstract class FabricState extends Equatable {
  const FabricState();

  @override
  List<Object?> get props => [];
}

class FabricLoadingState extends FabricState {}

class FabricDataState extends FabricState {
  const FabricDataState(this.fabrics);

  final List<Fabric> fabrics;

  @override
  List<Object?> get props => [fabrics];

  @override
  String toString() => 'FabricDataState {fabrics: $fabrics}';
}

class FabricErrorState extends FabricState {
  const FabricErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'FabricErrorState {error: $error}';
}
