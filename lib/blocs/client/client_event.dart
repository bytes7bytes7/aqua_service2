part of 'client_bloc.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

class ClientLoadEvent extends ClientEvent {}

class ClientAddEvent extends ClientEvent {
  const ClientAddEvent(this.client);

  final Client client;

  @override
  List<Object?> get props => [client];

  @override
  String toString() => 'ClientAddEvent {client: $client}';
}

class ClientUpdateEvent extends ClientEvent {
  const ClientUpdateEvent(this.client);

  final Client client;

  @override
  List<Object?> get props => [client];

  @override
  String toString() => 'ClientUpdateEvent {client: $client}';
}

class ClientDeleteEvent extends ClientEvent {
  const ClientDeleteEvent(this.client);

  final Client client;

  @override
  List<Object?> get props => [client];

  @override
  String toString() => 'ClientDeleteEvent {client: $client}';
}
