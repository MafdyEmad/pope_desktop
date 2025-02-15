import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pope_desktop/features/sayings/data/models/saying_model.dart';
import 'package:pope_desktop/features/sayings/data/remote_data_source/sayings_remote_data_source.dart';

part 'saying_event.dart';
part 'saying_state.dart';

class SayingBloc extends Bloc<SayingEvent, SayingState> {
  final SayingsRemoteDataSource _sayingsRemoteDataSource;
  SayingBloc(this._sayingsRemoteDataSource) : super(SayingInitial()) {
    on<AddSayingEvent>(_addSaying);
    on<GetSayingEvent>(_getSayings);
  }
  void _addSaying(AddSayingEvent event, Emitter emit) async {
    emit(AddSayingLoading());
    final result = await _sayingsRemoteDataSource.addSaying(filePicker: event.filePicker, text: event.text);
    result.fold(
      (error) => emit(AddSayingFail(message: error.message)),
      (_) => emit(AddSayingSuccess()),
    );
  }

  void _getSayings(GetSayingEvent event, Emitter emit) async {
    emit(GetSayingLoading());
    final result = await _sayingsRemoteDataSource.getSayings();
    result.fold(
      (error) => emit(GetSayingFail(message: error.message)),
      (sayings) => emit(GetSayingSuccess(sayings: sayings)),
    );
  }
}
