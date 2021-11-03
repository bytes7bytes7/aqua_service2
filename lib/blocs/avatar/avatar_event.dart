part of 'avatar_bloc.dart';

abstract class AvatarEvent extends Equatable {
  const AvatarEvent();

  @override
  List<Object?> get props => [];
}

class AvatarLoadEvent extends AvatarEvent {
  const AvatarLoadEvent(this.path);

  final String path;

  @override
  List<Object?> get props => [path];

  @override
  String toString() {
    return 'AvatarLoadEvent {path : $path}';
  }
}

class AvatarSelectEvent extends AvatarEvent {}

class AvatarDeleteEvent extends AvatarEvent {}
