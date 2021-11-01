part of 'client_bloc.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object?> get props => [];
}

class ClientLoadingState extends ClientState {}

class ClientDataState extends ClientState {
  const ClientDataState(this.clients);

  final List<Client> clients;

  @override
  List<Object?> get props => [clients];

  @override
  String toString() => 'ClientDataState {clients: $clients}';
}

class ClientErrorState extends ClientState {
  const ClientErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'ClientErrorState {error: $error}';
}
