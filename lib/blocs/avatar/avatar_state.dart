part of 'avatar_bloc.dart';

abstract class AvatarState extends Equatable {
  const AvatarState();

  @override
  List<Object?> get props => [];
}

class AvatarLoadingState extends AvatarState {}

class AvatarDataState extends AvatarState {
  const AvatarDataState(this.avatar, this.path);

  final Uint8List avatar;
  final String path;

  @override
  List<Object?> get props => [avatar, path];

  @override
  String toString() => 'AvatarDataState {avatar: ${avatar.hashCode}, path: $path}';
}

class AvatarErrorState extends AvatarState {
  const AvatarErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'AvatarErrorState {error: $error}';
}
