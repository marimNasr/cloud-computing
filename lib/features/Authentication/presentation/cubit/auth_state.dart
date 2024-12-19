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

class PhoneSignInLoading extends AuthState {}
class PhoneSignInSuccess extends AuthState {}
class PhoneSignInError extends AuthState {
  final String error;
  PhoneSignInError(this.error);
}

class PhoneCodeSent extends AuthState {
  final String verificationId;
  PhoneCodeSent(this.verificationId);
}

class PhoneAutoRetrievalTimeout extends AuthState {
  final String verificationId;
  PhoneAutoRetrievalTimeout(this.verificationId);
}

class PhoneVerificationLoading extends AuthState {}
class PhoneVerificationSuccess extends AuthState {}
class PhoneVerificationError extends AuthState {
  final String error;
  PhoneVerificationError(this.error);
}
