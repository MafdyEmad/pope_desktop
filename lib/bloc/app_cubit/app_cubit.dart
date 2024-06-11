import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/core/utile/enums.dart';

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
}
