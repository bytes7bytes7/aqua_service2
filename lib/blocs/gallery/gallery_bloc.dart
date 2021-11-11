import 'dart:typed_data';
import 'package:image_repository/image_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'gallery_event.dart';

part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc(ImageRepository imageRepository)
      : _imageRepository = imageRepository,
        super(GalleryLoadingState()) {
    on<GalleryLoadEvent>(_loadGallery);
    on<GalleryAddEvent>(_addGallery);
    on<GalleryDeleteEvent>(_deleteGallery);
  }

  final ImageRepository _imageRepository;

  Future<void> _loadGallery(
      GalleryLoadEvent event, Emitter<GalleryState> emit) async {
    if (state is! GalleryLoadingState) {
      emit(GalleryLoadingState());
    }
    try {
      List<Uint8List> bytes = [];
      for (String p in event.path) {
        bytes.add(await _imageRepository.loadImage(p));
      }
      return emit(GalleryDataState(bytes, event.path));
    } catch (e) {
      return emit(GalleryErrorState(e.toString()));
    }
  }

  void _addGallery(GalleryAddEvent event, Emitter<GalleryState> emit) async {
    String p = await _imageRepository.pickImage();
    if (p.isNotEmpty) {
      add(GalleryLoadEvent(event.path..add(p)));
    }
  }

  void _deleteGallery(GalleryDeleteEvent event, Emitter<GalleryState> emit) {
    add(GalleryLoadEvent(event.path));
  }
}
