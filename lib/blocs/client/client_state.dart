part of 'client_bloc.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object?> get props => [];
}

class ClientLoadingState extends ClientState {}

class ClientDataState extends ClientState {
  final List<Client> clients;

  const ClientDataState(this.clients);

  @override
  List<Object?> get props => [clients];

  @override
  String toString() => 'ClientDataState {clients: $clients}';
}

class ClientErrorState extends ClientState {
  final String error;

  const ClientErrorState(this.error);

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'ClientErrorState {error: $error}';
}
