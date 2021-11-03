part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class GalleryLoadEvent extends GalleryEvent {
  const GalleryLoadEvent(this.path);

  final List<String> path;

  @override
  List<Object?> get props => [path];

  @override
  String toString() {
    return 'GalleryLoadEvent {path.length: ${path.length}}';
  }
}

class GalleryAddEvent extends GalleryEvent {
  const GalleryAddEvent(this.path);

  final List<String> path;

  @override
  List<Object?> get props => [path];

  @override
  String toString() {
    return 'GalleryAddEvent {path.length: ${path.length}}';
  }
}

class GalleryDeleteEvent extends GalleryEvent {
  const GalleryDeleteEvent(this.path);

  final List<String> path;

  @override
  List<Object?> get props => [path];

  @override
  String toString() {
    return 'GalleryDeleteEvent {path.length: ${path.length}}';
  }
}
