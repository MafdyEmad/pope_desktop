part of 'saying_bloc.dart';

sealed class SayingEvent extends Equatable {
  const SayingEvent();

  @override
  List<Object> get props => [];
}

final class AddSayingEvent extends SayingEvent {
  final String text;
  final FilePickerResult filePicker;

  const AddSayingEvent({required this.text, required this.filePicker});
  @override
  List<Object> get props => [text, filePicker];
}

final class GetSayingEvent extends SayingEvent {}
