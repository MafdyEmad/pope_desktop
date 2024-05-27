part of 'assets_bloc.dart';

enum States { init, loading, success, failed, loaded }

class AssetsState extends Equatable {
  final States state;
  final String msg;
  final Folder folder;
  const AssetsState({required this.state, required this.msg, required this.folder});
  AssetsState copyWith({
    States? state,
    String? msg,
    Folder? folder,
  }) {
    return AssetsState(
      state: state ?? this.state,
      msg: msg ?? this.msg,
      folder: folder ?? this.folder,
    );
  }

  @override
  List<Object> get props => [state, msg, folder];
}
