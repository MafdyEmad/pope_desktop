import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  void changeRadioButton() {
    emit(const AppChangeRadioButton());
    emit(AppInitial());
  }

  void addImage() {
    emit(const AppAddImage());
    emit(AppInitial());
  }

  void changeTime() {
    emit(const AppChangeTime());
    emit(AppInitial());
  }
}
