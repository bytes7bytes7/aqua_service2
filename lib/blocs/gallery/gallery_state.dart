part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryLoadingState extends GalleryState {}

class GalleryDataState extends GalleryState {
  const GalleryDataState(this.gallery, this.path);

  final List<Uint8List> gallery;
  final List<String> path;

  @override
  List<Object?> get props => [gallery, path];

  @override
  String toString() => 'GalleryDataState {gallery.length: ${gallery.length}, path.length: ${path.length}}';
}

class GalleryErrorState extends GalleryState {
  const GalleryErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'GalleryErrorState {error: $error}';
}
