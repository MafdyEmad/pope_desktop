part of 'saying_bloc.dart';

sealed class SayingEvent extends Equatable {
  const SayingEvent();

  @override
  List<Object> get props => [];
}

final class AddSayingEvent extends SayingEvent {
  final String text;
  final FilePickerResult filePicker;
  final String publishDate;

  const AddSayingEvent({required this.text, required this.filePicker, required this.publishDate});
  @override
  List<Object> get props => [text, filePicker];
}

final class GetSayingEvent extends SayingEvent {}

final class DeleteSayingsEvent extends SayingEvent {
  final String id;

  const DeleteSayingsEvent({required this.id});
}
