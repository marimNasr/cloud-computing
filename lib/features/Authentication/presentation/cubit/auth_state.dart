part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class SignInLoading extends AuthState {}
class SignInSuccess extends AuthState {}
class SignInError extends AuthState {
  final String error;
  SignInError(this.error);
}

class SignUpLoading extends AuthState {}
class SignUpSuccess extends AuthState {}
class SignUpError extends AuthState {
  final String error;
  SignUpError(this.error);
}

class GoogleSignInLoading extends AuthState {}
class GoogleSignInSuccess extends AuthState {}
class GoogleSignInError extends AuthState {
  final String error;
  GoogleSignInError(this.error);
}