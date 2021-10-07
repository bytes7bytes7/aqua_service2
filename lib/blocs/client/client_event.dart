part of 'client_bloc.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

class ClientLoadEvent extends ClientEvent {}

class ClientAddEvent extends ClientEvent {
  final Client client;

  const ClientAddEvent(this.client);

  @override
  List<Object?> get props => [client];

  @override
  String toString() => 'ClientAddEvent {client: $client}';
}

class ClientUpdateEvent extends ClientEvent {
  final Client client;

  const ClientUpdateEvent(this.client);

  @override
  List<Object?> get props => [client];

  @override
  String toString() => 'ClientUpdateEvent {client: $client}';
}

class ClientDeleteEvent extends ClientEvent {
  final Client client;

  const ClientDeleteEvent(this.client);

  @override
  List<Object?> get props => [client];

  @override
  String toString() => 'ClientDeleteEvent {client: $client}';
}
