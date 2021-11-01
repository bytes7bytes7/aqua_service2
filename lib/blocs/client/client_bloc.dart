import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:client_repository/client_repository.dart';

part 'client_event.dart';

part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc(ClientRepository clientRepository)
      :
        // maybe I need a copy of ClientRepository instead of original
        _clientRepository = clientRepository,
        super(ClientLoadingState()) {
    on<ClientLoadEvent>(_loadClient);
    on<ClientAddEvent>(_addClient);
    on<ClientUpdateEvent>(_updateClient);
    on<ClientDeleteEvent>(_deleteClient);
  }

  final ClientRepository _clientRepository;

  Future<void> _loadClient(ClientLoadEvent event, Emitter<ClientState> emit) {
    // maybe I need an error catcher here
    // maybe I need to add new Event before I emit new State
    if (state is! ClientLoadingState) {
      emit(ClientLoadingState());
    }
    return emit.onEach<List<Client>>(
      _clientRepository.clients(),
      onData: (clients) => emit(
        ClientDataState(clients),
      ),
      onError: (Object error, StackTrace stackTrace) => emit(
        ClientErrorState('$error\n\n$stackTrace'),
      ),
    );
  }

  void _addClient(ClientAddEvent event, Emitter<ClientState> emit) {
    _clientRepository
        .addClient(event.client)
        .then((value) => add(ClientLoadEvent()));
  }

  void _updateClient(ClientUpdateEvent event, Emitter<ClientState> emit) {
    _clientRepository
        .updateClient(event.client)
        .then((value) => add(ClientLoadEvent()));
  }

  void _deleteClient(ClientDeleteEvent event, Emitter<ClientState> emit) {
    _clientRepository
        .deleteClient(event.client)
        .then((value) => add(ClientLoadEvent()));
  }
}
