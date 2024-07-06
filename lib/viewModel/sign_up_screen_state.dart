part of 'sign_up_screen_cubit.dart';

@immutable
sealed class SignUpScreenState {}

final class SignUpScreenInitial extends SignUpScreenState {}

final class SignUpScreenLoading extends SignUpScreenState {}

final class SignUpScreenSuccess extends SignUpScreenState {}

final class SignUpScreenError extends SignUpScreenState {
  String message;

  SignUpScreenError(this.message);
}