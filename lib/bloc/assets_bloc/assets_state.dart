part of 'assets_bloc.dart';

enum AssetState { init, loading, success, failed, loaded, progress }

class AssetsState extends Equatable {
  final AssetState state;
  final String msg;
  final Folder folder;
  final double progress;

  const AssetsState({
    required this.state,
    required this.msg,
    required this.folder,
    required this.progress,
  });

  AssetsState copyWith({
    AssetState? state,
    double? progress,
    String? msg,
    Folder? folder,
  }) {
    return AssetsState(
      state: state ?? this.state,
      progress: progress ?? this.progress,
      msg: msg ?? this.msg,
      folder: folder ?? this.folder,
    );
  }

  @override
  List<Object> get props => [state, msg, folder, progress];
}
