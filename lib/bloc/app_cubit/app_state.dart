part of 'app_cubit.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class AppInitial extends AppState {}

final class AppChangeRadioButton extends AppState {
  const AppChangeRadioButton();
}

final class AppAddImage extends AppState {
  const AppAddImage();
}

final class AppChangeTime extends AppState {
  const AppChangeTime();
}
