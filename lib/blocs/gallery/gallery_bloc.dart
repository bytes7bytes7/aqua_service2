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
      List<Uint8List> bytes = [];
      for (String p in event.path) {
        bytes.add(await ImageService.loadImage(p));
      }
      return emit(GalleryDataState(bytes, event.path));
    } catch (e) {
      return emit(GalleryErrorState(e.toString()));
    }
  }

  void _addGallery(GalleryAddEvent event, Emitter<GalleryState> emit) async {
    String p = await ImageService.pickImage();
    if (p.isNotEmpty) {
      add(GalleryLoadEvent(event.path..add(p)));
    }
  }

  void _deleteGallery(GalleryDeleteEvent event, Emitter<GalleryState> emit) {
    add(GalleryLoadEvent(event.path));
  }
}
