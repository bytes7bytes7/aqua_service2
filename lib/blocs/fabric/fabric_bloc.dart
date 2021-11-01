import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fabric_repository/fabric_repository.dart';

part 'fabric_event.dart';

part 'fabric_state.dart';

class FabricBloc extends Bloc<FabricEvent, FabricState> {
  FabricBloc(FabricRepository fabricRepository)
      : _fabricRepository = fabricRepository,
        super(FabricLoadingState()) {
    on<FabricLoadEvent>(_loadFabric);
    on<FabricAddEvent>(_addFabric);
    on<FabricUpdateEvent>(_updateFabric);
    on<FabricDeleteEvent>(_deleteFabric);
  }

  final FabricRepository _fabricRepository;

  Future<void> _loadFabric(FabricLoadEvent event, Emitter<FabricState> emit) {
    if (state is! FabricLoadingState) {
      emit(FabricLoadingState());
    }
    return emit.onEach<List<Fabric>>(
      _fabricRepository.fabrics(),
      onData: (fabrics) => emit(FabricDataState(fabrics)),
      onError: (Object error, StackTrace stackTrace) => emit(
        FabricErrorState('$error\n\n$stackTrace'),
      ),
    );
  }

  void _addFabric(FabricAddEvent event, Emitter<FabricState> emit) {
    _fabricRepository
        .addFabric(event.fabric)
        .then((value) => add(FabricLoadEvent()));
  }

  void _updateFabric(FabricUpdateEvent event, Emitter<FabricState> emit) {
    _fabricRepository
        .updateFabric(event.fabric)
        .then((value) => add(FabricLoadEvent()));
  }

  void _deleteFabric(FabricDeleteEvent event, Emitter<FabricState> emit) {
    _fabricRepository
        .deleteFabric(event.fabric)
        .then((value) => add(FabricLoadEvent()));
  }
}
