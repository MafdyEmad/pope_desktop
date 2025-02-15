part of 'saying_bloc.dart';

sealed class SayingState extends Equatable {
  const SayingState();

  @override
  List<Object> get props => [];
}

final class SayingInitial extends SayingState {}

final class AddSayingLoading extends SayingState {}

final class AddSayingSuccess extends SayingState {}

final class AddSayingFail extends SayingState {
  final String message;

  const AddSayingFail({required this.message});
  @override
  List<Object> get props => [message];
}

final class GetSayingLoading extends SayingState {}

final class GetSayingSuccess extends SayingState {
  final List<SayingModel> sayings;

  const GetSayingSuccess({required this.sayings});
  @override
  List<Object> get props => [sayings];
}

final class GetSayingFail extends SayingState {
  final String message;

  const GetSayingFail({required this.message});
  @override
  List<Object> get props => [message];
}
