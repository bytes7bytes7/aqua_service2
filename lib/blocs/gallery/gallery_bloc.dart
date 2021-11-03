import 'dart:typed_data';

import 'package:aqua_service2/services/image_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'gallery_event.dart';

part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc() : super(GalleryLoadingState()) {
    on<GalleryLoadEvent>(_loadGallery);
    on<GalleryAddEvent>(_addGallery);
    on<GalleryDeleteEvent>(_deleteGallery);
  }

  Future<void> _loadGallery(
      GalleryLoadEvent event, Emitter<GalleryState> emit) async {
    if (state is! GalleryLoadingState) {
      emit(GalleryLoadingState());
    }
    try {
      // Need a copy of path
      List<String> path = List.from(event.path);

      List<Uint8List> bytes = [];
      for (String p in path) {
        bytes.add(await ImageService.loadImage(p));
      }
      return emit(GalleryDataState(bytes, path));
    } catch (e) {
      return emit(GalleryErrorState(e.toString()));
    }
  }

  void _addGallery(GalleryAddEvent event, Emitter<GalleryState> emit) async {
    String p = await ImageService.pickImage();
    if (p.isNotEmpty) {
      // Need a copy of path
      List<String> path = List.from(event.path)..add(p);
      add(GalleryLoadEvent(path));
    }
  }

  void _deleteGallery(GalleryDeleteEvent event, Emitter<GalleryState> emit) {
    // Need a copy of path
    List<String> path = List.from(event.path);
    add(GalleryLoadEvent(path));
  }
}
