import 'dart:typed_data';

import 'package:image_repository/image_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'avatar_event.dart';

part 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc(ImageRepository imageRepository)
      : _imageRepository = imageRepository,
        super(AvatarLoadingState()) {
    on<AvatarLoadEvent>(_loadAvatar);
    on<AvatarSelectEvent>(_selectAvatar);
    on<AvatarDeleteEvent>(_deleteAvatar);
  }

  final ImageRepository _imageRepository;

  Future<void> _loadAvatar(
      AvatarLoadEvent event, Emitter<AvatarState> emit) async {
    if (state is! AvatarLoadingState) {
      emit(AvatarLoadingState());
    }
    try {
      Uint8List bytes = await _imageRepository.loadImage(event.path);
      return emit(AvatarDataState(bytes, event.path));
    } catch (e) {
      return emit(AvatarErrorState(e.toString()));
    }
  }

  void _selectAvatar(AvatarSelectEvent event, Emitter<AvatarState> emit) async {
    String path = await _imageRepository.pickImage();
    add(AvatarLoadEvent(path));
  }

  void _deleteAvatar(AvatarDeleteEvent event, Emitter<AvatarState> emit) {
    add(const AvatarLoadEvent(''));
  }
}
