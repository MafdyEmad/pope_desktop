part of 'assets_bloc.dart';

enum AssetState { init, loading, success, failed, loaded, progress }

class AssetsState extends Equatable {
  final AssetState state;
  final String msg;
  final Folder folder;
  final double progress;
  final Sayings saying;
  final List<Video> video;

  const AssetsState({
    required this.state,
    required this.msg,
    required this.folder,
    required this.progress,
    required this.saying,
    required this.video,
  });

  AssetsState copyWith({
    AssetState? state,
    double? progress,
    String? msg,
    Folder? folder,
    Sayings? saying,
    List<Video>? video,
  }) {
    return AssetsState(
      state: state ?? this.state,
      progress: progress ?? this.progress,
      msg: msg ?? this.msg,
      folder: folder ?? this.folder,
      saying: saying ?? this.saying,
      video: video ?? this.video,
    );
  }

  @override
  List<Object> get props => [state, msg, folder, progress, video, saying];
}
