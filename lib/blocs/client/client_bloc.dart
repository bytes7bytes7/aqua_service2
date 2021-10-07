import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:client_repository/client_repository.dart';

part 'client_event.dart';

part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc({required ClientRepository clientRepository})
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

  void _loadClient(ClientLoadEvent event, Emitter<ClientState> emit) {
    // maybe I need to add new Event before I emit new State
    emit.onEach<List<Client>>(
      _clientRepository.clients(),
      onData: (clients) => emit(ClientDataState(clients)),
    );
  }

  void _addClient(ClientAddEvent event, Emitter<ClientState> emit) {}

  void _updateClient(ClientUpdateEvent event, Emitter<ClientState> emit) {}

  void _deleteClient(ClientDeleteEvent event, Emitter<ClientState> emit) {}
}
